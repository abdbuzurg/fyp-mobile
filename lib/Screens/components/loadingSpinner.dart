import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: CircularProgressIndicator(
      strokeWidth: 5,
    )));
  }
}
