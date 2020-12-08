import 'package:flutter/material.dart';
import 'package:fypMobile/Screens/driverFeed_screen.dart';
import 'package:fypMobile/Screens/profile_screen.dart';

import 'clientFeed_screen.dart';

class BottomNav extends StatefulWidget {
  _BottomNav createState() => _BottomNav();
}

class _BottomNav extends State<BottomNav> {
  int _selectedIndex = 2;

  static List<Widget> _bottomNavView = [
    ClientFeed(),
    DriverFeed(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _bottomNavView),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (value) => setState(() => _selectedIndex = value),
        items: _navBarItem
            .map((item) => BottomNavigationBarItem(
                icon: Icon(
                  item.icon,
                  size: 28.0,
                ),
                activeIcon: Icon(item.activeIcon, size: 36.0),
                label: item.title))
            .toList(),
      ),
    );
  }
}

List<NavBarModel> _navBarItem = [
  NavBarModel(
      icon: Icons.commute,
      activeIcon: Icons.commute_outlined,
      title: "Client Feed"),
  NavBarModel(
      icon: Icons.supervised_user_circle,
      activeIcon: Icons.supervised_user_circle_outlined,
      title: "Driver Feed"),
  NavBarModel(
      icon: Icons.face, activeIcon: Icons.face_outlined, title: "Profile"),
];

class NavBarModel {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  NavBarModel({this.icon, this.activeIcon, this.title});
}
