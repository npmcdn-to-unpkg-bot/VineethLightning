@isTest
private class CB_ApplicationDetailTest {
	
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
	
	@isTest static void testUpdateApplicationDetail() {
		Opportunity opp = [SELECT Id, Deposit__c, County__c FROM Opportunity LIMIT 1];
		ApexPages.currentPage().getParameters().put('Id', opp.Id);
		
		Test.startTest();
		CB_ApplicationDetailCtrl testController = new CB_ApplicationDetailCtrl();
		testController.opportunity = opp;
		testController.opportunity.County__c = '10222';
		testController.updateApplicationDetail();
		Test.stopTest();
		
		Opportunity checkOpp = [SELECT County__c FROM Opportunity LIMIT 1];
		System.assertEquals(checkOpp.County__c, '10222');
	}

	@isTest static void testGetters() {
		Opportunity opp = [SELECT Id, Stagename FROM Opportunity LIMIT 1];
		ApexPages.currentPage().getParameters().put('Id', opp.Id);

		Test.startTest();
		CB_ApplicationDetailCtrl testController = new CB_ApplicationDetailCtrl();
		testController.opportunity = opp;
		List<String> testList = testController.steps;
		Integer stage = testController.activeStageIndex;
		Test.stopTest();

		System.assertEquals(6, stage);
		System.assertEquals(6, testList.size());
	}
}