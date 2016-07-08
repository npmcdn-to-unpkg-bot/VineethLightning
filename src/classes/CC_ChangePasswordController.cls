/**
* @author: Kalara Ivanchenko
* @date: April 2016
* @description: Controller for CC_ChangePassword page. Class provides functionality for changing password
*/
public without sharing class CC_ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        



	/**
	* @author: Kalara Ivanchenko
	* @date: April 2016
	* @description: This method changes user's password
	* @return: PageReference
	*/
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     



   	public CC_ChangePasswordController() {}
}