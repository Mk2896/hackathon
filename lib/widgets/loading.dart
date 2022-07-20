import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/custom_text.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.loadingText}) : super(key: key);

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: const Color(secondaryColor),
            borderRadius: BorderRadius.circular(10.0)),
        width: 300.0,
        height: 200.0,
        alignment: AlignmentDirectional.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  color: Color(primaryColor),
                  value: null,
                  strokeWidth: 5.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Center(
                child: CustomText(
                  text: loadingText,
                  textColor: const Color(primaryFontColor),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: "AbrilFatFace",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
