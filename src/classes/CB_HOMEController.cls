/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CB_HOME page. Class provides info about servise requests, mortgage applicants and applications
*/
public with sharing class CB_HOMEController {

	public CB_HOMEController() {
		
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage applicants
	* @return: List< Contact >
	*/
	@RemoteAction
	public static List< Contact > getCustomerList() {
		AccountByType__c customerAccount = AccountByType__c.getInstance( 'Customer' );
		Id customerAccountId = customerAccount.Id__c;

		List< Contact > customerList = [Select Id, FirstName, LastName, Email
			From Contact
			Where AccountId = :customerAccountId
			Order By FirstName, LastName
			LIMIT 50000];
			
		return customerList;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage applications
	* @return: List< Opportunity >
	*/
	@RemoteAction
	public static List< Opportunity > getApplicationList() {
		AccountByType__c customerAccount = AccountByType__c.getInstance( 'Customer' );
		Id customerAccountId = customerAccount.Id__c;

		List< Opportunity > applicationList = [Select Id, Case_Number__c, Customer_Name__c, StageName, To_Do__c, Amount, Deposit__c, Mortgage_Term__c
			From Opportunity
			Where AccountId = :customerAccountId
			Order By CreatedDate DESC
			LIMIT 50000];
			
		return applicationList;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the service requests
	* @return: List< Case >
	*/
	@RemoteAction
	public static List< Case > getCaseList() {
		List< Case > caseList = [Select Id, CaseNumber, Application_Number__c, Priority, CreatedDate
			From Case
			Where Application_Number__c != null
			Order By CreatedDate DESC
			LIMIT 50000];
			
		return caseList;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets data for chart (count of registered users per day for last 30 days)
	* @return: CustomerChartDataWrapper
	*/
	@RemoteAction
	public static CustomerChartDataWrapper getCustomerChartData() {
		AccountByType__c customerAccount = AccountByType__c.getInstance('Customer');
		Id customerAccountId = customerAccount.Id__c;

		Map< String, Integer > chartData = new Map< String, Integer >();
		for( Contact cont : [Select Id, CreatedDate
			From Contact
			Where AccountId = :customerAccountId AND CreatedDate = LAST_N_DAYS:30
			Order By CreatedDate
			LIMIT 50000] ) {

			String tmpDate = cont.CreatedDate.format( 'yyyy-MM-dd' );
			Integer tmpChartData = chartData.get( tmpDate );
			if ( tmpChartData == null ) {
				chartData.put( tmpDate, 1 );
			} else {
				tmpChartData++;
				chartData.put( tmpDate, tmpChartData );
			}
		}

		CustomerChartDataWrapper customerChartDataWrapper = new CustomerChartDataWrapper();
		customerChartDataWrapper.cuctomerCount.addAll( chartData.values() );
		customerChartDataWrapper.registrationDate.addAll( chartData.keySet() );

		return customerChartDataWrapper;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: Wrapper class for chart data
	*/
	public class CustomerChartDataWrapper {
		public List< Integer > cuctomerCount { get; set; }
		public List< String > registrationDate { get; set; }

		public CustomerChartDataWrapper() {
			cuctomerCount = new List< Integer >();
			registrationDate = new List< String >();
		}
	}

}