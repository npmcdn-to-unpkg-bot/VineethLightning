/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CC_ApplicationFAQ component. Class provides the info about application's faq
*/
public with sharing class CC_ApplicationFAQController {

	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the application's faq
	* @return: List< FAQ__kav >
	*/
	List< FAQ__kav > FAQList {
		get {
			return [
				SELECT Id, Title, UrlName, Question__c, Answer__c
				FROM FAQ__kav
				WHERE ( PublishStatus = 'online' AND Language = 'en_US' )
			];
		}
		set;
	}



	public CC_ApplicationFAQController() {
		
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the application's faq
	* @return: List< FAQ__kav >
	*/
	@RemoteAction
	public static List< FAQ__kav > getFAQ() {
		List< FAQ__kav > FAQList;

		FAQList = [
			SELECT Id, Title, UrlName, Question__c, Answer__c
			FROM FAQ__kav
			WHERE ( PublishStatus = 'online' AND Language = 'en_US' )
		];

		return FAQList;
	}
}