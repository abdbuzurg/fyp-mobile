import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/signin_screen.dart';
import 'package:fypMobile/models/UserShape.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => SignInScreen()));
  }

  Future<UserShape> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var url = Uri.parse(backendApiUrl + 'user/myself');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData["success"]) {
        return UserShape.from(responseData["data"]);
      }
    }
  }

  Widget content(UserShape user) {
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [appPrimaryColor, Colors.deepOrangeAccent])),
            child: Container(
              width: double.infinity,
              height: 250.0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 50.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(user.username,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            )),
        Container(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      "Email:",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 22.0),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 22.0),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      "Mobile Number:",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 22.0),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      user.mobileNumber,
                      style: TextStyle(fontSize: 22.0),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: 300.00,
          child: RaisedButton(
              elevation: 5.0,
              onPressed: () => logout(),
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: appPrimaryColor,
              child: Text("LOGOUT",
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appPrimaryColor,
            title: Center(child: Text("Profile"))),
        body: SingleChildScrollView(
            child: FutureBuilder(
          future: getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final UserShape user = snapshot.data;
              return content(user);
            }

            return CircularProgressIndicator();
          },
        )));
  }
}
