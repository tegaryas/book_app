import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/states/favorite_book/favorite_book_bloc.dart';
import 'package:book_app/states/favorite_book/favorite_book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBookStateSelector<T>
    extends BlocSelector<FavoriteBookBloc, FavoriteBookState, T> {
  FavoriteBookStateSelector({
    super.key,
    required T Function(FavoriteBookState) selector,
    required Widget Function(T) builder,
  }) : super(
          selector: selector,
          builder: (_, value) => builder(value),
        );
}

class FavoriteBookStateStatusSelector
    extends FavoriteBookStateSelector<FavoriteBookStateStatus> {
  FavoriteBookStateStatusSelector(
      Widget Function(FavoriteBookStateStatus) builder,
      {super.key})
      : super(
          selector: (state) => state.status,
          builder: builder,
        );
}

class FavoriteBookCanLoadMoreSelector extends FavoriteBookStateSelector<bool> {
  FavoriteBookCanLoadMoreSelector(Widget Function(bool) builder, {super.key})
      : super(
          selector: (state) => state.canLoadMore,
          builder: builder,
        );
}

class NumberOfFavoriteBooksSelector extends FavoriteBookStateSelector<int> {
  NumberOfFavoriteBooksSelector(Widget Function(int) builder, {super.key})
      : super(
          selector: (state) => state.books.length,
          builder: builder,
        );
}

class CurrentFavoriteBookSelector extends FavoriteBookStateSelector<Book> {
  CurrentFavoriteBookSelector(Widget Function(Book) builder, {super.key})
      : super(
          selector: (state) => state.selectedFavoriteBook,
          builder: builder,
        );
}

class FavoriteBookSelector
    extends FavoriteBookStateSelector<FavoriteBookSelectorState> {
  FavoriteBookSelector(int index, Widget Function(Book, bool) builder,
      {super.key})
      : super(
          selector: (state) => FavoriteBookSelectorState(
            state.books[index],
            state.selectedFavoriteBookIndex == index,
          ),
          builder: (value) => builder(value.book, value.selected),
        );
}

class FavoriteBookSelectorState {
  final Book book;
  final bool selected;

  const FavoriteBookSelectorState(this.book, this.selected);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is FavoriteBookSelectorState &&
      book == other.book &&
      selected == other.selected;
}
