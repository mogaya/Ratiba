import 'package:flutter/material.dart';

// ignore: camel_case_types
class customText extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration txtDecoration;
  final Color txtDecColor;
  final String? fontFamily;

  const customText({
    super.key,
    required this.label,
    this.labelColor = Colors.black,
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.txtDecoration = TextDecoration.none,
    this.txtDecColor = Colors.black,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        color: labelColor,
        decoration: txtDecoration,
        decorationColor: txtDecColor,
      ),
    );
  }
}
