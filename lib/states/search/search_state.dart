part of 'search_cubit.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Book> books;

  SearchLoaded({required this.books});
}

class SearchFailed extends SearchState {}
