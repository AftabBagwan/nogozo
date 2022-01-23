import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'netwok_search.dart';
import '../components/box_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;
  final carouselImages = [
    'https://i.imgur.com/WGzJP8V.jpg',
    'https://assets.brightspot.abebooks.a2z.com/dims4/default/c04a142/2147483647/strip/true/crop/1580x760+0+0/resize/998x480!/quality/90/?url=http%3A%2F%2Fabebooks-brightspot.s3.amazonaws.com%2F51%2F59%2Fc1ccb8904565b231c977ed1afdaa%2Fcarousel-dystopian.jpg',
    'https://cdn11.bigcommerce.com/s-yneuaokjib/images/stencil/1280w/carousel/31/CRE1243_HBR_Hero_GeneralBooks-R2.png?c=2',
    'https://dealsupdate.in/wp-content/uploads/2013/08/Buy-Books-Online1.jpg',
    'https://www.compareraja.in/blog/wp-content/uploads/2014/01/flipkart-book-offers-1440x564_c.jpg',
  ];
  final String url = "https://nogozo.com/api/romance-novels";
  List? data;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  Future<void> getJsonData() async {
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      var dataToJson = jsonDecode(response.body);
      data = dataToJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text('nogozo.com'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FilterNetworkListPage()));
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "What are you looking for ?",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.camera_alt_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 55)),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: data == null ? 0 : data!.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CarouselSlider.builder(
                            itemCount: carouselImages.length,
                            itemBuilder: (context, index, realIndex) {
                              final urlImage = carouselImages[index];
                              return Image.network(
                                urlImage,
                                fit: BoxFit.cover,
                              );
                            },
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              height: 150,
                              reverse: true,
                              autoPlay: true,
                              // autoPlayInterval: Duration(seconds: 2)
                            ),
                          ),
                        ),
                        Row(
                          children: const [
                            Expanded(
                                child: BoxContainer(
                              color: Colors.purple,
                              text: 'IIT JEE',
                            )),
                            BoxContainer(
                              color: Colors.pink,
                              text: 'NEET',
                            ),
                            BoxContainer(
                              color: Colors.amber,
                              text: 'XII Boards',
                            ),
                            BoxContainer(
                              color: Colors.green,
                              text: 'XI Books',
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                child: BoxContainer(
                              color: Colors.cyan,
                              text: 'Engineering',
                            )),
                            BoxContainer(
                              color: Colors.greenAccent,
                              text: 'Novels',
                            ),
                            BoxContainer(
                              color: Colors.deepOrange,
                              text: 'Govt Exams',
                            ),
                            BoxContainer(
                              color: Colors.lime,
                              text: 'IX & X',
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Books for Romance",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Column(
                                children: [
                                  Image.network(
                                    data![index]['image'],
                                  ),
                                  Text(
                                    data![index]['name'],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Rent Price: ₹" +
                                            data![index]['one_week_rent_price'],
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "₹" + data![index]['mrp'],
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              width: 170,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Column(
                                children: [
                                  Image.network(
                                    data![data!.length - index - 1 < 1
                                        ? index
                                        : data!.length - index - 1]['image'],
                                  ),
                                  Text(
                                    data![data!.length - index - 1 < 1
                                        ? index
                                        : data!.length - index - 1]['name'],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Rent Price: ₹" +
                                            data![(data!.length - index - 1) < 1
                                                ? index
                                                : (data!.length -
                                                    index -
                                                    1)]['one_week_rent_price'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "₹" +
                                            data![data!.length - index - 1 < 0
                                                    ? index
                                                    : data!.length - index - 1]
                                                ['mrp'],
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              width: 170,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
