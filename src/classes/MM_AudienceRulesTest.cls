@isTest
private class MM_AudienceRulesTest {
	@testSetup
	static void dataSetup() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		Audience__c audience = CC_DataFactory.createAudience();
		Manage_Content__c content = CC_DataFactory.createManageContent(true);
		Content_Audience__c jContentAudience = CC_DataFactory.createContentAudience(audience.Id, content.Id, true);
    }

	@isTest static void testGetOperators() {
		Audience__c audience = [SELECT Id FROM Audience__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.MM_ManageAudiences;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(audience);
        MM_AudienceRulesController audienceController = new MM_AudienceRulesController(sc);
		List<selectOption> options = audienceController.getOperators();		
		Test.stopTest();

		System.assertEquals(7, options.size());
	}

	@isTest static void testEditModeChanges() {
		Audience__c audience = [SELECT Id FROM Audience__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.MM_ManageAudiences;

        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', audience.Id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(audience);
        MM_AudienceRulesController audienceController = new MM_AudienceRulesController(sc);
		
		audienceController.enterEditMode();		
		System.assertEquals(true, audienceController.editMode);

		audienceController.cancelEditMode();
		System.assertEquals(false, audienceController.editMode);

		audienceController.AddRow();
		List<MM_AudienceRulesController.RuleSet> rules = audienceController.getRules();
		System.assertEquals(2, rules.size());
		
		audienceController.enterEditMode();
		audienceController.SaveAll();
		System.assertEquals(false, audienceController.editMode);

		audienceController.deleteSelected();
		List<SelectOption> userFields = audienceController.getUserFields();
		System.assertEquals(false, userFields.isEmpty());
		Test.stopTest();

	}

	@isTest static void testPagination() {
		Audience__c audience = [SELECT Id FROM Audience__c LIMIT 1];

        Test.startTest();
        PageReference pageRef = Page.MM_ManageAudiences;

        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', audience.Id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(audience);
        MM_AudienceRulesController audienceController = new MM_AudienceRulesController(sc);
		
		List<Contact> contacts = audienceController.getContentBrokers();		
		System.assertEquals(1, contacts.size());

		Boolean hasPrevious = audienceController.getHasPrevious();
		System.assertEquals(false, hasPrevious);

		Boolean hasNext = audienceController.getHasNext();
		System.assertEquals(false, hasNext);
		
		Integer pageNumber = audienceController.getPageNumber();
		System.assertEquals(1, pageNumber);

		Integer totalPages = audienceController.getTotalPages();
		System.assertEquals(1, totalPages);

		audienceController.dofirst();
		audienceController.doPrevious();
		audienceController.doNext();
		audienceController.doLast();
		Test.stopTest();

	}
}