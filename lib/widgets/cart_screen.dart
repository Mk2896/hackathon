import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/screens/payment_successfull.dart';
import 'package:hackatron/screens/register.dart';
import 'package:hackatron/widgets/cart_items.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/logout.dart';
import 'package:hackatron/widgets/profile_icon.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Cart",
                textColor: Color(primaryFontColor),
                fontSize: 36,
                fontWeight: FontWeight.w400,
                fontFamily: "AbrilFatFace",
              ),
              ProfileIcon(
                radius: 20,
                onClick: () => logout(context),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: const Color(bgColor),
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CartItems();
                }),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: const Color(bgColor),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CustomText(
                        text: "Total:",
                        textColor: Color(secondaryFontColor),
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: "\$ 25.99",
                        textColor: Color(primaryColor),
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  rightPadding: 15,
                  buttonText: "Pay Now",
                  buttonMethod: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        loaderOverlay(child: const PaymentSuccessfull()),
                  )),
                  buttonType: ButtonType.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            )),
      ],
    );
  }
}
