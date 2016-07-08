/**
* @author: 
* @date: Mart 2016
* @description: Class to show Personalised News Messages to Brokers.
*/
public with sharing class CC_NewsBroadcastsCtrl {
/**
* @author: 
* @date: December 2014
* @description: This method finds Manage_Content__c related to logged in User which will be shown in My news Section
* @param String filter config
* @param Integer offset value
* @param Integer limit for query
* @return: List<Manage_Content__c>
*/
    @RemoteAction
     public static CC_ActionResult getNewsAndProductUpdate(String filterConfig, Integer iOffset, Integer iLimit, String dateTo, String dateFrom, String searchString) {
        CC_ActionResult result = new CC_ActionResult();
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
        
        List<Manage_Content__c> manageContentList = new List<Manage_Content__c>();
        List<Manage_Content__c> manageContentCloneList = new List<Manage_Content__c>();
        List<ManageContentWrapper> manageContentWrapperList = new List<ManageContentWrapper>();
        List<ManageContentWrapper> manageContentWrapperCountList = new List<ManageContentWrapper>();
        Id RT_NEWS_AND_PRODUCT_UPDATE = Schema.getGlobalDescribe().get('Manage_Content__c').getDescribe().getRecordTypeInfosByName().get('News and Product Update').getRecordTypeId();
        if (!contentBrokerList.isEmpty()) {
            Set<Id> contentBrokerIDSet = new Set<Id>();
            
            for (Content_Broker__c contentBroker : contentBrokerList) {
                contentBrokerIDSet.add(contentBroker.Manage_Content__c);
                manageContentIdVSContentReadMap.put(contentBroker.Manage_Content__c, contentBroker.Read__c);
            }
            
            String baseQuery = 'SELECT Summary__c, Title__c , Id , Body__c , Publish_Start__c, Publish_End__c FROM Manage_Content__c WHERE isActivePublished__c = true AND RecordTypeId = :RT_NEWS_AND_PRODUCT_UPDATE AND Id IN: contentBrokerIDSet '; 
            if (dateTo != '') {
                Date dtTo = Date.parse(dateTo);
                baseQuery += ' AND Publish_Start__c <=' + (String.valueOf(dtTo)).substring(0,10);
            }
            
            if (dateFrom != '') {
                Date dtFrom = Date.parse(dateFrom);
                baseQuery += ' AND Publish_Start__c >=' + (String.valueOf(dtFrom)).substring(0,10);
            }
            system.debug('searchString----------'+searchString);
            if (searchString != '') {
                baseQuery += ' AND Title__c LIKE \'%'+ searchString + '%\'';
                //baseQuery += ' OR Summary__c LIKE \'%'+ searchString + '%\')';
                system.debug('baseQuery----------'+baseQuery);
                //'Summary LIKE \'%' + strSearchText + '%\''
            }
            
            baseQuery += ' order by Publish_Start__c ';
            String strQuery = baseQuery + filterConfig + ' LIMIT :iLimit OFFSET :iOffset';
            String strQueryClone = baseQuery + filterConfig;
            system.debug('strQueryClone**********'+strQueryClone);
                
            if (!contentBrokerIDSet.isEmpty()) {
                manageContentList = Database.query(strQuery);
                manageContentCloneList = Database.query(strQueryClone);
            }
        }
        

        for (Manage_Content__c manageContent : manageContentList) {
            if (!manageContentIdVSContentReadMap.isEmpty() && manageContentIdVSContentReadMap.containsKey(manageContent.Id)) {
                manageContentWrapperList.add(new ManageContentWrapper(manageContent, manageContentIdVSContentReadMap.get(manageContent.Id)));
            }
        }

        for (Manage_Content__c manageContent : manageContentCloneList) {
            if (!manageContentIdVSContentReadMap.isEmpty() && manageContentIdVSContentReadMap.containsKey(manageContent.Id)) {
                manageContentWrapperCountList.add(new ManageContentWrapper(manageContent, manageContentIdVSContentReadMap.get(manageContent.Id)));
            }
        }

        
        dataMap.put('ManageContentList',manageContentWrapperList);
        dataMap.put('TotalRecordCount', manageContentWrapperCountList.size());
        
        result.Data = dataMap;
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
    public static CC_ActionResult getNewsDetail(String manageContentId) {
        CC_ActionResult result = new CC_ActionResult();
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
        result.Data = dataMap;
        
        if (!manageContentDetailList.isEmpty()) {
            List<Content_Broker__c> contentBrokersList = manageContentDetailList[0].Content_Brokers__r;
            
            if (!contentBrokersList.isEmpty()) {
                List<Content_Broker__c> contentBrokersUpdateList = new List<Content_Broker__c>();
                
                for (Content_Broker__c contentBroker :contentBrokersList) {
                    contentBroker.Read__c = true;
                    contentBrokersUpdateList.add(contentBroker);
                }
                
                if (!contentBrokersUpdateList.isEmpty()) {
                   CC_Util.updateContentBroker(contentBrokersUpdateList);
                }
            }
        }
        return result;
    }
}