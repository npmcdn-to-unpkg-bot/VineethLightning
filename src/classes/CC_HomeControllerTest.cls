@isTest
private class CC_HomeControllerTest {
	
	@isTest
	static void testHomeController() {
		CC_HomeController homeController = new CC_HomeController();

		System.assertNotEquals( null, homeController );
	}



	@isTest
	static void testGetMostRecentAppWrongUser() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		Opportunity testMostResentApp;

		CC_HomeController homeController = new CC_HomeController();
		testMostResentApp = homeController.mostRecentApp;

		System.assertEquals( null, testMostResentApp );
	}



	@isTest
	static void testGetMostRecentAppWithoutOpportunity() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		Opportunity testMostResentApp;

		System.runAs(testCommunityUser) {
			CC_HomeController homeController = new CC_HomeController();
			testMostResentApp = homeController.mostRecentApp;
		}

		System.assertEquals( null, testMostResentApp );
	}



	@isTest
	static void testGetMostRecentAppWitOneOpportunity() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );
		Opportunity testApp = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );

		Opportunity testMostResentApp;

		System.runAs(testCommunityUser) {
			CC_HomeController homeController = new CC_HomeController();
			testMostResentApp = homeController.mostRecentApp;
		}

		System.assertEquals( testApp.Id, testMostResentApp.Id );
	}



	@isTest
	static void testGetMostRecentAppWitFewOpportunity() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );
		Opportunity testAppFirst = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );
		for ( Integer i = 0; i < 500000; i++ ) {}
		Opportunity testAppLast = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );

		Opportunity testMostResentApp;

		System.runAs(testCommunityUser) {
			CC_HomeController homeController = new CC_HomeController();
			testMostResentApp = homeController.mostRecentApp;
		}

		System.assertEquals( testAppLast.Id, testMostResentApp.Id );
	}
}