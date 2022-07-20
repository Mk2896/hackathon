import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/intro_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final List<String> bgImages = [
    "assets/images/bg_image_1.png",
    "assets/images/bg_image_2.png",
    "assets/images/bg_image_3.png"
  ];

  int activeIndex = 0;

  final indicatorController =
      PageController(viewportFraction: 0.2, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != 0 && details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              if (activeIndex > 0) {
                activeIndex -= 1;
              }
            } else {
              if (activeIndex < 2) {
                activeIndex += 1;
              }
            }
            setState(() {});
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgImages[activeIndex]),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: IntroScreen(index: activeIndex)),
                      SizedBox(
                        child: AnimatedSmoothIndicator(
                          activeIndex: activeIndex,
                          count: 3,
                          onDotClicked: (index) {
                            setState(() {
                              activeIndex = index;
                            });
                          },
                          effect: CustomizableEffect(
                            activeDotDecoration: DotDecoration(
                              width: 25,
                              height: 7,
                              color: const Color(primaryColor),
                              rotationAngle: 0,
                              verticalOffset: 0,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            dotDecoration: DotDecoration(
                              width: 5,
                              height: 5,
                              color: Colors.transparent,
                              dotBorder: const DotBorder(
                                padding: 2,
                                width: 1,
                                color: Color(secondaryColor),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              verticalOffset: 0,
                            ),
                            spacing: 6.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
