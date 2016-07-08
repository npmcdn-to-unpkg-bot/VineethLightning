/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CB_NewApplicationPage page. Class provides the creation of new mortgage applications and community users
*/
public with sharing class CB_NewApplicationController {

	private static final string CUSTOMER_PORTAL_PROFILE_NAME = 'Mortgage Customer Community Test';
	private static final string BROKER_PORTAL_PROFILE_NAME = 'Mortgage Broker Community Test';
	private static final string BROKER_RECORD_TYPE_NAME = 'Broker';
	private static final string APPLICANT_RECORD_TYPE_NAME = 'Mortgage Applicant';
	private static final string APPLICATION_RECORD_TYPE_NAME = 'Mortgage';
	private static final string COMMUNITY_ACCOUNT_SETTING = 'Customer';
	private static final string USER_ALIAS = 'ttest';
	private static final string USER_TIME_ZONE_SID_KEY = 'GMT';
	private static final string USER_LOCALE_SID_KEY = 'en_GB';
	private static final string USER_EMAIL_ENCODING_KEY = 'ISO-8859-1';
	private static final string USER_LANGUAGE_LOCALE_KEY = 'en_US';

	private static final string MORTGAGE_TYPE_APPLICANT = 'mortgageCustomer';
	private static final string MORTGAGE_TYPE_BROKER = 'broker';

	

	public CB_NewApplicationController( ApexPages.StandardController stdController ) {
		
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage applicants
	* @return: List< Contact >
	*/
	@ReadOnly
	@RemoteAction
	public static List< Contact > getMortgageApplicants() {
		return [
			Select Id, FirstName, LastName, Email
			From Contact
			Where RecordType.DeveloperName IN ('Mortgage_Applicant')
			Order By FirstName, LastName
			LIMIT 50000
		];
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage brokers
	* @return: List< Contact >
	*/
	@ReadOnly
	@RemoteAction
	public static List< Contact > getMortgageBrokers() {
		return [
			Select Id, FirstName, LastName, Email
			From Contact
			Where RecordType.DeveloperName IN ('Broker')
			Order By FirstName, LastName
			LIMIT 50000
		];
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage types
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getMortgageTypes() {
		List< SelectOptionWrapper > mortgageTypes = new List< SelectOptionWrapper >();
		mortgageTypes.add( new SelectOptionWrapper( 'Mortgage Customer', MORTGAGE_TYPE_APPLICANT ) );
		mortgageTypes.add( new SelectOptionWrapper( 'Broker', MORTGAGE_TYPE_BROKER ) );

		return mortgageTypes;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the contact's salutations
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getSalutations() {
		Schema.DescribeFieldResult contactSalutationFieldResult = Contact.Salutation.getDescribe();
		List< Schema.PicklistEntry > contactSalutationPicklistValues = contactSalutationFieldResult.getPicklistValues();
		
		List< SelectOptionWrapper > salutations = new List< SelectOptionWrapper >();
		for ( Schema.PicklistEntry contactSalutationPicklistValue : contactSalutationPicklistValues ) {
			salutations.add( new SelectOptionWrapper( contactSalutationPicklistValue.getLabel(),
				                                      contactSalutationPicklistValue.getValue() ) );
		}

		return salutations;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the countries
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getCountries() {
		List< SelectOptionWrapper > countries = new List< SelectOptionWrapper >();
		countries.add( new SelectOptionWrapper( 'UK', 'uk' ) );
		countries.add( new SelectOptionWrapper( 'USA', 'usa' ) );
		countries.add( new SelectOptionWrapper( 'India', 'india' ) );

		return countries;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage regardings
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getAppToDo() {
		Schema.DescribeFieldResult opportunityToDoFieldResult = Opportunity.To_Do__c.getDescribe();
		List< Schema.PicklistEntry > opportunityToDoPicklistValues = opportunityToDoFieldResult.getPicklistValues();
		
		List< SelectOptionWrapper > appToDo = new List< SelectOptionWrapper >();
		for ( Schema.PicklistEntry opportunityToDoPicklistValue : opportunityToDoPicklistValues ) {
			appToDo.add( new SelectOptionWrapper( opportunityToDoPicklistValue.getLabel(),
				                                  opportunityToDoPicklistValue.getValue() ) );
		}

		return appToDo;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage application types
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getAppType() {
		Schema.DescribeFieldResult opportunityTypeFieldResult = Opportunity.Type.getDescribe();
		List< Schema.PicklistEntry > opportunityTypePicklistValues = opportunityTypeFieldResult.getPicklistValues();
		
		List< SelectOptionWrapper > appType = new List< SelectOptionWrapper >();
		for ( Schema.PicklistEntry opportunityTypePicklistValue : opportunityTypePicklistValues ) {
			appType.add( new SelectOptionWrapper( opportunityTypePicklistValue.getLabel(),
				                                  opportunityTypePicklistValue.getValue() ) );
		}

		return appType;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage methods of payment
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getAppPreferToPay() {
		Schema.DescribeFieldResult opportunityPreferToPayFieldResult = Opportunity.Prefer_to_Pay__c.getDescribe();
		List< Schema.PicklistEntry > opportunityPreferToPayPicklistValues = opportunityPreferToPayFieldResult.getPicklistValues();
		
		List< SelectOptionWrapper > appPreferToPay = new List< SelectOptionWrapper >();
		for ( Schema.PicklistEntry opportunityPreferToPayPicklistValue : opportunityPreferToPayPicklistValues ) {
			appPreferToPay.add( new SelectOptionWrapper( opportunityPreferToPayPicklistValue.getLabel(),
				                                         opportunityPreferToPayPicklistValue.getValue() ) );
		}

		return appPreferToPay;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage types of property
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getAppTypeOfProperty() {
		Schema.DescribeFieldResult opportunityTypeOfPropertyFieldResult = Opportunity.Type_of_Property__c.getDescribe();
		List< Schema.PicklistEntry > opportunityTypeOfPropertyPicklistValues = opportunityTypeOfPropertyFieldResult.getPicklistValues();
		
		List< SelectOptionWrapper > appTypeOfProperty = new List< SelectOptionWrapper >();
		for ( Schema.PicklistEntry opportunityTypeOfPropertyPicklistValue : opportunityTypeOfPropertyPicklistValues ) {
			appTypeOfProperty.add( new SelectOptionWrapper( opportunityTypeOfPropertyPicklistValue.getLabel(),
				                                            opportunityTypeOfPropertyPicklistValue.getValue() ) );
		}

		return appTypeOfProperty;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage application's council tax bands
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getAppCouncilTaxBand() {
		Schema.DescribeFieldResult opportunityCouncilTaxBandFieldResult = Opportunity.Council_Tax_Band__c.getDescribe();
		List< Schema.PicklistEntry > opportunityCouncilTaxBandPicklistValues = opportunityCouncilTaxBandFieldResult.getPicklistValues();
		
		List< SelectOptionWrapper > appCouncilTaxBand = new List< SelectOptionWrapper >();
		for ( Schema.PicklistEntry opportunityCouncilTaxBandPicklistValue : opportunityCouncilTaxBandPicklistValues ) {
			appCouncilTaxBand.add( new SelectOptionWrapper( opportunityCouncilTaxBandPicklistValue.getLabel(),
				                                            opportunityCouncilTaxBandPicklistValue.getValue() ) );
		}

		return appCouncilTaxBand;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage terms
	* @return: List< SelectOptionWrapper >
	*/
	@RemoteAction
	public static List< SelectOptionWrapper > getAppYears() {
		List< SelectOptionWrapper > appYears = new List< SelectOptionWrapper >();
		appYears.add( new SelectOptionWrapper( '5', '5' ) );
		appYears.add( new SelectOptionWrapper( '10', '10' ) );
		appYears.add( new SelectOptionWrapper( '15', '15' ) );
		appYears.add( new SelectOptionWrapper( '20', '20' ) );

		return appYears;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method checks if there is any user with such email
	* @param String email
	* @return: Boolean
	*/
	@RemoteAction
	public static Boolean checkEmailDuplicates( String email ) {
		List< User > contacts = [
			Select Id
			From User
			Where Email = :email
			LIMIT 1
		];

		return ( contacts.isEmpty() ) ? false : true;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method checks if such username is valid
	* @param String email
	* @return: Boolean
	*/
	@RemoteAction
	public static Boolean isValidUsername( String email ) {
//		List < Contact > contactsWithEqualEmail = [
//			Select Id
//			From Contact
//			Where Email = :email
//			LIMIT 1
//		];
//
//		if ( contactsWithEqualEmail.size() > 0 ) {
//			return false;
//		}

		return Site.isValidUsername( email );
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method creates new mortgage application and also broker and customer
	* @param String JSON string with new application info
	* @return: SubmitAppResult
	*/
	@RemoteAction
	public static SubmitAppResult submitApplication ( String newMortgageJSON ) {
		CB_Mortgage mortgage = ( CB_Mortgage )JSON.deserialize( newMortgageJSON, CB_Mortgage.class );
		try {
			User broker;
			if ( mortgage.createBroker ) {
				broker = createBroker( mortgage.broker );
			} 
			if ( mortgage.findBroker ) {
				broker = findBroker( mortgage.broker );
			}
			if ( !String.isEmpty( mortgage.brokerType ) && broker == null ) {
				return new SubmitAppResult( false, 'Broker creation was failed.' );
			}

			Contact applicant;
			if ( mortgage.createApplicant ) {
				applicant = createApplicant( mortgage.applicant, mortgage.mortgageType, broker );
			}
			if ( mortgage.findApplicant ) {
				//applicant = findApplicant( mortgage.applicant );
				applicant = mortgage.applicant;
			}
			if ( applicant == null ) {
				return new SubmitAppResult( false, 'Customer creation was failed.' );
			}

			Opportunity application = createApplication( applicant.Id, mortgage.mortgage );
			if ( application == null ) {
				return new SubmitAppResult( false, 'Application creation was failed.' );
			}

			return new SubmitAppResult( true, 'Application was created successfully' );
		}
		catch ( Exception e ) {
			System.debug( '>>>' + e.getMessage() );
			System.debug( '>>>' + e.getStackTraceString() );
			return new SubmitAppResult( false, e.getMessage() );
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method finds existing broker
	* @param Contact broker info
	* @return: User
	*/
	private static User findBroker( Contact broker ) {
		User brokerUser = [
			Select Id, FirstName, LastName, Email, ContactId
			From User
			Where ContactId = :broker.Id AND Email = :broker.Email
			LIMIT 1
		];

		return brokerUser;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method creates new broker
	* @param Contact broker info
	* @return: User
	*/
	private static User createBroker( Contact broker ) {
		broker.AccountId = getPortalAccountId();
		broker.RecordTypeId = IntroducerRegistrationController.getRecordTypeId( Contact.getSobjectType(), BROKER_RECORD_TYPE_NAME ); 

		insert broker;

		Boolean isCustomer = false;
		User brokerUser = createUser( isCustomer, broker );

		return brokerUser;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method finds existing applicant
	* @param Contact applicant info
	* @return: User
	*/
	private static User findApplicant( Contact applicant ) {
		User applicantUser = [
			Select Id, FirstName, LastName, Email, ContactId
			From User
			Where ContactId = :applicant.Id AND Email = :applicant.Email
			LIMIT 1
		];

		return applicantUser;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method creates new applicant
	* @param Contact applicant info
	* @param String mortgage type
	* @param User broker info
	* @return: Contact
	*/
	private static Contact createApplicant( Contact applicant, String mortgageType, User broker ) {
		List < Contact > contactsWithEqualEmail = [
			Select Id
			From Contact
			Where Email = :applicant.Email
			LIMIT 1
		];

		if ( contactsWithEqualEmail.size() <= 0 ) {
			applicant.AccountId = getPortalAccountId();
			applicant.RecordTypeId = IntroducerRegistrationController.getRecordTypeId( Contact.getSobjectType(), APPLICANT_RECORD_TYPE_NAME ); 
			
			if ( mortgageType.equals( MORTGAGE_TYPE_BROKER ) && broker != null ) {
				applicant.BrokerId__c = broker.Id;
			}

			insert applicant;
		}

		User applicantUser;
		if ( mortgageType.equals( MORTGAGE_TYPE_APPLICANT ) ) {
			Boolean isCustomer = true;
			applicantUser = createUser( isCustomer, applicant );
		}

		return applicant;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method creates new user
	* @param Boolean true if created user is customer
	* @param Contact mortgage type
	* @return: User
	*/
	private static User createUser( Boolean isCustomer, Contact cont ) {
		String communityNickname = '';
		if ( cont.FirstName.length() > 40 - String.valueOf( Datetime.now() ).length() ) {
			communityNickname = cont.FirstName.substring( 0, 40 - String.valueOf( Datetime.now() ).length() ) + Datetime.now();
		} else {
			communityNickname = cont.FirstName + Datetime.now();
		}

		User user = new User(
			Username = cont.Email,
			Email = cont.Email,
			FirstName = cont.FirstName,
			LastName = cont.LastName,
			ProfileId = getProfileId( isCustomer ),
			CommunityNickname = communityNickname,
			ContactId = cont.Id,
			Alias = USER_ALIAS,
			TimeZoneSidKey = USER_TIME_ZONE_SID_KEY,
			LocaleSidKey = USER_LOCALE_SID_KEY,
			EmailEncodingKey = USER_EMAIL_ENCODING_KEY,
			LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY
		);

		insert user;

		return user;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method creates new mortgage application
	* @param Id applicant id
	* @param Opportunity application info
	* @return: Opportunity
	*/
	private static Opportunity createApplication( Id applicantId, Opportunity application ) {
		application.AccountId = getPortalAccountId();
		application.Customer__c = applicantId;
		application.RecordTypeId = IntroducerRegistrationController.getRecordTypeId( Opportunity.getSobjectType(), APPLICATION_RECORD_TYPE_NAME );
		application.Name = application.To_Do__c;
		application.StageName = 'New';
		application.CloseDate = System.today() + 7;

		insert application;

		return application;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets default account for customer community
	* @return: Id
	*/
	private static Id getPortalAccountId() {
		AccountByType__c customerAccount = AccountByType__c.getInstance( COMMUNITY_ACCOUNT_SETTING );
		Id customerAccountId = customerAccount.Id__c;

		return customerAccountId;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets profile id for customer or broker
	* @param Boolean true if created user is customer
	* @return: Id
	*/
	private static Id getProfileId( Boolean isCustomer ) {
		if ( isCustomer ) {
			return [
        	    Select Id
        	    From Profile
        	    Where Name = :CUSTOMER_PORTAL_PROFILE_NAME
        	    LIMIT 1
        	].Id;
    	} else {
    		return [
        	    Select Id
        	    From Profile
        	    Where Name = :BROKER_PORTAL_PROFILE_NAME
        	    LIMIT 1
        	].Id;
    	}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: Wrapper class for select options
	*/
	public class SelectOptionWrapper {
		public String label { get; set; }
		public String value { get; set; }

		public SelectOptionWrapper( String label, String value ) {
			this.label = label;
			this.value = value;
		}
	}


	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: Class for describing the results of submit application
	*/
	public class SubmitAppResult {
		public Boolean isSuccess { get; set; }
		public String message { get; set; }

		public SubmitAppResult( Boolean isSuccess, String message ) {
			this.isSuccess = isSuccess;
			this.message = message;
		}
	}

}