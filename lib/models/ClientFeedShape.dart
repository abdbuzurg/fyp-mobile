import 'package:fypMobile/models/RequestShape.dart';

class ClientFeedShape {
  final int id;
  final String username;
  final String driverName;
  final String initialLocation;
  final String finalLocation;
  final String pricing;
  final String carModel;
  final int numberOfSeats;
  final String departureDate;
  final String mobileNumber;
  final String description;
  final int driverId;
  final String postedOn;

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
      this.driverId,
      this.postedOn});

  factory ClientFeedShape.fromAllFeedJson(Map<String, dynamic> result) {
    if (result["destinationFrom"].toString().length <= 11)
      result["destinationFrom"] +=
          " " * (11 - result["destinationFrom"].toString().length);
    else
      result["destinationTo"] +=
          result["destinationTo"].toString().substring(0, 8) + "...";

    if (result["destinationTo"].toString().length <= 11)
      result["destinationTo"] += " " * (11 - result["destinationTo"].length);
    else
      result["destinationTo"] +=
          result["destinationTo"].toString().substring(0, 8) + "...";

    return ClientFeedShape(
        id: result["id"],
        initialLocation: result["destinationFrom"],
        finalLocation: result["destinationTo"],
        pricing: result["pricing"],
        carModel: result["carModel"],
        numberOfSeats: result["numberOfSeats"],
        departureDate: result["departureDate"],
        postedOn: result["createdAt"]);
  }
}
