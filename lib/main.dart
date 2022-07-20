import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/confirmation.dart';
import 'package:hackathon/dashboard.dart';
import 'package:hackathon/login.dart';
import 'package:hackathon/shop.dart';
import 'package:hackathon/signup.dart';
import 'package:hackathon/splash_screen.dart';

import 'firebase_options.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Raleway'),
      scrollBehavior: MyBehavior(),
      home: const SplashScreen(),
      routes: {
        '/home':(context) => const Home(),
        '/splash_screen': (context) => const SplashScreen(),
        '/login':(context) => const  Login(),
        '/signup':(context) => const Signup(),
        '/dashboard':(context) => const Dashboard(),
        '/shop':(context) => const Shop(),
        '/confirmation':(context) => const Confirmation(),
      },
    );
  }
}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}