import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';

import '../constants.dart';
import 'components/customSnackBar.dart';
import 'signin_screen.dart';

import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  String _username;
  String _email;
  String _password;
  String _name;
  String _mobileNumber;
  final globalKey = GlobalKey<ScaffoldState>();

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
      key: globalKey,
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
                  print("SIGN UP button pressed");
                  final splitName = _name.split(" ");
                  if (splitName.length != 2) {
                    return;
                  }
                  final firstName = splitName[0];
                  final lastName = splitName[1];
                  Map data = {
                    "username": _username,
                    "password": _password,
                    "email": _email,
                    "firstName": firstName,
                    "lastName": lastName,
                    "mobileNumber": _mobileNumber
                  };
                  String body = json.encode(data);
                  var url = Uri.parse(backendApiUrl + 'user/');
                  final response = await http.post(url,
                      headers: {"Content-Type": "application/json"},
                      body: body);
                  if (response.statusCode == 200) {
                    Map responseData = json.decode(response.body);
                    if (responseData["success"]) {
                      print("User has been created");
                      Navigator.pop(context);
                    } else {
                      print(responseData["message"]);
                    }
                  }
                })
              ],
            ),
          )),
    );
  }
}
