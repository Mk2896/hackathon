import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
    this.overflow,
    this.letterSpacing,
    this.isItalic = false,
    this.textDecoration,
    this.textAlignment,
    this.fontFamily
  }) : super(key: key);

  final String text;
  final TextOverflow? overflow;
  final Color textColor;
  final double? letterSpacing;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isItalic;
  final TextDecoration? textDecoration;
  final TextAlign? textAlignment;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlignment,
        style: textStyle(
          textColor: textColor,
          isItalic: isItalic,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
          overflow: overflow,
          textDecoration: textDecoration,
        ));
  }
}

TextStyle textStyle({
  required Color textColor,
  bool isItalic = false,
  required double fontSize,
  required FontWeight fontWeight,
  double? letterSpacing,
  TextOverflow? overflow,
  TextDecoration? textDecoration,
  String? fontFamily,
}) {
  FontStyle fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;

  return TextStyle(
    color: textColor,
    fontFamily: fontFamily ?? "Railway",
    fontSize: fontSize,
    fontWeight: fontWeight,
    overflow: overflow ?? TextOverflow.clip,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: textDecoration,
  );
}
