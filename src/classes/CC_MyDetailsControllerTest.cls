@isTest
private class CC_MyDetailsControllerTest {
	
	@isTest
	static void testMyDetailsController() {
		CC_MyDetailsController myDetailsController = new CC_MyDetailsController();

		System.assertNotEquals( null, myDetailsController );
	}



	@isTest
	static void testGetCustomerDetailInformation() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		Test.startTest();
		Contact customerContact = CC_MyDetailsController.getCustomerDetailInformation( testCommunityUser.Id );
		Test.stopTest();

		System.assertEquals( testCommunityUser.ContactId, customerContact.Id );
	}



	@isTest
	static void testSetCustomerDetailInformation() {
		User testCommunityUser = CC_DataFactory.createCommunityUser( 'btt-dev-test1@email.com' );

		String newSalutation = 'Mr.';
		String newFirstName = 'TestFirstNew';
		String newLastName = 'TestLastNew';
		String newPhone = '111';
		String newMobilePhone = '222';
		String newEmail = 'testNew@email.com';
		String newCountry = 'USA';
		String newGender = 'Male';
		String newPostalCode = '333';

		String contactJson = '{' +
			'"Id":"' + testCommunityUser.ContactId + '",' +
			'"Salutation":"' + newSalutation + '",' +
			'"FirstName":"' + newFirstName + '",' +
			'"LastName":"' + newLastName + '",' +
			'"Phone":"' + newPhone + '",' +
			'"MobilePhone":"' + newMobilePhone + '",' +
			'"Email":"' + newEmail + '",' +
			'"MailingCountry":"' + newCountry + '",' +
			'"Birthdate":"2016-03-30",' +
			'"Gender__c":"' + newGender + '",' +
			'"MailingPostalCode":"' + newPostalCode + '"' +
		'}';

		Test.startTest();
		Contact customerContact = CC_MyDetailsController.setCustomerDetailInformation( testCommunityUser.Id, contactJson );
		Test.stopTest();

		System.assertEquals( newSalutation, customerContact.Salutation );
		System.assertEquals( newFirstName, customerContact.FirstName );
		System.assertEquals( newLastName, customerContact.LastName );
		System.assertEquals( newPhone, customerContact.Phone );
		System.assertEquals( newMobilePhone, customerContact.MobilePhone );
		System.assertEquals( newEmail, customerContact.Email );
		System.assertEquals( newCountry, customerContact.MailingCountry );
		System.assertEquals( newGender, customerContact.Gender__c );
		System.assertEquals( newPostalCode, customerContact.MailingPostalCode );
	}
	
}