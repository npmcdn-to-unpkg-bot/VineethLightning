/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CB_MortgagePayments component. Class provides info about costomer's mortgage payments
*/
global with sharing class CB_MortgagePaymentsController {

	global CB_MortgagePaymentsController() {
		
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets mortgage information
	* @param Id mortgage id
	* @return: MortgageInfo
	*/
	@RemoteAction
	global static MortgageInfo getMortgageInfo( Id mortgageId ) {
		MortgageInfo mortgageInfo = new MortgageInfo(
			'0012314235254',
			150000,
			4,
			Date.today() - 5,
			Date.today() - 3,
			'Approved',
			90000,
			500,
			25,
			Date.today() + 3
		);

		return mortgageInfo;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets mortgage's payments
	* @param Id mortgage id
	* @return: List< MortgagePayment >
	*/
	@RemoteAction
	global static List< MortgagePayment > getMortgagePayments( Id mortgageId ) {
		List< MortgagePayment > mortgagePayments = new List< MortgagePayment >();

		mortgagePayments.add( new MortgagePayment(
			Date.today(),
			500,
			'PENDING',
            '£'
		) );
		mortgagePayments.add( new MortgagePayment(
			Date.today() - 1,
			500,
			'PAID',
            '£'
		) );
		mortgagePayments.add( new MortgagePayment(
			Date.today() - 2,
			500,
			'PAID',
            '£'
		) );
		mortgagePayments.add( new MortgagePayment(
			Date.today() - 3,
			500,
			'PAID',
            '£'
		) );
		mortgagePayments.add( new MortgagePayment(
			Date.today() - 4,
			500,
			'PAID',
            '£'
		) );
		mortgagePayments.add( new MortgagePayment(
			Date.today() - 5,
			500,
			'PAID',
            '£'
		) );

		return mortgagePayments;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: Class contains mortgage info
	*/
	global class MortgageInfo {
		global String mortgageNumber { get; set; }
		global Decimal loanAmount { get; set; }
		global Decimal interest { get; set; }
		global Date approvedOn { get; set; }
		global Date lastPayment { get; set; }
		global String status { get; set; }
		global Decimal dueAmount { get; set; }
		global Decimal paymentAmount { get; set; }
		global Integer term { get; set; }
		global Date nextPayment { get; set; }

		global MortgageInfo( String mortgageNumber, Decimal loanAmount, Decimal interest, Date approvedOn, Date lastPayment,
			String status, Decimal dueAmount, Decimal paymentAmount, Integer term, Date nextPayment ) {
			this.mortgageNumber = mortgageNumber;
			this.loanAmount = loanAmount;
			this.interest = interest;
			this.approvedOn = approvedOn;
			this.lastPayment = lastPayment;
			this.status = status;
			this.dueAmount = dueAmount;
			this.paymentAmount = paymentAmount;
			this.term = term;
			this.nextPayment = nextPayment;
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: Class contains mortgage payment info
	*/
	global class MortgagePayment {
		global Date paymentDate { get; set; }
		global Decimal amount { get; set; }
		global String status { get; set; }
		global String currencySymbol { get; set; }

		global MortgagePayment( Date paymentDate, Decimal amount, String status, String currencySymbol ) {
			this.paymentDate = paymentDate;
			this.amount = amount;
			this.status = status;
			this.currencySymbol = currencySymbol;
		}
	}
	
}