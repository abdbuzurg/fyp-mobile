class ClientFeedShape {
  final int id;
  final String username;
  final String driverName;
  final String initialLocation;
  final String finalLocation;
  final String pricing;
  final String carModel;
  final String numberOfSeats;
  final String departureDate;
  final String mobileNumber;
  final String description;
  final int driverId;

  ClientFeedShape(
      {this.id,
      this.username,
      this.driverName,
      this.initialLocation,
      this.finalLocation,
      this.pricing,
      this.carModel,
      this.numberOfSeats,
      this.departureDate,
      this.mobileNumber,
      this.description,
      this.driverId});

  factory ClientFeedShape.fromAllFeedJson(Map<String, dynamic> result) {
    return ClientFeedShape(
        id: result["id"],
        username: result["driver"]["username"],
        driverName: result["driver"]["name"],
        initialLocation: result["initialLocation"],
        finalLocation: result["finalLocation"],
        pricing: result["pricing"],
        carModel: result["carModel"],
        numberOfSeats: result["numberOfSeats"],
        departureDate: result["departureDate"],
        description: result["description"],
        mobileNumber: result["driver"]["mobileNumber"],
        driverId: result["driver"]["id"]);
  }
}
