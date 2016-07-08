/**
* @author Tejas Kardile
* @date Nov 2014
* @description Utility class provides functions to create test data in test classes
*/
public class TestDataUtility {
     
     /*
    public void testShating(){
        
        withSharing objwithSharing = new withSharing();
        
        withoutSharing objwithoutSharing = new withoutSharing();
        
        List<Task> withSharingTaskList = objwithSharing.getTasks();
        List<Task> withoutSharingTaskList = objwithoutSharing.getTasks();
        
        system.debug(
            '\n withSharingTaskList    ====: ' + withSharingTaskList.size() + 
            '\n withoutSharingTaskList ====: ' + withoutSharingTaskList.size()
        );
    }
    
   
    public with sharing class withSharing{
        
        public withSharing(){}
        
        public List<Task> getTasks(){
            set<Id> taskActionsRecTypeIdSet = new set<Id>{'012m00000004MQlAAM', '012m00000004MQvAAM', '012m00000004Ma2AAE', '012m00000004Ma5AAE', '012m00000004N47AAE', '012m00000004N9bAAE'};
            set<Id> taskNotificationsRecTypeIdSet = new set<Id>{'012m00000004Ma3AAE', '012m00000004Ma4AAE'};
            map<Id, Opportunity> opportunityMap = new map<Id, Opportunity>([Select Id, AccountId From Opportunity where AccountId = '001m0000009IXRr']);
            set<Id> oppIdSet = opportunityMap.keySet();
            
            List<Task> taskList = [Select Id, Subject, Status, Priority, AccountId, CreatedDate, IsClosed, ActivityDate, OwnerId, Owner.Name, RecordTypeId, RecordType.DeveloperName, RecordType.Name, RecordType.Id, Is_passed_due_date__c From Task WHERE 
            (
                (
                    (OwnerId = '005m0000000kAizAAE' AND RecordTypeId IN :taskActionsRecTypeIdSet AND Status != 'Completed' AND IsClosed = false) 
                    OR 
                    (
                        (OwnerId = '005m0000000kAizAAE' AND RecordTypeId IN :taskNotificationsRecTypeIdSet AND Status != 'Completed' AND IsClosed = false) 
                        OR 
                        (   OwnerId = '005m0000000kAizAAE' AND RecordTypeId IN :taskNotificationsRecTypeIdSet AND 
                            Status = 'Completed' AND IsClosed = true
                        )
                    )
                ) 
                OR 
                (RecordTypeId = '012m00000004Ma2AAE' AND WhatId IN : oppIdSet)
            ) 
            ORDER BY ActivityDate Desc];
            
            return taskList;
        }
        
    }
    
    public without sharing class withoutSharing{
        
        public withoutSharing(){}
        
        public List<Task> getTasks(){
            set<Id> taskActionsRecTypeIdSet = new set<Id>{'012m00000004MQlAAM', '012m00000004MQvAAM', '012m00000004Ma2AAE', '012m00000004Ma5AAE', '012m00000004N47AAE', '012m00000004N9bAAE'};
            set<Id> taskNotificationsRecTypeIdSet = new set<Id>{'012m00000004Ma3AAE', '012m00000004Ma4AAE'};
            map<Id, Opportunity> opportunityMap = new map<Id, Opportunity>([Select Id, AccountId From Opportunity where AccountId = '001m0000009IXRr']);
            set<Id> oppIdSet = opportunityMap.keySet();
            
            List<Task> taskList = [
                Select Id, Subject, Status, Priority, AccountId, CreatedDate, IsClosed, ActivityDate, OwnerId, Owner.Name, 
                       RecordTypeId, RecordType.DeveloperName, RecordType.Name, RecordType.Id, Is_passed_due_date__c 
                  From Task 
                 WHERE (((OwnerId = '005m0000000kAizAAE' AND RecordTypeId IN :taskActionsRecTypeIdSet AND Status != 'Completed' AND IsClosed = false) 
                        OR ((OwnerId = '005m0000000kAizAAE' AND RecordTypeId IN :taskNotificationsRecTypeIdSet AND Status != 'Completed' AND IsClosed = false) 
                            OR(   OwnerId = '005m0000000kAizAAE' AND RecordTypeId IN :taskNotificationsRecTypeIdSet AND 
                                Status = 'Completed' AND IsClosed = true
                            )
                        )) 
                        OR (RecordTypeId = '012m00000004Ma2AAE' AND WhatId IN : oppIdSet)) 
              ORDER BY ActivityDate Desc];
            
            return taskList;
        }
    }
    /**
    * @author Mahesh Hirugade
    * @date November 2014
    * @description Creates single Account record with provided record type
    * @param String RecordTypeName of Account
    * @param Boolean If TRUE inserts a record and returns Account with ID, If FALSE then does not inserts record and returns only instance of Account
    * @return Account
    */
    public static Account createAccount(String recordTypeName, Boolean doInsert) {
        Account account = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(),
            Name = 'Unittest company name',
            Type = 'Appointed Representative'
        );
        if (doInsert) {
            insert account;
        }
        return account;
    }
    
    /**
    * @author Mahesh Hirugade
    * @date November 2014
    * @description Creates single Contact record with provided record type
    * @param Id Account Id
    * @param String RecordTypeName of Contact
    * @param Boolean If TRUE inserts a record and returns Contact with ID, If FALSE then does not inserts record and returns only instance of Contact
    * @return Contact
    */
    public static Contact createContact(Id accountId, String recordTypeName, Boolean doInsert) {
        Contact contact = new Contact(
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(),
            AccountId = accountId,
            FirstName = 'Test' + Math.random(),
            LastName = 'LastName' + Math.random()
        );
        if(doInsert){
            insert contact;
        }
        return contact;
    }
    
    /**
    * @author Chitra Poojari
    * @date June 2015
    * @description Creates single registration record with provided record type
    * @param Id Account Id
    * @param Id Contact Id
    * @param String RecordTypeName of Registration
    * @param Boolean If TRUE inserts a record and returns Registration with ID, If FALSE then does not inserts record and returns only instance of Registration__c
    * @return Registration__c
    */
