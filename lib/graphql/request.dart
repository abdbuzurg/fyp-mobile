class RequestGraphql {
  static String allRequstOfAClientFeed(int clientFeedId) {
    return """
      {
      allRequstOfAClientFeed(clientFeedId: $clientFeedId){
        reciever{
          id
        }
        sender{
          id
        }
      }
    }
    """;
  }

  static String createRequestForClientFeed(int feedId) {
    return """
    mutation{
      createRequest(
        feedType: 1,
        feedId: $feedId
      ){
        id
      }
    }
    """;
  }
}
