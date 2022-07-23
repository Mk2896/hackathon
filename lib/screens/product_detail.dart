import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/cart.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/widgets/color_widget.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/favorite_btn.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProdutcDetail extends StatefulWidget {
  const ProdutcDetail({
    Key? key,
    required this.product,
    required this.productId,
  }) : super(key: key);

  final Products product;
  final String productId;

  @override
  State<ProdutcDetail> createState() => _ProdutcDetailState();
}

class _ProdutcDetailState extends State<ProdutcDetail>
    with TickerProviderStateMixin {
  late TabController _tabBarController;
  late CollectionReference userRef;
  late CollectionReference? cartRef;
  late User currentUser;
  late int wishlistCount;
  final List<Widget> colorWidgets = [];
  final List<bool> colorBool = [];
  bool isMyWishlistProduct = false;
  String quantity = "1";

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
    userRef =
        FirebaseFirestore.instance.collection("users").withConverter<Users>(
              fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
              toFirestore: (users, _) => users.toJson(),
            );
    currentUser = FirebaseAuth.instance.currentUser!;
    wishlistCount = widget.product.wishlistCount;
    cartRef =
        userRef.doc(currentUser.uid).collection("cart").withConverter<Cart>(
              fromFirestore: (snapshot, _) => Cart.fromJson(snapshot.data()!),
              toFirestore: (cart, _) => cart.toJson(),
            );
    isMyWishlist();

    int i = 0;
    for (var code in widget.product.colorCodes) {
      i == 0 ? colorBool.add(true) : colorBool.add(false);
      i++;
      colorWidgets.add(ColorWidget(color: Color(code)));
    }
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  Future<void> isMyWishlist() async {
    Users data = (await userRef.doc(currentUser.uid).get()).data() as Users;
    setState(() {
      isMyWishlistProduct = data.wishlist != null
          ? data.wishlist!.contains(widget.productId)
          : false;
    });
  }

  Future<void> updateWishlist() async {
    Users data = (await userRef.doc(currentUser.uid).get()).data() as Users;
    if (isMyWishlistProduct) {
      data.wishlist?.remove(widget.productId);
      wishlistCount -= 1;
    } else {
      data.wishlist?.add(widget.productId);
      wishlistCount += 1;
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .set(
      {"wishlist": data.wishlist},
      SetOptions(merge: true),
    );
    await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .set(
      {"wishlistCount": wishlistCount},
      SetOptions(merge: true),
    );
    setState(() {
      isMyWishlistProduct = !isMyWishlistProduct;
    });
  }

  void addToCart() async {
    !context.loaderOverlay.visible
        ? context.loaderOverlay
            .show(widget: const Loading(loadingText: "Adding To Cart"))
        : null;
    var cartData = (await cartRef!.get()).docs;
    bool alreadyInCart = false;
    if (cartData.isNotEmpty) {
      for (var element in cartData) {
        Cart cartItem = element.data() as Cart;
        if (cartItem.productId == widget.productId) {
          alreadyInCart = true;
        }
      }
    }

    if (!alreadyInCart) {
      cartRef!.doc(widget.productId).set(Cart(
            productId: widget.productId,
            name: widget.product.name,
            userName: currentUser.displayName!,
            photoURL: widget.product.images[0],
            price: widget.product.price.toString(),
          ));

      snackBar("Added To Cart Successfully", Color(successColor), context);
    } else {
      snackBar("Product Already In Cart", Colors.orange, context);
    }

    context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(secondaryColor),
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  CarouselSlider(
                    items: widget.product.images.map((img) {
                      return Image(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: false,
                      height: MediaQuery.of(context).size.height * 0.6,
                      viewportFraction: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FavoriteButton(
                                isMyWishlistProduct: isMyWishlistProduct,
                                updateWishlist: updateWishlist),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.arrowshape_turn_up_right_fill,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              TabBar(
                indicatorColor: const Color(primaryColor),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color(primaryFontColor),
                unselectedLabelColor: const Color(secondaryFontColor),
                controller: _tabBarController,
                tabs: const [
                  Tab(
                    text: "INFO",
                  ),
                  Tab(
                    text: "MEASUREMENTS",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabBarController,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: "MATERIALS",
                                  textColor: Color(primaryFontColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CustomText(
                                    text: widget.product.materialDescription,
                                    textColor: const Color(primaryFontColor),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const CustomText(
                                  text: "WASH INSTRUCTION",
                                  textColor: Color(primaryFontColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CustomText(
                                    text: widget.product.washInstruction,
                                    textColor: const Color(primaryFontColor),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            child: CustomButton(
                              width: MediaQuery.of(context).size.width * 0.55,
                              buttonText: "Add To Bag",
                              buttonMethod: () => addToCart(),
                              buttonType: ButtonType.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Expanded(
                              child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    CustomText(
                                      text: "Waist",
                                      textColor: Color(primaryFontColor),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomText(
                                      text: "Length",
                                      textColor: Color(primaryFontColor),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomText(
                                      text: "Breadth",
                                      textColor: Color(primaryFontColor),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 35),
                                        decoration: const BoxDecoration(
                                          color: Color(bgColor),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: CustomText(
                                          text: widget.product.measurements['W']
                                              .toString(),
                                          textColor:
                                              const Color(primaryFontColor),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 35),
                                        decoration: const BoxDecoration(
                                          color: Color(bgColor),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: CustomText(
                                          text: widget.product.measurements['L']
                                              .toString(),
                                          textColor:
                                              const Color(primaryFontColor),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 35),
                                        decoration: const BoxDecoration(
                                          color: Color(bgColor),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: CustomText(
                                          text: widget.product.measurements['B']
                                              .toString(),
                                          textColor:
                                              const Color(primaryFontColor),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const CustomText(
                                        text: "Color:",
                                        textColor: Color(primaryFontColor),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      ToggleButtons(
                                          renderBorder: false,
                                          fillColor: Colors.transparent,
                                          onPressed: (int index) {
                                            setState(() {
                                              for (int indexBtn = 0;
                                                  indexBtn < colorBool.length;
                                                  indexBtn++) {
                                                if (indexBtn == index) {
                                                  colorBool[indexBtn] = true;
                                                } else {
                                                  colorBool[indexBtn] = false;
                                                }
                                              }
                                            });
                                          },
                                          isSelected: colorBool,
                                          children: colorWidgets),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: const Color(bgColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: DropdownButton(
                                            icon: const Icon(Icons
                                                .keyboard_arrow_down_rounded),
                                            isExpanded: true,
                                            value: quantity,
                                            items: const [
                                              DropdownMenuItem(
                                                value: "1",
                                                child: Text("1"),
                                              ),
                                              DropdownMenuItem(
                                                value: "2",
                                                child: Text("2"),
                                              ),
                                              DropdownMenuItem(
                                                value: "3",
                                                child: Text("3"),
                                              ),
                                              DropdownMenuItem(
                                                value: "4",
                                                child: Text("4"),
                                              ),
                                              DropdownMenuItem(
                                                value: "5",
                                                child: Text("5"),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              quantity = value.toString();
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Row(
                                    children: [
                                      const CustomText(
                                        text: "Total: ",
                                        textColor: Color(secondaryFontColor),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      CustomText(
                                        text: "\$ ${widget.product.price}",
                                        textColor: const Color(primaryColor),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                ),
                                CustomButton(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  buttonText: "Add To Bag",
                                  buttonMethod: () => addToCart(),
                                  buttonType: ButtonType.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
