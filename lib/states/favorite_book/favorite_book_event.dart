abstract class FavoriteBookEvent {
  const FavoriteBookEvent();
}

class FavoriteBookLoadStarted extends FavoriteBookEvent {
  final bool loadAll;

  const FavoriteBookLoadStarted({this.loadAll = false});
}

class FavoriteBookLoadMoreStarted extends FavoriteBookEvent {}

class FavoriteBookSelectChanged extends FavoriteBookEvent {
  final int bookId;

  const FavoriteBookSelectChanged({required this.bookId});
}
