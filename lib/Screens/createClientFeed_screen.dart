import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/components/signingTF.dart';
import 'package:fypMobile/utils/prefs.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'components/customSnackBar.dart';

import 'package:http/http.dart' as http;

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
  DateTime departureDate;
  String description;
  String initialPrice;
  String _currency = "Select Currency";
  final globalKey = GlobalKey<ScaffoldState>();

  Future<void> createClientFeed() async {
    if (initialLocation == null ||
        finalLocation == null ||
        pricing == null ||
        carModel == null ||
        numberOfSeats == null ||
        departureDate == null) return;
    String _departureDate = departureDate.millisecondsSinceEpoch.toString();
    String token = await getToken();
    var url = Uri.parse(backendApiUrl + 'client/');
    Map data = {
      "destinationFrom": initialLocation,
      "destinationTo": finalLocation,
      "pricing": pricing,
      "carModel": carModel,
      "numberOfSeats": numberOfSeats,
      "departureDate": _departureDate
    };
    String body = json.encode(data);
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: body);
    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData["success"]) {
        Navigator.pop(context, true);
      } else {
        print("fail");
      }
    } else {}
  }

  void _pickDate() async {
    // picking the date
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: departureDate == null ? DateTime.now() : departureDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (pickedDate == null) return;
    //picking the time
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: departureDate == null
            ? TimeOfDay.fromDateTime(pickedDate)
            : TimeOfDay.fromDateTime(departureDate));
    if (pickedTime == null) return;
    //saving the time and date into the state
    setState(() {
      departureDate = DateTime(pickedDate.year, pickedDate.month,
          pickedDate.day, pickedTime.hour, pickedTime.minute);
    });
  }

  Future<void> currencySelection(String currency) {
    switch (currency) {
      case "RUB":
        setState(() {
          pricing = (double.parse(initialPrice) * 0.15).round().toString();
        });
        break;

      case "USD":
        setState(() {
          pricing = (double.parse(initialPrice) * 11.40).round().toString();
        });
        break;
      case "EUR":
        setState(() {
          pricing = (double.parse(initialPrice) * 13.76).round().toString();
        });
        break;
      default:
        setState(() {
          pricing = initialPrice;
        });
    }
    setState(() {
      _currency = currency;
    });
    print(pricing);
    Navigator.of(context).pop();
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Pricing",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                            alignment: Alignment.centerLeft,
                            height: 60.0,
                            child: Row(children: [
                              Flexible(
                                  child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    pricing = value;
                                    initialPrice = value;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                decoration: InputDecoration(
                                    hintText: "Pricing",
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(
                                            192, 192, 192, 1.0))),
                              )),
                              RaisedButton(
                                  elevation: 5.0,
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Select currency:",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                TextButton(
                                                    onPressed: () =>
                                                        currencySelection(
                                                            "TJK"),
                                                    child: Text("TJK")),
                                                TextButton(
                                                    onPressed: () =>
                                                        currencySelection(
                                                            "RUB"),
                                                    child: Text("RUB")),
                                                TextButton(
                                                    onPressed: () =>
                                                        currencySelection(
                                                            "USD"),
                                                    child: Text("USD")),
                                                TextButton(
                                                    onPressed: () =>
                                                        currencySelection(
                                                            "EUR"),
                                                    child: Text("EUR")),
                                              ],
                                            ),
                                          ],
                                        ));
                                      }),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  color: appPrimaryColor,
                                  child: Text(_currency,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)))
                            ]))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    SigningTF(
                      "Number of seats",
                      (value) => setState(() => numberOfSeats = value),
                      keyboardType: true,
                    ),
                    SizedBox(height: 10.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Departure Date",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  departureDate == null
                                      ? "No date Selected"
                                      : DateFormat("d MMMM HH:mm a")
                                          .format(departureDate),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                color: appPrimaryColor,
                                child: Text("Select Date"),
                                onPressed: _pickDate,
                              )
                            ],
                          )
                        ]),
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
