import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/netwok_search.dart';

class NogozoApi {
  static Future<List<Book>> getBooks(String query) async {
    final url = Uri.parse('https://nogozo.com/api/romance-novels');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List books = json.decode(response.body);
      return books.map((json) => Book.fromJson(json)).where((book) {
        final titleLower = book.name.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
