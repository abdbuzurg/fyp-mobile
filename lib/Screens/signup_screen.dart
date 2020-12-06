import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';
import 'package:fypMobile/graphql/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants.dart';
import '../graphQLConfig.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  String _username;
  String _email;
  String _password;
  String _name;
  String _mobileNumber;

  Widget _buildButton(String text, Function onPressed) {
    return Container(
      padding: EdgeInsets.only(top: 25.0, bottom: 0.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: onPressed,
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: appPrimaryColor,
          child: Text(text,
              style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Sign up",
                    style: TextStyle(
                        color: appPrimaryColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 15.0),
                SigningTF("Username", (value) {
                  setState(() {
                    _username = value;
                  });
                }),
                SizedBox(height: 15.0),
                SigningTF("Email", (value) {
                  setState(() {
                    _email = value;
                  });
                }),
                SizedBox(height: 15.0),
                SigningTF(
                  "Password",
                  (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  obscure: true,
                ),
                SizedBox(height: 15.0),
                SigningTF(
                  "Name",
                  (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(height: 15.0),
                SigningTF(
                  "Mobile Number",
                  (value) {
                    setState(() {
                      _mobileNumber = value;
                    });
                  },
                  keyboardType: true,
                ),
                _buildButton("SIGN UP", () async {
                  String registerMutation = Auth.register(
                      _name, _username, _email, _password, _mobileNumber);
                  GraphQLClient client = graphQLConfiguration.clientToQuery();
                  QueryResult result = await client.mutate(MutationOptions(
                    documentNode: gql(registerMutation),
                  ));
                  if (!result.hasException) {
                    Navigator.of(context).pop(MaterialPageRoute(
                        builder: (context) => SignInScreen()));
                  }
                })
              ],
            ),
          )),
    );
  }
}
