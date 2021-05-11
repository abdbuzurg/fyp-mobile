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
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();

  Future<void> signUp() async {
    //triming all the inputs
    _username.text = _username.text.trim();
    _email.text = _email.text.trim();
    _password.text = _password.text.trim();
    _name.text = _name.text.trim();
    _mobileNumber.text = _mobileNumber.text.trim();
    //checking if the input are empty
    if (_username.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _name.text.isEmpty ||
        _mobileNumber.text.isEmpty) {
      globalKey.currentState.showSnackBar(
          customSnackBar("Please fill all the fields", icon: Icons.error));
      return;
    }
    //validating username
    if (_username.text.length < 4 && _username.text.length > 10) {
      globalKey.currentState.showSnackBar(customSnackBar(
          "Username length is between 4 and 10",
          icon: Icons.error));
      return;
    }
    //validating email
    if (!_email.text.contains("@")) {
      globalKey.currentState.showSnackBar(
          customSnackBar("Please put a correct email", icon: Icons.error));
      return;
    }

    List<String> splitName = _name.text.split(" ");
    //validationg the Name input
    if (splitName.length != 2) {
      globalKey.currentState.showSnackBar(customSnackBar(
          "Write your first name and last name",
          icon: Icons.error));
      return;
    }
    final firstName = splitName[0];
    final lastName = splitName[1];
    //validating the mobile number
    if (_mobileNumber.text.length == 9) {
      _mobileNumber.text = "+992" + _mobileNumber.text;
    } else if (_mobileNumber.text.length == 12) {
      _mobileNumber.text = "+" + _mobileNumber.text;
    } else if (_mobileNumber.text.length != 13) {
      globalKey.currentState.showSnackBar(customSnackBar(
          "Please write correct phone number",
          icon: Icons.error));
      return;
    }
    //Forming the data
    Map data = {
      "username": _username.text,
      "password": _password.text,
      "email": _email.text,
      "firstName": firstName,
      "lastName": lastName,
      "mobileNumber": _mobileNumber.text
    };
    String body = json.encode(data);
    var url = Uri.parse(backendApiUrl + 'user/');

    //Adding the loading
    globalKey.currentState.showSnackBar(
        customSnackBar("Signing up...", progress: true, duration: 20));
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    globalKey.currentState.removeCurrentSnackBar();

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData["success"]) {
        globalKey.currentState.showSnackBar(
            customSnackBar("You are registered", icon: Icons.mood));
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pop(context);
      } else {
        globalKey.currentState.showSnackBar(customSnackBar(
            responseData["message"],
            icon: Icons.sentiment_satisfied));
      }
    } else {
      if (response.statusCode == 500) {
        globalKey.currentState.showSnackBar(
            customSnackBar("Internal server error", icon: Icons.dns));
      }
      globalKey.currentState.showSnackBar(customSnackBar(
          "No internet connection",
          icon: Icons.signal_cellular_connected_no_internet_4_bar));
    }
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

  @override
  Widget build(BuildContext build) {
    GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();

    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: Form(
          key: _signUpKey,
          child: Container(
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
                    SigningTF("Username", _username),
                    SizedBox(height: 15.0),
                    SigningTF("Email", _email),
                    SizedBox(height: 15.0),
                    SigningTF(
                      "Password",
                      _password,
                      obscure: true,
                    ),
                    SizedBox(height: 15.0),
                    SigningTF("Name", _name),
                    SizedBox(height: 15.0),
                    SigningTF(
                      "Mobile Number",
                      _mobileNumber,
                      keyboardType: true,
                    ),
                    _buildButton("SIGN UP", signUp)
                  ],
                ),
              ))),
    );
  }
}
