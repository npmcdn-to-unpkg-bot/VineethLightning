/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CC_ForgotPasswordConfirm and CC_Login pages. Class provides functionality for loggin into customer community
*/
global with sharing class CC_LoginController {

    global String username { get; set; }
    global String password { get; set; }



    global CC_LoginController() {
        //username = 'a19@a19.com';
        //password = 'qwerty123';
    }



    /**
    * @author: Pavel Kalinin
    * @date: April 2016
    * @description: This method provides functionality for loggin into customer community
    * @return: PageReference
    */
    global PageReference login() {
        System.debug( '>>>' + username + '\n>>>' + password );

    	List<User> loginUser = [
    		Select Id, Username, Email
    		From User
    		Where Email = :username
    		LIMIT 1
    	];

        PageReference pr;

        if ( loginUser == null || loginUser.size() <= 0 ) {
            ApexPages.addmessage( new ApexPages.message( ApexPages.severity.ERROR,'Your login attempt has failed. Make sure the username and password are correct.' ) );
            return null;
        }

        pr = Site.login( loginUser[0].Username, password, null );

        return pr;
    }

}