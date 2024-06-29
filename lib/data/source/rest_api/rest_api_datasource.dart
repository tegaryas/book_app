import 'package:book_app/core/network.dart';
import 'package:book_app/data/source/rest_api/models/book.dart';

class RestApiDatasource {
  final NetworkManager networkManager;

  RestApiDatasource({required this.networkManager});

  static const String booksURL = "https://gutendex.com/books";

  Future<(List<RestAPIBookModel>, bool)> getBooks(
      {int page = 1, List<RestAPIBookModel> data = const []}) async {
    final response = await networkManager
        .request(RequestMethod.get, booksURL, queryParameters: {"page": page});

    final result = ((response.data["results"]) as List<dynamic>)
        .map((item) => RestAPIBookModel.fromJson(item))
        .toList();

    return (result, response.data["next"] != null);
  }
}
