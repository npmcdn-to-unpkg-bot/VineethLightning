public class leadSendMail {

public Id leadId{get;set;}
public boolean msg{get;set;}

    public leadSendMail(ApexPages.StandardController controller) {
        leadId = ApexPages.currentPage().getParameters().get('id');
        msg=true;
    }
    
    public void sendMail(){
    
    lead leadRecord = [select id,Amount_of_loan__c,Deposit_amount__c,Industry_sector__c,Existing_Barclays_Customer__c,Business_profile__c 
                    ,Loan_to_Value_LTV__c,Reason_for_the_loan__c,Name,company,status,email,phone from lead where id = :leadId];
                    
          Task t = new Task();
       // t.Owner.id = leadRec.owner.id;
        t.subject = 'Email: Addition Information for lead '+leadRecord.name+' required';
        t.ActivityDate = system.today();
        t.Description = 'Additional To: '+leadRecord.email+
                        '\r\n' +
                        'CC:' +
                        '\r\n' +
                        'BCC:' +
                        '\r\n' +
                        'Attachment:'+
                        '\r\n '+
                        '\r\n '+
                        'Subject: Addition Information for lead '+leadRecord.name+' required'+
                         '\r\n '+
                        'Body:'+
                         '\r\n '+
                         'Dear Demo Introducer, Your Barclays Business Development Manager has request additional information on the lead '+leadRecord.name+' that you submitted. Please click on the below link to fill the additional details required- '+leadRecord.name+' Thanks, SIS Team, Barclays Business Banking';
                        
        t.status = 'Completed';
        t.Priority = 'Normal';
        t.Whoid= leadRecord.id;
        insert t;                      
                   
                    
                 
                    
        String subject = 'Addition Information for lead '+leadRecord.name+' required';
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/leadAdditionalFieldRequest?id='+leadRecord.id;
        String body =   '<font style="font-family:Barclaycard Co Lt"> <b>Dear Demo Introducer,</font></b><br/>' +  
                        '<br>' +                       
                         '<font style="font-family:Barclaycard Co Lt"> Your Barclays Business Development Manager has request additional information on the lead </font>' +leadRecord.name+'<font style="font-family:Barclaycard Co Lt"> that you submitted. </font>'+
                          '<br>' +
                          '<font style="font-family:Barclaycard Co Lt"> Please click on the below link to fill the additional details required-'+
                          '<br>' +
                           ' <a href="' + fullRecordURL + '">' + leadRecord.Name +'</a> '+
                            '<br> <br>' +
                            '<font style="font-family:Barclaycard Co Lt"> Thanks, </font>' +
                            '<br>' +
                            '<font style="font-family:Barclaycard Co Lt"> SIS Team, </font>' +
                            '<br>' +
                            '<font style="font-family:Barclaycard Co Lt"> Barclays Business Banking </font>' ;
                            
                           
        List<String> userEmail= new List<String>();
        userEmail.add('martin.loheac@cognizant.com');
        
        List<String> bccEmail = new List<String>();
        bccEmail.add('aditya.gokhru@cognizant.com');
        bccEmail.add('ambar.verma@cognizant.com');    
              
                                 

        Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
        singleEmail.setToAddresses(userEmail);
        singleEmail.setBccAddresses(bccEmail);
        singleEmail.setSubject(subject);
        singleEmail.setHtmlBody(body); 
        try{       
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {singleEmail});
        }
        catch(Exception e){
            msg=false;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Your Request has been sent to demo introducer.'));
        }
        
       
    }

}