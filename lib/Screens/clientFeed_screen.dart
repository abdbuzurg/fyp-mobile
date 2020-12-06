import 'package:flutter/material.dart';
import 'package:fypMobile/constants.dart';
import 'package:fypMobile/graphQLConfig.dart';
import 'package:fypMobile/graphql/clientFeed.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/loadingSpinner.dart';
import '../models/ClientFeedShape.dart';
import 'createClientFeed_screen.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.get("token");
    GraphQLClient client = GraphQLConfiguration().clientToQuery(token: token);
    String fetchAll = ClientFeedQraphql.fetchAll();
    QueryResult result =
        await client.query(QueryOptions(documentNode: gql(fetchAll)));
    if (!result.hasException) {
      List<dynamic> clientFeed = result.data["fetchClientFeed"];
      return clientFeed
          .map((clientFeed) => ClientFeedShape.fromAllFeedJson(clientFeed))
          .toList();
    } else {
      print(result.exception);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Center(child: Text("Client Feed")),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => CreateClientFeed()))
                .then((value) => value != null ? _refresh.value += 1 : null),
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

  Widget oneFeed(ClientFeedShape feed) {
    return GestureDetector(
        onTap: () => print(feed.id),
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
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: appPrimaryColor,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(feed.driverName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(feed.username,
                                style: TextStyle(fontSize: 11.0)),
                          ],
                        )
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Icon(Icons.directions_car, size: 24.0),
                                Text(feed.carModel),
                              ]),
                              Row(children: [
                                Icon(Icons.call, size: 24.0),
                                Text(feed.mobileNumber)
                              ])
                            ]),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Icon(Icons.my_location, size: 24.0),
                                Text(feed.initialLocation),
                              ]),
                              Row(children: [
                                Icon(Icons.location_on, size: 24.0),
                                Text(feed.finalLocation)
                              ])
                            ]),
                        SizedBox(height: 10.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Icon(Icons.attach_money, size: 24.0),
                                Text(feed.pricing),
                              ]),
                              Row(children: [
                                Icon(Icons.airline_seat_legroom_normal,
                                    size: 24.0),
                                Text(feed.numberOfSeats.toString())
                              ]),
                              Row(children: [
                                Icon(Icons.access_time, size: 24.0),
                                Text(feed.departureDate)
                              ])
                            ])
                      ],
                    ))
              ],
            )));
  }
}
