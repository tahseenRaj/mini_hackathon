import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Trend extends StatelessWidget {
  final String number;
  final String name;
  final String message;
  const Trend({Key? key, required this.number,required this.name,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.asset(
            "assets/images/trend$number.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            height: 350,
            width: 320,
            // color: Colors.pink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'NO  ',
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: number,
                          style: GoogleFonts.abrilFatface(
                              fontSize: 50, color: Colors.white)),
                    ],
                  ),
                ),
                const Text(
                  'Featured',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffFE2550)),
                ),
                Text('Tailored',
                    style: GoogleFonts.abrilFatface(
                        fontSize: 50, color: Colors.white)),
                Text.rich(
                  TextSpan(
                    text: name,
                    style: GoogleFonts.raleway(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: message,
                          style: GoogleFonts.raleway(
                              fontSize: 20, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 70,
                  width: 320,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Shop Now',
                          style: GoogleFonts.raleway(
                              fontSize: 24, fontWeight: FontWeight.w900))),
                )
              ],
            ),
          ),
        ]);
  }
}
