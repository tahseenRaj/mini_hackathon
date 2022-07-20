import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double total = 0.0;

class Product extends StatefulWidget {
  final QueryDocumentSnapshot data;
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart');
  Product({required this.data, Key? key}) : super(key: key);
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List color = [
    Colors.pink,
    Colors.pinkAccent,
    Colors.blue,
    Colors.deepPurple,
    Colors.brown,
    Colors.orange[600],
    Colors.grey[350],
    Colors.cyan
  ];
  var selectedColor;
  late num size;
  int confirm = 1;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 60,
        width: 200,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xfffe2550),
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              var ha = await widget.db.doc(widget.data.id).get();
              if (ha.exists != true) {
                print(ha.exists);
                widget.db.doc(widget.data.id).set({
                  'image': widget.data.get('image').toString(),
                  'title': widget.data.get('title').toString(),
                  'price': widget.data.get('price').toString(),
                  'name': widget.data.get('name').toString()
                }).then((value) {
                  // total = total + double.parse(widget.data.get('price'));
                  final snackBar = SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                        '${widget.data.get('title').toString()} is added to your cart.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              } else {
                const snackBar = SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Already added in your cart.'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // print('Docuement Id: ${data.id}');
              }
              print(widget.data.id);
            },
            child: Text('Add to Bag',
                style: GoogleFonts.raleway(
                    fontSize: 20, fontWeight: FontWeight.bold))),
      ),
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(
                      url: widget.data.get('image'),
                    );
                  }));
                },
                child: InteractiveViewer(
                  panEnabled: true,
                  maxScale: 2.5,
                  child: Image.network(
                    widget.data.get('image'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.get('title'),
                      style: const TextStyle(fontSize: 16)),
                  Text('\$ ${widget.data.get('price')}',
                      style: GoogleFonts.robotoSerif(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: const Color(0xffFE2550)))
                ],
              ),
            ),
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: const Color(0xfffe2550),
              tabs: const [
                Tab(
                  text: 'INFO',
                ),
                Tab(
                  text: 'MEASUREMENTS',
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('MATERIALS',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Text(
                              'Linen is very strong, absorbent, and dries faster than cotton. Because of these properties, linen is comfortable to wear in hot weather and is valued for use in garments. It also has other distinctive characteristics, notably its tendency to wrinkle.',
                              style: TextStyle(height: 1.5)),
                          const SizedBox(height: 10),
                          const Text('WASH INSTRUCTIONS',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Text(
                              "Always wash your linen clothes on your machine’s gentle cycle. Avoid washing in cold or very hot water. If it is possible to select the water level in the washing machine, always use the maximum offered. Your clothing should move freely.",
                              style: TextStyle(height: 1.5)),
                          const SizedBox(width: 10),
                          const SizedBox(width: 20),
                          const Divider(),
                          Row(
                            children: [
                              SizedBox(
                                height: 80,
                                child: Row(children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Total: ',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                '\$ ${widget.data.get('price')}',
                                            style: GoogleFonts.robotoSerif(
                                                fontSize: 17,
                                                color:
                                                    const Color(0xfffe2550))),
                                      ],
                                    ),
                                  ),
                                ]),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Size(name: 'WAIST', length: '30'),
                            Size(name: 'LENGTH', length: '60'),
                            Size(name: 'BREADTH', length: '18')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 12),
                          child: Row(
                            children: [
                              const Text('Colors:',
                                  style: TextStyle(fontSize: 20)),
                              const Spacer(),
                              Container(
                                height: 50,
                                width: 250,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: color.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor: color[index],
                                            radius: 20,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedColor = index;
                                              print(selectedColor.toString());
                                            });
                                          }),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Do you want to use this material',
                                  style: GoogleFonts.raleway(fontSize: 20)),
                              SizedBox(height: 20),
                              Row(children: [
                                SizedBox(
                                  height: 45,
                                  width: 70,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: confirm != 1
                                            ? Colors.white
                                            : const Color(0xfffe2550),
                                        onPrimary: confirm != 1
                                            ? Colors.black
                                            : Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        confirm = 1;
                                      });
                                    },
                                    child: Text("Yes",
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 45,
                                  width: 70,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: confirm == 0
                                            ? const Color(0xfffe2550)
                                            : Colors.white,
                                        onPrimary: confirm == 0
                                            ? Colors.white
                                            : Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        confirm = 0;
                                      });
                                    },
                                    child: Text("No",
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 80,
                                child: Row(children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Total: ',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                '\$ ${widget.data.get('price')}',
                                            style: GoogleFonts.robotoSerif(
                                                fontSize: 17,
                                                color:
                                                    const Color(0xfffe2550))),
                                      ],
                                    ),
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

//ignore: must_be_immutable
class Size extends StatefulWidget {
  final String name;
  late String length;
  Size({Key? key, required this.name, required this.length}) : super(key: key);

  @override
  State<Size> createState() => _SizeState(length);
}

class _SizeState extends State<Size> {
  var length;
  _SizeState(String length);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(widget.name,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[200],
              ),
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              height: 45,
              width: 100,
              child: DropdownButton<String>(
                value: widget.length,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.length = newValue!;
                  });
                },
                items: <String>[for (var i = 18; i <= 70; i++) i.toString()]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailScreen extends StatelessWidget {
  late String url;
  DetailScreen({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: InteractiveViewer(
            panEnabled: true, // Set it to false
            // minScale: 0.5,
            // maxScale: 2,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Image.network(
                url,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
