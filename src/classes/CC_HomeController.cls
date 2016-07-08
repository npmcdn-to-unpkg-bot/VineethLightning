/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CC_HOME page. Class provides info about the most recent user's mortgage application
*/
public with sharing class CC_HomeController {

	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets the most recent user's mortgage application
	* @return: Opportunity
	*/
	public Opportunity mostRecentApp {
		get {
			
			User customerUser = [Select Id, ContactId From User Where Id = :UserInfo.getUserId() LIMIT 1];
			if ( customerUser == null || customerUser.ContactId == null ) {
				return null;
			}

			List< Opportunity > customerApps = [Select Id, Customer__c, CreatedDate, Case_Number__c, Need_Additional_Information__c,
			        Gross_annual_income__c, Current_credit_card_balance__c, Total_monthly_loan_payments__c,
			        Other_monthly_financial_commitments__c, Stagename, To_Do__c, Amount,
			        Deposit__c, Type, Prefer_to_Pay__c, Mortgage_Term__c, Building_Name__c, City__c,
			        County__c, Postcode__c, Country__c, Type_of_Property__c, Council_Tax_Band__c
			    From Opportunity
			    Where Customer__c = :customerUser.ContactId LIMIT 50000];

			Opportunity mostRecentApplication;

			if ( customerApps.isEmpty() ) {
				return null;
			} else if ( customerApps.size() == 1 ) {
				mostRecentApplication = customerApps[ 0 ];
			} else {
				mostRecentApplication = [Select Id, Customer__c, CreatedDate, Case_Number__c, Need_Additional_Information__c,
			            Gross_annual_income__c, Current_credit_card_balance__c, Total_monthly_loan_payments__c,
			            Other_monthly_financial_commitments__c, Stagename, To_Do__c, Amount,
			            Deposit__c, Type, Prefer_to_Pay__c, Mortgage_Term__c, Building_Name__c, City__c,
			            County__c, Postcode__c, Country__c, Type_of_Property__c, Council_Tax_Band__c
			        From Opportunity
			        Where Customer__c = :customerUser.ContactId
			        Order By isClosed, CreatedDate desc
			        LIMIT 1];
			}

			return mostRecentApplication;
		}
		
		private set {}
	}



	public CC_HomeController() {
		
	}
}