import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userStatus = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    userStatus == null ? const Home() : const Dashboard())));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFE2550),
      body: Center(
        child:
            Center(child: Image(image: AssetImage('assets/images/logo.png'))),
      ),
    );
  }
}
