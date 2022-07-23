import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/screens/product_detail.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/profile_icon.dart';
import 'package:hackatron/widgets/tag.dart';
import 'package:hackatron/widgets/extensions.dart';

class Post extends StatelessWidget {
  const Post(this.product, this.productId, {Key? key}) : super(key: key);

  final Products product;
  final String productId;

  void openProduct(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          loaderOverlay(child: ProdutcDetail(product: product, productId: productId)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .withConverter<Users>(
            fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          )
          .doc(product.userId)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Users user = snapshot.data!.data() as Users;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Card(
              color: const Color(secondaryColor),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              ProfileIcon(
                                radius: 20,
                                image: NetworkImage(user.photoURL),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: user.name,
                                      textColor: const Color(primaryFontColor),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomText(
                                      text: user.profession ?? "-",
                                      textColor:
                                          const Color(secondaryFontColor),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              CustomText(
                                text: product.wishlistCount.toHumanReadable(),
                                textColor: const Color(secondaryFontColor),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => openProduct(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: CustomText(
                          text: product.description,
                          textColor: const Color(primaryFontColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textAlignment: TextAlign.justify,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => openProduct(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: NetworkImage(product.images[0]),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image(
                                      image: NetworkImage(product.images[1]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Image(
                                      image: NetworkImage(product.images[2]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image(
                                      image: NetworkImage(product.images[3]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Image(
                                      image: NetworkImage(product.images[4]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: product.tags.map((tag) {
                                return tagWidget(tag, context);
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                CupertinoIcons.arrowshape_turn_up_right_fill,
                                color: Color(secondaryFontColor),
                              ),
                              CustomText(
                                text: product.shareCount.toHumanReadable(),
                                textColor: const Color(secondaryFontColor),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Loading(
          loadingText: "",
        );
      },
    );
  }
}
