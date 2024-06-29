import 'package:book_app/core/usecase.dart';
import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/domain/entities/book.dart';

class GetAllBooksUseCase extends NoParamsUseCase<List<Book>> {
  final BookRepository bookRepository;

  GetAllBooksUseCase({required this.bookRepository});

  @override
  Future<List<Book>> call() {
    return bookRepository.getAllBooks();
  }
}

class GetBooksParams {
  const GetBooksParams({
    required this.page,
    required this.limit,
  });

  final int page;
  final int limit;
}

class GetBooksUseCase extends UseCase<(List<Book>, bool), GetBooksParams> {
  final BookRepository bookRepository;

  GetBooksUseCase({required this.bookRepository});

  @override
  Future<(List<Book>, bool)> call(GetBooksParams params) {
    return bookRepository.getBooks(limit: params.limit, page: params.page);
  }
}

class GetBookParam {
  const GetBookParam({
    required this.id,
  });
  final int id;
}

class GetBookUseCase extends UseCase<Book?, GetBookParam> {
  final BookRepository bookRepository;

  GetBookUseCase({required this.bookRepository});

  @override
  Future<Book?> call(GetBookParam params) {
    return bookRepository.getBook(params.id);
  }
}
