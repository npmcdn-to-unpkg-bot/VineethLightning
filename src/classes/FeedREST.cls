@RestResource(urlMapping='/Welcome/*')
global class FeedREST {

	@HttpPost
    global static void doPost() {//(String userId) {
    	//System.debug('ID === ' + userId);
    	//RestContext.response.addHeader('Content-Type', 'text/plain');
        //String userId = RestContext.request.params.get('id');
        //RestContext.response.responseBody = Blob.valueOf('Hello '+name);
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null,//Network.getNetworkId(), 
                    userId, ConnectApi.FeedElementType.FeedItem, 'On vacation this week.');
        RestContext.response.responseBody = Blob.valueOf('Hello '+ userId);
    }
}