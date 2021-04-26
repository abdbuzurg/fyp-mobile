import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/constants.dart';
import 'package:fypMobile/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/loadingSpinner.dart';
import '../models/ClientFeedShape.dart';
import 'aSignleClientFeed.dart';
import 'createClientFeed_screen.dart';

import 'package:http/http.dart' as http;

class ClientFeed extends StatefulWidget {
  _ClientFeed createState() => _ClientFeed();
}

class _ClientFeed extends State<ClientFeed> {
  ValueNotifier<int> _refresh = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
  }

  Future<List<ClientFeedShape>> _fetchClientFeed() async {
    String token = await getToken();
    var url = Uri.parse(backendApiUrl + 'client/');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData["success"]) {
        List<ClientFeedShape> data = new List();
        responseData["data"].forEach((clientFeed) {
          data.add(ClientFeedShape.fromAllFeedJson(clientFeed));
        });
        return data.reversed.toList();
      } else {
        print(responseData["message"]);
      }
    }
  }

  Future<void> _deleteClientFeed(int id) async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Center(child: Text("Client Feed")),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Show Snackbar',
              onPressed: () {
                _refresh.value += 1;
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => CreateClientFeed()))
                .then((value) => value ? _refresh.value += 1 : null),
            child: Icon(Icons.add),
            backgroundColor: appPrimaryColor),
        body: ValueListenableBuilder(
            valueListenable: _refresh,
            builder: (context, value, child) => FutureBuilder(
                  future: _fetchClientFeed(),
                  builder:
                      (context, AsyncSnapshot<List<ClientFeedShape>> snapshot) {
                    if (snapshot.hasData) {
                      List<ClientFeedShape> allFeed = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allFeed.length,
                        itemBuilder: (context, index) {
                          ClientFeedShape feed = allFeed[index];
                          return oneFeed(feed);
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                    }

                    return LoadingSpinner();
                  },
                )));
  }

  Future<bool> _removeEnabled(int driverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userId = await prefs.get("userId");
    return userId == driverId;
  }

  void detailedInformation(ClientFeedShape feed) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              width: double.infinity,
              height: double.infinity,
              color: appPrimaryColor,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.5, color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person_pin_circle, size: 40.0),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Initial Location",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            feed.initialLocation,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 40.0),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Final Location",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            feed.finalLocation,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.5, color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Post on",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      feed.postedOn.substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.0),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Departure Date",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      feed.departureDate.substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.5, color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Seats",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        Text(
                                          feed.numberOfSeats.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Price",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        Text(
                                          feed.pricing,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Car Model",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        Text(
                                          feed.carModel,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () => print("call"),
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.white,
                            child: Text("Call",
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                      )
                    ],
                  )));
        });
  }

  Widget oneFeed(ClientFeedShape feed) {
    return GestureDetector(
        onTap: () => detailedInformation(feed),
        child: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.5, color: appPrimaryColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.only(left: 5.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: <Widget>[
                              Column(children: <Widget>[
                                Icon(Icons.person_pin_circle, size: 30.0),
                                Container(
                                  height: 40,
                                  child: CustomPaint(
                                    foregroundPainter: LinePainter(),
                                  ),
                                ),
                                Icon(Icons.location_on, size: 30.0)
                              ]),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Initial Location",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    feed.initialLocation,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Final Location",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    feed.finalLocation,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Posted on",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    feed.postedOn.substring(0, 10),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Departure Date",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    feed.departureDate.substring(0, 10),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ]),
                          ],
                        ))),
              ],
            )));
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 3;
    paint.color = appIconColor;
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
