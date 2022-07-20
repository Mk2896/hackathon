import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/screens/intro.dart';

class SpalashScreen extends StatelessWidget {
  const SpalashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Intro(),
            )));

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(primaryColor),
        child: Center(child: Image.asset("assets/images/logo.png")),
      ),
    );
  }
}
