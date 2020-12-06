import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/signin_screen.dart';
import 'package:fypMobile/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/bottomNav_screen.dart';

bool isLogged;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  isLogged = prefs.getString("token") == null ? false : true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FYP-MOBILE',
      theme: ThemeData(
        primaryColor: appPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: isLogged ? "/welcome" : "/login",
      routes: {
        "/login": (context) => SignInScreen(),
        "/welcome": (context) => BottomNav(),
      },
    );
  }
}
