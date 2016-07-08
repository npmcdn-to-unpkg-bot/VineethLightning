/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: Controller for CC_RequestComponent component and CC_NewApplicationPage page. Class provides functionality for creating new mortgage applications and service requests
*/
public with sharing class CC_CommunityController {
    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method creates new mortgage application (Opportunity)
    * @param String JSON string with customer info
    * @param String JSON string with application info
    * @param Boolean true if created user is guest
    * @return: Response
    */
    @RemoteAction
    public static Response createOpportunity(String contactJson, string oppJson, Boolean isGuest) {
        Opportunity opp = (Opportunity)JSON.deserialize(oppJson, Type.forName('Opportunity'));
        User currentUser;
        String userIdStr;
        Response response = new Response();
        if (isGuest) {
            Contact contact = (Contact)JSON.deserialize(contactJson, Type.forName('Contact'));
            Id accountId = [
                SELECT Id__c
                FROM AccountByType__c
                WHERE Name =: 'Customer'
                LIMIT 1
            ].Id__c;

            List<Contact> contacts = getDuplicates(contact, accountId);
            if (! contacts.isEmpty()) {
                try {
                    contacts.get(0).AccountId = accountId;
                    upsert contacts.get(0);
                } catch (DmlException ex) {
                    response.isSuccess = false;
                    response.message = Label.Something_went_wrong_with_your_Application;
                    return response;
                }                
            }

            userIdStr = registrate(contact, accountId);
            if (userIdStr != null) {
                currentUser = getUserDetails(userIdStr);
                Contact c = fillOutContact(currentUser.ContactId, contact);
                try {
                    update c;

                } catch (DmlException ex) {
                    response.isSuccess = false;
                    response.message = ex.getMessage();
                    return response;
                }
            } else {
                response.isSuccess = false;
                response.message = Label.Something_went_wrong_with_your_Application;
                return response;
            }
        } else {
            currentUser = getUserDetails(UserInfo.getUserId());
        }

        opp.Customer__c = currentUser.ContactId;
        opp.AccountId = currentUser.AccountId;
        opp.RecordTypeId = getRecordTypeId(Opportunity.getSobjectType(), 'Mortgage');
        opp.Name = opp.To_Do__c;
        opp.StageName = 'New';
        opp.CloseDate = system.today() + 7;
        try {
            insert opp;
/*            if (isGuest) {
                sendWelcome(opp.Id);
            }  */          
        } catch (DmlException ex) {
            System.debug('Opportunity INSERT NEW ERROR +++ '+ex.getMessage());
            response.isSuccess = false;
            response.message = Label.Something_went_wrong_with_your_Application_please_login_and_try_again;
        }                
        return response;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the named RecordType for sObject
    * @param Schema.SobjectType sObject for the RecordType
    * @param String name of the RecordType
    * @return: Id
    */
    public static Id getRecordTypeId(Schema.SobjectType sobjType, String name){
        Map<String, Schema.RecordTypeInfo> infoMap = sobjType.getDescribe().getRecordTypeInfosByName();
        return infoMap.containsKey(name) ? infoMap.get(name).getRecordTypeId(): null;
        
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method fills the contact's fields
    * @param Id id of the contact
    * @param Contact contact's object
    * @return: Contact
    */
    public static Contact fillOutContact(Id contactId, Contact contact) {
        String queryFields = getContactFieldsQuery();
        String query = 'SELECT ' + queryFields + ' FROM Contact WHERE Id =: contactId LIMIT 1';
        List<Contact> contacts = (List<Contact>)Database.query(query);

        Contact c = contacts.get(0);
        c.Salutation = contact.Salutation;
        c.FirstName = contact.FirstName;
        c.Gender__c = contact.Gender__c;
        c.LastName = contact.LastName;
        c.Phone = contact.Phone;
        c.MobilePhone = contact.MobilePhone;
        c.MailingCountry = contact.MailingCountry;
        c.MailingPostalCode = contact.MailingPostalCode;
        c.Birthdate = contact.Birthdate;

        return c;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method registers new community user
    * @param Contact user's related contact
    * @param Id id of the default community's account
    * @return: Contact
    */
    public static Id registrate(Contact contact, Id accountId) {
        Response response = new Response();
        String profileId = [
            SELECT Id
            FROM Profile
            WHERE Name =: 'Mortgage Customer Community Test'
            LIMIT 1
        ].Id; 
        
        String ownerId = [
            SELECT Id
            FROM User
            WHERE Profile.Name =: 'System Administrator' 
            AND UserRoleId != null
            LIMIT 1
        ].Id; 
        
         String domain = [
            SELECT Additional_Domain__c
            FROM Domain__c
            WHERE Name =: 'Customer'
            LIMIT 1
        ].Additional_Domain__c;

        String userName = contact.email + domain;
        
        User u = new User();
        u.Username = userName;
        u.Email = contact.email;
        u.FirstName = contact.firstName;
        u.LastName = contact.lastName;
        u.ProfileId = profileId;
        u.CommunityNickname = (contact.firstName.length() > 40 - String.valueOf(datetime.now()).length()) ? contact.firstName.substring(0, 40 - String.valueOf(datetime.now()).length()) + datetime.now() : contact.firstName + datetime.now();
        String userId;

        try {
            userId = Site.createExternalUser(u, accountId);
            } catch (Exception ex) {
            System.debug('CREATE USER ++++ ' + ex.getMessage());
        }
        return userId;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the list of contacts with the same email and related to the same account
    * @param Contact contact
    * @param Id id of the default community's account
    * @return: List< Contact >
    */
    public static List<Contact> getDuplicates(Contact contact, Id accountId) {
        String queryFields = getContactFieldsQuery();
        String query = 'SELECT ' + queryFields + ' FROM Contact WHERE Email = \'' + contact.email +'\' AND AccountId !=: accountId LIMIT 1';
        List<Contact> contacts = (List<Contact>)Database.query(query);
        return contacts;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the list of the api names of fields for the contact object
    * @return: String
    */
    public static String getContactFieldsQuery() {
        SObjectType contactType = Schema.getGlobalDescribe().get('Contact');
        Map<String,Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();
        List<String> fields = new List<String> (mfields.keySet());
        String query = String.join( fields, ', ');
        return query;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the user's info
    * @param Id id of the user
    * @return: User
    */
    public static User getUserDetails(Id userId) {
       return [Select AccountId, ContactId FROM User WHERE Id=: userId];
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method checks if there is any users with such email
    * @param String email
    * @return: Boolean
    */
    @Remoteaction
    public static Boolean checkEmailDuplicates(String email) {
        List<User> contacts = [
            SELECT Id
            FROM User
            WHERE Email =: email
        ];

        return (contacts.isEmpty()) ? false : true;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the list of the service requests
    * @return: List< Case >
    */
    @Remoteaction
    public static List<Case> getRequests() {
        return [Select Id, CaseNumber, Priority, Status, CreatedDate from Case ];
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method creates new service request
    * @param Case case instance
    * @param String application number
    * @param String payment id
    * @return: Response
    */
    @RemoteAction
    public static Response createRequest(Case caseInstance, String applicationNumber, String paymentId) {
        Response response = new Response();
        caseInstance.Application__c = getApplicationId(applicationNumber);
        caseInstance.Payment__c = getPaymentId(paymentId);
        try {
            if (caseInstance.Application__c != null) {
                caseInstance.RecordTypeId = getRecordTypeId(Case.getSobjectType(), 'Service Request'); 
            }
            else if(caseInstance.Payment__c != null) {
                caseInstance.RecordTypeId = getRecordTypeId(Case.getSobjectType(), 'Payment Request'); 
            }
            insert caseInstance;
            response.Id = caseInstance.Id;
            response.name = [SELECT CaseNumber FROM case WHERE id=: caseInstance.id][0].CaseNUmber;
        } catch (Exception ex) {
            response = new Response(ex);
        }
        return response;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the id of the application by it's number
    * @param String application number
    * @return: Id
    */
    public static Id getApplicationId(String applicationNumber) {
        Id appId = null;
        if (applicationNumber != null && applicationNumber != '') {
            List<Opportunity> oppLIst = [SELECT Id FROM Opportunity WHERE Case_Number__c =: applicationNumber LIMIT 1];
            if (oppList.size() > 0) {
                appId = oppList[0].Id;
            }
        }
        return appId;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets payment id by it's id, returns null if there is no payment with such id
    * @param String payment id
    * @return: Id
    */
    public static Id getPaymentId(String paymentId) {
        Id appId = null;
        if (paymentId != null && paymentId != '') {
            List<Payment__c> payList = [SELECT Id FROM Payment__c WHERE Name =: paymentId LIMIT 1];
            if (payList.size() > 0) {
                appId = payList[0].Id;
            }
        }
        return appId;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: Wrapper class for response after service request is created
    */
    public class Response {
        public Boolean isSuccess {get;set;}
        public string message {get;set;}
        public string id {get;set;}
        public string name {get;set;}
        public Response() {
            isSuccess = true;
        }
        
        public Response(Exception ex) {
            isSuccess = false;
            message = ex.getMessage();
        }
    }
}