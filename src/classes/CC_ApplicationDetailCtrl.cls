/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description:  Class to show and edit Custumer Application.
*/
public with sharing class CC_ApplicationDetailCtrl {

    public Opportunity opportunity {get; set;}

    public String newAppCouncilTaxBand { get; set; }
    public List< SelectOption > appCouncilTaxBand { get; set; }



    public CC_ApplicationDetailCtrl() {
        getAppCouncilTaxBand();
    }


/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: This method saves edited Application Council_Tax_Band__c field
*/
    public void updateApplicationDetail() {
        try {
            opportunity.Council_Tax_Band__c = newAppCouncilTaxBand;
            update opportunity;
        } catch(DmlException ex) {
            System.debug('ERROR +++ ' + ex.getMessage());
        }
    }

/**
* @author: Pavel Kalinin
* @date: May 2016
* @description: This method set current value in newAppCouncilTaxBand variable (otherwise it contains the first value of picklist)
*/
    public void setCurrentCouncilTaxBand() {
        newAppCouncilTaxBand = opportunity.Council_Tax_Band__c;
    }
    
/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: This method detects Application steps 
*/
    public List<String> steps {
        get {

            Opportunity application = [
                SELECT Id, Customer__c, CreatedDate, Case_Number__c, Need_Additional_Information__c,
                        Gross_annual_income__c, Current_credit_card_balance__c, Total_monthly_loan_payments__c,
                        Other_monthly_financial_commitments__c, Stagename, To_Do__c, Amount,
                        Deposit__c, Type, Prefer_to_Pay__c, Mortgage_Term__c, Building_Name__c, City__c,
                        County__c, Postcode__c, Country__c, Type_of_Property__c, Council_Tax_Band__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
            ];

            List<String> steps = new List<String> { 'New', 'DIP', 'Valuation', 'Pre-Offer', 'Offer' };
            if ( application.Stagename.equals(Label.Gone_Off) ) {
                steps.add( Label.Gone_Off );
            } else if ( application.Stagename.equals(Label.Won) ) {
                steps.add( Label.Won );
            } else {
                steps.add( Label.Approved_Declined );
            }
            return steps;
        }
        set;
    }

/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: This method detects current Application step
*/

    public Integer activeStageIndex {
        get {

            Opportunity application = [
                SELECT Id, Customer__c, CreatedDate, Case_Number__c, Need_Additional_Information__c,
                        Gross_annual_income__c, Current_credit_card_balance__c, Total_monthly_loan_payments__c,
                        Other_monthly_financial_commitments__c, Stagename, To_Do__c, Amount,
                        Deposit__c, Type, Prefer_to_Pay__c, Mortgage_Term__c, Building_Name__c, City__c,
                        County__c, Postcode__c, Country__c, Type_of_Property__c, Council_Tax_Band__c
                FROM Opportunity
                WHERE Id = :opportunity.Id
                LIMIT 1
            ];

            Integer activeStageIndex = 1;
            for (String step : steps) {
                if (application.Stagename.equals(step)) {
                    break;
                }
                activeStageIndex++;
            }
            return activeStageIndex;
        }
        set;
    }

/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: This method prepares select options available for Application Council_Tax_Band__c field
*/
    private void getAppCouncilTaxBand() {
        Schema.Describefieldresult opportunityCouncilTaxBandFieldResult = Schema.sObjectType.Opportunity.fields.Council_Tax_Band__c;
        opportunityCouncilTaxBandFieldResult = opportunityCouncilTaxBandFieldResult.getSObjectField().getDescribe();

        List< Schema.PicklistEntry > opportunityCouncilTaxBandPicklistValues = opportunityCouncilTaxBandFieldResult.getPicklistValues();
        appCouncilTaxBand = new List<SelectOption>();
        for ( Schema.PicklistEntry opportunityCouncilTaxBandPicklistValue : opportunityCouncilTaxBandPicklistValues ) {
            appCouncilTaxBand.add( new SelectOption( opportunityCouncilTaxBandPicklistValue.getLabel(),
                                                     opportunityCouncilTaxBandPicklistValue.getValue() ) );
        }
    }

}