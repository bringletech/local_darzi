import 'package:flutter/material.dart';

class AllText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  const AllText({super.key, required this.text, required this.fontFamily,required this.fontSize, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "",
        fontSize: fontSize,
        //color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
