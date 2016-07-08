global without sharing class WelcomeEmail implements Messaging.InboundEmailHandler{
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.Inboundenvelope envelope) {
        System.debug('INBOUND MEssage +++  ' + email);
/*      List<Contact> c = [
            SELECT FirstName
            From Contact
            Where Id = '0034E0000029Tjq'
        ];
        c.get(0).FirstName = 'changed';
        update c.get(0);*/
        System.debug('INBOUND MEssage +++  ' + email);
      
        FeedItem fi = new FeedItem(
            ParentId = email.subject,
            Body = 'Welcome to Community',
            Visibility = 'AllUsers'
        );
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        result.success = true;
        try {
            insert fi;
        } catch(Exception ex) {
            System.debug('Error +++ ' + ex.getMessage());
            result.success = false;
        }
        
        return result;
    }
}