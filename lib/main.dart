import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackatron/firebase_options.dart';
import 'package:hackatron/models/get_dummy_data.dart';
import 'package:hackatron/screens/my_home_page.dart';
import 'package:hackatron/screens/splash_screen.dart';
import 'package:hackatron/widgets/loader_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // GetDummyData().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackatron',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loaderOverlay(
        child: FirebaseAuth.instance.currentUser != null
            ? MyHomePage()
            : const SpalashScreen(),
      ),
    );
  }
}
