public class CommunityController{

    @RemoteAction
    public static Response createOpportunity(String contactJson, string oppJson){
         Contact contact = (Contact)JSON.deserialize(contactJson,  Type.forName('Contact'));
         Opportunity opp = (Opportunity )JSON.deserialize(oppJson ,  Type.forName('Opportunity'));
        
        Response response = new Response();
        try{
            User currentUser = getUserDetails(UserInfo.getUserId());
            contact.RecordTypeId = IntroducerRegistrationController.getRecordTypeId(Contact.getSobjectType(), 'Mortgage Applicant'); 
            insert contact;
            opp.AccountId = currentUser.AccountId;
            opp.Customer__c = contact.Id;
            opp.RecordTypeId = IntroducerRegistrationController.getRecordTypeId(Opportunity.getSobjectType(), 'Mortgage');
            opp.Name = opp.To_Do__c;
            opp.StageName = 'New';
            opp.CloseDate = system.today() + 7;
            insert opp;
            response.id = opp.id;
        }
        catch(Exception ex){
            response.isSuccess = false;
            response.message = ex.getMessage();
        }
        return response;
    }

    public static User getUserDetails(Id userId){
       return [Select AccountId from user where id=: userId];
    }
    
    @remoteaction
    public static List<Case> getRequests(){
        return [Select Id, CaseNumber, Priority, Status, CreatedDate from Case ];
    }
    
    @RemoteAction
    public static Response createRequest(Case caseInstance, String applicationNumber, String paymentId){
        Response response = new Response();
        caseInstance.Application__c = getApplicationId(applicationNumber);
        caseInstance.Payment__c = getPaymentId(paymentId);
        try{
            if(caseInstance.Application__c != null){
                caseInstance.RecordTypeId = IntroducerRegistrationController.getRecordTypeId(Case.getSobjectType(), 'Service Request'); 
            }
            else if(caseInstance.Payment__c != null){
                caseInstance.RecordTypeId = IntroducerRegistrationController.getRecordTypeId(Case.getSobjectType(), 'Payment Request'); 
            }
            insert caseInstance;
            response.Id = caseInstance.Id;
            response.name = [Select CaseNumber from case where id=: caseInstance.id][0].CaseNUmber;
        }
        catch(Exception ex){
            response = new Response(ex);
        }
        return response;
    }
    
    public static Id getApplicationId(String applicationNumber){
        Id appId = null;
        if(applicationNumber != null && applicationNumber != ''){
            List<Opportunity> oppLIst = [Select Id from Opportunity where Case_Number__c =: applicationNumber limit 1];
            if(oppList.size() > 0){
                appId = oppList[0].Id;
            }
        }
        return appId;
    }
    
    public static Id getPaymentId(String paymentId){
        Id appId = null;
        if(paymentId != null && paymentId != ''){
            List<Payment__c> payList = [Select Id from Payment__c where Name =: paymentId limit 1];
            if(payList.size() > 0){
                appId = payList[0].Id;
            }
        }
        return appId;
    }
    
    public class Response{
        public boolean isSuccess{get;set;}
        public string message{get;set;}
        public string id{get;set;}
        public string name{get;set;}
        public Response(){
            isSuccess = true;
        }
        
        public Response(Exception ex){
            isSuccess= false;
            message = ex.getMessage();
        }
    }
}