/**
* @author Martin Loheac
* @date October 2014
* @description MM_01,MM_02,MM_03 Controller class to manage the Content publishing and logic behind it
* Added with sharing 
*/
public with sharing class MM_ManageContentController {
    
    public List<AudienceWrapper> AudienceWrapperList { get; set; }
    public String audiencename { get; set;}
    public String selectedAudienceId { get; set; }
   
    private Set<Id> audiencetIdSet = new Set<Id>();
    private ApexPages.StandardSetController audienceCon;
    private Set<Id> selectedAudienceIdsSet;
    private Set<Id> contentAudienceIdSet;
    
    private Integer QueryLimit = 50000;
    
    private static Set<Id> globalSelectedAudienceIdSet = new Set<Id>();
    
    public Boolean selectAllAudience { get; set; }
    public Boolean isSelectAll { get; set; }
    
    public class selectAudience{
        public Audience__C Audience{get;set;}
        public boolean selected{get;set;}
        public selectAudience( Audience__c aud, boolean s) {
            
            Audience = aud;
            selected = s;
        }
    }
    
    public List<selectAudience> Audiences{get;set;}
    protected Manage_Content__C myContent;
    ApexPages.StandardController myController;
    protected String ref;
    
/**
* @author Martin Loheac
* @date October 2014
* @description Extended controller constructor
* @param c standard controller
*/
    public MM_ManageContentController(ApexPages.StandardController c) {
        if (!test.isRunningTest()) {
            c.addFields(new List<String>{'Type_of_Signature__c','Signature__c','Approved__c'});
        }
        
        myContent = (Manage_content__c)c.getRecord();
        mycontroller = c;
        
        //populate the list of audiences
        contentAudienceIdSet = new Set<Id>();
        Audiences = new List<SelectAudience>();
        
        for (Content_audience__c ca : [SELECT Id, Audience__r.Id FROM Content_audience__c WHERE Manage_content__c = : mycontent.Id LIMIT : QueryLimit]) {
            contentAudienceIdSet.add(ca.audience__r.id);
        }
        
        for (Audience__c a : [SELECT id, name, Description__c FROM Audience__c LIMIT :QueryLimit]) {
            Audiences.add(new selectAudience(a, contentAudienceIdSet.contains(a.id)));  
        }
        
        ref = ApexPages.currentPage().getHeaders().get('Referer');
        
        selectAllAudience = false;
        isSelectAll = false;
        
        this.selectedAudienceIdsSet = new Set<Id>();
        this.audienceCon = new ApexPages.StandardSetController([SELECT Name, Id, Description__c FROM Audience__c LIMIT :QueryLimit]);
        this.audienceCon.setpageNumber(1);
        this.audienceCon.setPageSize(10);  
    }

/**
* @author Martin Loheac
* @date October 2014
* @description MM_01,MM_02 method to publish a content and assign the brokers
*/
    public PageReference Publish() {
          Integer dmlLimit = 10000;
          
          if(selectedAudienceIdsSet.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Audience record.'));
                return null;
          }
          
        //mark as published
        myContent.published__c = true;  
        
        //delete any previous audiences and brokers just in case it is a re-publishing
        List<Content_audience__c> deleteAudiences = [SELECT Id FROM Content_audience__c WHERE Manage_content__c =: mycontent.id LIMIT :QueryLimit];
        List<Content_broker__c> deleteBrokers = [SELECT Id FROM Content_broker__c WHERE Manage_content__c =: myContent.id LIMIT :QueryLimit];
        
        
        //accumulate the selected audiences
        List<Content_audience__c> saveAudiences = new List<Content_audience__c>();
        List<Id> au = new List<Id>();

        if (!selectedAudienceIdsSet.isEmpty()) {
            for (Id audiencetId :selectedAudienceIdsSet) {
                saveAudiences.add(new Content_audience__c(Manage_Content__c = myContent.Id, Audience__c = audiencetId));
                au.add(audiencetId);
            }
        }  
        
        
        //retrieve and insert the brokers that match the audience criteria
        List<Contact> lBrokers = MM_Audiences.retrieveContacts(au);
        List<Content_Broker__c> insertSet = new List<Content_Broker__c>();
        
        for (Contact lc : lBrokers) {
            Content_Broker__c cb = new Content_Broker__c();
            cb.manage_content__c = mycontent.id;
            cb.contact__c = lc.id;
            insertSet.add(cb);
        }
        
        if (insertSet.size() > dmlLimit) {
            myContent.published__c = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IP_MM_Content_Publishing_Limit));
            return null;
        }
        else if (insertSet.size() <= dmlLimit) {
            
            delete deleteAudiences;
            delete deleteBrokers;
            
            insert saveAudiences;           
            insert insertSet;
            myController.save();
        }
        
        return new ApexPages.StandardController(myContent).view();
         
    }
    
/**
* @author Martin Loheac
* @date October 2014
* @description MM_01,MM_02 method to publish a content and assign the brokers
*/
    public PageReference unPublish() {
        mycontent.published__c = false;
        globalSelectedAudienceIdSet.clear();
        mycontroller.save();        
        return new ApexPages.StandardController(myContent).view();
    }

