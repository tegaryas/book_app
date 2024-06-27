import 'package:book_app/domain/entities/book.dart';

enum FavoriteBookStateStatus {
  initial,
  loading,
  loadSuccess,
  loadFailure,
  loadingMore,
  loadMoreSuccess,
  loadMoreFailure,
}

class FavoriteBookState {
  final FavoriteBookStateStatus status;
  final List<Book> books;
  final int selectedFavoriteBookIndex;
  final int page;
  final Exception? error;
  final bool canLoadMore;

  Book get selectedFavoriteBook => books[selectedFavoriteBookIndex];

  const FavoriteBookState._({
    this.status = FavoriteBookStateStatus.initial,
    this.books = const [],
    this.selectedFavoriteBookIndex = 0,
    this.page = 1,
    this.error,
    this.canLoadMore = true,
  });

  const FavoriteBookState.initial() : this._();

  FavoriteBookState asLoading() {
    return copyWith(
      status: FavoriteBookStateStatus.loading,
    );
  }

  FavoriteBookState asLoadSuccess(List<Book> books, {bool canLoadMore = true}) {
    return copyWith(
      status: FavoriteBookStateStatus.loadSuccess,
      books: books,
      page: 1,
      canLoadMore: canLoadMore,
    );
  }

  FavoriteBookState asLoadFailure(Exception e) {
    return copyWith(
      status: FavoriteBookStateStatus.loadFailure,
      error: e,
    );
  }

  FavoriteBookState asLoadingMore() {
    return copyWith(status: FavoriteBookStateStatus.loadingMore);
  }

  FavoriteBookState asLoadMoreSuccess(List<Book> newFavoriteBooks,
      {bool canLoadMore = true}) {
    return copyWith(
      status: FavoriteBookStateStatus.loadMoreSuccess,
      books: [...books, ...newFavoriteBooks],
      page: canLoadMore ? page + 1 : page,
      canLoadMore: canLoadMore,
    );
  }

  FavoriteBookState asLoadMoreFailure(Exception e) {
    return copyWith(
      status: FavoriteBookStateStatus.loadMoreFailure,
      error: e,
    );
  }

  FavoriteBookState copyWith({
    FavoriteBookStateStatus? status,
    List<Book>? books,
    int? selectedFavoriteBookIndex,
    int? page,
    bool? canLoadMore,
    Exception? error,
  }) {
    return FavoriteBookState._(
      status: status ?? this.status,
      books: books ?? this.books,
      selectedFavoriteBookIndex:
          selectedFavoriteBookIndex ?? this.selectedFavoriteBookIndex,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      error: error ?? this.error,
    );
  }
}
