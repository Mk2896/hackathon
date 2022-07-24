import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/logout.dart';
import 'package:hackatron/widgets/product.dart';
import 'package:hackatron/widgets/profile_icon.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late CollectionReference productsRef;
  late CollectionReference userRef;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    productsRef = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Products>(
          fromFirestore: (snapshot, _) => Products.fromJson(snapshot.data()!),
          toFirestore: (products, _) => products.toJson(),
        );
    userRef =
        FirebaseFirestore.instance.collection('users').withConverter<Users>(
              fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
              toFirestore: (users, _) => users.toJson(),
            );
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Wishlist",
                    textColor: Color(primaryFontColor),
                    fontSize: 30,
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
          ],
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: const Color(bgColor),
            child: FutureBuilder(
              future: userRef.doc(currentUserId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.data() != null) {
                    Users userData = snapshot.data!.data() as Users;
                    if (userData.wishlist!.isNotEmpty) {
                      return GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                        ),
                        children: userData.wishlist!.map((item) {
                          return FutureBuilder(
                              future: productsRef.doc(item).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> product) {
                                if (product.connectionState ==
                                    ConnectionState.done) {
                                  if (product.hasData &&
                                      product.data!.data() != null) {
                                    Products productData =
                                        product.data!.data() as Products;
                                    return Product(productData, item, () {
                                      setState(() {});
                                    });
                                  } else {
                                    return const Center();
                                  }
                                } else {
                                  return const Center(
                                    child: CustomText(
                                      text: "",
                                      textColor: Color(primaryFontColor),
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "AbrilFatFace",
                                    ),
                                  );
                                }
                              });
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: CustomText(
                          text: "No Item Found..",
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
                        text: "No Item Found..",
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
            ),
          ),
        )
      ],
    );
  }
}
