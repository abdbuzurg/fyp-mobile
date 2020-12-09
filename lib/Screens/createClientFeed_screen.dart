import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';
import 'package:fypMobile/graphql/clientFeed.dart';
import '../graphQLConfig.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'components/customSnackBar.dart';

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
  final globalKey = GlobalKey<ScaffoldState>();

  Future<void> createClientFeed() async {
    final loading = CustomSnackBar("Loading", duration: 60, progress: true);
    globalKey.currentState.showSnackBar(loading.build(context));
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
      globalKey.currentState.removeCurrentSnackBar();
      final successfullSnackBar = CustomSnackBar(
        "Successfuly created new post",
        duration: 10,
        icon: Icons.done,
      );
      globalKey.currentState
          .showSnackBar(successfullSnackBar.build(context) as SnackBar);
      Navigator.pop(context, true);
      await Future.delayed(const Duration(milliseconds: 1500));
    } else {
      globalKey.currentState.removeCurrentSnackBar();
      if (result.exception.clientException != null) {
        final connectionSnackBar = CustomSnackBar(
          "Connection error. Check your internet.",
          duration: 10,
          icon: Icons.wifi_off,
        );
        globalKey.currentState
            .showSnackBar(connectionSnackBar.build(context) as SnackBar);
      } else {
        final graphqlSnackBar = CustomSnackBar("Please fill all the fields",
            duration: 10, icon: Icons.warning);
        globalKey.currentState
            .showSnackBar(graphqlSnackBar.build(context) as SnackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
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
