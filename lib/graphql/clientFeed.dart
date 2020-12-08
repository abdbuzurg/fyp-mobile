class ClientFeedQraphql {
  static String fetchAll() {
    return """
      {
        fetchClientFeed{
          id
          initialLocation
          finalLocation
          pricing
          departureDate
          description
          carModel
          numberOfSeats
          driver{
            id
            username
            email
            name
            mobileNumber
          }
        }
      }
    """;
  }

  static String createClientFeed(
      {String initialLocation,
      String finalLocation,
      String pricing,
      String carModel,
      String numberOfSeats,
      String departureDate,
      String description}) {
    return """
    mutation{
      createClientFeed(
        initialLocation:"$initialLocation",
        finalLocation:"$finalLocation",
        pricing: "$pricing",
        carModel: "$carModel",
        numberOfSeats: "$numberOfSeats",
        departureDate: "$departureDate"
        description: "$description"
      )
      {
        id
      }
    }
    """;
  }

  static String deleteClientFeed(int id) {
    return """
    mutation{
      deleteClientFeed(id:$id)
    }
    """;
  }
}
