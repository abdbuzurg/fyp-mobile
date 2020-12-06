import 'package:flutter/material.dart';

class SigningTF extends StatefulWidget {
  final String name;
  final bool obscure;
  final bool keyboardType;
  final Function callback;

  const SigningTF(
    this.name,
    this.callback, {
    this.obscure = false,
    this.keyboardType = false,
  });

  _SigningTF createState() => _SigningTF();
}

class _SigningTF extends State<SigningTF> {
  @override
  Widget build(BuildContext build) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextField(
              onChanged: (value) {
                widget.callback(value);
              },
              keyboardType: widget.keyboardType
                  ? TextInputType.number
                  : TextInputType.text,
              obscureText: widget.obscure,
              decoration: InputDecoration(
                  hintText: widget.name,
                  hintStyle:
                      TextStyle(color: Color.fromRGBO(192, 192, 192, 1.0))),
            ))
      ],
    );
  }
}
