/**
* @author Sandip Kulkarni
* @date Nov 2014
* @description MM_01,MM_02,MM_03 Controller class to manage the Content publishing and logic behind it
* 
*/
public with sharing class MM_PublishPersonalisedMessagesController{
    
    public List<BorkerContactWrapper> borkerContactWrapperList { get; set; }
    public String firstNamesearchtext { get; set;}
    public String lastNamesearchtext { get; set;}
    public String selectedBrokerContactId { get; set; }  
    
    private ApexPages.StandardSetController personalizedMessageCon;    
    private Set<Id> selectedBrokerContactIdsSet;
    private Set<Id> existingBrokerContactIdSet;
    
    private static Set<Id> globalSelectedBrokerContactIdSet = new Set<Id>();
    
    protected Manage_Content__C myContent;
    ApexPages.StandardController myController;       

    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Added code to display Broker contact List on page when RecordType is PERSONALISED_MESSAGE.
    */
    public MM_PublishPersonalisedMessagesController(ApexPages.StandardController c){
        if(!test.isRunningTest())
            c.addFields(new List<String>{'Type_of_Signature__c','Signature__c','Approved__c'});
            
        myContent = (Manage_content__c)c.getRecord();
        mycontroller = c;
        existingBrokerContactIdSet = new set<id>();
        
        list<Content_Broker__c> contentBrokerList = [Select Name, Id, Contact__c, Manage_Content__c  From Content_Broker__c where Manage_Content__c = : mycontent.id];
        for(Content_Broker__c contentBroker :contentBrokerList) {
            existingBrokerContactIdSet.add(contentBroker.Contact__c);
        }
        system.debug('##existingBrokerContactIdSet==>'+existingBrokerContactIdSet);
        
        this.selectedBrokerContactIdsSet= new Set<Id>();
        this.personalizedMessageCon = new ApexPages.StandardSetController([SELECT Name, Id, Account.Name, FirstName, Lastname FROM Contact  WHERE RM__c =:UserInfo.getUserId()]);
        this.personalizedMessageCon.setpageNumber(1);
        this.personalizedMessageCon.setPageSize(10);            
    }
    
    /**
    * @author Siddhant Indra
    * @date Nov 2014
    * @description MM_01,MM_02 method to publish a content and assign the brokers
    */
    
    public PageReference unPublish(){    
        mycontent.published__c = false;
        mycontroller.save();
        return new ApexPages.StandardController(myContent).view(); 
    }

    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Method to close the publishing and return to the content
    * @returns redirect to the content page
    */
    public Pagereference Close(){
        return new ApexPages.StandardController(myContent).view();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Inserts ContactBroker records
    * @returns returns the PageReference
    */
    
    public PageReference publishBrokerContact() {
        List<Content_Broker__c> contentBrokerList = new List<Content_Broker__c>();
        try {
            system.debug('selectedBrokerContactIdsSet==>'+selectedBrokerContactIdsSet);
            if (!selectedBrokerContactIdsSet.isEmpty()) {
                list<content_broker__c> deleteBrokersList = [select id from content_broker__c where manage_content__c=:myContent.id];
                delete deleteBrokersList;
            
                //mark as published
                myContent.published__c=true;
                for (Id brokerContactId :selectedBrokerContactIdsSet) {
                    contentBrokerList.add(new Content_Broker__c(Manage_Content__c = myContent.Id, Contact__c = brokerContactId));
                }
            
                insert contentBrokerList;
                                
                myController.save();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Contact record. '));
                return null;
            }
        } catch(Exception ex) {
            system.debug('Exception occured>>>'+ex);
        }
        return new ApexPages.StandardController(myContent).view();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Search method for Broker Name
    * @returns returns the PageReference
    */
    
    public PageReference searchBroker() {
        String query = '';
        if (String.isNotBlank(firstNamesearchtext)) {
            firstNamesearchtext = String.escapeSingleQuotes(firstNamesearchtext);
        }
        if (String.isNotBlank(lastNamesearchtext)) {
            lastNamesearchtext = String.escapeSingleQuotes(lastNamesearchtext);
        }

        query = 'SELECT Name, Id, Account.Name, FirstName, Lastname FROM Contact where RM__c='+'\'' + UserInfo.getUserId() +'\'';
        
        if (String.isNotBlank(firstNamesearchtext) && String.isNotBlank(lastNamesearchtext)) {
            query +=  ' and ( FirstName LIKE ' + '\'%' + firstNamesearchtext +  '%\'' + ' OR ';
            query +=  ' LastName LIKE ' + '\'%' + lastNamesearchtext +  '%\')';
        } else if (String.isNotBlank(firstNamesearchtext)) {
            query +=  ' and FirstName LIKE ' + '\'%' + firstNamesearchtext +  '%\'';
        } else if (String.isNotBlank(lastNamesearchtext)) {
            query +=  ' and LastName LIKE ' + '\'%' + lastNamesearchtext +  '%\'';
        }
        
        if (query.length() > 0) {
            personalizedMessageCon  = new ApexPages.StandardSetController(Database.query(query));
            this.personalizedMessageCon.setpageNumber(1);
            this.personalizedMessageCon.setPageSize(10);
        }
        
        //selectedBrokerContactIdsSet.clear();
        return null;
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description This method will add selected contact to selectedBrokerContactIdsSet when any contact is selected on Page.
    * @returns returns the PageReference
    */
    public void doSelectItem() {
        this.selectedBrokerContactIdsSet.add(this.selectedBrokerContactId);
        globalSelectedBrokerContactIdSet.add(this.selectedBrokerContactId);
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description This method will remove selected contact from selectedBrokerContactIdsSet when any contact is de-selected on Page.
    * @returns returns the void
    */
    
    public void doDeselectItem() {
        this.selectedBrokerContactIdsSet.remove(this.selectedBrokerContactId);
        globalSelectedBrokerContactIdSet.remove(this.selectedBrokerContactId);
        
        if (!existingBrokerContactIdSet.isEmpty() && existingBrokerContactIdSet.contains(this.selectedBrokerContactId)) {
            existingBrokerContactIdSet.remove(this.selectedBrokerContactId);        
        }
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description go to next page
    * @returns return void
    */
    
    public void doNext() {
        if (this.personalizedMessageCon.getHasNext()) {
            this.personalizedMessageCon.next();
        }    
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description go to previous page
    * @returns return void
    */
    public void doPrevious() {
        if (this.personalizedMessageCon.getHasPrevious()) {
            this.personalizedMessageCon.previous();
        }    
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Initialize con and return a list of records
    * @returns return current page of groups
    */
    
    public List<BorkerContactWrapper> getContacts() {
        List<BorkerContactWrapper> rows = new List<BorkerContactWrapper>();
        for (sObject r : this.personalizedMessageCon.getRecords()) {
            Contact c = (Contact)r;
             
            BorkerContactWrapper row = new BorkerContactWrapper(c,false);
            system.debug('###########'+c);
            system.debug('####existingBrokerContactIdSet#######'+existingBrokerContactIdSet.size());
            if (!existingBrokerContactIdSet.isEmpty() && existingBrokerContactIdSet.contains(c.Id)) {
                 this.selectedBrokerContactIdsSet.add(c.Id);
            }
            
            if (this.selectedBrokerContactIdsSet.contains(c.Id) || globalSelectedBrokerContactIdSet.contains(c.Id)) {
                row.IsSelected=true;
            } else {
                row.IsSelected=false;
            }
            rows.add(row);
        }
        
        Integer currentPage = getPageNumber();
        this.personalizedMessageCon.setPageNumber(1);
        
        for (integer i=0; i < getTotalPages(); i++) {
            for (sObject contact : this.personalizedMessageCon.getRecords()) {
                Contact c = (Contact)contact;
                
                if (!existingBrokerContactIdSet.isEmpty() && existingBrokerContactIdSet.contains(c.Id)) {
                    this.selectedBrokerContactIdsSet.add(c.Id);
                }
            }
            this.personalizedMessageCon.next();
        }
        this.personalizedMessageCon.setPageNumber(currentPage);
        
        return rows;
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description return whether previous page exists
    * @returns return whether previous page exists
    */
    public Boolean getHasPrevious() {
        return this.personalizedMessageCon.getHasPrevious();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description return whether next page exists
    * @returns return whether next page exists
    */
    public Boolean getHasNext() {
        return this.personalizedMessageCon.getHasNext();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description return page number
    * @returns return page number
    */
    public Integer getPageNumber() {
        return this.personalizedMessageCon.getPageNumber();
    }
    
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description calculates total number of pages
    * @returns return total pages
    */
    
    public Integer getTotalPages() {
        Decimal totalSize = this.personalizedMessageCon.getResultSize();
        Decimal pageSize = this.personalizedMessageCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
 
    /**
    * @author Siddhant Indra
    * @date November 2014
    * @description Wrapper class for Broker Contact
    */
    
    public with sharing class BorkerContactWrapper {
        public Contact contact{get;set;}
        public Boolean IsSelected{get;set;}
 
        public BorkerContactWrapper(Contact contact, Boolean isSelected) {
            this.contact= contact;
            this.IsSelected= isSelected;
        }
    }
}