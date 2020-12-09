import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String description;
  final IconData icon;
  final bool progress;
  final int duration;

  CustomSnackBar(this.description,
      {this.icon, this.progress = false, this.duration = 10});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
        duration: Duration(seconds: this.duration),
        content: Row(
          children: [
            this.progress ? CircularProgressIndicator() : Icon(this.icon),
            SizedBox(width: 10.0),
            Text(this.description)
          ],
        ));
  }
}
