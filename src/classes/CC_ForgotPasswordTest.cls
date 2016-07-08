@IsTest public with sharing class CC_ForgotPasswordTest {
     @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        CC_ForgotPasswordController controller = new CC_ForgotPasswordController();
        controller.email= 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}