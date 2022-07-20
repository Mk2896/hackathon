import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/models/users.dart';
import 'package:hackatron/screens/login.dart';
import 'package:hackatron/screens/my_home_page.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_image_input.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/custom_text_field.dart';
import 'package:hackatron/widgets/extensions.dart';
import 'package:hackatron/widgets/google_btn.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/snackbar.dart';
import 'package:hackatron/widgets/text_divider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/cupertino.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmpasswordController;
  late GlobalKey<FormState> _loginFormKey;
  File? temporaryImagePath;
  String? imageErrorText = "";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _professionController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmpasswordController = TextEditingController();
    _loginFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Your Name is required";
    } else if (value.length < 3) {
      return "Invalid Name";
    }

    return null;
  }

  String? _professionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Profession is required";
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email Address is required";
    } else if (!value.isValidEmail()) {
      return "Invalid Email Address";
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length < passwordLength) {
      return "Password must be atleast $passwordLength characters.";
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm Password is required";
    } else if (value.length < passwordLength) {
      return "Confirm Password must be atleast $passwordLength characters.";
    } else if (value != _passwordController.text) {
      return "Password doesn't match";
    }
    return null;
  }

  Future<void> pickImage(ImageSource source) async {
    Navigator.pop(context);

    final image = await ImagePicker()
        .pickImage(source: source, preferredCameraDevice: CameraDevice.front);

    if (image == null) return;

    setState(() {
      temporaryImagePath = File(image.path);
    });
  }

  void _registerMethod(BuildContext context) async {
    if (temporaryImagePath == null) {
      setState(() {
        imageErrorText = "Profile Picture is required";
      });
    } else {
      setState(() {
        imageErrorText = null;
      });
    }
    if (_loginFormKey.currentState!.validate()) {
      !context.loaderOverlay.visible
          ? context.loaderOverlay.show(
              widget: const Loading(loadingText: "Registering You Please Wait"))
          : null;
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String currentUserID = FirebaseAuth.instance.currentUser!.uid;

        try {
          final firebaseStorageRef = FirebaseStorage.instance.ref();

          final firebaseStorageImageRef =
              firebaseStorageRef.child("users/$currentUserID.jpg");

          late String imageURL;

          UploadTask imageUpoadTask =
              firebaseStorageImageRef.putFile(temporaryImagePath as File);

          imageURL = await (await imageUpoadTask).ref.getDownloadURL();

          try {
            final userRef = FirebaseFirestore.instance
                .collection('users')
                .withConverter<Users>(
                  fromFirestore: (snapshot, _) =>
                      Users.fromJson(snapshot.data()!),
                  toFirestore: (users, _) => users.toJson(),
                );

            await userRef.doc(currentUserID).set(Users(
                  name: _nameController.text,
                  email: _emailController.text,
                  photoURL: imageURL,
                  profession: _professionController.text,
                ));

            await FirebaseAuth.instance.currentUser!
                .updateDisplayName(_nameController.text);
            await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageURL);

            snackBar(
                "Logged in Successfully", const Color(successColor), context);
            Navigator.canPop(context) ? Navigator.of(context).pop() : null;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => loaderOverlay(child: MyHomePage()),
            ));
          } catch (e) {
            FirebaseAuth.instance.currentUser!.delete();
            FirebaseAuth.instance.signOut();
            firebaseStorageImageRef.delete();
            snackBar(e.toString(), const Color(errorColor), context);
          }
        } catch (e) {
          FirebaseAuth.instance.currentUser!.delete();
          FirebaseAuth.instance.signOut();
          snackBar(e.toString(), const Color(errorColor), context);
        }
      } on FirebaseAuthException catch (e) {
        snackBar(e.message, const Color(errorColor), context);
      } catch (e) {
        snackBar(e.toString(), const Color(errorColor), context);
      }
      context.loaderOverlay.visible ? context.loaderOverlay.hide() : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo-2.png",
                  height: 150,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 40),
                  child: Card(
                    elevation: 5,
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomTextField(
                            textController: _nameController,
                            leftPadding: 20,
                            rightPadding: 20,
                            topMargin: 20,
                            hintText: "Your Name",
                            textAlignment: TextAlign.center,
                            prefix: const Icon(
                              Icons.person_outline,
                              color: Color(secondaryFontColor),
                            ),
                            validationMethod: _nameValidator,
                          ),
                          CustomTextField(
                            textController: _professionController,
                            leftPadding: 20,
                            rightPadding: 20,
                            topMargin: 20,
                            hintText: "Profession",
                            textAlignment: TextAlign.center,
                            prefix: const Icon(
                              CupertinoIcons.briefcase,
                              color: Color(secondaryFontColor),
                            ),
                            validationMethod: _professionValidator,
                          ),
                          CustomTextField(
                            textController: _emailController,
                            leftPadding: 20,
                            rightPadding: 20,
                            topMargin: 20,
                            hintText: "Your Email",
                            keyboardType: TextInputType.emailAddress,
                            textAlignment: TextAlign.center,
                            prefix: const Icon(
                              Icons.email_outlined,
                              color: Color(secondaryFontColor),
                            ),
                            validationMethod: _emailValidator,
                          ),
                          CustomTextField(
                            textController: _passwordController,
                            leftPadding: 20,
                            rightPadding: 20,
                            topMargin: 20,
                            hintText: "Password",
                            isPassword: true,
                            textAlignment: TextAlign.center,
                            prefix: const Icon(
                              Icons.lock_outline,
                              color: Color(secondaryFontColor),
                            ),
                            validationMethod: _passwordValidator,
                          ),
                          CustomTextField(
                            textController: _confirmpasswordController,
                            leftPadding: 20,
                            rightPadding: 20,
                            topMargin: 20,
                            hintText: "Confirm Password",
                            isPassword: true,
                            textAlignment: TextAlign.center,
                            prefix: const Icon(
                              Icons.lock_outline,
                              color: Color(secondaryFontColor),
                            ),
                            validationMethod: _confirmPasswordValidator,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CustomImageInput(
                              temporaryImagePath: temporaryImagePath,
                              errorText: imageErrorText,
                              pickImageMethod: pickImage,
                            ),
                          ),
                          CustomButton(
                            buttonText: "Register",
                            buttonMethod: () => _registerMethod(context),
                            buttonType: ButtonType.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            width: MediaQuery.of(context).size.width * 0.5,
                            topMargin: 20,
                            bottomMargin: 20,
                          ),
                          const TextDivider(text: "OR"),
                          GoogleButton(
                            text: "Sign Up With Google",
                            width: MediaQuery.of(context).size.width * 0.7,
                            topMargin: 20,
                            bottomMargin: 20,
                          ),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(secondaryFontColor)))),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).canPop()
                                      ? Navigator.of(context).pop()
                                      : null;
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        loaderOverlay(child: Login()),
                                  ));
                                },
                                child: const CustomText(
                                  text: "Go to login",
                                  textColor: Color(secondaryFontColor),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          )
                        ],
                      ),
                    ),
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
