public class IntroducerRegistrationController {
    
    public Static string attachmentBody {get;set;}
    
    public static id getRecordTypeId(Schema.SobjectType sobjType, String name){
        Map<String, Schema.RecordTypeInfo> infoMap = sobjType.getDescribe().getRecordTypeInfosByName();
        return infoMap.containsKey(name) ? infoMap.get(name).getRecordTypeId(): null;
        
    }
    
     
    @RemoteAction
    public static String createLead(Lead lead){
         List<User> userList = [Select id from user where email =: lead.Email and Profile.Name = 'Demo Community User' and isactive = true];
         if(userList.size() > 0){
         
             throw new CustomException('Email Id already registered');
         }
        try{
            lead.RecordTypeId = getRecordTypeId(lead.getSobjectType(), 'Broker Lead');
            insert lead;
        }
        catch(Exception ex){
            throw new CustomException(ex.getmessage());
        }
        return 'Request submitted successfully';
    }
    
    @RemoteAction
    public static String registerUser(Account account, Contact contact,String sigattachmentBody){
        try{
            account.Status__c = 'Staging';
            account.RecordTypeId = getRecordTypeId(Account.getSobjectType(), 'Broker Firm');
            insert account;
            contact.AccountId = account.Id;
            contact.Status__c = 'Staging';
            contact.RecordTypeId = getRecordTypeId(Contact.getSobjectType(), 'Broker'); 
            insert contact;
            
            Attachment attach = new Attachment();
            if(sigattachmentBody!= null){
                attachmentBody = sigattachmentBody.replace(' ', '+');
                attachmentBody = sigattachmentBody.replace('data:image/png;base64,', '');
                
                attach.ParentId = contact.Id;
                attach.Name = 'eSignature - '+Datetime.now();
                attach.ContentType = 'image/png';
                attach.Body = EncodingUtil.base64Decode(attachmentBody);
                insert attach;  
            }
            
            if(Limits.getEmailInvocations() < 10){
                try{
                    messaging.SingleEmailMessage singleEmail = new messaging.SingleEmailMessage();
                    Id templateId;  
                    templateId = [select id, name from EmailTemplate where developername = 'Registration'].id;
                    singleEmail.setTemplateId(templateId);
                    singleEmail.setSaveAsActivity(false);
                    singleEmail.setTargetObjectId(contact.id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmail });
                }
                catch(Exception ex){}
            }
            
            return 'User registered successfully.';
        }
        catch(Exception ex){
            return ex.getMessage();
        }
    }   
    
    public class CustomException extends Exception{
    } 
    
}