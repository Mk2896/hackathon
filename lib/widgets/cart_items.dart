import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/cart.dart';
import 'package:hackatron/widgets/custom_text.dart';

class CartItems extends StatelessWidget {
  const CartItems({Key? key, required this.item, required this.removeFromCart})
      : super(key: key);

  final Cart item;
  final void Function(String) removeFromCart;
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
              Image(image: NetworkImage(item.photoURL)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.name,
                    textColor: const Color(primaryFontColor),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: item.userName,
                    textColor: const Color(secondaryFontColor),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              CustomText(
                text: "\$ ${item.price}",
                textColor: const Color(primaryColor),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 25,
        child: IconButton(
          onPressed: () => removeFromCart(item.productId),
          icon: const Icon(
            Icons.close,
            size: 20,
            color: Color(secondaryFontColor),
          ),
        ),
      ),
    ]);
  }
}
