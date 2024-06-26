import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/states/book/book_bloc.dart';
import 'package:book_app/states/book/book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookStateSelector<T> extends BlocSelector<BookBloc, BookState, T> {
  BookStateSelector({
    super.key,
    required T Function(BookState) selector,
    required Widget Function(T) builder,
  }) : super(
          selector: selector,
          builder: (_, value) => builder(value),
        );
}

class BookStateStatusSelector extends BookStateSelector<BookStateStatus> {
  BookStateStatusSelector(Widget Function(BookStateStatus) builder, {super.key})
      : super(
          selector: (state) => state.status,
          builder: builder,
        );
}

class BookCanLoadMoreSelector extends BookStateSelector<bool> {
  BookCanLoadMoreSelector(Widget Function(bool) builder, {super.key})
      : super(
          selector: (state) => state.canLoadMore,
          builder: builder,
        );
}

class NumberOfBooksSelector extends BookStateSelector<int> {
  NumberOfBooksSelector(Widget Function(int) builder, {super.key})
      : super(
          selector: (state) => state.books.length,
          builder: builder,
        );
}

class CurrentBookSelector extends BookStateSelector<Book> {
  CurrentBookSelector(Widget Function(Book) builder, {super.key})
      : super(
          selector: (state) => state.selectedBook,
          builder: builder,
        );
}

class BookSelector extends BookStateSelector<BookSelectorState> {
  BookSelector(int index, Widget Function(Book, bool) builder, {super.key})
      : super(
          selector: (state) => BookSelectorState(
            state.books[index],
            state.selectedBookIndex == index,
          ),
          builder: (value) => builder(value.book, value.selected),
        );
}

class BookSelectorState {
  final Book book;
  final bool selected;

  const BookSelectorState(this.book, this.selected);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is BookSelectorState &&
      book == other.book &&
      selected == other.selected;
}
