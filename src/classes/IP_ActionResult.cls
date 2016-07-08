/**
* @author Sachin Chavan
* @date October 2014
* @description epic/user story number / description.
*/

public with sharing class IP_ActionResult {
    public String Id { get; set; }
    public Boolean Success { get; set; }
    public String Message { get; set; }
    public String ErrorDetails { get; set; }
    public Object Data { get; set; }
    
    /**
    * @author Sachin Chavan
    * @date October 2014
    * @description Default constructor
    */
    public IP_ActionResult() { 
        Id = '';
        Success = true;
        Message = '';
        ErrorDetails = '';
    }
    
    /** 
    * @author Sachin Chavan
    * @date October 2014
    * @description This method gives the details while performing any operation
    * @param Database.SaveResult saveResult which tells whether the operation was successful or not
    * @return IP_ActionResult with Error Details  
    */
    public IP_ActionResult(Database.SaveResult saveResult) {
        Id = saveResult.getId();
        Success = saveResult.isSuccess();
        
        for( Database.Error error : saveResult.getErrors()) {
            Message += error.getMessage();
            ErrorDetails = 'The following error has occurred.\n';                    
            ErrorDetails += error.getStatusCode() + ': ' + error.getMessage();
            ErrorDetails += '\nFields that affected this error: ' + error.getFields();
        }
    }
    
    /** 
    * @author Sachin Chavan
    * @date October 2014
    * @description This method gives the details of exception occured
    * @param System.Exception ex is the type of exception encountered
    * @return IP_ActionResult with Error Details  
    */
    public IP_ActionResult(System.Exception ex) {
        Id = '';
        Success = false;
        
        if( ex.getTypeName().equals('System.DmlException')) {
            System.DmlException dmlEx = (System.DmlException)ex;
            Message = dmlEx.getDmlMessage(0);
        }
        else {
            Message = ex.getMessage();
        }
        
        ErrorDetails = 'The following ' + ex.getTypeName() + ' has occurred.\n';                    
        ErrorDetails += 'At: ' + ex.getLineNumber();
        ErrorDetails += '\nStack Trace: ' + ex.getStackTraceString();
    }
}