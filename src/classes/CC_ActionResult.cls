/**
* @author Sachin Chavan
* @date October 2014
* @description epic/user story number / description.
*/

public without sharing class CC_ActionResult {
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
    public CC_ActionResult() { 
        Id = '';
        Success = true;
        Message = '';
        ErrorDetails = '';
    }
}