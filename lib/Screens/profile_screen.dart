import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/signin_screen.dart';
import 'package:fypMobile/models/UserShape.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

import 'package:http/http.dart' as http;

import 'editProfile_screen.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  Future<UserShape> _user;
  String _title;

  @override
  void initState() {
    refresh();
  }

  Future<void> refresh() async {
    _user = getUserInfo();
    _user.then((value) => setState(() {
          _title = value.username;
        }));
  }

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

  Future<void> edit() async {
    UserShape user = await _user;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditProfile(user)))
        .then((value) => refresh());
  }

  Widget content(UserShape user) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.5, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ]),
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 125,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            user.name.split(" ")[0],
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(user.name.split(" ")[1],
                              style: TextStyle(
                                fontSize: 25,
                              )),
                          Row(children: [
                            Icon(Icons.email),
                            SizedBox(width: 5),
                            Text(user.email,
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          ]),
                          Row(children: [
                            Icon(Icons.call),
                            SizedBox(width: 5),
                            Text(user.mobileNumber,
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          ]),
                          Container(
                            width: 150,
                            child: RaisedButton(
                                elevation: 5.0,
                                onPressed: edit,
                                padding: EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                color: appPrimaryColor,
                                child: Text("Edit",
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    )
                  ]),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                        child: Text(
                      "History",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              padding: EdgeInsets.all(5),
                              child: Column(children: [
                                Icon(Icons.directions_car),
                                Text("As a driver")
                              ]),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              padding: EdgeInsets.all(5),
                              child: Column(children: [
                                Icon(Icons.emoji_people),
                                Text("As a Client")
                              ]),
                            ))
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.5, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ]),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1.5, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            padding: EdgeInsets.all(5),
                            child: Column(
                                children: [Icon(Icons.help), Text("Help")]),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1.5, color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            padding: EdgeInsets.all(5),
                            child: Column(
                                children: [Icon(Icons.info), Text("About")]),
                          ))
                    ],
                  ),
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title != null
              ? Text(_title.toUpperCase(), style: titleTextStyle)
              : Text("Profile"),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => logout(),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: FutureBuilder(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final UserShape user = snapshot.data;
              return content(user);
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
