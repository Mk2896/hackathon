import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/screens/search.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/extensions.dart';
import 'package:hackatron/widgets/loader_overlay.dart';

Widget tagWidget(String text, BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => loaderOverlay(child: Search(searchKeyword: text)),
    )),
    child: Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: CustomText(
              text: "#${text.toCapitalized()}",
              textColor: const Color(secondaryColor),
              fontSize: 11,
              fontWeight: FontWeight.w400),
        )
      ],
    ),
  );
}
