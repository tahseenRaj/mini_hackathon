import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon/product.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference db = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  TextEditingController searchController = TextEditingController();
  signout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      Navigator.pushReplacementNamed(
          context, '/splash_screen');
    });
  }

  int icon = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); //remove focus
      },
      child: SafeArea(
        child: CustomScrollView(
          anchor: 0.05,
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: Text('Products',
                  style: GoogleFonts.abrilFatface(
                      color: Colors.black, fontSize: 30)),
              automaticallyImplyLeading: false,
              snap: false,
              primary: true,
              pinned: false,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: 170,
                      height: 25,
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: Color(0xffD6D6D6), size: 16),
                          Flexible(
                            child: TextField(
                              style: GoogleFonts.roboto(fontSize: 10),
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 10),
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                        backgroundColor: const Color(0xfffe2550),
                        radius: 16,
                        child: PopupMenuButton(
                          child:  CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                NetworkImage(user!.photoURL == null ? 'https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png' : user!.photoURL.toString())),
                                itemBuilder: (context) {
                                  return List.generate(1, (index) {
                                    return PopupMenuItem(
                                      child: TextButton(onPressed: signout, child: const Text('Logout')),
                                    );
                                  });
                                },
                              ),
                                )
                  ],
                ),
              ),
              expandedHeight: 120,
              backgroundColor: Colors.white,
              forceElevated: true,
              elevation: 1,
            ),
            
            StreamBuilder(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(child: Center(
                          child: Text(snapshot.error.toString()),
                        ));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Color(0xFFFE2250),)));
                    }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.51,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index)  {
                      QueryDocumentSnapshot data =
                          snapshot.data!.docs[index];
                      return Item(icon: icon, data: data);
                    },
                    childCount: snapshot.data?.docs.length,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Item extends StatefulWidget {
  late int icon;
  final QueryDocumentSnapshot data;
  Item({required this.icon, required this.data, Key? key}) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Product(data: widget.data,)),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFFE2250),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                image: NetworkImage(widget.data.get('image').toString()),
                height: 220,
                width: double.infinity * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$ ${widget.data.get('price')}',
                  style: GoogleFonts.robotoSerif(
                      fontSize: 17,
                      color: const Color(0xfffe2550),
                      fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(
                    widget.icon == 1 ? Icons.favorite : Icons.favorite_outline),
                color: const Color(0xfffe2550),
                onPressed: () {
                  setState(() {
                    if (widget.icon == 1) {
                      widget.icon = 0;
                    } else {
                      widget.icon = 1;
                    }
                  });
                },
                padding: EdgeInsets.zero,
              )
            ],
          ),
          SizedBox(
            height: 25,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Marquee(
                text: widget.data.get('title'),
                style: const TextStyle(
                  fontSize: 14,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 40.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 2),
                // startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 2),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(seconds: 1),
                decelerationCurve: Curves.easeInOut,
              ),
            ),
          ),
          // const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(widget.data.get('profilePic'))),
              const SizedBox(width: 5),
              Expanded(
                child: Text(widget.data.get('name'),
                    style: TextStyle(
                        fontSize: (widget.data.get('name').toString().length) <= 12 ? 15 : 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
