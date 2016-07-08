/**
* @author: Klara Ivanchenko
* @date: April 2016
* @description: Controller for CB_ApplicationDetail component. Class provides the creation of new mortgage applications and community users
*/
public with sharing class CB_ApplicationDetailCtrl {

    public Opportunity opportunity {get; set;}
    public Opportunity opportunityActivity {get; set;}

    public String newAppCouncilTaxBand { get; set; }
    public List< SelectOption > appCouncilTaxBand { get; set; }
    
    public CB_ApplicationDetailCtrl() {
        String oppId = Apexpages.currentPage().getParameters().get('Id');
        if (String.isNotBlank(oppId)) {
            opportunityActivity = [
                SELECT Stagename,
                    (SELECT Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, IsHighPriority, Owner.Name, Description, IsClosed,
                         CreatedDate, CreatedBy.Name, LastModifiedDate, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject 
                    FROM Tasks), 
                    (SELECT Id, WhoId, WhatId, Subject, Location, ActivityDateTime, ActivityDate, DurationInMinutes, StartDateTime, EndDateTime, 
                        Description, OwnerId, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedById, IsArchived
                     FROM Events) 
                FROM Opportunity 
                WHERE Id =: oppId 
            ];
        }
        getAppCouncilTaxBand();
        
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method updates mortgage application details
    * @return: void
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
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the list of the mortgage application steps
    * @return: List< String >
    */
    public List<String> steps {
        get {
            List<String> steps = new List<String> { 'New', 'DIP', 'Valuation', 'Pre-Offer', 'Offer' };
            if ( opportunityActivity.Stagename.equals(Label.Gone_Off) ) {
                steps.add( Label.Gone_Off );
            } else if ( opportunityActivity.Stagename.equals(Label.Won) ) {
                steps.add( Label.Won );
            } else {
                steps.add( 'Won/Lost' );
            }
            return steps;
        }
        set;
    }



    /**
    * @author: Klara Ivanchenko
    * @date: April 2016
    * @description: This method gets the index of the current step of the chosen mortgage application
    * @return: Integer
    */
    public Integer activeStageIndex {
        get {
            Integer activeStageIndex = 1;
            for (String step : steps) {
                if (opportunityActivity.Stagename.equals(step)) {
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
    * @description: This method gets the list of the mortgage council tax bands
    * @return: void
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