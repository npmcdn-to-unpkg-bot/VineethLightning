/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CC_MortgageArticles component. Class provides the information about mortgage articles
*/
public with sharing class CC_MortgageArticlesController {

	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage articles
	* @return: List< Knowledge__kav >
	*/
	List< Knowledge__kav > FAQList {
		get {
			return [
				SELECT Id, Title, UrlName, Summary, Body__c
				FROM Knowledge__kav
				WHERE ( PublishStatus = 'online' AND Language = 'en_US' )
			];
		}
		set;
	}



	public CC_MortgageArticlesController() {
		
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets list of the mortgage articles
	* @return: List< Knowledge__kav >
	*/
	@RemoteAction
	public static List< Knowledge__kav > getArticles() {
		List< Knowledge__kav > ArticleList;

		ArticleList = [
			SELECT Id, Title, UrlName, Summary, Body__c
			FROM Knowledge__kav
			WHERE ( PublishStatus = 'online' AND Language = 'en_US' )
		];

		return ArticleList;
	}
}