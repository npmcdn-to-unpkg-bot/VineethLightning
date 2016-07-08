public class CS_TableController {
    
    
    
	@AuraEnabled
    public static String getData( String objectName, String fieldsList, String whereStr, String orderByStr, String limitStr ) {
        TableData tableData = new TableData();
        
        List< String > fieldsApiNames = new List< String >();
        List< String > fieldsLabels = new List< String >();        
        
        fieldsApiNames = getFieldApiNames( fieldsList );
        fieldsLabels = getFieldLabels( objectName, fieldsApiNames );
        
        System.debug( '>>> ' + fieldsLabels );
        
        tableData.headers = fieldsLabels;
        
        String query = 'Select Id, ' + fieldsList + ' From ' + objectName;
        if ( !String.isEmpty( whereStr ) ) {
            query += ' Where ' + whereStr;
        }
        if ( !String.isEmpty( orderByStr ) ) {
        	query += ' OrderBy ' + orderByStr;
        }            
        query += ' LIMIT ' + limitStr + ' ';
        
        System.debug( '>>> query = ' + query );
        
        List< sObject > objList = Database.query( query );
        tableData.data = objList;
        
        System.debug( '>>> ' + tableData );
        
        return JSON.serialize( tableData );
    }
    
    
    
    private static List< String > getFieldApiNames( String fieldsList ) {
        List< String > fieldsApiNames = new List< String >();
        
        if ( String.isEmpty( fieldsList ) ) {
            return null;
        }
        
        fieldsApiNames = fieldsList.split( ',' );
        
        return fieldsApiNames;
    }
        
        
        
    private static List< String > getFieldLabels( String objectName, List< String > fieldsApiNames ) {
        List< String > fieldsLabels = new List< String >();

        SObjectType describeSobjectsResult = Schema.getGlobalDescribe().get( objectName );
        if ( describeSobjectsResult == null ) {
            return null;
        }
        Map< String, Schema.SObjectField > mfields = describeSobjectsResult.getDescribe().fields.getMap();
        for ( String fieldApiName : fieldsApiNames ) {
            Schema.SObjectField sObjField = mfields.get( fieldApiName );
            if ( sObjField == null ) {
                continue;
            }
			String fieldLabel = sObjField.getDescribe().getLabel();
            fieldsLabels.add( fieldLabel );
		}
        
        return fieldsLabels;
    }
    
    
    
    public class TableData {
        //public Map< String, String > headers { get; set; }
        public List< String > headers { get; set; }
        public List< SObject > data { get; set; }
    }
    
    
    
}