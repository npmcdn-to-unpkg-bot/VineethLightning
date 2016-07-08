public class BTT_SendEmail {
    
    
    @future
    Public static void triggerEmailToCustomer(string Id)
     {
         EmailTemplate et=[Select id from EmailTemplate where name=:'Case Registration'];
         map<id,attachment> caseact = new map<id,attachment>();
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                  
         for(attachment a : [select Name, Body, BodyLength,ParentId,ContentType  from Attachment where ParentId =:Id LIMIT 1])
          {
              
              caseact.put(a.ParentId,a);
          }
         
          
          for(case c : [select id,contactid ,Accepeted__c,CaseNumber,Contact.Name,Contact.email from case where id =:Id])
           {
               
               if(c.Accepeted__c){
                   
                   string body ='<style type="text/css"> body { background: #e8e8e8; margin: 0px; padding: 0px; } p { font-family: "Helvetica Neue",Helvetica,Arial,sans-serif; font-size: 14px; color: #333; } .container { width: 700px; margin: 0px auto; background: white; } .header { } .body { padding: 10px 20px; } .footer { background-color: #05649E; color: #fff; padding: 10 8 10 10; } .footer a { color: #fff; background-color: #05649E; } </style> <div class="container"> <div class="header"> <img src="https://c.cs83.content.force.com/servlet/servlet.ImageServer?id=0154E00000094O8&oid=00D4E000000Cupz&lastMod=1460363781000" alt="Bank of Tomorrow... Today" /> </div> <div class="body"> <p>Hello '+C.Contact.Name+'</p> <p>Thanks for submitting your application.</p> <p>One of our agents will take care of it soon and start the evaluation process. In the meantime, you can log in our community to check in real time the status and contact us in case you have any enquiry. </p> <p>Thanks</p> <p>BTT team</p> </div> <div class="footer"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#">Privacy Policy</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp; <a href="#">Important Information</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp; <a href="#">Term of Use</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp; <a href="#">Cookie Policy</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp; <a href="#">@BTT</a> </div> </div> </div>';
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   mail.subject = 'BTT Re-Mortgage ref no :'+c.CaseNumber; 
                   mail.setSenderDisplayName('BTT MAIL');
                   mail.setHtmlBody(body);
                   List<String> sendTo = new List<String>();
                   sendTo.add(c.Contact.email);
                   mail.setToAddresses(sendTo);
                   Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                   attachment.setBody(caseact.get(c.id).body);
                   attachment.setContentType(caseact.get(c.id).ContentType);
                   attachment.setFileName(caseact.get(c.id).name);
                   attachment.setinline(false);
                   mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );
                   mails.add(mail);
                   
               }
               
             Messaging.sendEmail(mails);
               
               
           }
          
          
         
     }

}