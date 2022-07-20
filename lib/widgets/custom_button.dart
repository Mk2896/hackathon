import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/custom_text.dart';

enum ButtonType { secondary, primary, other }

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.topMargin,
    this.bottomMargin,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.width,
    required this.buttonText,
    required this.buttonMethod,
    required this.buttonType,
    required this.fontSize,
    required this.fontWeight,
    this.fontFamily,
  })  : backgroundColor = buttonType == ButtonType.primary
            ? const Color(primaryColor)
            : (buttonType == ButtonType.other
                ? Colors.white
                : Colors.transparent),
        borderColor = buttonType == ButtonType.primary
            ? const Color(primaryColor)
            : (buttonType == ButtonType.other
                ? Colors.black
                : const Color(secondaryColor)),
        textColor = buttonType == ButtonType.primary
            ? const Color(secondaryColor)
            : (buttonType == ButtonType.other
                ? Colors.black
                : const Color(secondaryColor)),
        super(key: key);

  final double? topMargin;
  final double? bottomMargin;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? width;
  final void Function() buttonMethod;
  final String buttonText;
  final ButtonType buttonType;
  final double fontSize;
  final FontWeight fontWeight;
  final String? fontFamily;

  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin ?? 0,
        bottom: bottomMargin ?? 0,
      ),
      padding: EdgeInsets.only(
        left: leftPadding ?? 0,
        right: rightPadding ?? 0,
        top: topPadding ?? 0,
        bottom: bottomPadding ?? 0,
      ),
      width: width ?? MediaQuery.of(context).size.width,
      height: 60,
      child: ElevatedButton(
        onPressed: buttonMethod,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          side: BorderSide(color: borderColor),
        ),
        child: CustomText(
          text: buttonText,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
