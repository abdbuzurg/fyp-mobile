import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/models/ClientFeedShape.dart';
import 'package:fypMobile/models/DriverFeedShape.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

import 'package:http/http.dart' as http;

import 'components/loadingSpinner.dart';
import 'components/oneFeed.dart';

class SearchResult extends StatefulWidget {
  final String initialLocation;
  final String finalLocation;
  final bool isClientFeed;
  SearchResult(this.initialLocation, this.finalLocation, this.isClientFeed);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  Future<List<ClientFeedShape>> clientFeedSearchResult;
  Future<List<DriverFeedShape>> driverFeedSearchResult;

  @override
  void initState() {
    if (widget.isClientFeed) {
      clientFeedSearchResult = _searchClient();
    }
  }

  Future<List<ClientFeedShape>> _searchClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var url = Uri.parse(backendApiUrl + 'search');
    Map data = {
      "initialLocation": widget.initialLocation,
      "finalLocation": widget.finalLocation,
      "isClientFeed": widget.isClientFeed
    };
    String body = json.encode(data);
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: body);

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData["success"]) {
        List<ClientFeedShape> result = new List();
        responseData["data"].forEach((clientFeed) {
          result.add(ClientFeedShape.fromAllFeedJson(clientFeed));
        });
        return result;
      } else {
        return null;
      }
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text("SEARCH RESULTS", style: titleTextStyle),
        ),
        body: FutureBuilder(
            future: widget.isClientFeed
                ? clientFeedSearchResult
                : driverFeedSearchResult,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (widget.isClientFeed) {
                  List<ClientFeedShape> allFeed = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allFeed.length,
                    itemBuilder: (context, index) {
                      ClientFeedShape feed = allFeed[index];
                      return oneFeed(feed, context);
                    },
                  );
                }
              }
              return LoadingSpinner();
            }));
  }
}
