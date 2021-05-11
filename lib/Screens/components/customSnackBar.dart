import 'package:flutter/material.dart';

SnackBar customSnackBar(String description,
    {IconData icon, progress = false, duration = 5}) {
  return SnackBar(
      duration: Duration(seconds: duration),
      content: Row(
        children: [
          progress
              ? CircularProgressIndicator()
              : (icon == null ? SizedBox() : Icon(icon)),
          SizedBox(width: 10.0),
          Text(description)
        ],
      ));
}
