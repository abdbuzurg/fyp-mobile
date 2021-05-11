import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/models/UserShape.dart';
import 'package:fypMobile/utils/prefs.dart';

import '../constants.dart';
import 'components/customSnackBar.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final UserShape user;

  EditProfile(this.user);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<ScaffoldState> _editProfileScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();

  @override
  void initState() {
    _username.text = widget.user.username;
    _name.text = widget.user.name;
    _email.text = widget.user.email;
    _mobileNumber.text = widget.user.mobileNumber;
  }

  Future<void> editProfile() async {
    if (_editProfileFormKey.currentState.validate()) {
      String token = await getToken();
      List<String> splitName = _name.text.split(" ");
      String firstName = splitName[0];
      String lastName = splitName[1];
      Map data = {
        "username": _username.text,
        "email": _email.text,
        "mobileNumber": _mobileNumber.text,
        "firstName": firstName,
        "lastName": lastName
      };
      String body = json.encode(data);
      var url = Uri.parse(backendApiUrl + 'user/');
      _editProfileScaffoldKey.currentState.showSnackBar(customSnackBar(
          "Changing profile info...",
          progress: true,
          duration: 20));
      final response = await http.put(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          },
          body: body);

      _editProfileScaffoldKey.currentState.removeCurrentSnackBar();
      if (response.statusCode == 200) {
        Map responseData = json.decode(response.body);
        if (responseData["success"]) {
          _editProfileScaffoldKey.currentState.showSnackBar(
              customSnackBar("Your profile is updated", icon: Icons.mood));
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pop(context, true);
        } else {
          _editProfileScaffoldKey.currentState.showSnackBar(customSnackBar(
              responseData["message"],
              icon: Icons.sentiment_satisfied));
        }
      } else {
        if (response.statusCode == 500) {
          _editProfileScaffoldKey.currentState.showSnackBar(
              customSnackBar("Internal server error", icon: Icons.dns));
        }
        _editProfileScaffoldKey.currentState.showSnackBar(customSnackBar(
            "No internet connection",
            icon: Icons.signal_cellular_connected_no_internet_4_bar));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _editProfileScaffoldKey,
        appBar: AppBar(title: Text("Edit Profile")),
        body: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _editProfileFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _username,
                        validator: (value) {
                          if (value.length < 4 || value.length > 10) {
                            return "Length should be greater than 4 and less 10";
                          }

                          return null;
                        },
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                      TextFormField(
                        controller: _email,
                        validator: (value) {
                          if (!value.contains("@")) {
                            return "Email is not valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      TextFormField(
                        controller: _name,
                        validator: (value) {
                          if (value.split(" ").length != 2) {
                            return "Enter only firstname and lastname";
                          }

                          return null;
                        },
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                      TextFormField(
                        controller: _mobileNumber,
                        validator: (value) {
                          if ((value.length > 13 && value.length < 9) ||
                              (value.length > 9 &&
                                  value.length <= 12 &&
                                  value.contains("+"))) {
                            return "Invalid mobile number";
                          }

                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Mobile Number"),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25.0, bottom: 0.0),
                        width: double.infinity,
                        child: RaisedButton(
                            elevation: 5.0,
                            onPressed: editProfile,
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: appPrimaryColor,
                            child: Text("Confirm",
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ))));
  }
}
