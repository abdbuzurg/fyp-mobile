import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25.0, bottom: 0.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () => logout(),
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: appPrimaryColor,
          child: Text("LOGOUT",
              style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))),
    );
  }
}
