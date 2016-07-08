/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CB_CaseDetailPage page. Class provides info about case steps
*/
public with sharing class CB_CaseDetailPageController {

	public List<String> steps { get; set; }
	public Integer stepsCount { get; set; }
	public Integer activeStepIndex { get; set; }
	public Case currentCase { get; set; }



	public CB_CaseDetailPageController(ApexPages.Standardcontroller controller) {
		controller.addFields( new List< String >{ 'Status' } );
		currentCase = ( Case )controller.getRecord();
		getSteps();
		getActiveStepIndex();
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This is get method for steps variable which contain list of the case's steps
	* @return: void
	*/
	private void getSteps() {
		Schema.DescribeFieldResult caseStatusFieldResult = Case.Status.getDescribe();
		List< Schema.PicklistEntry > caseStatusPicklistValues = caseStatusFieldResult.getPicklistValues();
		
		steps = new List< String >();
		for ( Schema.PicklistEntry caseStatusPicklistValue : caseStatusPicklistValues ) {
			steps.add( caseStatusPicklistValue.getLabel() );
		}

		stepsCount = steps.size();
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This is get method for activeStepIndex variable which contain index of the current step of the chosen case
	* @return: void
	*/
	private void getActiveStepIndex() {
		activeStepIndex = 1;

		for ( String step : steps ) {
			if ( currentCase.Status.equals( step ) ) {
				break;
			}
			activeStepIndex++;
		}
	}
}