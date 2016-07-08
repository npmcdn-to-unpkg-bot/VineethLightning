/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CC_MyDetails page. Class provides information about customer's info
*/
public with sharing class CC_MyDetailsController {

	public CC_MyDetailsController() {
		
	}



	@RemoteAction
	public static Contact getCustomerDetailInformation(Id userId) {
		User customerUser = [Select Id, ContactId From User Where Id = :userId];
		Contact customerContact;
		if (customerUser != null && customerUser.ContactId != null) {
			customerContact = [Select Id, Salutation, FirstName, LastName, Gender__c, Phone,
		                              MobilePhone, Email, MailingCountry, MailingPostalCode, Birthdate
		                       From Contact
		                       Where Id = :customerUser.ContactId
		                       LIMIT 1];
		}

		return customerContact;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method sets the customer's information (update Contact)
	* @param Id id of the user
	* @param String JSON string with customer's information
	* @return: Contact
	*/
	@RemoteAction
	public static Contact setCustomerDetailInformation(Id userId, String contactJson) {
		Schema.DescribeFieldResult dfr = Schema.sObjectType.User.fields.Email;
		system.debug('>>> Email is updateble ' + dfr.isUpdateable());
		
		dfr = Schema.sObjectType.User.fields.communityNickName;
		system.debug('>>> NickName is updateble ' + dfr.isUpdateable());

		User customerUser = [Select Id, ContactId From User Where Id = :userId];
		Contact customerContact;
		if (customerUser != null && customerUser.ContactId != null) {
			customerContact = (Contact)JSON.deserialize(contactJson, Type.forName('Contact'));
			update customerContact;
			updateUser(userId, customerContact.FirstName, customerContact.LastName, customerContact.Phone, customerContact.MobilePhone,
			           customerContact.Email, customerContact.MailingCountry, customerContact.MailingPostalCode);
		}

		return customerContact;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method updates User
	* @param Id id of the user
	* @param String user's first name
	* @param String user's last name
	* @param String user's phone
	* @param String user's mobile phone
	* @param String user's email
	* @param String user's country
	* @param String user's postal code
	* @return: void
	*/
	@future
	private static void updateUser(Id userId, String userFirstName, String userLastName, String userPhone,
	                               String userMobilePhone, String userEmail, String userCountry, String userPostalCode) {

		User customerUser = [Select Id, FirstName, LastName, Phone, MobilePhone, Email, Country, PostalCode, ContactId
		                     From User
		                     Where Id = :userId];

		String oldEmail = customerUser.Email;
		String newEmail = userEmail;

		customerUser.FirstName = userFirstName;
		customerUser.LastName = userLastName;
		customerUser.Phone = userPhone;
		customerUser.MobilePhone = userMobilePhone;
		customerUser.Email = userEmail;
		customerUser.Country = userCountry;
		customerUser.PostalCode = userPostalCode;

		update customerUser;

		if ( !newEmail.equals( oldEmail ) ) {
			String templateApiName = 'CC_ChangedEmail';
			String firstName = userFirstName;
			List< String > toRecipients = new List< String >();
			toRecipients.add( newEmail );
			List< String > ccRecipients = new List< String >();
			ccRecipients.add( oldEmail );

			sendTemplatedEmail( toRecipients, ccRecipients, templateApiName, firstName, oldEmail, newEmail );
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method updates User
	* @param List< String > list of the recipients
	* @param List< String > list of the copy recipients
	* @param String api name of the email template
	* @param String user's first name
	* @param String user's old email
	* @param String user's new email
	* @return: void
	*/
	public static void sendTemplatedEmail(
		List< String > toRecipients,
		List< String > ccRecipients,
		String templateApiName,
		String firstName,
		String oldEmail,
		String newEmail ) {

		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

		String htmlBody;  
		try {
			htmlBody = [Select Id, Name, HtmlValue From EmailTemplate Where Developername = :templateApiName].HtmlValue;
		}
		catch ( Exception e ) {
			System.debug( e.getMessage() );
			System.debug( e.getStackTraceString() );
			return;
		}

		htmlBody = htmlBody.replace( '{FirstName}', firstName );
		htmlBody = htmlBody.replace( '{OldEmail}', oldEmail );
		htmlBody = htmlBody.replace( '{NewEmail}', newEmail );

		email.setToAddresses( toRecipients );
		email.setCcAddresses( ccRecipients );
		email.setSubject( 'Your email has been changed.' );
		email.setHtmlBody( htmlBody );

		try {
			Messaging.sendEmail( new Messaging.SingleEmailMessage[] { email } );
			return;
		}
		catch ( EmailException e ) {
			System.debug( e.getMessage() );
			System.debug( e.getStackTraceString() );
			return;
		}
	}
}