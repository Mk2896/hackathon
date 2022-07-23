import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/tags.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/logout.dart';
import 'package:hackatron/widgets/product.dart';
import 'package:hackatron/widgets/profile_icon.dart';
import 'package:hackatron/widgets/search_field.dart';

class Search extends StatefulWidget {
  Search({Key? key, required this.searchKeyword}) : super(key: key);

  final String searchKeyword;

  final TextEditingController searchController = TextEditingController();

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late CollectionReference productsRef;
  late CollectionReference tagsRef;
  late String keyword;

  void _search() {
    if (widget.searchController.text.length > 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => loaderOverlay(
            child: Search(searchKeyword: widget.searchController.text)),
      ));
    }
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

  @override
  void initState() {
    super.initState();
    keyword = widget.searchKeyword;
    widget.searchController.text = keyword;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SearchField(
                    width: MediaQuery.of(context).size.width * 0.78,
                    textController: widget.searchController,
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
                      onPressed: () => widget.searchController.text = "",
                    ),
                    hintText: "Search",
                    onSuggestionSelect: (value) {
                      widget.searchController.text = value;
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
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 15),
                  color: const Color(bgColor),
                  child: FutureBuilder(
                      future: productsRef
                          .where("tags", arrayContains: keyword)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CustomText(
                                    text:
                                        "${snapshot.data!.docs.length} items found for '$keyword'",
                                    textColor: const Color(primaryFontColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.6,
                                    crossAxisCount: 2,
                                  ),
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Products product =
                                        document.data()! as Products;
                                    return Product(product, document.id,(){});
                                  }).toList(),
                                ),
                              ),
                            ],
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
        ),
      ),
    );
  }
}
