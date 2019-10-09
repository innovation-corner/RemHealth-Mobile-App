import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final focusColor;
  final borderColor;
  final TextEditingController controller;
  final TextInputType type;
  final Function onChanged;
  final bool obscureText;
  final cursorColor;

  const InputText(
      {Key key,
      this.label,
      this.focusColor,
      this.borderColor,
      this.controller,
      this.type,
      this.onChanged,
      this.obscureText,
      this.cursorColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Lato",
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: (string) => onChanged(string),
          keyboardType: type,
          cursorColor: cursorColor,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 11),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: focusColor),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ],
    );
  }
}
