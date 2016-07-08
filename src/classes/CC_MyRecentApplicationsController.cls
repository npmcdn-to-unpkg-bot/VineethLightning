public with sharing class CC_MyRecentApplicationsController {

/*	public List< String > steps {
		get {
			List< String > steps = new LIst< String > { 'New', 'DIP', 'Valuation', 'Pre-Offer', 'Offer' };
			if ( mostRecentApp.Stagename.equals( 'Gone-Off' ) ) {
        	    steps.add( 'Gone-Off' );
        	} else if ( mostRecentApp.Stagename.equals( 'Won' ) ) {
        	    steps.add( 'Won' );
        	} else {
        	    steps.add( 'Approved/Declined' );
        	}
        	return steps;
		}
		set;
	}

	public Integer activeStageIndex {
		get {
			Integer activeStageIndex = 1;
        	for( String step : steps ) {
        	    if( mostRecentApp.Stagename.equals( step ) ) {
        	        break;
        	    }
        	    activeStageIndex++;
        	}
        	return activeStageIndex;
		}
		set;
	}*/

	public Opportunity mostRecentApp { get; set; }

/*	public CC_MyRecentApplicationsController() {
        
	}*/

}