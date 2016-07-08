public without sharing class UserTriggerHandler {
	public static void addWelcomeFeed(List<User> newUsers) {
		List<Id> customerIds = new List<Id>();
		String profileId = [
            SELECT Id
            FROM Profile
            WHERE Name =: 'Mortgage Customer Community Test'
            LIMIT 1
        ].Id;
		for (User u : newUsers) {
			System.debug('USER = ' + u);
			if (u.ProfileId == profileId) {
				System.debug('USER = +++ ' + u);
				customerIds.add(u.Id);
			} 
		}
		
		//FutureWelcomeFeed.addWelcome(customerIds);
		/*for (Id id : customerIds) {
			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null,//Network.getNetworkId(), 
                    id, ConnectApi.FeedElementType.FeedItem, 'On vacation this week.');
		}*/
	}

	
	public static void addWelcomeFeedUpdate(Map<Id,User> newUsers, Map<Id,User> oldUsers) {
		List<Id> customerIds = new List<Id>();
		String profileId = [
            SELECT Id
            FROM Profile
            WHERE Name =: 'Mortgage Customer Community Test'
            LIMIT 1
        ].Id;

		for (User u : newUsers.values()) {
			System.debug('USER = +++++' + u);
			if (u.ProfileId == profileId && u.LastLoginDate != null && oldUsers.get(u.Id).LastLoginDate == null) {
				System.debug('USER = +++ ' + u);
				customerIds.add(u.Id);
			} 
		}
		
		for (Id id : customerIds) {
			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null,//Network.getNetworkId(), 
                    id, ConnectApi.FeedElementType.FeedItem, 'On vacation this week.');
		}
	}
}