public without sharing class OpportunityTriggerHandler {
    public static void addStatusFeed(Map<Id, Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunities) {
        List<FeedItem> feeds = new List<FeedItem>();
        for (Opportunity nOpp : newOpportunities.values()) {
        System.debug('TRIGGER ++ '+nOpp.Account.Name+'****'+oldOpportunities.get(nOpp.Id).account.name);
            if (nOpp.StageName != oldOpportunities.get(nOpp.Id).StageName) {
                feeds.add(
                    new FeedItem(
                        ParentId = nOpp.Id,
                       // Body = Label.Your_application_has_been_reviewed_Status_changed_to + ' ' + nOpp.StageName,  Commented by Vineeth for new Body
                        Body = 'Application ' + nOpp.Customer_Name__c + ' has been updated from '+oldOpportunities.get(nOpp.Id).StageName+' to ' + nOpp.StageName + ' by ' +UserInfo.getName(),
                        Visibility = 'AllUsers',
                        LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+nOpp.Id,
                        Title = nOpp.Customer_Name__c
                    )
                );
            }
        }

        insert feeds;
    }
}