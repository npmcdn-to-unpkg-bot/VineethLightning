@RestResource(urlMapping='/BTTRestService/*')
global class BTT_RestService {

    @HttpGet
    global static string getWidgets() {
        
        return 'Hello From Salesforce';
    }
    //Public Opportunity Opp {get; set;}
    @HttpPost 
    global static String createNewWidget() {
        
        RestRequest req = RestContext.request;
        String ReturnX ;
        Attachment Attach = new Attachment();
        String getAppNum = 'MA-'+req.headers.get('AppNum');
        System.debug('*****getAppNum **********'+getAppNum );
        try{
            Opportunity Opp = [Select id,name,Case_Number__c,Customer__c from Opportunity where Case_Number__c =: getAppNum];
            Attach.ParentId = Opp.id;
            Attach.Name = 'REST.PNG';
            Attach.Body = EncodingUtil.base64Decode(req.headers.get('Photo'));
            //Attach.ContentType = 'image/gif';
            insert Attach;
            task task = new task();
            task.WhatId = opp.id;
            task.WhoId = Opp.Customer__c;
            task.Subject = 'Visual IVR Updates';
            task.priority= 'Normal';
            task.status = 'In Progress';
            task.description = 'Visual IVR URL : '+req.headers.get('JacadaURL');
            insert task;
            system.debug('**********FFF'+Attach.id);
            ReturnX= 'Done from salesforce';
        }
        catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            ReturnX =e.getMessage();
        }
       
        return ReturnX;
   }

   
}