import 'package:flutter/material.dart';
import 'package:hackathon/shop.dart';

import 'cart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int screenIndex = 0;
  final screens = [
    const Shop(),
    const Cart(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 1,
              blurStyle: BlurStyle.outer,
            )
          ]
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  screenIndex = 0;
                });
              },
              icon: Icon(
                Icons.home_outlined,
                color: screenIndex == 0
                  ? const Color(0xFFF84367) : Colors.grey,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  screenIndex = 1;
                });
              },
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: screenIndex == 1
                  ? const Color(0xFFF84367) : Colors.grey,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
