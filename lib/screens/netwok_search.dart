import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nogozo/components/search_widget.dart';
import '../api/api.dart';

class FilterNetworkListPage extends StatefulWidget {
  const FilterNetworkListPage({Key? key}) : super(key: key);

  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<FilterNetworkListPage> {
  List<Book> books = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final books = await NogozoApi.getBooks(query);

    setState(() => this.books = books);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  autofocus: true,
                  onChanged: searchBook,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "What are you looking for ?",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                //   // ...phrases.map((phrase) => _Card(phrase: phrase)).toList(),
              ),
              preferredSize: Size(MediaQuery.of(context).size.width, 55)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];

                  return buildBook(book);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Title or Author Name',
        onChanged: searchBook,
      );

  Future searchBook(String query) async => debounce(() async {
        final books = await NogozoApi.getBooks(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.books = books;
        });
      });

  Widget buildBook(Book book) => ListTile(
        leading: Image.network(
          book.urlImage,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(book.name),
        subtitle: Row(
          children: [
            Text(
              "₹" + book.rent,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "₹" + book.mrp,
              style: const TextStyle(decoration: TextDecoration.lineThrough),
            )
          ],
        ),
      );
}

class Book {
  final int id;
  final String name;
  final String mrp;
  final String urlImage;
  final String rent;

  const Book(
      {required this.id,
      required this.mrp,
      required this.name,
      required this.urlImage,
      required this.rent});

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        mrp: json['mrp'],
        name: json['name'],
        urlImage: json['image'],
        rent: json['one_week_rent_price'],
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'mrp': mrp, 'urlImage': urlImage, 'rent': rent};
}
