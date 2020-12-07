import 'package:flutter/material.dart';
import 'package:fypMobile/constants.dart';
import 'package:fypMobile/models/ClientFeedShape.dart';

class ASingleClientFeed extends StatefulWidget {
  final ClientFeedShape clientFeed;
  ASingleClientFeed(this.clientFeed);

  @override
  _ASingleClientFeedState createState() => _ASingleClientFeedState();
}

class _ASingleClientFeedState extends State<ASingleClientFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text("Client Feed #${widget.clientFeed.id}"),
        ),
        body: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: appPrimaryColor,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.clientFeed.driverName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                          Text(widget.clientFeed.username,
                              style: TextStyle(fontSize: 15.0)),
                        ],
                      )
                    ],
                  )),
              SizedBox(height: 10.0),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(children: [
                        Icon(Icons.my_location, size: 36.0),
                        SizedBox(width: 8.0),
                        Text(widget.clientFeed.initialLocation,
                            style: TextStyle(fontSize: 18.0)),
                      ]),
                      SizedBox(height: 10.0),
                      Row(children: [
                        Icon(Icons.location_on, size: 36.0),
                        SizedBox(width: 8.0),
                        Text(widget.clientFeed.finalLocation,
                            style: TextStyle(fontSize: 18.0)),
                      ]),
                      SizedBox(height: 10.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.attach_money, size: 36.0),
                              SizedBox(width: 8.0),
                              Text(widget.clientFeed.pricing,
                                  style: TextStyle(fontSize: 18.0)),
                            ]),
                            SizedBox(width: 30.0),
                            Row(children: [
                              Icon(Icons.airline_seat_legroom_normal,
                                  size: 36.0),
                              SizedBox(width: 8.0),
                              Text(widget.clientFeed.numberOfSeats,
                                  style: TextStyle(fontSize: 18.0)),
                            ])
                          ]),
                      SizedBox(height: 10.0),
                      Row(children: [
                        Icon(Icons.directions_car, size: 36.0),
                        SizedBox(width: 8.0),
                        Text(widget.clientFeed.carModel,
                            style: TextStyle(fontSize: 18.0)),
                      ]),
                      SizedBox(height: 10.0),
                      Row(children: [
                        Icon(Icons.call, size: 36.0),
                        SizedBox(width: 8.0),
                        Text(widget.clientFeed.mobileNumber,
                            style: TextStyle(fontSize: 18.0)),
                      ]),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 36.0),
                          SizedBox(width: 8.0),
                          Text(widget.clientFeed.departureDate,
                              style: TextStyle(fontSize: 18.0)),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15.0),
              RaisedButton(
                  elevation: 5.0,
                  onPressed: () => print("Request sent"),
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: appPrimaryColor,
                  child: Text("Request seat",
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ])));
  }
}
