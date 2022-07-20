import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/custom_text.dart';

class CartItems extends StatelessWidget {
  const CartItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        height: 150,
        child: Card(
          color: const Color(secondaryColor),
          elevation: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Image(image: AssetImage("assets/images/product-1.png")),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CustomText(
                    text: "Hawaian Shirt",
                    textColor: Color(primaryFontColor),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: "Sandy Williams",
                    textColor: Color(secondaryFontColor),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const CustomText(
                text: "\$ 25.99",
                textColor: Color(primaryColor),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
      const Positioned(
        top: 10,
        right: 25,
        child: Icon(
          Icons.close,
          size: 20,
          color: Color(secondaryFontColor),
        ),
      ),
    ]);
  }
}