/**
* @author Martin Loheac
* @date October 2014
* @description Method to close the publishing and return to the content
* @returns redirect to the content page
*/
    
    public Pagereference Close() {
        return new ApexPages.StandardController(myContent).view();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Search method for Broker Name
    * @returns returns the PageReference
    */
    
    public PageReference searchAudience() {
       String query = '';
       String queryString = 'SELECT Name, Id, Description__c FROM Audience__c WHERE ';
       String whereClause = ' Name LIKE ' + '\''+ '%';
       query = queryString + whereClause + String.escapeSingleQuotes(audiencename) + '%'+ '\'  ORDER BY Name limit :QueryLimit';
        
        if (query.length() > 0) {
            audienceCon  = new ApexPages.StandardSetController(Database.query(query));
            this.audienceCon.setpageNumber(1);
            this.audienceCon.setPageSize(10);
        }
        return null;
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description This method will add selected contact to selectedAudienceIdsSet when any contact is selected on Page.
    * @returns returns the void
    */
    public void doSelectItem() {
        this.selectedAudienceIdsSet.add(this.selectedAudienceId);
        globalSelectedAudienceIdSet.add(this.selectedAudienceId);
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description This method will remove selected contact from selectedAudienceIdsSet when any contact is de-selected on Page.
    * @returns returns the void
    */
    public void doDeselectItem() {
        this.selectedAudienceIdsSet.remove(this.selectedAudienceId);
        globalSelectedAudienceIdSet.remove(this.selectedAudienceId);
        
        if (!contentAudienceIdSet.isEmpty() && contentAudienceIdSet.contains(this.selectedAudienceId)) {
            contentAudienceIdSet.remove(this.selectedAudienceId);        
        }        
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description go to next page
    * @returns return void
    */
    public void doNext() {
        if (this.audienceCon.getHasNext()) {
            this.audienceCon.next();
        }
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description go to previous page
    * @returns return void
    */
    public void doPrevious() {
        if (this.audienceCon.getHasPrevious()) {
            this.audienceCon.previous();
        }
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Initialize con and return a list of records
    * @returns return current page of groups
    */
    public List<AudienceWrapper> getAudiencesWrapper() {
        List<AudienceWrapper> audienceWrapperList = new List<AudienceWrapper>();
        
        for (sObject r : this.audienceCon.getRecords()) {
            Audience__c c = (Audience__c)r;
            AudienceWrapper row = new AudienceWrapper(c,false);          
            
            if (!contentAudienceIdSet.isEmpty() && contentAudienceIdSet.contains(c.Id)) {
                 this.selectedAudienceIdsSet.add(c.Id);
            }
            
            if (isSelectAll) {
                if (this.selectedAudienceIdsSet.isEmpty() || this.selectedAudienceIdsSet.contains(c.Id) || globalSelectedAudienceIdSet.contains(c.Id)){ //
                    row.IsSelected = true;
                }
                else if (!this.selectedAudienceIdsSet.contains(c.Id)) {
                    row.IsSelected = false;
                }
            }
            else if (this.selectedAudienceIdsSet.contains(c.Id) || globalSelectedAudienceIdSet.contains(c.Id)) {
                row.IsSelected = true;
            }
            else if (!isSelectAll) {
                row.IsSelected = false;
            }
            audienceWrapperList.add(row);
        }
        
        
        Integer currentPage = getPageNumber();
        this.audienceCon.setPageNumber(1);
        
        for (Integer i = 0; i < getTotalPages(); i++) {
            for (sObject audience : this.audienceCon.getRecords()) {
                Audience__c c = (Audience__c)audience;
                
                if (!contentAudienceIdSet.isEmpty() && contentAudienceIdSet.contains(c.Id)) {
                    this.selectedAudienceIdsSet.add(c.Id);
                }
            }
            this.audienceCon.next();
        }
        this.audienceCon.setPageNumber(currentPage);
        
        return audienceWrapperList;
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description return whether previous page exists
    * @returns return whether previous page exists
    */
    public Boolean getHasPrevious() {
        return this.audienceCon.getHasPrevious();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description return whether next page exists
    * @returns return whether next page exists
    */
    public Boolean getHasNext() {
        return this.audienceCon.getHasNext();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description return page number
    * @returns return page number
    */
    public Integer getPageNumber() {
        return this.audienceCon.getPageNumber();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description calculates total number of pages
    * @returns return total pages
    */
    public Integer getTotalPages() {
        Decimal totalSize = this.audienceCon.getResultSize();
        Decimal pageSize = this.audienceCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description selects all/ unselect all audience records
    * @returns return null
    */
    public void selectUnselectAllAudience() {
        if (isSelectAll) {
            //When Select all is clicked fill all audience Id into Set
            Integer currentPageNumber = getPageNumber();
            this.audienceCon.setpageNumber(1);
            
            for (integer i=0; i < getTotalPages(); i++) {
                for (sObject audienceObject : this.audienceCon.getRecords()) {
                    Audience__c audience = (Audience__c)audienceObject;
                    this.selectedAudienceIdsSet.add(audience.Id);
                }
                this.audienceCon.next();
            }
            
            this.audienceCon.setpageNumber(currentPageNumber);
        }
        else if (!isSelectAll) {
            selectedAudienceIdsSet.clear();
            globalSelectedAudienceIdSet.clear();
            contentAudienceIdSet.clear();
        }
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Wrapper class for Broker Contact
    */
    public with sharing class AudienceWrapper {
        public Audience__c audience { get; set; }
        public Boolean IsSelected { get; set; }
 
        public AudienceWrapper(Audience__c audience, Boolean isSelected) {
            this.audience = audience;
            this.IsSelected = isSelected;
        }
    }
}