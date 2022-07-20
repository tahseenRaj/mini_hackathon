import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool emailValid = true;

  loginWithEmail() async {
    emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(emailController.text.toLowerCase());
    if (emailValid) {
      try {
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.toLowerCase(),
          password: passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                'User not found',
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (e.code == 'wrong-password') {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                'Wrong password provided for that user.',
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Invalid Email',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> LogInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              backgroundColor: Colors.transparent,
              content: SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator())),
            );
          });
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      User? user = result.user;

      if (user != null) {
        db.collection('users').doc(user.uid).set({
          'userName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
        });
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); //remove focus
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 50, left: 20, right: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                      color: Color(0xffFE2550),
                    ),
                    const SizedBox(height: 30),
                    Container(
                        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(height: 25),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Email',
                                    prefixIcon: Icon(Icons.person, color: Colors.grey,),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    prefixIcon: Icon(Icons.vpn_key, color: Colors.grey,),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: 'Password',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFFF84367)),
                                  onPressed: loginWithEmail,
                                  child: const Text('Login',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                child: Center(
                                  child: Text(
                                    '-------------------- OR --------------------',
                                    style: TextStyle(
                                      fontFamily: 'roboto',
                                      fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 18,),
                                  ),
                                )),
                              SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFFDBDBDB)),
                                  onPressed: () {
                                    LogInWithGoogle(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    Image.asset('assets/images/google.png', height: 25, width: 25,), 
                                    const SizedBox(width: 30,),
                                    const Text('Login with Google',
                                      style: TextStyle(fontSize: 18, color: Colors.black))],),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey,))),
                                child: TextButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey[600]),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    child: const Text(
                                      'Create account',
                                      style: TextStyle(fontSize: 18, fontFamily: 'roboto'),
                                    )),
                              ),
                            ])),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
