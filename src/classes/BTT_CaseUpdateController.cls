/**
* @author: Vineeth Vadnal
* @date: April 2016
* @description: Controller for BTT_CaseUpdateController component. Class provides the creation of new case applications and community users
*/
public with sharing class BTT_CaseUpdateController{
    
    public boolean showpopup {get;set;}
    public  contact c {get;set;}
    
    public BTT_CaseUpdateController ()
     {
         c= new contact();
         User U = [select id ,ContactId from user where id = :UserInfo.getUserId()];
         if(u.ContactId!=null)
          c = [select id,showpopup__c,MailingPostalCode,MailingCountry,Birthdate from contact where id = :u.ContactId];
         showpopup = c.showpopup__c==true ?true:false;
         
         
     }
     
     public void closeDeal()
      {
          c.showpopup__c = false;
          try{
              update c;
          }
         catch(DmlException e){
           System.debug( 'ERROR +++ ' + e.getMessage() );
         } 
         
          
      }
      
       @RemoteAction
    public static Response createOpportunity(String contactJson, Boolean isGuest) {
        
        System.debug('********311********'+isGuest);
        Response response = new Response();
        contact contact = new contact();
        contact = (Contact)JSON.deserialize(contactJson, Type.forName('Contact'));
        system.debug('***********'+contact);
        Case cs = new case();
        cs.ContactId = [select ContactId from user  where id = :UserInfo.getUserId()].ContactId;
        cs.Status = 'New';
        cs.Origin = 'Web';
        cs.Subject = 'BTT OFFERS';
        cs.Reason ='Reason';
        cs.Accepeted__c = contact.checkbox__c ;
        cs.Description = contact.textarea__c ;
        contact.showpopup__c = false;
        contact.id = cs.ContactId;
        try {
           insert cs;
           update contact;
            StaticResource st =[SELECT Body,ContentType,Description,Id,Name FROM StaticResource where name = 'ReadMe'];
            Attachment at = new Attachment();
            at.parentId = cs.id;
            at.ContentType = st.ContentType;
            at.name = st.name;
            at.body = st.body;
            insert at ;
            BTT_SendEmail.triggerEmailToCustomer(cs.id);
         } catch (Exception ex) {
            System.debug('Opportunity INSERT NEW ERROR +++ '+ex.getMessage());
            response.isSuccess = false;
            response.message = Label.Something_went_wrong_with_your_Application_please_login_and_try_again;
        } 
        
         
        
        return response;
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