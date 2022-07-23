import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/cart.dart';
import 'package:hackatron/screens/payment_successfull.dart';
import 'package:hackatron/widgets/cart_items.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/logout.dart';
import 'package:hackatron/widgets/profile_icon.dart';
import 'package:hackatron/widgets/extensions.dart';
import 'package:hackatron/widgets/snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CollectionReference? cartRef;

  late User currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = FirebaseAuth.instance.currentUser!;
    cartRef = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("cart")
        .withConverter<Cart>(
          fromFirestore: (snapshot, _) => Cart.fromJson(snapshot.data()!),
          toFirestore: (cart, _) => cart.toJson(),
        );
  }

  payNow() async {
    !context.loaderOverlay.visible
        ? context.loaderOverlay
            .show(widget: const Loading(loadingText: "Processing Payment.."))
        : null;
    var snapshot = await cartRef!.get();
    var batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => loaderOverlay(child: const PaymentSuccessfull()),
    ));
  }

  payNowDummy() {
    snackBar("Please Add Item To Cart First..", Colors.orange, context);
  }

  void removeFromCart(String id) async {
    !context.loaderOverlay.visible
        ? context.loaderOverlay.show(
            widget: const Loading(loadingText: "Removing Item From Cart.."))
        : null;

    await cartRef!.doc(id).delete();

    setState(() {});

    context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
  }

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
              child: FutureBuilder(
                future: cartRef!.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      var data = snapshot.data!.docs;
                      return ListView(
                        children: data.reversed
                            .map((item) => CartItems(
                                  item: item.data() as Cart,
                                  removeFromCart: removeFromCart,
                                ))
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child: CustomText(
                          text: "No Item In Cart",
                          textColor: Color(primaryFontColor),
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          fontFamily: "AbrilFatFace",
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CustomText(
                        text: "Loading Data..",
                        textColor: Color(primaryFontColor),
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        fontFamily: "AbrilFatFace",
                      ),
                    );
                  }
                },
              )),
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
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: CustomText(
                          text: "Total:",
                          textColor: Color(secondaryFontColor),
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: cartRef!.get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data!.docs.isNotEmpty) {
                                var data = snapshot.data!.docs;
                                double price = 0;
                                for (var element in data) {
                                  Cart elm = element.data() as Cart;
                                  price += double.parse(elm.price);
                                }
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "\$ ${price.toPrecision(2)}",
                                      textColor: const Color(primaryColor),
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomButton(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      rightPadding: 15,
                                      buttonText: "Pay Now",
                                      buttonMethod: () => payNow(),
                                      buttonType: ButtonType.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      text: "\$ 0",
                                      textColor: Color(primaryColor),
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomButton(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      rightPadding: 15,
                                      buttonText: "Pay Now",
                                      buttonMethod: () => payNowDummy(),
                                      buttonType: ButtonType.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ],
                                );
                              }
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    text: "\$ 0",
                                    textColor: Color(primaryColor),
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    rightPadding: 15,
                                    buttonText: "Pay Now",
                                    buttonMethod: () => payNowDummy(),
                                    buttonType: ButtonType.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
