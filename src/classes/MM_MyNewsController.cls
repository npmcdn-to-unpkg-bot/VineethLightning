/**
* @author: Siddhant Indra
* @date: December 2014
* @description: MM_03_US0010 Class to show Personalised Marketing Messages to Brokers.
*/
public without sharing class MM_MyNewsController {
/**
* @author: Siddhant Indra
* @date: December 2014
* @description: This method finds Manage_Content__c related to logged in User which will be shown in My news Section
* @param String filter config
* @param Integer offset value
* @param Integer limit for query
* @return: List<Manage_Content__c>
*/
    @RemoteAction
     public static List<Manage_Content__c> getNewsAndProductUpdate(String filterConfig, Integer iOffset, Integer iLimit, String dateTo, String dateFrom, String searchString){
        //IP_ActionResult result = new IP_ActionResult();
        List<Manage_Content__c> result = new List<Manage_Content__c>();
        Map<String,Object> dataMap = new Map<String,Object>();
        Map<Id, Boolean> manageContentIdVSContentReadMap = new Map<Id, Boolean>();
        User user = [
            SELECT Id, ContactId 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];

        List<Content_Broker__c> contentBrokerList = [
            SELECT Manage_Content__c, Read__c, Id 
            FROM Content_Broker__c 
            WHERE Contact__c =: user.ContactId
        ];
        
        String str = '';
        List<Manage_Content__c> manageContentList = new List<Manage_Content__c>();
        List<Manage_Content__c> manageContentCloneList = new List<Manage_Content__c>();
        List<ManageContentWrapper> manageContentWrapperList = new List<ManageContentWrapper>();
        List<ManageContentWrapper> manageContentWrapperCountList = new List<ManageContentWrapper>();
        Id RT_NEWS_AND_PRODUCT_UPDATE = Schema.getGlobalDescribe().get('Manage_Content__c').getDescribe().getRecordTypeInfosByName().get('News and Product Update').getRecordTypeId();
        if(!contentBrokerList.isEmpty()) {
            Set<Id> contentBrokerIDSet = new Set<Id>();
            
            
            
            for(Content_Broker__c contentBroker :contentBrokerList) {
                contentBrokerIDSet.add(contentBroker.Manage_Content__c);
                manageContentIdVSContentReadMap.put(contentBroker.Manage_Content__c, contentBroker.Read__c);
            }
            
            String baseQuery = 'Select Summary__c, Title__c , Id , Body__c , Publish_Start__c, Publish_End__c From Manage_Content__c where isActivePublished__c = true and RecordTypeId = :RT_NEWS_AND_PRODUCT_UPDATE and Id IN :contentBrokerIDSet '; 
            if(dateTo != ''){
                Date dtTo = Date.parse(dateTo);
                baseQuery += ' AND Publish_Start__c <=' + (String.valueOf(dtTo)).substring(0,10);
            }
            
            if(dateFrom != ''){
                Date dtFrom = Date.parse(dateFrom);
                baseQuery += ' AND Publish_Start__c >=' + (String.valueOf(dtFrom)).substring(0,10);
            }
            system.debug('searchString----------'+searchString);
            if(searchString !=''){
                baseQuery += ' AND Title__c LIKE \'%'+ searchString + '%\'';
                //baseQuery += ' OR Summary__c LIKE \'%'+ searchString + '%\')';
                system.debug('baseQuery----------'+baseQuery);
                //'Summary LIKE \'%' + strSearchText + '%\''
            }
            
            baseQuery += ' order by Publish_Start__c ';
            String strQuery = baseQuery + filterConfig + ' LIMIT :iLimit OFFSET :iOffset';
            String strQueryClone = baseQuery + filterConfig;
            system.debug('strQueryClone**********'+strQueryClone);
                
            if(!contentBrokerIDSet.isEmpty()) {
                manageContentList = database.query(strQuery);
                manageContentCloneList = database.query(strQueryClone);
            }
        }
        
        if(!manageContentList.isEmpty()) {
            for(Manage_Content__c manageContent : manageContentList) {
                if(!manageContentIdVSContentReadMap.isEmpty() && manageContentIdVSContentReadMap.containsKey(manageContent.Id)) {
                    manageContentWrapperList.add(new ManageContentWrapper(manageContent, manageContentIdVSContentReadMap.get(manageContent.Id)));
                }
            }
        }
            
        if(!manageContentCloneList.isEmpty()) {
            for(Manage_Content__c manageContent : manageContentCloneList) {
                if(!manageContentIdVSContentReadMap.isEmpty() && manageContentIdVSContentReadMap.containsKey(manageContent.Id)) {
                    manageContentWrapperCountList.add(new ManageContentWrapper(manageContent, manageContentIdVSContentReadMap.get(manageContent.Id)));
                }
            }
        }
        
        dataMap.put('ManageContentList',manageContentWrapperList);
        dataMap.put('TotalRecordCount', manageContentWrapperCountList.size());
        
        //result.Data = dataMap;
        system.debug('--- '+ dataMap);
        return result;
     }
     
/**
* @author: Siddhant Indra
* @date: December 2014
* @description: Wrapper class for Manage Content
*/
     
     public class ManageContentWrapper {
        public Boolean isRead { get; set; }
        public Manage_Content__c manageContent { get; set; }
        
/**
* @author: Siddhant Indra
* @date: December 2014
* @description: Default Construtor for Wrapper class
*/     
   
        public ManageContentWrapper(Manage_Content__c objManageContent, boolean read) {
            this.isRead = read;
            this.manageContent = objManageContent;
        }
     }
     
/** 
* @author: Siddhant Indra
* @date: 20/11/2014
* @description: This method is used to display Detailed section of My news and Product
* @param String id of manage content
* @return: IP_ActionResult.  
*/
    @RemoteAction
    public static List<Manage_Content__c> GetNewsDetail(String manageContentId) {
        //IP_ActionResult result = new IP_ActionResult();
        List<Manage_Content__c> result = new List<Manage_Content__c>();
        Map<String,Object> dataMap = new Map<String,Object>();
        List<Manage_Content__c> manageContentDetailList = new List<Manage_Content__c>();
        
        User user = [
            SELECT Id, ContactId 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        
        manageContentDetailList = [
            SELECT Title__c, Summary__c, Body__c, Link__c, Publish_Start__c, Publish_End__c, Name, 
                (SELECT Manage_Content__c, Contact__c, Read__c 
                 FROM Content_Brokers__r 
                 WHERE Contact__c =: user.ContactId)
            FROM Manage_Content__c 
            WHERE Id = :manageContentId
        ];
        dataMap.put('ManageContentDetailList', manageContentDetailList);
        //result.Data = dataMap;
        
        if(!manageContentDetailList.isEmpty()) {
            List<Content_Broker__c> contentBrokersList = manageContentDetailList[0].Content_Brokers__r;
            
            if(!contentBrokersList.isEmpty()) {
                List<Content_Broker__c> contentBrokersUpdateList = new List<Content_Broker__c>();
                
                for(Content_Broker__c contentBroker :contentBrokersList) {
                    contentBroker.Read__c = true;
                    contentBrokersUpdateList.add(contentBroker);
                }
                
                if(!contentBrokersUpdateList.isEmpty()){
                   //IP_Util.updateContentBroker(contentBrokersUpdateList);
                }
            }
        }
        return result;
    }
}