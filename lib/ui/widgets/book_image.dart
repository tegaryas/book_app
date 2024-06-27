import 'package:book_app/domain/entities/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  static const Size _cacheMaxSize = Size(700, 700);

  final Book book;
  final EdgeInsets padding;
  final bool useHero;
  final Size size;
  final Color? tintColor;

  const BookImage({
    Key? key,
    required this.book,
    required this.size,
    this.padding = EdgeInsets.zero,
    this.useHero = true,
    this.tintColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeroMode(
      enabled: useHero,
      child: Hero(
        tag: book.id,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuint,
          padding: padding,
          child: CachedNetworkImage(
            imageUrl: book.formats.imageJpeg,
            useOldImageOnUrlChange: true,
            maxWidthDiskCache: _cacheMaxSize.width.toInt(),
            maxHeightDiskCache: _cacheMaxSize.height.toInt(),
            fadeInDuration: const Duration(milliseconds: 120),
            fadeOutDuration: const Duration(milliseconds: 120),
            imageBuilder: (_, image) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: image,
                width: size.width,
                height: size.height,
                alignment: Alignment.bottomCenter,
                color: tintColor,
                fit: BoxFit.cover,
              ),
            ),
            placeholder: (_, __) => Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16)),
            ),
            errorWidget: (_, __, ___) => Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(16)),
                ),
                Icon(
                  Icons.warning_amber_rounded,
                  size: size.width * 0.3,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
