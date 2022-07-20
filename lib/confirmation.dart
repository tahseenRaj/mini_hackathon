import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(77, 39, 174, 95)),
              height: 100,
              width: 100,
              child: const Center(
                  child: Icon(Icons.check_rounded,
                      size: 40, color: Color(0xff27AE60))),
            ),
            const SizedBox(height: 50),
            Text('Payment Successfull',
                style: GoogleFonts.abrilFatface(fontSize: 25)),
            const SizedBox(height: 20),
            const Text(
              'Your order will be ready in 5 days, including shipping, more details and options for tracking will be sent to your email.',
              style: TextStyle(fontSize: 16, height: 2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text('Thanks!!!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 50),
            SizedBox(
                height: 60,
                width: 220,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xfffe2550),
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/shop');
                    },
                    child: Text('Continue Shopping',
                        style: GoogleFonts.raleway(
                            fontSize: 16, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}
