import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/tags.dart';
import 'package:hackatron/screens/search.dart';
import 'package:hackatron/widgets/custom_refresh_indeicator.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/custom_text_field.dart';
import 'package:hackatron/widgets/logout.dart';
import 'package:hackatron/widgets/post.dart';
import 'package:hackatron/widgets/profile_icon.dart';
import 'package:hackatron/widgets/search_field.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late TabController _tabBarController;
  late CollectionReference productsRef;
  late CollectionReference tagsRef;
  List<String> _searchedTags = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabBarController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    productsRef = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Products>(
          fromFirestore: (snapshot, _) => Products.fromJson(snapshot.data()!),
          toFirestore: (products, _) => products.toJson(),
        );
    tagsRef = FirebaseFirestore.instance.collection('tags').withConverter<Tags>(
          fromFirestore: (snapshot, _) => Tags.fromJson(snapshot.data()!),
          toFirestore: (tags, _) => tags.toJson(),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabBarController.dispose();
    super.dispose();
  }

  Future<Iterable<dynamic>> _getHint(String value) async {
    if (value.isEmpty) {
      return [];
    }
    return (await tagsRef
            .where("name", isGreaterThanOrEqualTo: value)
            .where("name", isLessThanOrEqualTo: "$value\uf7ff")
            .get())
        .docs
        .map((DocumentSnapshot document) {
      Tags tag = document.data() as Tags;
      return tag.name;
    }).toList();
  }

  void _search() {
    if (_searchController.text.length > 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Search(
          searchKeyword: _searchController.text,
        ),
      ));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SearchField(
                  width: MediaQuery.of(context).size.width * 0.78,
                  textController: _searchController,
                  borderRadius: 5,
                  height: 45,
                  prefix: IconButton(
                    icon: const Icon(Icons.search,
                        color: Color(secondaryFontColor)),
                    onPressed: () => _search(),
                  ),
                  suffix: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(secondaryFontColor),
                      size: 15,
                    ),
                    onPressed: () => _searchController.text = "",
                  ),
                  hintText: "Search",
                  onSuggestionSelect: (value) {
                    _searchController.text = value;
                    _search();
                  },
                  suggestionCallback: _getHint,
                ),
                ProfileIcon(
                  radius: 20,
                  onClick: () => logout(context),
                )
              ],
            ),
          ],
        ),
        TabBar(
          indicatorColor: const Color(primaryColor),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: const Color(primaryFontColor),
          unselectedLabelColor: const Color(secondaryFontColor),
          controller: _tabBarController,
          tabs: const [
            Tab(
              text: "Women",
            ),
            Tab(
              text: "Men",
            ),
            Tab(
              text: "Child",
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabBarController,
            children: [
              CustomRefreshIndicator(
                reset: _refresh,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(bgColor),
                  child: FutureBuilder(
                      future: productsRef.where("type", isEqualTo: 1).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Products product = document.data()! as Products;
                                return Post(product);
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CustomText(
                                text: "No Data Found..",
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
                      }),
                ),
              ),
              CustomRefreshIndicator(
                reset: _refresh,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(bgColor),
                  child: FutureBuilder(
                      future: productsRef.where("type", isEqualTo: 2).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Products product = document.data()! as Products;
                              return Post(product);
                            }).toList(),
                          );
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
                      }),
                ),
              ),
              CustomRefreshIndicator(
                reset: _refresh,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(bgColor),
                  child: FutureBuilder(
                      future: productsRef.where("type", isEqualTo: 3).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Products product = document.data()! as Products;
                              return Post(product);
                            }).toList(),
                          );
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
                      }),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
