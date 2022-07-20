import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:hackathon/product.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  TextEditingController searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> _cartStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .snapshots();
  double sum = 0.0;
  int icon = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text('Cart',
            style: GoogleFonts.abrilFatface(color: Colors.black, fontSize: 30)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: _cartStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFFE2250),
                  ));
                }

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 100),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    var x = snapshot.data!.docs.length;
                    for (var i = 0; i <= x; i++) {
                      // sum = 0.0;
                      sum = sum + double.parse(data['price']);
                    }
                    return CartItem(data: data, id: document.reference.id);
                  }).toList(),
                );
              },
            ),
          ),
          Positioned(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 100,
            width: double.infinity,
            // color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(
                    text: 'Total: ',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1),
                    children: [
                      TextSpan(
                        text: '\$${total.round()}',
                        style: GoogleFonts.robotoSerif(
                            fontSize: 22,
                            color: const Color(0xFFFE2550),
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                SizedBox(
                  height: 50,
                  width: 160,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xfffe2550),
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/confirmation');
                      },
                      child: Text('Pay Now',
                          style: GoogleFonts.raleway(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const CartItem({
    required this.data,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late Map<String, dynamic> data;
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference<Map<String, dynamic>> db = FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('cart');

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              height: 75,
              width: 75,
              child: Image(
                image: NetworkImage(widget.data['image']),
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              // width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    height: 20,
                    child: Text(widget.data['title'],
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.data['name'],
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print(widget.data);
                          db.doc(widget.id).delete().then((value) {
                            // total = total - double.parse(widget.data['price']);
                            final snackBar = SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                  '${widget.data['title'].toString()} is added to your cart.'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }).catchError((error) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 1),
                              content: Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        });
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      '\$${widget.data['price']}',
                      style: GoogleFonts.robotoSerif(
                          color: const Color(0xfffe2550),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
