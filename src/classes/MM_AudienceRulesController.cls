/**
* @author Martin Loheac
* @date October 2014
* @description MM_01,MM_02,MM_03 - News product update and peronalised messages - Controller class to manage the audiences for the content.
* Added with sharing 
*/
public with sharing class MM_AudienceRulesController {
    
    //data structure class for managing the rules
    public class RuleSet {
        
        public AudienceRule__c Rule {get;set;}
        public boolean selected {get;set;}
        
        RuleSet() {
        }
        
        RuleSet(AudienceRule__c r) {
            Rule = r;
            selected = false;
        }
    }
    
    //Id of the audience currently being edited
    protected String AudienceId;
    //standard controller
    protected ApexPages.StandardController stdController;
    
    //flag to detect if the screen is in edit mode
    public boolean editMode{get;set;}
    
    public Boolean showBrokers { get; set; }
    private ApexPages.StandardSetController brokerCon;
    
    public String fieldType { get; set; }
    //public String fieldTypeValue { get; set; }
    public String currentAudienceId { get; set; }
    
    public Integer audienceRuleCount { get; set; }
    //private static Map<String, Schema.SObjectField> fieldMap;

    //list of rules
    protected List<RuleSet> cRules;

    /**
    * @author Martin Loheac
    * @date October 2014
    * @description method for pgetting the rules
    * @return list of rules
    */
    public List<RuleSet> getRules() {
       return cRules;        
    }
    
    //list of fields in the user object 
     
    protected List<SelectOption> cUserFields;
    //get the list of fields in the user object
    /**
    * @author Martin Loheac
    * @date October 2014
    * @description Gets the list of fields in the user object
    * @return list of user object fields
    */   
    public List<SelectOption> getUserFields() {
        return cUserFields;        
    }
    
    public MM_AudienceRulesController(ApexPages.StandardController c) {
        stdController = c;
        AudienceId = System.currentPageReference().getParameters().get('id'); 
        String edit = System.currentPageReference().getParameters().get('edit');

        if (String.isBlank(edit)) {
            editMode = false;
        } else {
            editMode = (edit == 'true');  
        }
        
        audienceRuleCount = 0;
        fieldType = '';
        
        populateRules();
        populateUserFields();
        
        showBrokers = false;
        populateBrokers();
    }
    
//list of posible available operators for the filter in the rule
/**
* @author Martin Loheac
* @date October 2014
* @description list of posible available operators for the filter in the rule
* @return list of operators for the picklist 
*/
    
    public List<SelectOption> getOperators() {
        
        List<SelectOption> retVal = new List<SelectOption>();
        
        retVal.add(new SelectOption('','Please select an operator'));
        retVal.add(new SelectOption('=','Equals'));
        retVal.add(new SelectOption('!=','Not equal'));
        retVal.add(new SelectOption('>','Greater than'));
        retVal.add(new SelectOption('>=','Greater than or equal to'));
        retVal.add(new SelectOption('<','Smaller than'));
        retVal.add(new SelectOption('<=','Smaller than or equal to'));                  
                   
        return retVal;
    }
        
//method to add a new line to the rules
/**
* @author Martin Loheac
* @date October 2014
* @description method to add a new line to the rules
*/
  public void AddRow() {
        
        List<AudienceRule__c> ar = new List<AudienceRule__c>();
        
        for (RuleSet rs : cRules) {
            ar.add(rs.Rule);
        }
        saveRecords(ar);
        populateRules();
    }
    
//method for populating the list of rules
/**
* @author Martin Loheac
* @date October 2014
* @description method for populating the list of rules
*/
    public void populateRules() {
       
        cRules = new List<RuleSet>();
        for (AudienceRule__c r : [SELECT Id, Name, Userfield__c, Operator__c, Value__c, OverrideConditionString__c FROM Audiencerule__c WHERE Audience__c =: AudienceId]) {
            RuleSet rs = new RuleSet();
            rs.Rule = r;
            rs.selected = false;
            cRules.add(rs);
        }
        //empty row in the end
        RuleSet rs1 = new RuleSet(new AudienceRule__c());
        rs1.Rule.Audience__c = AudienceID;
        cRules.add(rs1);
        
    }
    
//get the list of fields in the user object
/**
* @author Martin Loheac
* @date October 2014
* @description populates the list of fields in the user object
*/
    private void populateUserFields() {
        cUserFields = new List<SelectOption>();
        cUserFields.add(new SelectOption('','Please select a field'));
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('contact').getDescribe().fields.getMap();
        for (Schema.SObjectField sfield : fieldMap.Values()) {
            schema.describefieldresult dfield = sfield.getDescribe();
             
            if (dfield.isFilterable() 
                && dfield.isAccessible()
                && 'Id' != dfield.getName() 
                && 'IsDeleted' != dfield.getName()
                && 'CreatedById' != dfield.getName()
                && 'CreatedDate' != dfield.getName()
                && 'LastModifiedById' != dfield.getName()
                && 'LastModifiedDate' != dfield.getName()
                && 'SystemModstamp' != dfield.getName()
                && 'RecordTypeId' != dfield.getName() 
                && 'OwnerId' != dfield.getName()) {
                if (string.isEmpty(dfield.getRelationshipName()))
                    cUserFields.add(new SelectOption(dfield.getName(), dfield.getLabel()));
                else
                    cUserFields.add(new SelectOption(dfield.getRelationshipName()+'.name', dfield.getLabel()));
            }
        }
        cUserFields.sort();
        
    }
    
    
//internal save method
/**
* @author Martin Loheac
* @date October 2014
* @description Saves the audiences
* @param r List of rules to save
*/    
    private void saveRecords(list<AudienceRule__c> r) {
        List<AudienceRule__c> saveRecords = new  List<AudienceRule__c>();
        
        for (AudienceRule__c ar : r) {           
            
            if (!(String.isBlank(ar.Userfield__c)) && !(String.isBlank(ar.operator__c))) {
                saveRecords.add(ar);    
            }
        }
        upsert saveRecords; 
        populateRules();        
    }
    
//method to delete selected rows
/**
* @author Martin Loheac
* @date October 2014
* @description Deletes selected rule
*/      
    public void deleteSelected() {
        List<AudienceRule__c> deleteSet = new List<AudienceRule__c>();
        
        for (RuleSet rs : cRules) {
            if (rs.selected) {
                deleteSet.add(rs.Rule);     
            }    
        }
        delete deleteSet;
        populateRules();        
    }
   
//method to save all
/**
* @author Martin Loheac
* @date October 2014
* @description Saves all the audience rules
*/    
    public void SaveAll() {
        List<AudienceRule__c> ar = new List<AudienceRule__c>();
        
        for (RuleSet rs : cRules) {
            ar.add(rs.Rule);
        }
        editMode = false;
        saveRecords(ar);
        populateBrokers();
        stdController.save();
        
    }
    
//change the vf view to edit
/**
* @author Martin Loheac
* @date October 2014
* @description Puts the screen in edit mode
*/    
  
    public void enterEditMode() {
        editMode = true;        
    }
    
//cancel edition
/**
* @author Martin Loheac
* @date October 2014
* @description Cancels the edit mode
*/    
    public void cancelEditMode() {
        editMode = false;
        stdController.cancel();       
    }
    
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description finds related brokers to Audience rule
    */
    public void populateBrokers() {
        List<Contact> availableContentBrokerList = new List<Contact>();
        availableContentBrokerList = MM_Audiences.retrieveContacts(new List<Id>{stdController.getId()});
        
        if(!availableContentBrokerList.isEmpty() && availableContentBrokerList.size() < 10000) {
            this.brokerCon = new ApexPages.StandardSetController(availableContentBrokerList);
            this.brokerCon.setpageNumber(1);
            this.brokerCon.setPageSize(10);
            showBrokers = true;
        }
        else if(availableContentBrokerList.size() > 10000){
            availableContentBrokerList.clear();
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, Label.IP_MM_Audience_Broker_Display_Limit));
        }
        else if(availableContentBrokerList.isEmpty()){
            this.brokerCon= new ApexPages.StandardSetController(availableContentBrokerList);
            showBrokers = false;
            availableContentBrokerList.clear();
            Apexpages.addMessage(new Apexpages.Message(Apexpages.severity.WARNING, 'No records matching flter criteria'));
        }
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description return brokers related to Audience
    * @returns return List<Contact>
    */
    public List<Contact> getContentBrokers() {
        return (List<Contact>) brokerCon.getRecords();
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description return whether previous page exists
    * @returns return whether previous page exists
    */
    public Boolean getHasPrevious() {
        return this.brokerCon.getHasPrevious();
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description return whether next page exists
    * @returns return whether next page exists
    */
    public Boolean getHasNext() {
        return this.brokerCon.getHasNext();
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description return page number
    * @returns return page number
    */
    public Integer getPageNumber() {
        return this.brokerCon.getPageNumber();
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description calculates total number of pages
    * @returns return total pages
    */
    public Integer getTotalPages(){
        Decimal totalSize = this.brokerCon.getResultSize();
        Decimal pageSize = this.brokerCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description go to next page
    * @returns return void
    */
    public void doNext() {
        if (this.brokerCon.getHasNext()) {
            this.brokerCon.next();
        }    
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description go to previous page
    * @returns return void
    */
    public void doPrevious() {
        if (this.brokerCon.getHasPrevious()) {
            this.brokerCon.previous();
        }  
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description go to first page
    * @returns return void
    */
    public void dofirst() {
        this.brokerCon.first(); 
    }
    
    /**
    * @author Siddhant Indra
    * @date April 2015
    * @description go to last page
    * @returns return void
    */
    public void doLast() {
        this.brokerCon.last(); 
    }
    
    /**
    * @author Siddhant Indra
    * @date June 2015
    * @description generate condition string from audience object to add into where clause in SOQL
    * @returns return string
    */
    public static String getConditionString(Audiencerule__c audiencerule) {
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
        Schema.DisplayType displayType;
        String conditionString = '';
        
        if (fieldMap.containsKey(audiencerule.UserField__c)) {
            
            Schema.SObjectField sobjectField = fieldMap.get(audiencerule.UserField__c);
            displayType = sobjectField.getDescribe().getType();
            
            if (Schema.DisplayType.String == displayType || Schema.DisplayType.Picklist == displayType || Schema.DisplayType.MultiPicklist == displayType ||  Schema.DisplayType.TextArea == displayType || Schema.DisplayType.Email == displayType || Schema.DisplayType.Phone == displayType) {
                conditionString = audiencerule.UserField__c + ' ' + audiencerule.Operator__c + ' \'' + String.escapeSingleQuotes(audiencerule.Value__c) + '\'';
            }
            else if (Schema.DisplayType.DateTime == displayType) {
                String dateString = String.valueOf(audiencerule.Value__c);
                List<String> dateList = dateString.split('-');
                Datetime myDateTime = Datetime.newInstance(Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[2]));
                String formatedDateTime = String.ValueOf(myDateTime);
                List<String> formatedDateTimeLsit = formatedDateTime.split(' ');
                String str  = formatedDateTimeLsit[0] + 'T'+ formatedDateTimeLsit[1]+'Z';
                conditionString = audiencerule.UserField__c + ' ' + audiencerule.Operator__c + ' ' + str;
            }
            else {
                conditionString = audiencerule.UserField__c + ' ' + audiencerule.Operator__c + ' ' + String.escapeSingleQuotes(audiencerule.Value__c);
            }
        }
        if (audiencerule.UserField__c == 'Account.name' || audiencerule.UserField__c == 'RM__r.name') {
            conditionString = audiencerule.UserField__c + ' ' + audiencerule.Operator__c + ' \'' + String.escapeSingleQuotes(audiencerule.Value__c) + '\'';
        }
        return conditionString;
    }
}