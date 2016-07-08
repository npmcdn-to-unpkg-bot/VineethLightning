public with sharing class tableQuery {
public Integer limitValue{get;set;}
public String objName{get;set;}
public String apiFields{get;set;}
public string filter{get;set;}
public List<String> lableField{get;set;}
public List<String> apiFieldslst{get;set;}
public string nameField{get;set;}
public string detailPage{get;set;}

public tableQuery(){
   
}

public List<sObject> getObjLst(){
apiFieldslst = new List<String>();
apiFieldslst = apiFields.split(',');
lableField = new List<String>();
Integer limitVal = limitValue;
String query;

system.debug('>>Account Object' +objName);

SObjectType describeSobjectsResult= Schema.getGlobalDescribe().get(objName);
Map<String,Schema.SObjectField> mfields = describeSobjectsResult.getDescribe().fields.getMap();
for(String apiFieldsName: apiFieldslst){
String fieldLabel = mfields.get(apiFieldsName).getDescribe().getLabel();
lableField.add(fieldLabel);
}
//apiFieldslst.add(nameField);
String fields  = String.join(apiFieldslst,',');
if(objName == 'opportunity'){
    fields+= ', Need_Additional_Information__c';
}
query = 'Select '+fields+' from '+objName;
if(filter != null && filter != ''){
    query += ' where '+filter.unescapeEcmaScript();
}
query += ' order by createddate desc';

if(limitValue!=0 && limitValue!=null){
    query = query + ' limit :limitValue';
}


System.debug('>>Qu '+query);

List<sObject> objList = Database.query(query);
return objList;
}

}