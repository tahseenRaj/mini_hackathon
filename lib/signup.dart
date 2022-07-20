import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool emailValid = true;
  FirebaseFirestore db = FirebaseFirestore.instance;

  signup() async {
    emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(emailController.text.toLowerCase());
    if (nameController.text != '') {
      if (emailValid) {
        if (passwordController.text.length >= 8) {
          if (passwordController.text != '' &&
              confirmPasswordController.text != '' &&
              passwordController.text == confirmPasswordController.text) {
            // create account
            try {
              final user =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text.toLowerCase(),
                password: passwordController.text,
              );
              db.collection('users').doc(user.user!.uid).set({
                'userName': nameController.text.trim(),
                'email': emailController.text.toLowerCase().trim(),
                'photoUrl': 'https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png',
              });
              Navigator.pushReplacementNamed(context, '/dashboard');
            } on FirebaseAuthException catch (e) {
              if (e.code == 'email-already-in-use') {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Error',
                      style: TextStyle(color: Colors.red),
                    ),
                    content: Text(
                      e.code,
                      style: const TextStyle(fontSize: 15),
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
            } catch (e) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Error',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    e.toString(),
                    style: const TextStyle(fontSize: 15),
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
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Congragulations',
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text(
                  'You have been signed up!',
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
          } else {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Error',
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text(
                  'Confirm password is not same as Password',
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
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                'Password must be 8 craracters long',
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
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Name can\'t be empty',
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
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Full name',
                                    prefixIcon: Icon(Icons.abc, color: Colors.grey,),
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
                              const SizedBox(height: 25),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: confirmPasswordController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    prefixIcon: Icon(Icons.vpn_key, color: Colors.grey,),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: 'Confirm Password',
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
                                  onPressed: signup,
                                  child: const Text('Signup',
                                      style: TextStyle(fontSize: 18)),
                                ),
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
