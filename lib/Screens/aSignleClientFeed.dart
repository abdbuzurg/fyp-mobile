import 'package:flutter/material.dart';
import 'package:fypMobile/constants.dart';
import 'package:fypMobile/graphql/request.dart';
import 'package:fypMobile/models/ClientFeedShape.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../graphQLConfig.dart';
import 'components/loadingSpinner.dart';

class ASingleClientFeed extends StatefulWidget {
  final ClientFeedShape clientFeed;
  ASingleClientFeed(this.clientFeed);

  @override
  _ASingleClientFeedState createState() => _ASingleClientFeedState();
}

class _ASingleClientFeedState extends State<ASingleClientFeed> {
  // bool requestStatus = false;
  // Future<bool> ownerOfFeed;

  // Future<bool> initialCheckForOwnerOfPost() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final int userId = await prefs.get("userId");
  //   return widget.clientFeed.driverId == userId ? true : false;
  // }

  // Future<void> initialCheckForRequest() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String token = await prefs.get("token");
  //   final String checkIfRequested =
  //       RequestGraphql.allRequstOfAClientFeed(widget.clientFeed.id);
  //   print(checkIfRequested);
  //   GraphQLClient client = GraphQLConfiguration().clientToQuery(token: token);
  //   QueryResult result =
  //       await client.query(QueryOptions(documentNode: gql(checkIfRequested)));
  //   print(result.data);
  //   if (result.hasException) {
  //     print(result.data);
  //     // if (!result.data["allRequstOfAClientFeed"].length == 0) {

  //     // };
  //   } else {
  //     print(result.exception);
  //   }
  // }

  // @override
  // void initState() {
  //   ownerOfFeed = initialCheckForOwnerOfPost();
  //   super.initState();
  // }

  // void requestSeat() {
  //   setState(() {
  //     requestStatus = true;
  //   });
  // }

  // void cancelSeat() {
  //   setState(() {
  //     requestStatus = false;
  //   });
  // }

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
                      SizedBox(height: 10.0),
                      // FutureBuilder(
                      //     future: ownerOfFeed,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState !=
                      //           ConnectionState.done) {
                      //         print(snapshot);
                      //         if (snapshot.data) {
                      //           print("You should request the state");
                      //           return Text("You should request the State");
                      //         } else {
                      //           return Text("You are the owner");
                      //         }
                      //       }

                      //       return LoadingSpinner();
                      //     })
                    ],
                  )),
              SizedBox(height: 15.0),
            ])));
  }
}
