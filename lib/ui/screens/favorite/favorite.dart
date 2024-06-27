import 'dart:async';

import 'package:book_app/configs/colors.dart';
import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/routes.dart';
import 'package:book_app/states/favorite_book/favorite_book_bloc.dart';
import 'package:book_app/states/favorite_book/favorite_book_event.dart';
import 'package:book_app/states/favorite_book/favorite_book_selector.dart';
import 'package:book_app/states/favorite_book/favorite_book_state.dart';
import 'package:book_app/ui/widgets/book_image.dart';
import 'package:book_app/ui/widgets/book_refresh_control.dart';
import 'package:book_app/ui/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sections/book_grid.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _BookGrid());
  }
}
