@isTest
private class CC_CommunityTest {
	
	@testSetup
	static void dataSetup() {

		List<Account> accs = new List<Account>{
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
   }

	@isTest static void testCreateOpportunity() {
		Contact testCommunityContact = new Contact(
			Salutation = 'Mrs.',
			FirstName = 'Test',
			LastName = 'Test',
			Gender__c = 'Male',
			Phone = '123123123',
			MobilePhone = '123123123',
			Email = 'test@test.com',
			MailingCountry = 'UK',
			MailingPostalCode = '123123',
			Birthdate = Date.today()
		);
		String contactStr = JSON.serialize(testCommunityContact);

		Opportunity testOpp = new Opportunity(
			To_Do__c = 'Buying a first property',
			Council_Tax_Band__c = 'C',
			Mortgage_For__c = '',
			Mortgage_Term__c = 10,
			Type = 'All mortgages',
			Prefer_to_Pay__c = 'Interest only',
			Building_Name__c = '123',
			City__c = 'NY',
			County__c = 'Test',
			Country__c = 'Test Country',
			Postcode__c = '123',
			Type_of_Property__c = 'Cottage'
		);
        String oppStr = JSON.serialize(testOpp);  

		Test.startTest();
		CC_CommunityController.Response response = CC_CommunityController.createOpportunity(contactStr, oppStr, true);
		Test.stopTest();
		System.assertEquals(false, response.isSuccess);
                              		
	}

	@isTest static void testCreateOpportunityNotGuestUser() {
		Contact testCommunityContact = new Contact(
			Salutation = 'Mrs.',
			FirstName = 'Test',
			LastName = 'Test',
			Gender__c = 'Male',
			Phone = '123123123',
			MobilePhone = '123123123',
			Email = 'test2@test.com',
			MailingCountry = 'UK',
			MailingPostalCode = '123123',
			Birthdate = Date.today()
		);
		String contactStr = JSON.serialize(testCommunityContact);

		Opportunity testOpp = new Opportunity(
			To_Do__c = 'Buying a first property',
			Council_Tax_Band__c = 'C',
			Mortgage_For__c = '',
			Mortgage_Term__c = 10,
			Type = 'All mortgages',
			Prefer_to_Pay__c = 'Interest only',
			Building_Name__c = '123',
			City__c = 'NY',
			County__c = 'Test',
			Country__c = 'Test Country',
			Postcode__c = '123',
			Type_of_Property__c = 'Cottage'
		);
        String oppStr = JSON.serialize(testOpp);  

        
		Test.startTest();
		CC_CommunityController.Response response = CC_CommunityController.createOpportunity(contactStr, oppStr, false);
		Test.stopTest();

     	System.assertEquals(true, response.isSuccess);                         		
	}

	@isTest static void testFillOutContact() {
		Contact c = [SELECT Id FROM Contact WHERE Email = 'test@test.com'];
		Contact testCommunityContact = new Contact(
			Salutation = 'Mrs.',
			FirstName = 'Test',
			LastName = 'Test',
			Gender__c = 'Male',
			Phone = '0123123123',
			MobilePhone = '123123123',
			Email = 'test2@test.com',
			MailingCountry = 'UK',
			MailingPostalCode = '123123',
			Birthdate = Date.today()
		);

		Test.startTest();
		Contact testContact = CC_CommunityController.fillOutContact(c.Id, testCommunityContact);
		Test.stopTest();

		System.assertEquals(testContact.Description, 'Description');   
	}

	@isTest static void testCheckEmailDuplicates() {

		Test.startTest();
		Boolean duplicatesValue = CC_CommunityController.checkEmailDuplicates('test@test.com');
		Test.stopTest();

		System.assertEquals(false, duplicatesValue);   
	}
	
	@isTest static void testCreateRequest() {
		Case testCase = new Case();
		Opportunity opp = [SELECT Id, Case_Number__c FROM Opportunity WHERE Name = 'Test' LIMIT 1];
		Test.startTest();
		CC_CommunityController.Response testResponse = CC_CommunityController.createRequest(testCase, opp.Case_Number__c, '');
		Test.stopTest();
		System.debug('TEST +++ ' + testResponse);
		//System.assertEquals(false, duplicatesValue);   
	}

	@isTest static void testGetRequests() {
		Test.startTest();
		List<Case> testResponse = CC_CommunityController.getRequests();
		Test.stopTest();
		
		System.assertEquals(false, testResponse.isEmpty());   
	}
}