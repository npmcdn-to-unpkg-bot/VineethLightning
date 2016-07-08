@isTest
private class OpportunityTriggerHandlerTest {
	
	@isTest static void testAddStatusFeed() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );
		Opportunity testApp = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );

		Test.startTest();
		try {
			testApp.StageName = 'New';
			update testApp;
		} catch (DmlException ex) {
		}

		List<FeedItem> testFeeds = [SELECT ID FROM FeedItem WHERE ParentId =: testApp.Id LIMIT 10000];
		System.assertEquals(1, testFeeds.size());
		Test.stopTest();
	}

}