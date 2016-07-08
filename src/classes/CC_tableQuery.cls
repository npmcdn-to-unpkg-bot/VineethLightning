/**
* @author: Pavel Kalinin
* @date: April 2016
* @description: Controller for CC_TableTest component. Class provides functionality for creating table by list of fields
*/
public with sharing class CC_tableQuery {

	public Integer limitValue { get; set; }
	public String objName { get; set; }
	public String apiFields { get; set; }
	public String filter { get; set; }
	public List< String > lableField { get; set; }
	public List< String > apiFieldslst { get; set; }
	public String nameField { get; set; }
	public String detailPage { get; set; }



	public CC_tableQuery() {
		
	}



	/**
	* @author: Pavel Kalinin
	* @date: April 2016
	* @description: This method creates soql query string and receive the list of sObect to display through it
	* @return: List< sObject >
	*/
	public List< sObject > getObjLst() {
		apiFieldslst = new List< String >();
		apiFieldslst = apiFields.split( ',' );
		lableField = new List< String >();
		Integer limitVal = limitValue;
		String query;
		
		System.debug( '>>Account Object' + objName );
		
		SObjectType describeSobjectsResult = Schema.getGlobalDescribe().get( objName );
		Map< String, Schema.SObjectField > mfields = describeSobjectsResult.getDescribe().fields.getMap();
		for ( String apiFieldsName : apiFieldslst ) {
			String fieldLabel = mfields.get( apiFieldsName ).getDescribe().getLabel();
			lableField.add( fieldLabel );
		}

		String fields = String.join( apiFieldslst, ',' );
		if ( objName.equals( 'opportunity' ) ) {
		    fields += ', Need_Additional_Information__c';
		}

		query = 'Select ' + fields + ' From ' + objName;

		if ( !String.isEmpty( filter ) ) {
		    query += ' Where ' + filter.unescapeEcmaScript();
		}

		query += ' Order By CreatedDate desc';
		
		if ( limitValue != null && limitValue != 0 ) {
		    query = query + ' LIMIT :limitValue';
		}
		
		System.debug( '>>Qu ' + query );
		
		List< sObject > objList = Database.query( query );

		System.debug( '>>objList ' + objList );
		System.debug( '>>objList.size() ' + objList.size() );

		if ( objList.size() == 0 ) {
			return null;
		}

		return objList;
	}

}