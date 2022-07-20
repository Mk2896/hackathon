import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/custom_text.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    Key? key,
    required this.text,
    this.bottomPadding = 0,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.topPadding = 0,
  }) : super(key: key);

  final String text;
  final double topPadding;
  final double bottomPadding;
  final double leftPadding;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            child: Divider(
              thickness: 2,
              endIndent: 10,
              indent: 10,
            ),
          ),
          CustomText(
            text: text,
            textColor: const Color(secondaryFontColor),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const Expanded(
            child: Divider(
              thickness: 2,
              endIndent: 10,
              indent: 10,
            ),
          ),
        ],
      ),
    );
  }
}
