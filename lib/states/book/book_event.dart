abstract class BookEvent {
  const BookEvent();
}

class BookLoadStarted extends BookEvent {
  final bool loadAll;

  const BookLoadStarted({this.loadAll = false});
}

class BookLoadMoreStarted extends BookEvent {}

class BookSelectChanged extends BookEvent {
  final int bookId;

  const BookSelectChanged({required this.bookId});
}
