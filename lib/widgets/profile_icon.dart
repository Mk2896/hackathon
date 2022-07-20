import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';

class ProfileIcon extends StatelessWidget {
  ProfileIcon(
      {Key? key,
      required this.radius,
      this.color = primaryColor,
      this.onClick,
      this.image})
      : super(key: key);

  final double radius;
  final int color;
  final void Function()? onClick;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    var bgImage = image ??
        (FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.photoURL != null
            ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
            : const AssetImage("assets/images/default_profile.png"));
    return InkWell(
      onTap: onClick,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Color(color),
            radius: radius,
          ),
          CircleAvatar(
            backgroundImage: bgImage as ImageProvider,
            radius: radius - 2,
          )
        ],
      ),
    );
  }
}
