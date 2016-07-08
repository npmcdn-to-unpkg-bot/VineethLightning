@isTest
private class CC_tableQueryTest {
	
	@isTest static void testTableQuery() {
		CC_tableQuery testTableQuery = new CC_tableQuery();

		System.assertNotEquals( null, testTableQuery );
	}



	@isTest static void testGetObjLst() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );
		Opportunity testApp1 = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );
		Opportunity testApp2 = CC_DataFactory.createCustomerApplication( testCommunityUser.ContactId );

		CC_tableQuery testTableQuery = new CC_tableQuery();
		testTableQuery.limitValue = 1;
		testTableQuery.objName = 'opportunity';
		testTableQuery.apiFields = 'Id,Name';
		testTableQuery.filter = 'isClosed = False';
		testTableQuery.nameField = '';
		testTableQuery.detailPage = '';

		List< sObject > testListOfApplications = testTableQuery.getObjLst();

		System.assertNotEquals( null, testListOfApplications );
		System.assertEquals( 1, testListOfApplications.size() );
	}



	@isTest static void testGetObjLstEmpty() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		CC_tableQuery testTableQuery = new CC_tableQuery();
		testTableQuery.limitValue = 1;
		testTableQuery.objName = 'opportunity';
		testTableQuery.apiFields = 'Id,Name';
		testTableQuery.filter = 'isClosed = False';
		testTableQuery.nameField = '';
		testTableQuery.detailPage = '';

		List< sObject > testListOfApplications = testTableQuery.getObjLst();

		System.assertEquals( null, testListOfApplications );
	}
	
}