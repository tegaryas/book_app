import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/domain/entities/book.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final BookRepository _bookRepository;

  SearchCubit(this._bookRepository) : super(SearchInitial());

  Future<void> onSearchBook(String query) async {
    try {
      emit(SearchLoading());
      final result =
          await _bookRepository.getBooks(page: 1, limit: 100, query: query);
      emit(SearchLoaded(books: result));
    } catch (e) {
      emit(SearchFailed());
    }
  }

  void reset() => emit(SearchInitial());
}
