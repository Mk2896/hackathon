import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/products.dart';

class ProdutcDetail extends StatelessWidget {
  const ProdutcDetail({Key? key, required this.product}) : super(key: key);

  final Products product;
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
              CarouselSlider(
                items: product.images.map((img) {
                  return Image(
                    image: NetworkImage(img),
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: false,
                  height: MediaQuery.of(context).size.height * 0.4,
                  viewportFraction: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
