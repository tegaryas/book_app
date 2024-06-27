import 'package:book_app/routes.dart';
import 'package:book_app/utils/size.dart';
import 'package:flutter/material.dart';

const double mainAppbarPadding = 28;

class MainSliverAppBar extends SliverAppBar {
  static const TextStyle _textStyle = TextStyle(
    // color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: kToolbarHeight / 3,
    height: 1,
  );

  MainSliverAppBar(
      {super.key,
      GlobalKey? appBarKey,
      String title = 'Gutendex',
      double height = kToolbarHeight + mainAppbarPadding * 1,
      double expandedFontSize = 30,
      void Function()? onLeadingPress = AppNavigator.pop,
      void Function()? onTrailingPress,
      required BuildContext context})
      : super(
          centerTitle: true,
          expandedHeight: height,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (onTrailingPress != null)
              IconButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: mainAppbarPadding),
                icon: const Icon(Icons.favorite_border_outlined,
                    color: Colors.white),
                onPressed: onTrailingPress,
              ),
          ],
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final safeAreaTop = MediaQuery.of(context).padding.top;
              final minHeight = safeAreaTop + kToolbarHeight;
              final maxHeight = height + safeAreaTop;

              final percent =
                  (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
              final fontSize = _textStyle.fontSize ?? 16;
              final currentTextStyle = _textStyle.copyWith(
                fontSize: fontSize + (expandedFontSize - fontSize) * percent,
              );

              final textWidth =
                  getTextSize(context, title, currentTextStyle).width;
              const startX = mainAppbarPadding;
              final endX = MediaQuery.of(context).size.width / 2 -
                  textWidth / 2 -
                  startX;
              final dx = startX + endX - endX * percent;

              return Container(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.8 - percent * 0.8),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight / 3),
                      child: Transform.translate(
                        offset:
                            Offset(dx, constraints.maxHeight - kToolbarHeight),
                        child: Text(
                          title,
                          style: currentTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
}

class MainAppBar extends AppBar {
  MainAppBar({
    super.key,
    Widget? title,
    IconData? rightIcon,
    Widget? flexibleSpace,
  }) : super(
          title: title,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: flexibleSpace,
          actions: (rightIcon != null)
              ? <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: mainAppbarPadding),
                    child: Icon(
                      rightIcon,
                      color: Colors.white,
                    ),
                  ),
                ]
              : null,
        );
}
