@isTest
private class CC_CommunityApplicationTest {
	
	@testSetup
	static void dataSetup() {
		List<Account> accs = new List<Account>{
        	new Account(
       			Name = 'Test Account'
       		)
        };
        insert accs;

        List<Opportunity> opportunities = new List<Opportunity>{
        	new Opportunity(
        		Name = 'Test',
        		AccountId = accs.get(0).Id,
        		StageName = 'Won',
        		CloseDate = Date.today()
        	)
        };

        insert opportunities;
    }
	
	@isTest static void test_CC_CommunityApplicationController() {
		Opportunity opp = [SELECT Id, Stagename FROM Opportunity LIMIT 1];

		Test.startTest();
        PageReference pageRef = Page.CC_ApplicationDetailPage;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller standardCtrl = new ApexPages.Standardcontroller(opp);
        CC_CommunityApplicationController communityAppCtrl = new CC_CommunityApplicationController(standardCtrl);
		Test.stopTest();

		System.assertEquals(6, communityAppCtrl.steps.size());
	}
	
}