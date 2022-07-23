import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/screens/product_detail.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/favorite_btn.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/profile_icon.dart';

class Product extends StatefulWidget {
  const Product(
    this.product,
    this.productId,
    this.wishlistHook, {
    Key? key,
  }) : super(key: key);

  final Products product;
  final String productId;
  final void Function() wishlistHook;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late CollectionReference userRef;
  late String currentUserId;
  late int wishlistCount;
  bool isMyWishlistProduct = false;

  @override
  void initState() {
    super.initState();
    userRef =
        FirebaseFirestore.instance.collection("users").withConverter<Users>(
              fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
              toFirestore: (users, _) => users.toJson(),
            );
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    wishlistCount = widget.product.wishlistCount;
    isMyWishlist();
  }

  void openProduct(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => loaderOverlay(
          child: ProdutcDetail(
              product: widget.product, productId: widget.productId)),
    ));
  }

  Future<void> isMyWishlist() async {
    Users data = (await userRef.doc(currentUserId).get()).data() as Users;
    setState(() {
      isMyWishlistProduct = data.wishlist != null
          ? data.wishlist!.contains(widget.productId)
          : false;
    });
  }

  Future<void> updateWishlist() async {
    Users data = (await userRef.doc(currentUserId).get()).data() as Users;
    List? wishlist;
    if (isMyWishlistProduct) {
      data.wishlist?.remove(widget.productId);
      wishlist = data.wishlist;
      wishlistCount -= 1;
    } else {
      if (data.wishlist != null) {
        data.wishlist?.add(widget.productId);
        wishlist = data.wishlist;
      } else {
        wishlist = [widget.productId];
      }
      wishlistCount += 1;
    }

    await FirebaseFirestore.instance.collection("users").doc(currentUserId).set(
      {"wishlist": wishlist},
      SetOptions(merge: true),
    );
    await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .set(
      {"wishlistCount": wishlistCount},
      SetOptions(merge: true),
    );

    widget.wishlistHook();

    setState(() {
      isMyWishlistProduct = !isMyWishlistProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userRef.doc(widget.product.userId).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Users user = snapshot.data!.data() as Users;
          return Container(
            width: MediaQuery.of(context).size.width * 0.4,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              color: const Color(secondaryColor),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image(
                          image: NetworkImage(widget.product.images[0]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "\$ ${widget.product.price}",
                          textColor: const Color(primaryColor),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        FavoriteButton(
                          isMyWishlistProduct: isMyWishlistProduct,
                          updateWishlist: updateWishlist,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => openProduct(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CustomText(
                          text: widget.product.name,
                          textColor: const Color(primaryFontColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textAlignment: TextAlign.justify,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ProfileIcon(
                            radius: 20,
                            image: NetworkImage(user.photoURL),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: CustomText(
                              text: user.name,
                              textColor: const Color(primaryFontColor),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
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
