import 'package:flutter/material.dart';
import 'package:hackathon/trend.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Trends(),
    );
  }
}

class Trends extends StatefulWidget {
  const Trends({Key? key}) : super(key: key);

  @override
  State<Trends> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  final PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      PageView(
        physics:const ScrollPhysics(),
        controller: controller,
        children: const <Widget>[
          Trend(number: '1', name: 'Jennifer Kingsley ', message: 'exploring the new range of winter fashion wear',),
          Trend(number: '2', name: 'Jimmy Chuka ', message: 'exploring new spring sweater collection',),
          Trend(number: '3', name: 'Christian Lobi', message: 'showing us his new summer beach wear',)
          
        ],
      ),
      Positioned(
        bottom: 40,
        child: SmoothPageIndicator(
          controller: controller,
          count: 3,
          effect: const ExpandingDotsEffect(
            activeDotColor: Colors.pinkAccent,
            dotColor: Colors.white,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ),
    ]);
  }
}
