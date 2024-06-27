import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/states/favorite_book/favorite_book_event.dart';
import 'package:book_app/states/favorite_book/favorite_book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class FavoriteBookBloc extends Bloc<FavoriteBookEvent, FavoriteBookState> {
  static const int booksPerPage = 32;

  final BookRepository _bookRepository;

  FavoriteBookBloc(this._bookRepository)
      : super(const FavoriteBookState.initial()) {
    on<FavoriteBookLoadStarted>(
      _onLoadStarted,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<FavoriteBookLoadMoreStarted>(
      _onLoadMoreStarted,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<FavoriteBookSelectChanged>(_onSelectChanged);
  }

  void _onLoadStarted(
      FavoriteBookLoadStarted event, Emitter<FavoriteBookState> emit) async {
    try {
      emit(state.asLoading());

      final books =
          await _bookRepository.getFavoriteBooks(page: 1, limit: booksPerPage);

      final canLoadMore = books.length >= booksPerPage;

      emit(state.asLoadSuccess(books, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(FavoriteBookLoadMoreStarted event,
      Emitter<FavoriteBookState> emit) async {
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      final books = await _bookRepository.getFavoriteBooks(
        page: state.page + 1,
        limit: booksPerPage,
      );

      final canLoadMore = books.length >= booksPerPage;

      emit(state.asLoadMoreSuccess(books, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectChanged(
      FavoriteBookSelectChanged event, Emitter<FavoriteBookState> emit) async {
    try {
      final bookIndex = state.books.indexWhere(
        (book) => book.id == event.bookId,
      );

      if (bookIndex < 0 || bookIndex >= state.books.length) return;

      final book = await _bookRepository.getBook(event.bookId);

      if (book == null) return;

      emit(state.copyWith(
        books: state.books..setAll(bookIndex, [book]),
        selectedFavoriteBookIndex: bookIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }
}
