import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final Function onTap;
  final Color color;
  final Color shadow;

  const ButtonWidget({Key key, this.text, this.onTap, this.color, this.shadow})
      : super(key: key);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 35),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: widget.shadow,
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          )
        ], borderRadius: BorderRadius.circular(6), color: widget.color),
        child: Center(
            child: Text(widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.07,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.w600,
                ))),
      ),
    );
  }
}
