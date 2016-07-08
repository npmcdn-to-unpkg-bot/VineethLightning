public class BrokerOnboardingController{
    
    public Lead leadInstance{get;set;}
    
    public List<string> checkFields{get;set;}
    public string checkJson{get;set;}
    public BrokerOnboardingController(ApexPages.StandardController controller){
        checkFields = new List<String>();
        checkFields.add('FCA_Status_check__c');
        checkFields.add('CCL_Check__c');
        checkFields.add('Sanctions_Check_Status__c');
        checkFields.add('Risk_Register_Check__c');
        checkFields.add('Company_Address_check_status__c');
        checkFields.add('Confirmation_E_mail_Received__c');

        leadInstance = (Lead)controller.getRecord();
        if(leadInstance.Id != null){
            leadInstance = Database.query('Select id, '+String.join(checkFields,',')+' from Lead where Id = \''+ leadInstance.Id+'\'');
        }
        checkJson = Json.serialize(checkFields);
    }
    
    public void performChecks(){
        leadInstance.FCA_Status_check__c = 'Yes';
        leadInstance.FCA_Status_Check_Date__c = system.now();
        leadInstance.CCL_Check__c = 'Passed';        
        leadInstance.CCl_Check_Date__c = system.now();
        leadInstance.Sanctions_Check_Status__c = 'Passed';
        leadInstance.Sanctions_Check_Date__c = system.now();
        leadInstance.Risk_Register_Check__c = 'Passed';
        leadInstance.Risk_Register_Check_Date__c = system.now();
        leadInstance.Company_Address_check_status__c = 'Passed';
        leadInstance.Company_Address_check_status_date__c = system.now();
        leadInstance.Confirmation_E_mail_Received__c = 'Passed';
        leadInstance.Confirmation_E_mail_Date__c = system.now();
        
        update leadInstance;
    }
    public void changeStatus(){
        String fieldName = ApexPages.CurrentPage().getParameters().get('fieldName');
        String value= ApexPages.CurrentPage().getParameters().get('value');        
        leadInstance.put(fieldName, value);
        update leadInstance;
    }
    
    public boolean getisAllStatusChecked(){
        for(String field: checkFields){
            if(leadInstance.get(field) =='' || leadInstance.get(field) == null){
                return false;
            }
        }
        return true;
    }
    
    public void convertLead(){
        try{
            List<Database.LeadConvertResult > result = BrokerOnboardingController.convertLead(new lIst<Lead>{leadInstance});
            if(result[0].isSuccess()){
            
                ApexPages.addMessage(new ApexPAges.message(ApexPAges.severity.Info,'Onboarding completed successfully'));
            }
            else{
                ApexPages.addMessage(new ApexPAges.message(ApexPAges.severity.Info,'Onboarding failed: '+result[0].geterrors()[0].getMessage()));
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPAges.message(ApexPAges.severity.Info,'Onboarding failed: '+ex.getMessage()));
        }
    }
    
       public static List<Database.LeadConvertResult > convertLead(List<Lead> leads){
        
        List<Database.LeadConvert> leadConvertlist = new List<Database.LeadConvert>();
        for(lead lead: leads){
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setConvertedStatus('Closed - Converted');
            lc.setLeadId(lead.Id);
            lc.setDoNotCreateOpportunity(true);
            lc.setOwnerId(UserInfo.getUserId());
            leadConvertlist.add(lc);
        }
        
        List<Database.LeadConvertResult> convertResultList = Database.convertLead(leadConvertlist);
        Set<Id> contactIds = new set<Id>();
        for(Database.LeadConvertResult convertResult: convertResultList){
            contactIds.add(convertResult.contactId);
        }
        if(!contactIds.isEmpty()){
            BrokerOnboardingController.createUsers(contactIds);
        }
         return convertResultList ;
    }
    
    @Future
    public static void createUsers(Set<Id> contactIds){
        List<Profile> profileList = [Select Id from Profile where Name = 'Demo Community User' limit 1];
        if(!profileList.isEmpty()){
            List<User> userList = new List<User>();
            Map<Id, Contact> contactMap = new Map<Id, Contact>([Select Id, FirstName, LastName, Name, Email, Account.BillingCountry from Contact where Id in: contactIds]);
            for(Id contactId: contactIds){
                Contact contact = contactMap.get(contactId);
                List<String> emailSplit = contact.Email.split('@');
                if(contact != null){
                    userList.add(new User(FirstName = contact.FirstName,
                                          LastName = contact.LastName,
                                          Email = contact.Email,
                                          UserName = emailSplit[0]+'@communityuser.com',
                                          ProfileId = profileList[0].Id,
                                          IsActive = true,
                                          EmailEncodingKey = 'UTF-8',
                                          LanguageLocaleKey = 'en_US',
                                          LocaleSidKey = 'en_GB',
                                          TimeZoneSidKey = 'Europe/London',
                                          contactId = contact.Id,
                                          alias = contact.name.right(4)+'comu',
                                          CommunityNickname= contact.name,
                                          Country = contact.Account.BillingCountry
                                         // PortalRole = 'Introducer'
                                ));
                }
            }
            if(!userList.isEmpty()){
                insert userList;
            }
        }
        
    }
    
   
}