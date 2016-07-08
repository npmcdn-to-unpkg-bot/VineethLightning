/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CB_CaseDetail component. Class provides info about chosen case and it's related mortgage application
*/
public with sharing class CB_CaseDetailController {

	public String newAppToDo { get; set; }
	public Decimal newAppAmount { get; set; }
	public Decimal newAppDeposit { get; set; }
	public String newAppType { get; set; }
	public String newAppPreferToPay { get; set; }
	public Decimal newAppMortgageTerm { get; set; }

	public String newAppBuildingName { get; set; }
	public String newAppCity { get; set; }
	public String newAppCounty { get; set; }
	public String newAppPostcode { get; set; }
	public String newAppCountry { get; set; }
	public String newAppTypeOfProperty { get; set; }
	public String newAppCouncilTaxBand { get; set; }

	public List< SelectOption > appToDo { get; set; }
	public List< SelectOption > appType { get; set; }
	public List< SelectOption > appPreferToPay { get; set; }
	public List< SelectOption > appTypeOfProperty { get; set; }
	public List< SelectOption > appCouncilTaxBand { get; set; }

	public List< Event > currentCaseEventList {
		get {
			return [Select Id, Subject, Who.Name, StartDateTime, EndDateTime From Event Where WhatId = :currentCaseId];
		}
		set;
	}

	public Id currentCaseId {
		get {
			return apexPages.currentPage().getParameters().get('id');
		}
		set;
	}

	public Case curCase {
		get {
			return [Select Id, CaseNumber, Priority, CreatedDate, Application_Number__c, Application__r.To_Do__c, Application__r.Amount,
			    Application__r.Deposit__c, Application__r.Type, Application__r.Prefer_to_Pay__c, Application__r.Mortgage_Term__c,
			    Application__r.Building_Name__c, Application__r.City__c, Application__r.County__c, Application__r.Postcode__c,
			    Application__r.Country__c, Application__r.Type_of_Property__c, Application__r.Council_Tax_Band__c, Application__c
			    From Case Where Id = :currentCaseId LIMIT 1];
		}
		set;
	}



	public CB_CaseDetailController() {
		getAppToDo();
		getAppType();
		getAppPreferToPay();
		getAppTypeOfProperty();
		getAppCouncilTaxBand();

		newAppToDo = curCase.Application__r.To_Do__c;
		newAppAmount = curCase.Application__r.Amount;
		newAppDeposit = curCase.Application__r.Deposit__c;
		newAppType = curCase.Application__r.Type;
		newAppPreferToPay = curCase.Application__r.Prefer_to_Pay__c;
		newAppMortgageTerm = curCase.Application__r.Mortgage_Term__c;

		newAppBuildingName = curCase.Application__r.Building_Name__c;
		newAppCity = curCase.Application__r.City__c;
		newAppCounty = curCase.Application__r.County__c;
		newAppPostcode = curCase.Application__r.Postcode__c;
		newAppCountry = curCase.Application__r.Country__c;
		newAppTypeOfProperty = curCase.Application__r.Type_of_Property__c;
		newAppCouncilTaxBand = curCase.Application__r.Council_Tax_Band__c;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method updates mortgage details of the case's related mortgage application
	* @return: PageReference
	*/
	public PageReference updateMortgageDetails() {
		System.debug( '>>>updateMortgageDetails' );

		Opportunity customerApp = new Opportunity();
		customerApp.Id = curCase.Application__c;

		if ( !String.isEmpty( newAppToDo ) ) {
			customerApp.To_Do__c = newAppToDo;
			System.debug( '>>>newAppToDo = ' + newAppToDo );
		}
		if ( newAppAmount > 0 ) {
			customerApp.Amount = newAppAmount;
			System.debug( '>>>newAppAmount = ' + newAppAmount );
		}
		if ( newAppDeposit > 0 ) {
			customerApp.Deposit__c = newAppDeposit;
			System.debug( '>>>newAppDeposit = ' + newAppDeposit );
		}
		if ( !String.isEmpty( newAppType ) ) {
			customerApp.Type = newAppType;
			System.debug( '>>>newAppType = ' + newAppType );
		}
		if ( !String.isEmpty( newAppPreferToPay ) ) {
			customerApp.Prefer_to_Pay__c = newAppPreferToPay;
			System.debug( '>>>newAppPreferToPay = ' + newAppPreferToPay );
		}
		if ( newAppMortgageTerm > 0 ) {
			customerApp.Mortgage_Term__c = newAppMortgageTerm;
			System.debug( '>>>newAppMortgageTerm = ' + newAppMortgageTerm );
		}

		try {
			update customerApp;
		} catch( DmlException ex ) {
			System.debug( '>>>ERROR +++ ' + ex.getMessage() );
			return null;
		}

		return null;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method updates property details of the case's related mortgage application
	* @return: PageReference
	*/
	public PageReference updatePropertyDetails() {
		Opportunity customerApp = new Opportunity();
		customerApp.Id = curCase.Application__c;

		if ( !String.isEmpty( newAppBuildingName ) ) {
			customerApp.Building_Name__c = newAppBuildingName;
		}
		if ( !String.isEmpty( newAppCity ) ) {
			customerApp.City__c = newAppCity;
		}
		if ( !String.isEmpty( newAppCounty ) ) {
			customerApp.County__c = newAppCounty;
		}
		if ( !String.isEmpty( newAppPostcode ) ) {
			customerApp.Postcode__c = newAppPostcode;
		}
		if ( !String.isEmpty( newAppCountry ) ) {
			customerApp.Country__c = newAppCountry;
		}
		if ( !String.isEmpty( newAppTypeOfProperty ) ) {
			customerApp.Type_of_Property__c = newAppTypeOfProperty;
		}
		if ( !String.isEmpty( newAppCouncilTaxBand ) ) {
			customerApp.Council_Tax_Band__c = newAppCouncilTaxBand;
		}

		try {
			update customerApp;
		} catch( DmlException ex ) {
			System.debug( 'ERROR +++ ' + ex.getMessage() );
			return null;
        }

        return null;
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets the list of the mortgage regardings
	* @return: void
	*/
	private void getAppToDo() {
		Schema.DescribeFieldResult opportunityToDoFieldResult = Opportunity.To_Do__c.getDescribe();
		List< Schema.PicklistEntry > opportunityToDoPicklistValues = opportunityToDoFieldResult.getPicklistValues();
		
		appToDo = new List<SelectOption>();
		for ( Schema.PicklistEntry opportunityToDoPicklistValue : opportunityToDoPicklistValues ) {
			AppToDo.add( new SelectOption( opportunityToDoPicklistValue.getLabel(),
				                           opportunityToDoPicklistValue.getValue() ) );
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets the list of the mortgage application types
	* @return: void
	*/
	private void getAppType() {
		Schema.DescribeFieldResult opportunityTypeFieldResult = Opportunity.Type.getDescribe();
		List< Schema.PicklistEntry > opportunityTypePicklistValues = opportunityTypeFieldResult.getPicklistValues();
		
		appType = new List<SelectOption>();
		for ( Schema.PicklistEntry opportunityTypePicklistValue : opportunityTypePicklistValues ) {
			AppType.add( new SelectOption( opportunityTypePicklistValue.getLabel(),
				                           opportunityTypePicklistValue.getValue() ) );
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets the list of the mortgage preferred method of payment
	* @return: void
	*/
	private void getAppPreferToPay() {
		Schema.DescribeFieldResult opportunityPreferToPayFieldResult = Opportunity.Prefer_to_Pay__c.getDescribe();
		List< Schema.PicklistEntry > opportunityPreferToPayPicklistValues = opportunityPreferToPayFieldResult.getPicklistValues();
		
		appPreferToPay = new List<SelectOption>();
		for ( Schema.PicklistEntry opportunityPreferToPayPicklistValue : opportunityPreferToPayPicklistValues ) {
			AppPreferToPay.add( new SelectOption( opportunityPreferToPayPicklistValue.getLabel(),
				                                  opportunityPreferToPayPicklistValue.getValue() ) );
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets the list of the mortgage types of property
	* @return: void
	*/
	private void getAppTypeOfProperty() {
		Schema.DescribeFieldResult opportunityTypeOfPropertyFieldResult = Opportunity.Type_of_Property__c.getDescribe();
		List< Schema.PicklistEntry > opportunityTypeOfPropertyPicklistValues = opportunityTypeOfPropertyFieldResult.getPicklistValues();
		
		appTypeOfProperty = new List<SelectOption>();
		for ( Schema.PicklistEntry opportunityTypeOfPropertyPicklistValue : opportunityTypeOfPropertyPicklistValues ) {
			appTypeOfProperty.add( new SelectOption( opportunityTypeOfPropertyPicklistValue.getLabel(),
				                                     opportunityTypeOfPropertyPicklistValue.getValue() ) );
		}
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method gets the list of the mortgage council tax bands
	* @return: void
	*/
	private void getAppCouncilTaxBand() {
		Schema.DescribeFieldResult opportunityCouncilTaxBandFieldResult = Opportunity.Council_Tax_Band__c.getDescribe();
		List< Schema.PicklistEntry > opportunityCouncilTaxBandPicklistValues = opportunityCouncilTaxBandFieldResult.getPicklistValues();
		
		appCouncilTaxBand = new List<SelectOption>();
		for ( Schema.PicklistEntry opportunityCouncilTaxBandPicklistValue : opportunityCouncilTaxBandPicklistValues ) {
			appCouncilTaxBand.add( new SelectOption( opportunityCouncilTaxBandPicklistValue.getLabel(),
				                                     opportunityCouncilTaxBandPicklistValue.getValue() ) );
		}
	}
}