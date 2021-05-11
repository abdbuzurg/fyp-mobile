import 'package:flutter/material.dart';

class SigningTF extends StatefulWidget {
  final String name;
  final bool obscure;
  final bool keyboardType;
  final TextEditingController textEditingController;
  final Function validator;
  final GlobalKey key;

  const SigningTF(
    this.name,
    this.textEditingController, {
    this.key,
    this.obscure = false,
    this.keyboardType = false,
    this.validator,
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
            child: TextFormField(
              key: widget.key,
              validator: widget.validator == null
                  ? widget.validator
                  : (value) => value.isNotEmpty ? null : "Invalid Field",
              controller: widget.textEditingController,
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
