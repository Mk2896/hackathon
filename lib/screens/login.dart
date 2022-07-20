import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/screens/my_home_page.dart';
import 'package:hackatron/screens/register.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:hackatron/widgets/custom_text_field.dart';
import 'package:hackatron/widgets/extensions.dart';
import 'package:hackatron/widgets/google_btn.dart';
import 'package:hackatron/widgets/loader_overlay.dart';
import 'package:hackatron/widgets/loading.dart';
import 'package:hackatron/widgets/snackbar.dart';
import 'package:hackatron/widgets/text_divider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

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

  void _loginMethod(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      !context.loaderOverlay.visible
          ? context.loaderOverlay
              .show(widget: const Loading(loadingText: "Loading Please Wait"))
          : null;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        snackBar("Logged in Successfully", const Color(successColor), context);
        Navigator.canPop(context) ? Navigator.of(context).pop() : null;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => loaderOverlay(child: MyHomePage()),
        ));
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
                  height: MediaQuery.of(context).size.height * 0.65,
                  margin: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: const Color(secondaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          textController: _emailController,
                          leftPadding: 20,
                          rightPadding: 20,
                          hintText: "Your Email",
                          keyboardType: TextInputType.emailAddress,
                          textAlignment: TextAlign.center,
                          prefix: const Icon(
                            Icons.person_outline,
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
                        CustomButton(
                          buttonText: "Login",
                          buttonMethod: () => _loginMethod(context),
                          buttonType: ButtonType.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          width: MediaQuery.of(context).size.width * 0.5,
                          topMargin: 20,
                          bottomMargin: 20,
                        ),
                        const TextDivider(text: "OR"),
                        GoogleButton(
                          text: "Sign In With Google",
                          width: MediaQuery.of(context).size.width * 0.7,
                          topMargin: 20,
                          bottomMargin: 20,
                        ),
                        Container(
                          height: 40,
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
                                      loaderOverlay(child: Register()),
                                ));
                              },
                              child: const CustomText(
                                text: "Create account",
                                textColor: Color(secondaryFontColor),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        )
                      ],
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
