import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/screens/my_home_page.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';

class PaymentSuccessfull extends StatelessWidget {
  const PaymentSuccessfull({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(secondaryColor),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/images/payment_done.png")),
              const CustomText(
                text: "Payment Successful",
                textColor: Color(primaryFontColor),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: "AbrilFatFace",
              ),
              const CustomText(
                text:
                    "Your order will be ready in 5 days, including shipping, more details and options for tracking will be sent to your email\n\n Thanks!!!",
                textColor: Color(primaryFontColor),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                textAlignment: TextAlign.center,
              ),
              CustomButton(
                  topMargin: 15,
                  width: MediaQuery.of(context).size.width * 0.7,
                  buttonText: "Continue Shopping",
                  buttonMethod: () {
                    Navigator.canPop(context)
                        ? Navigator.of(context).pop()
                        : null;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => loaderOverlay(child:  MyHomePage()),
                    ));
                  },
                  buttonType: ButtonType.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)
            ],
          ),
        ),
      ),
    );
  }
}
