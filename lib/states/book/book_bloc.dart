import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/states/book/book_event.dart';
import 'package:book_app/states/book/book_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  static const int booksPerPage = 32;

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

      List<Book> currentBooks = [];
      List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (!connectivityResult.contains(ConnectivityResult.none)) {
        final (books, _) = await _bookRepository.getBooks(
          page: 1,
          limit: booksPerPage,
          isOnline: true,
        );
        currentBooks = books;
      } else {
        final (books, _) = await _bookRepository.getBooks(
          page: 1,
          limit: booksPerPage,
          isOnline: false,
        );
        currentBooks = books;
      }

      emit(state.asLoadSuccess(currentBooks, canLoadMore: true));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(
      BookLoadMoreStarted event, Emitter<BookState> emit) async {
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      List<Book> currentBooks = [];
      bool canFetchNext = false;

      List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (!connectivityResult.contains(ConnectivityResult.none)) {
        final (books, canLoadMore) = await _bookRepository.getBooks(
          page: state.page + 1,
          limit: booksPerPage,
          isOnline: true,
        );
        currentBooks = books;
        canFetchNext = canLoadMore;
      } else {
        final (books, _) = await _bookRepository.getBooks(
          page: state.page + 1,
          limit: booksPerPage,
          isOnline: false,
        );
        currentBooks = books;
        canFetchNext = currentBooks.length >= booksPerPage;
      }

      emit(state.asLoadMoreSuccess(currentBooks, canLoadMore: canFetchNext));
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
