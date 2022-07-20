import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/screens/my_home_page.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton(
      {Key? key,
      required this.text,
      this.bottomMargin,
      this.topMargin,
      this.rightMargin,
      this.leftMargin,
      this.height,
      this.width})
      : super(key: key);
  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? width;
  final double? height;
  final String text;

  Future<void> signInWithGoogle(BuildContext context) async {
    !context.loaderOverlay.visible
        ? context.loaderOverlay
            .show(widget: const Loading(loadingText: "Loading Please Wait"))
        : null;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
        return;
      }
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      User? currentUser = FirebaseAuth.instance.currentUser!;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .withConverter<Users>(
            fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
            toFirestore: (users, _) => users.toJson(),
          );

      DocumentSnapshot<Users> userExist =
          await userRef.doc(currentUser.uid).get();
      if (!userExist.exists) {
        try {
          await userRef.doc(currentUser.uid).set(Users(
                name: currentUser.displayName ?? "",
                email: currentUser.email ?? "",
                photoURL: currentUser.photoURL ?? "",
                profession: null,
              ));
        } catch (e) {
          FirebaseAuth.instance.currentUser!.delete();
          FirebaseAuth.instance.signOut();
          context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
          snackBar(e.toString(), const Color(errorColor), context);
          return;
        }
      }

      snackBar("Logged in Successfully", const Color(successColor), context);
      Navigator.canPop(context) ? Navigator.of(context).pop() : null;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => loaderOverlay(child: MyHomePage()),
      ));
    } catch (e) {
      snackBar(e.toString(), const Color(errorColor), context);
    }

    context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: leftMargin ?? 0,
        right: rightMargin ?? 0,
        top: topMargin ?? 0,
        bottom: bottomMargin ?? 0,
      ),
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color(secondaryColor)),
        ),
        onPressed: () => signInWithGoogle(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
              child: Image(image: AssetImage("assets/images/google_logo.png")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomText(
                text: text,
                textColor: const Color(primaryFontColor),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