/*    public static Registration__c createRegistration(Id accountId, Id ContactId, String recordTypeName, Boolean doInsert) {
        Registration__c registration = new Registration__c(
            RecordTypeId = Schema.SObjectType.Registration__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(),
            Broker__c = ContactId,
            Registered_Account__c = accountId
            );
        if(doInsert){
            insert registration;
        }
        return registration;
    }*/
    
    /**
    * @author Mahesh Hirugade
    * @date November 2014
    * @description Creates single Case record with provided record type
    * @param Id Contact Id
    * @param String RecordTypeName of Case
    * @param Boolean If TRUE inserts a record and returns Case with ID, If FALSE then does not inserts record and returns only instance of Case
    * @return Account
    */
    public static Case createCase(Id contactId, String recordTypeName, Boolean doInsert){
        Case objCase = new Case(
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(),
            ContactId = contactId/*,
            Request_on_behalf_of_other_user__c= true*/
        );
         system.debug('objCase++' + objCase);
        if(doInsert){
            Insert objCase;
        }
        return objCase;
    }
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to get RecordTypeId by record type name from any Object
    * @param String Object Name
    * @param String RecordTypeName
    * @param Boolean 
    * @return Id RecordTypeId
    */
    public static ID getRecordTypeId(String ObjectType, String RecordTypeLabel, Boolean doInsert) {
        SObject OBJ;
        // Describing Schema
        Schema.SObjectType Res = Schema.getGlobalDescribe().get(ObjectType);
        if(Res != null) {
            OBJ = Res.newSObject();
            // Describing Object
            Schema.DescribeSObjectResult DesRes = OBJ.getSObjectType().getDescribe();
            if(DesRes != null){
                Map<String, schema.recordtypeinfo> RecordTypeMap = DesRes.getRecordTypeInfosByName();
                if(RecordTypeMap != null){
                    Schema.RecordTypeInfo RecordTypeRes = RecordTypeMap.get(RecordTypeLabel);
                    if(RecordTypeRes != null){
                        return RecordTypeRes.getRecordTypeId();
                    }
                }
            }
        }
        return null;
    }
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to create Audience__c
    * @param Boolean If true then inserts Audience__c else only returns an instance of Audience__c
    * @return Audience__c
    */
    public static Audience__c createAudience( Boolean doInsert) {
        Audience__c audience = new Audience__c(Name='Audience1', Description__c='Test Audience');
        if(doInsert){
            insert audience;
        }
        return audience;
    }
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to create Content_Audience__c
    * @param Id audienceId to set in Audience__c lookup
    * @param Id manageContentId to set in Manage_Content__c lookup
    * @param Boolean If true then inserts Content_Audience__c else only returns an instance of Content_Audience__c
    * @return Content_Audience__c
    */
    public static Content_Audience__c createContentAudience(Id audienceId, Id manageContentId, Boolean doInsert) {
        Content_Audience__c contentAudience = new Content_Audience__c(Audience__c = audienceId, Manage_Content__c = manageContentId);
        if(doInsert){
            insert contentAudience;
        }
        return contentAudience;
    }
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to create Manage_Content__c
    * @param Boolean If true then inserts Manage_Content__c else only returns an instance of Manage_Content__c
    * @return Manage_Content__c
    */
    public static Manage_Content__c createManageContent(Boolean doInsert) {
        Manage_Content__c manageContent = new Manage_Content__c(Title__c='manageContent1',Publish_Start__c = System.today(), Publish_End__c = System.today().addDays(10));
        if(doInsert){
            insert manageContent;
        }
        return manageContent;
    }
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to create IntermediarySearchSettings__c
    * @param Boolean If true then upserts IntermediarySearchSettings__c else only returns an instance of IntermediarySearchSettings__c
    * @return IntermediarySearchSettings__c
    */
    public static void createIntermediarySearchSetting(Boolean doUpsert) {

    }
    /*public static IntermediarySearchSettings__c createIntermediarySearchSetting(Boolean doUpsert) {
        IntermediarySearchSettings__c intermediarySearchSettings = IntermediarySearchSettings__c.getValues('IntermediarySearchSettings');
        intermediarySearchSettings = (intermediarySearchSettings != null) ? intermediarySearchSettings : new IntermediarySearchSettings__c();
        intermediarySearchSettings.Trigger__c = true;
        intermediarySearchSettings.Name = 'IntermediarySearchSettings';
        if(doUpsert){
            upsert intermediarySearchSettings;
        }
        return intermediarySearchSettings;
    }*/
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to create User
    * @param String Id of Contact
    * @param Boolean If true then inserts User else only returns an instance of User
    * @return User
    */
    public static User createPortalaUser(String contactId, Boolean doInsert){
        Profile brokerCommunityProfile = [Select Id from Profile where name = 'Broker Community User' and UserLicense.Name = 'Partner Community'];
        
        User brokerCommunityUser = new User(
            ContactId = contactId,
            ProfileId = brokerCommunityProfile.Id,
            Username = 'test2@test.com' + Math.random(),
            Alias = 'TBrok',
            Email='test@broker.com',
            EmailEncodingKey='UTF-8',
            Firstname='Broker1',
            Lastname='Broker1',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        
        if(doInsert){
            insert brokerCommunityUser;
        }
        return brokerCommunityUser;
    }
    
    /**
    * @author IPDEV Team
    * @date December 2014
    * @description Method to create portal User
    * @param String Id of Contact
    * @param String Id of Profile
    * @param Boolean If true then inserts User else only returns an instance of User
    * @return User
    */
    public static User createPortalUser(String contactId, String profileId, Boolean doInsert){
        User brokerCommunityUser = new User(
            ContactId = contactId,
            ProfileId = profileId,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'TBrok',
            Email='test@broker.com',
            EmailEncodingKey='UTF-8',
            Firstname='Broker1',
            Lastname='Broker1',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        
        if(doInsert){
            insert brokerCommunityUser;
        }
        
        return brokerCommunityUser;
    }
 
}