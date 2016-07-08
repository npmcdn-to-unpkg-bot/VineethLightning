@isTest
private class CC_NewsBroadcastsTest {
	@testSetup
	static void dataSetup() {

		/*List<Account> accs = new List<Account>{
        	new Account(
       			Name = 'Test Customer Account'
       		),
       		new Account(
       			Name = 'Test Account'
       		)
        };
        insert accs;

        insert new AccountByType__c(
        		Name = 'Customer',
        		Id__c = accs.get(0).Id
        	);

        Contact c = new Contact(
        	AccountId = accs.get(1).Id, 
			LastName = 'Test',
			Gender__c = 'Male',
			Phone = '123123123',
			MobilePhone = '123123123',
			Email = 'test@test.com',
			MailingCountry = 'UK',
			MailingPostalCode = '123123',
			Birthdate = Date.today(),
			Description = 'Description'
		);
		insert c;

		Case case1 = new Case(
        	Status = 'Wroking',
        	Origin = 'Email'
        );
        insert case1;

        List<Opportunity> opportunities = new List<Opportunity>{
        	new Opportunity(
        		Name = 'Test',
        		AccountId = accs.get(0).Id,
        		StageName = 'Prospecting',
        		CloseDate = Date.today()
        	)
        };

        insert opportunities;


        User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );
		Opportunity testApp = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );

		Opportunity testMostResentApp;

		System.runAs(testCommunityUser) {
			CC_HomeController homeController = new CC_HomeController();
			testMostResentApp = homeController.mostRecentApp;
		}*/
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		Audience__c audience = CC_DataFactory.createAudience();
		Manage_Content__c content = CC_DataFactory.createManageContent(true);
		Content_Audience__c jContentAudience = CC_DataFactory.createContentAudience(audience.Id, content.Id, true);
		CC_DataFactory.publishContent(audience.Id, content.Id);
    }

	@isTest static void testGetNewsAndProductUpdate() {
		User user = [SELECT Id, ContactId FROM User WHERE Email = 'btt-dev-test1@email.com' LIMIT 1];
		Test.startTest();
		CC_ActionResult response;
		System.runAs(user) {
			response = CC_NewsBroadcastsCtrl.getNewsAndProductUpdate('DESC', 0, 5, '', '', 'ma');
			System.debug('TEST +++ ' + response);
		}
		Test.stopTest();
		
		System.assertEquals(true, response.success);
	}
	
	@isTest static void testGetNewsDetail() {
		User user = [SELECT Id, ContactId FROM User WHERE Email = 'btt-dev-test1@email.com' LIMIT 1];
		Manage_Content__c content = [SELECT Id FROM Manage_Content__c LIMIT 1];
		Test.startTest();
		CC_ActionResult response;
		System.runAs(user) {
			response = CC_NewsBroadcastsCtrl.getNewsDetail(content.Id);
			System.debug('TEST +++ ' + response);
		}
		Test.stopTest();
		
		System.assertEquals(true, response.success);
	}
}