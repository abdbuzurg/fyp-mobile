import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';
import 'package:fypMobile/Screens/signup_screen.dart';
import 'package:fypMobile/constants.dart';
import 'package:fypMobile/graphql/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../graphQLConfig.dart';
import 'bottomNav_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreen createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  bool _rememberMe = false;
  String _user;
  String _password;

  final String dummyUser = "vortex";
  final String dummyPassword = "qwerty";

  Widget _buildForgotPasswordFlag() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () => print("Forgot button is working"),
          padding: EdgeInsets.only(right: 0.0),
          child: Text("Forgot Password?")),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.black),
              child: Checkbox(
                value: _rememberMe,
                checkColor: Colors.black,
                activeColor: appPrimaryColor,
                onChanged: (value) {
                  setState(() => {_rememberMe = value});
                },
              ),
            ),
            Text("Remember me", style: TextStyle(fontSize: 14.0))
          ],
        ));
  }

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

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: double.infinity,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(horizontal: 35.0, vertical: 120.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sign in",
                        style: TextStyle(
                            color: appPrimaryColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 15.0),
                    SigningTF(
                      "Username or Email",
                      (value) {
                        setState(() {
                          _user = value;
                        });
                      },
                    ),
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
                    _buildForgotPasswordFlag(),
                    _buildRememberMeCheckbox(),
                    _buildButton("LOGIN", () async {
                      String loginMutation = Auth.login(_user, _password);
                      GraphQLClient client =
                          GraphQLConfiguration().clientToQuery();
                      QueryResult result = await client.mutate(MutationOptions(
                        documentNode: gql(loginMutation),
                      ));
                      if (!result.hasException) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                            "token", result.data["login"]["token"]);
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BottomNav()));
                      } else {
                        print(result.exception);
                      }
                    }),
                    SizedBox(height: 5),
                    _buildButton("REGISTER", () => _navigateToSignUp(context))
                  ],
                ))));
  }
}
