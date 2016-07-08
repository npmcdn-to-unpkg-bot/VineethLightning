global class FutureWelcomeFeed {
	@future
    public static void addWelcome(List<ID> recordIds)
    {   
        for (Id id : recordIds) {
			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null,//Network.getNetworkId(), 
                    id, ConnectApi.FeedElementType.FeedItem, 'On vacation this week.');
		}
    }
}