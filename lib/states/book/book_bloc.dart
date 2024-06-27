import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/states/book/book_event.dart';
import 'package:book_app/states/book/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  static const int booksPerPage = 10;

  final BookRepository _bookRepository;

  BookBloc(this._bookRepository) : super(const BookState.initial()) {
    on<BookLoadStarted>(
      _onLoadStarted,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<BookLoadMoreStarted>(
      _onLoadMoreStarted,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<BookSelectChanged>(_onSelectChanged);
  }

  void _onLoadStarted(BookLoadStarted event, Emitter<BookState> emit) async {
    try {
      emit(state.asLoading());

      final books = event.loadAll
          ? await _bookRepository.getAllBooks()
          : await _bookRepository.getBooks(page: 1, limit: booksPerPage);

      final canLoadMore = books.length >= booksPerPage;

      emit(state.asLoadSuccess(books, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(
      BookLoadMoreStarted event, Emitter<BookState> emit) async {
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      final books = await _bookRepository.getBooks(
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
      BookSelectChanged event, Emitter<BookState> emit) async {
    try {
      final bookIndex = state.books.indexWhere(
        (book) => book.id == event.bookId,
      );

      if (bookIndex < 0 || bookIndex >= state.books.length) return;

      final book = await _bookRepository.getBook(event.bookId);

      if (book == null) return;

      emit(state.copyWith(
        books: state.books..setAll(bookIndex, [book]),
        selectedBookIndex: bookIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }
}
