/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Class contains info about new mortgage application (used to create mortgage application)
*/
public with sharing class CB_Mortgage {
	
	public String mortgageType { get; set; }
	public String brokerType { get; set; }
	public String applicantType { get; set; }
	public Contact broker { get; set; }
	public Contact applicant { get; set; }
	public Opportunity mortgage { get; set; }

	public Boolean createBroker { get; set; }
	public Boolean findBroker { get; set; }
	public Boolean createApplicant { get; set; }
	public Boolean findApplicant { get; set; }

	public CB_Mortgage() {

	}
}