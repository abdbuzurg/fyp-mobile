import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/modalClientFeed.dart';
import 'package:fypMobile/models/ClientFeedShape.dart';

import '../../constants.dart';
import '../clientFeed_screen.dart';

Widget oneFeed(ClientFeedShape feed, BuildContext context) {
  return GestureDetector(
      onTap: () => detailedInformation(feed, context),
      child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
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
