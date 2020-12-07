import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';
import 'package:fypMobile/graphql/clientFeed.dart';
import '../graphQLConfig.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class CreateClientFeed extends StatefulWidget {
  @override
  _CreateClientFeedState createState() => _CreateClientFeedState();
}

class _CreateClientFeedState extends State<CreateClientFeed> {
  String initialLocation;
  String finalLocation;
  String pricing;
  String carModel;
  String numberOfSeats;
  String departureDate;
  String description;

  Future<void> createClientFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.get("token");
    GraphQLClient client = GraphQLConfiguration().clientToQuery(token: token);
    String query = ClientFeedQraphql.createClientFeed(
        initialLocation: initialLocation,
        finalLocation: finalLocation,
        pricing: pricing,
        carModel: carModel,
        numberOfSeats: numberOfSeats,
        departureDate: departureDate,
        description: description);
    QueryResult result =
        await client.mutate(MutationOptions(documentNode: gql(query)));
    if (!result.hasException) {
      Navigator.pop(context, true);
    } else {
      print(result.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text("New post for clients"),
        ),
        body: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            height: double.infinity,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SigningTF("Initial location",
                        (value) => setState(() => initialLocation = value)),
                    SizedBox(height: 10.0),
                    SigningTF("Final location",
                        (value) => setState(() => finalLocation = value)),
                    SizedBox(height: 10.0),
                    SigningTF("Car Model",
                        (value) => setState(() => carModel = value)),
                    SizedBox(height: 10.0),
                    SigningTF(
                      "Pricing",
                      (value) => setState(() => pricing = value),
                      keyboardType: true,
                    ),
                    SizedBox(height: 10.0),
                    SigningTF(
                      "Number of seats",
                      (value) => setState(() => numberOfSeats = value),
                      keyboardType: true,
                    ),
                    SizedBox(height: 10.0),
                    SigningTF("Departure Date",
                        (value) => setState(() => departureDate = value)),
                    SizedBox(height: 15.0),
                    SigningTF("Description",
                        (value) => setState(() => description = value)),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.only(top: 25.0, bottom: 0.0),
                      width: double.infinity,
                      child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () => createClientFeed(),
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: appPrimaryColor,
                          child: Text("Create",
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ))));
  }
}
