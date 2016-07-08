@isTest
public class CC_DataFactory {

	public static Account createCommunityAccount() {
		Account testCommunityAccount = new Account(
			Name = 'Customer'
		);
		insert testCommunityAccount;

		return testCommunityAccount;
	}



	public static Contact createCommunityContact(
		Id comunityAccountId,
		String salutation,
		String firstName,
		String lastName,
		String gender,
		String phone,
		String mobilePhone,
		String email,
		String mailingCountry,
		String mailingPostalCode,
		Date birthdate) {

		Contact testCommunityContact = new Contact(
			AccountId = comunityAccountId,
			Salutation = salutation,
			FirstName = firstName,
			LastName = lastName,
			Gender__c = gender,
			Phone = phone,
			MobilePhone = mobilePhone,
			Email = email,
			MailingCountry = mailingCountry,
			MailingPostalCode = mailingPostalCode,
			Birthdate = birthdate
		);
		insert testCommunityContact;

		return testCommunityContact;
	}



	public static User createCommunityUser( String username ) {
		Account testCommunityAccount = createCommunityAccount();

		String salutation = 'Mr.';
		String firstName = 'TestFirst1';
		String lastName = 'TestLast1';
		String email = username;
		String gender = 'Male';
		String phone = '1111111';
		String mobilePhone = '2222222';
		String mailingCountry = 'Country';
		String mailingPostalCode = '333';
		Date birthdate = Date.newInstance( 2000, 1, 1 );
		Contact testCommunityContact = createCommunityContact(
			testCommunityAccount.Id,
			salutation,
			firstName,
			lastName,
			gender,
			phone,
			mobilePhone,
			email,
			mailingCountry,
			mailingPostalCode,
			birthdate
		);

		String profileId = [Select Id From Profile Where Name = 'Mortgage Customer Community Test' LIMIT 1].Id; 

		User testCommunityUser = new User(
			ContactId = testCommunityContact.Id,
			Username = username,
			Email = email,
			FirstName = firstName,
			LastName = lastName,
			Phone = phone,
			MobilePhone = mobilePhone,
			Country = mailingCountry,
			PostalCode = mailingPostalCode,
			ProfileId = profileId,
			CommunityNickname = username,
			Alias = 'ttest',
			TimeZoneSidKey = 'GMT',
			LocaleSidKey = 'en_GB',
			EmailEncodingKey = 'ISO-8859-1',
			LanguageLocaleKey = 'en_US'
		);
		insert testCommunityUser;

		return testCommunityUser;
	}



	public static Opportunity createCustomerApplication(String customerId) {
		Opportunity testCustomerApp = new Opportunity(
			Name = 'testApp',
			Customer__c = customerId,
			StageName = 'Prospecting',
			CloseDate = Date.today()
		);
		insert testCustomerApp;

		return testCustomerApp;
	}

	public static Audience__c createAudience() {
        Audience__c audience = new Audience__c(Name = 'Audience1', Description__c = 'Test Audience');
        insert audience;
        AudienceRule__c rule = new AudienceRule__c (
        	Audience__c = audience.Id,
        	UserField__c = 'Gender__c',
        	Operator__c = '=',
        	Value__c = 'Male'
        );
        insert rule;
        return audience;
    }

    public static Manage_Content__c createManageContent(Boolean doInsert) {
        Manage_Content__c manageContent = new Manage_Content__c(Title__c = 'manageContent1', Publish_Start__c = System.today(), Publish_End__c = System.today().addDays(10));
        if (doInsert) {
            insert manageContent;
        }
        return manageContent;
    }

    public static Content_Audience__c createContentAudience(Id audienceId, Id manageContentId, Boolean doInsert) {
        Content_Audience__c contentAudience = new Content_Audience__c(Audience__c = audienceId, Manage_Content__c = manageContentId);
        insert contentAudience;
        return contentAudience;
    }
    
    public static void publishContent(Id audienceId, Id manageContentId) {
        List<Contact> lBrokers = MM_Audiences.retrieveContacts(new List<Id>{ audienceId });

        List<Content_Broker__c> insertSet = new List<Content_Broker__c>();

        for (Contact lc : lBrokers) {
            Content_Broker__c cb = new Content_Broker__c();
            cb.Manage_content__c = manageContentId;
            cb.Contact__c = lc.id;
            insertSet.add(cb);
        }

        insert insertSet;
    }

}