/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: Controller for CC_ForgotPassword page. Class provides functionality for recovery user's password
*/
public with sharing class CC_ForgotPasswordController {
    public String email {get; set;}   


   
    public CC_ForgotPasswordController() {}



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method recoveries user's password
    * @return: PageReference
    */
    public PageReference forgotPassword() {
        User user = [
            SELECT UserName
            FROM User
            Where Email =: email
            LIMIT 1
        ];
        boolean success = Site.forgotPassword(user.username);
        PageReference pr = Page.CC_ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
}