import 'package:book_app/domain/entities/book.dart';

enum BookStateStatus {
  initial,
  loading,
  loadSuccess,
  loadFailure,
  loadingMore,
  loadMoreSuccess,
  loadMoreFailure,
}

class BookState {
  final BookStateStatus status;
  final List<Book> books;
  final int selectedBookIndex;
  final int page;
  final Exception? error;
  final bool canLoadMore;

  Book get selectedBook => books[selectedBookIndex];

  const BookState._({
    this.status = BookStateStatus.initial,
    this.books = const [],
    this.selectedBookIndex = 0,
    this.page = 1,
    this.error,
    this.canLoadMore = true,
  });

  const BookState.initial() : this._();

  BookState asLoading() {
    return copyWith(
      status: BookStateStatus.loading,
    );
  }

  BookState asLoadSuccess(List<Book> books, {bool canLoadMore = true}) {
    return copyWith(
      status: BookStateStatus.loadSuccess,
      books: books,
      page: 1,
      canLoadMore: canLoadMore,
    );
  }

  BookState asLoadFailure(Exception e) {
    return copyWith(
      status: BookStateStatus.loadFailure,
      error: e,
    );
  }

  BookState asLoadingMore() {
    return copyWith(status: BookStateStatus.loadingMore);
  }

  BookState asLoadMoreSuccess(List<Book> newBooks, {bool canLoadMore = true}) {
    return copyWith(
      status: BookStateStatus.loadMoreSuccess,
      books: [...books, ...newBooks],
      page: canLoadMore ? page + 1 : page,
      canLoadMore: canLoadMore,
    );
  }

  BookState asLoadMoreFailure(Exception e) {
    return copyWith(
      status: BookStateStatus.loadMoreFailure,
      error: e,
    );
  }

  BookState copyWith({
    BookStateStatus? status,
    List<Book>? books,
    int? selectedBookIndex,
    int? page,
    bool? canLoadMore,
    Exception? error,
  }) {
    return BookState._(
      status: status ?? this.status,
      books: books ?? this.books,
      selectedBookIndex: selectedBookIndex ?? this.selectedBookIndex,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      error: error ?? this.error,
    );
  }
}
