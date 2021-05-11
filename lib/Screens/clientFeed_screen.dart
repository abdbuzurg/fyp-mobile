import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/search_screen.dart';
import 'package:fypMobile/constants.dart';
import 'package:fypMobile/models/UserShape.dart';
import 'package:fypMobile/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/loadingSpinner.dart';
import '../models/ClientFeedShape.dart';
import 'components/oneFeed.dart';
import 'modalClientFeed.dart';
import 'createClientFeed_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class ClientFeed extends StatefulWidget {
  _ClientFeed createState() => _ClientFeed();
}

class _ClientFeed extends State<ClientFeed> {
  Future<List<ClientFeedShape>> clientFeed;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    clientFeed = _fetchClientFeed();
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
        return null;
      }
    } else
      return null;
  }

  Future<void> refreshFeed() async {
    List<ClientFeedShape> freshFeed = await _fetchClientFeed();
    setState(() {
      clientFeed = Future.value(freshFeed);
    });
  }

  void search(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _initialLocation =
              TextEditingController();
          final TextEditingController _finalLocation = TextEditingController();
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text("Search",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 20,
                  ),
                  TextFormField(
                    validator: (value) =>
                        value.isNotEmpty ? null : "Invalid Field",
                    controller: _initialLocation,
                    decoration: InputDecoration(labelText: "Initial Location"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) =>
                        value.isNotEmpty ? null : "Invalid Field",
                    controller: _finalLocation,
                    decoration: InputDecoration(labelText: "Final Location"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchResult(
                                    _initialLocation.text,
                                    _finalLocation.text,
                                    true)));
                          }
                        },
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: appPrimaryColor,
                        child: Text("Search",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                  ),
                ])),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text("SEARCH", style: titleTextStyle),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Show Snackbar',
              onPressed: () => search(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => CreateClientFeed()))
                .then((value) => value ? refreshFeed() : null),
            child: Icon(Icons.add),
            backgroundColor: appPrimaryColor),
        body: FutureBuilder(
          future: clientFeed,
          builder: (context, AsyncSnapshot<List<ClientFeedShape>> snapshot) {
            if (snapshot.hasData) {
              List<ClientFeedShape> allFeed = snapshot.data;
              return RefreshIndicator(
                  onRefresh: refreshFeed,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allFeed.length,
                    itemBuilder: (context, index) {
                      ClientFeedShape feed = allFeed[index];
                      return oneFeed(feed, context);
                    },
                  ));
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }

            return LoadingSpinner();
          },
        ));
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
