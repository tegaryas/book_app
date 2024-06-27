import 'package:book_app/domain/entities/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_app/data/repositories/book_repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final BookRepository _bookRepository;

  FavoriteCubit(this._bookRepository) : super(FavoriteNotSelected());

  Future<void> init(Book book) async {
    try {
      emit(FavoriteNotSelected());
      final result = await _bookRepository.getFavoriteBook(book);
      if (result == null) {
        emit(FavoriteNotSelected());
      } else {
        emit(FavoriteSelected());
      }
    } catch (e) {
      emit(FavoriteNotSelected());
    }
  }

  Future<void> onAddToFavorite(Book book) async {
    try {
      emit(FavoriteNotSelected());
      await _bookRepository.saveFavoriteBook(book);
      emit(FavoriteSelected());
    } catch (e) {
      emit(FavoriteNotSelected());
    }
  }

  Future<void> onRemoveFromFavorite(Book book) async {
    try {
      emit(FavoriteSelected());
      await _bookRepository.removeFavoriteBook(book);
      emit(FavoriteNotSelected());
    } catch (e) {
      emit(FavoriteSelected());
    }
  }
}
