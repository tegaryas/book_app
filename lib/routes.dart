import 'package:book_app/core/fade_page_route.dart';
import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/ui/screens/book_info/book_info.dart';
import 'package:book_app/ui/screens/book_search/book_search.dart';
import 'package:book_app/ui/screens/favorite/favorite.dart';
import 'package:book_app/ui/screens/home/home.dart';
import 'package:book_app/ui/screens/splash/splash.dart';
import 'package:flutter/material.dart';

enum Routes { splash, home, books, bookInfo, favoriteBooks, searchBooks }

class _Paths {
  static const String splash = '/';
  static const String home = '/home';
  static const String bookInfo = '/home/book';
  static const String favoriteBooks = '/home/favorite';
  static const String searchBooks = '/home/search';

  static const Map<Routes, String> _pathMap = {
    Routes.splash: _Paths.splash,
    Routes.home: _Paths.home,
    Routes.bookInfo: _Paths.bookInfo,
    Routes.favoriteBooks: _Paths.favoriteBooks,
    Routes.searchBooks: _Paths.searchBooks
  };

  static String of(Routes route) => _pathMap[route] ?? splash;
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Paths.splash:
        return FadeRoute(page: const SplashScreen());

      case _Paths.bookInfo:
        return FadeRoute(
            page: BookInfoScreen(
          book: settings.arguments as Book,
        ));

      case _Paths.searchBooks:
        return FadeRoute(page: const BookSearchScreen());

      case _Paths.favoriteBooks:
        return FadeRoute(page: const FavoriteScreen());

      case _Paths.home:
      default:
        return FadeRoute(page: const HomeScreen());
    }
  }

  static Future? push<T>(Routes route, [T? arguments]) =>
      state?.pushNamed(_Paths.of(route), arguments: arguments);

  static Future? replaceWith<T>(Routes route, [T? arguments]) =>
      state?.pushReplacementNamed(_Paths.of(route), arguments: arguments);

  static void pop() => state?.pop();

  static NavigatorState? get state => navigatorKey.currentState;
}
