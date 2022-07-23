import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/cart_screen.dart';
import 'package:hackatron/widgets/home_page_screen.dart';
import 'package:hackatron/widgets/wishlist.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentBottomIndex = 0;

  final List<Widget> homeScreens = [
    const HomePageScreen(),
    const CartScreen(),
    const Wishlist(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(secondaryColor),
          padding: const EdgeInsets.only(top: 15),
          child: homeScreens[currentBottomIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomIndex,
        selectedItemColor: const Color(primaryColor),
        unselectedItemColor: const Color(secondaryFontColor),
        showSelectedLabels: false,
        onTap: (index) {
          setState(() {
            currentBottomIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 30,
              ),
              activeIcon: Icon(
                Icons.home_outlined,
                size: 35,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: 30,
              ),
              activeIcon: Icon(
                Icons.shopping_bag_outlined,
                size: 35,
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
                size: 30,
              ),
              activeIcon: Icon(
                Icons.favorite_border,
                size: 35,
              ),
              label: "Wishlist"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              activeIcon: Icon(
                Icons.add,
                size: 35,
              ),
              label: "Add"),
        ],
      ),
    );
  }
}
