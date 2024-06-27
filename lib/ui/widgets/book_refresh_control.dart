import 'package:book_app/configs/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookRefreshControl extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const BookRefreshControl({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: (_, __, ___, ____, _____) => const Center(
          child: CircularProgressIndicator(color: AppColors.purple)),
    );
  }
}
