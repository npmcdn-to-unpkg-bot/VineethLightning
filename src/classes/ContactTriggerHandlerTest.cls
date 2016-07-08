@isTest
private class ContactTriggerHandlerTest {

	@testSetup
    static void dataSetup() {

        List<Account> accs = new List<Account>{
        	new Account(
       			Name = 'Test Account'
       		)
        };

        insert accs;
        List<Contact> contacts = new List<Contact>{
        	new Contact(
                AccountId = accs.get(0).Id,
                FirstName = 'Test', 
                LastName = 'UnitTest',
                Email = 'test@test.test'
            )
        };
        insert contacts;

    }
	
	@isTest static void testCheckduplicates() {
		
		Test.startTest();
		try {
			insert new Contact(
				FirstName = 'Test2', 
		        LastName = 'UnitTest2',
		        Email = 'test@test.test'
			);
		} catch (DmlException ex) {
		}
				

		List<Contact> contacts = [SELECT ID FROM Contact LIMIT 10000];
		System.assertEquals(1, contacts.size());

		insert new Contact(
			FirstName = 'Test2', 
            LastName = 'UnitTest2',
            Email = 'test2@test.test'
		);
		contacts = [SELECT ID FROM Contact LIMIT 10000];
		System.assertEquals(2, contacts.size());
		Test.stopTest();
	}
}