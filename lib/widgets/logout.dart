import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackatron/screens/register.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:loader_overlay/loader_overlay.dart';

logout(BuildContext context) async {
  !context.loaderOverlay.visible
      ? context.loaderOverlay
          .show(widget: const Loading(loadingText: "Logging Out"))
      : null;
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().isSignedIn() ? GoogleSignIn().signOut() : null;
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => loaderOverlay(child: Register()),
  ));
  context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
}
