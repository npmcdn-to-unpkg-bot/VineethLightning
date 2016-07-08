public class BTT_PureCloudIntegration {
    
    private static fromJSON f ;
    
   
    @future(callout=true)
    Public static void doIntegration(String name ,String mobnum){
       
       try{ 
        mobnum =Label.CountryCode+mobnum.removeStart('0'); 
        
        http p = new http();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://login.mypurecloud.com/oauth/token');
        //blob headervalue=blob.valueof('4f2bc240-fd1a-4fe0-afed-86067c66e4d5:wcIt_s-tXdn4PR74vzoss6xpCr83WaDMhT9q3Ve4_Wg');
        //blob headervalue=blob.valueof('2008adc3-1d26-4fc0-bffb-248428a0d7f9:oQC4mEEs8ZIn3UOxy4IDkeZL83gXJz4uOy_3LyIyh0E');
        blob headervalue=blob.valueof('9452be59-40ae-4fe2-aff7-e3ebb4cdac0a:m_htg-RwDToeUEtbOMuLluv8Pqa4PaEzTfeKd3nh-bI');
        
        string authheader='Basic '+EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authheader);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setbody('grant_type=client_credentials');
        httpresponse res = new httpresponse();
        res = p.send(req);
        System.debug('******************'+res.getBody());
        f = new fromJSON();
        f= (fromJSON)  System.JSON.deserialize(res.getBody(), fromJSON.class);
        System.debug('*******'+f.access_token);
        
        p = new http();
        req = new HTTPRequest();
        res = new httpresponse();
        req.setHeader('Authorization','Bearer '+f.access_token);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        String body = '[{ "contactListId": "2863e770-984b-4a5a-be61-398f9706960c", "data": { "Name": "'+name+'","Phone":"'+mobnum+'"}, "callable": true }]';
        req.setBody(body);
        req.setHeader('Content-Type','application/json');
       //req.setEndpoint('http://requestb.in/1nesjik1');
        req.setEndpoint('https://api.mypurecloud.com/api/v2/outbound/contactlists/2863e770-984b-4a5a-be61-398f9706960c/contacts');
        //req.setEndpoint('https://api.mypurecloud.com/api/v2/outbound/contactlists/f6be4c38-0138-4809-8d79-83866d0d53c5');
        
        res = p.send(req);
        System.debug('**********VVVVV********'+res+'*************'+res.getBody());
       }
       
       catch(Exception e){
           System.debug('***'+e.getMessage());
       }
        
        
    }
    

public class fromJSON{
	public String access_token;	
	public String token_type;
	public Integer expires_in;
}

}