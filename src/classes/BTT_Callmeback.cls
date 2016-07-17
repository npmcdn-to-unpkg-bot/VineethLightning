/**
* @author: Vineeth Vadnal
* @date: April 2016
* @description: Controller for callback component. Class provides the creation of new case and call back 
*/



public with sharing class  BTT_Callmeback{
    
    public boolean showpopup {get;set;}
    public  contact c {get;set;}
    public case cs {get;set;}
    private static User U;
    public BTT_Callmeback(){
         c= new contact();
         cs = new case();
         u = [select id ,ContactId from user where id = :UserInfo.getUserId()];
         if(u.ContactId!=null)
           {
               c = [select id,showpopup__c,MailingPostalCode,MailingCountry from contact where id = :u.ContactId];
               try{
               cs= [select id ,Token__c from case where ContactId = :u.ContactId and createddate =today and Status!= 'Closed' and Token__c!=null limit 1];
               showpopup = true;
                   
               }
               catch(QueryException qe)
                {
                    System.Exception('Error occured'+qe.getMessage());
                }
           }
          
          
        
    }
  
   
 @RemoteAction
    public  static Response updateCase(String mobnum,string passkey) 
    {
        System.debug('***************'+mobnum+'@@'+passkey);
        Response response = new Response();
        Case c = new case();
        c.Token__c = passkey;
        c.ContactId = [select id ,ContactId from user where id = :UserInfo.getUserId()].ContactId;
        c.Status = 'New';
        c.Origin = 'Web';
        c.Priority = 'High';
        c.Type = 'other';
        c.subject= 'Call me back for user ' +UserInfo.getFirstName();
        c.callmeback_number__c = mobnum;
        
        try{
             Insert c;
             response.isSuccess = true;
             BTT_PureCloudIntegration bt = new BTT_PureCloudIntegration();
             BTT_PureCloudIntegration.doIntegration(UserInfo.getFirstName()+'_'+passkey,mobnum);
            
         }
        catch(Dmlexception e)
         {
             response.isSuccess = false;
             response.message = Label.Something_went_wrong_with_your_Application_please_login_and_try_again;
         }
        
        
        
      
        return response;
    }
    
    
     @RemoteAction
    public static Response doGetText() {
         Response response = new Response();
        try{
           user u1 = [select id ,ContactId from user where id = :UserInfo.getUserId()];
           case css= [select id ,Token__c from case where  ContactId =:u1.ContactId and createddate =today and Status!= 'Closed' and Token__c!=null and IsDeleted=false order by createddate DESC  limit 1];
           response.isSuccess = true;
           response.message = 'Found a record';
           response.name = css.Token__c;
        }
        catch(Exception e){
            response.isSuccess = false;
            response.message = 'No record found';
        }
        return Response;
    }
    
    public class Response {
        public Boolean isSuccess {get;set;}
        public string message {get;set;}
        public string id {get;set;}
        public string name {get;set;}
        public Response() {
            isSuccess = true;
            
        }
        
        public Response(Exception ex) {
            isSuccess = true;
            message = ex.getMessage();
        }
    }
     
   

}