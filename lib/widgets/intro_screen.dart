import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/screens/register.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  final List<String> textString = [
    "Jennifer Kingsley exploring the new range of winter fashion wear",
    "Jimmy Chuka exploring new spring sweater collection",
    "Christain Lobi showing us his new summer beach wears",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CustomText(
              text: "No",
              textColor: Color(secondaryColor),
              fontSize: 17.55,
              fontWeight: FontWeight.w800,
              textDecoration: TextDecoration.underline,
            ),
            CustomText(
              text: (index + 1).toString(),
              textColor: const Color(secondaryColor),
              fontSize: 51.84,
              fontWeight: FontWeight.w400,
              fontFamily: "AbrilFatFace",
            ),
          ],
        ),
        const CustomText(
          text: "Featured",
          textColor: Color(primaryColor),
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        const CustomText(
          text: "Tailored",
          textColor: Color(secondaryColor),
          fontSize: 51.84,
          fontWeight: FontWeight.w400,
          fontFamily: "AbrilFatFace",
        ),
        CustomText(
          text: textString[index],
          textColor: const Color(secondaryColor),
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        CustomButton(
          buttonText: "Shop Now",
          buttonMethod: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => loaderOverlay(
                child: Register(),
              ),
            ),
          ),
          buttonType: ButtonType.secondary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          topMargin: 15,
        )
      ],
    );
  }
}
