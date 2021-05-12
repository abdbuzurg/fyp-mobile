import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/clientFeed_screen.dart';
import 'package:fypMobile/models/ClientFeedShape.dart';
import 'package:fypMobile/utils/prefs.dart';

import '../constants.dart';
import 'components/oneFeed.dart';
import 'package:http/http.dart' as http;

class DriverHistory extends StatefulWidget {
  @override
  _DriverHistoryState createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
  Future<Map<String, List<ClientFeedShape>>> _driverHistory;

  @override
  void initState() {
    super.initState();
    _driverHistory = fetchDriverHistory();
  }

  Future<Map<String, List<ClientFeedShape>>> fetchDriverHistory() async {
    String token = await getToken();
    var url = Uri.parse(backendApiUrl + 'client/history');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData["success"]) {
        Map<String, List<ClientFeedShape>> result = {
          "pastAction": new List<ClientFeedShape>(),
          "futureAction": new List<ClientFeedShape>()
        };
        responseData["data"]["pastAction"].forEach((clientFeed) =>
            result["pastAction"]
                .add(ClientFeedShape.fromAllFeedJson(clientFeed)));
        responseData["data"]["futureAction"].forEach((clientFeed) =>
            result["futureAction"]
                .add(ClientFeedShape.fromAllFeedJson(clientFeed)));
        return result;
      } else {
        print(responseData["message"]);
        return null;
      }
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("History"),
            bottom: TabBar(tabs: [
              Tab(
                  child: Text(
                "Incoming",
                style: TextStyle(fontSize: 20),
              )),
              Tab(
                  child: Text(
                "Finished",
                style: TextStyle(fontSize: 20),
              ))
            ]),
          ),
          body: FutureBuilder(
              future: _driverHistory,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data;
                  return TabBarView(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data["futureAction"].length,
                        itemBuilder: (context, index) {
                          print(data["futureAction"]);
                          ClientFeedShape feed = data["futureAction"][index];
                          return oneFeed(feed, context);
                        },
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data["pastAction"].length,
                        itemBuilder: (context, index) {
                          ClientFeedShape feed = data["pastAction"][index];
                          return oneFeed(feed, context);
                        },
                      )
                    ],
                  );
                }
                return TabBarView(children: [
                  Center(child: CircularProgressIndicator()),
                  Center(child: CircularProgressIndicator())
                ]);
              }),
        ));
  }
}
