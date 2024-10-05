import 'package:flutter/material.dart';

class customButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double borderRadius;
  final double padding;
  final FontWeight txtFontWeight;
  final Color? txtColor;
  final double txtFontSize;

  const customButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderRadius = 0,
    this.padding = 16,
    this.txtFontWeight = FontWeight.w300,
    this.txtColor,
    this.txtFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      padding: EdgeInsets.all(
        padding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: txtColor,
          fontSize: txtFontSize,
          fontWeight: txtFontWeight,
        ),
      ),
    );
  }
}
