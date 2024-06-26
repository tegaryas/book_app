import 'dart:convert';

import 'package:book_app/core/network.dart';
import 'package:book_app/data/source/rest_api/models/book.dart';

class RestApiDatasource {
  final NetworkManager networkManager;

  RestApiDatasource({required this.networkManager});

  static const String booksURL = "https://gutendex.com/books/";

  Future<List<RestAPIBookModel>> getPokemons() async {
    final response = await networkManager.request(RequestMethod.get, booksURL);

    final data = (json.decode(response.data) as List)
        .map((item) => RestAPIBookModel.fromJson(item))
        .toList();

    return data;
  }
}
