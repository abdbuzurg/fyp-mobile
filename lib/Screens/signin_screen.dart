import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/customSnackBar.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';
import 'package:fypMobile/Screens/signup_screen.dart';
import 'package:fypMobile/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomNav_screen.dart';

import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreen createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  bool _rememberMe = false;
  String _user;
  String _password;
  final globalKey = GlobalKey<ScaffoldState>();

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
        key: globalKey,
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
                      print("Logging in");
                      var url = Uri.parse(backendApiUrl + 'user/login');
                      Map data = {'username': _user, 'password': _password};
                      String body = json.encode(data);
                      final response = await http.post(url,
                          headers: {"Content-Type": "application/json"},
                          body: body);
                      if (response.statusCode == 200) {
                        Map responseData = json.decode(response.body);
                        if (responseData["success"]) {
                          print("You are logged in");
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          print(responseData["token"]);
                          await prefs.setString("token", responseData["token"]);
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BottomNav()));
                        } else {
                          print(responseData["message"]);
                        }
                      }
                    }),
                    SizedBox(height: 5),
                    _buildButton("REGISTER", () => _navigateToSignUp(context))
                  ],
                ))));
  }
}
