import 'package:book_app/configs/colors.dart';
import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/domain/entities/format.dart';
import 'package:book_app/routes.dart';
import 'package:book_app/states/book/book_bloc.dart';
import 'package:book_app/states/favorite/favorite_cubit.dart';
import 'package:book_app/ui/widgets/book_image.dart';
import 'package:book_app/ui/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class BookInfoScreen extends StatefulWidget {
  final Book book;
  const BookInfoScreen({super.key, required this.book});

  @override
  State<BookInfoScreen> createState() => _BookInfoScreenState();
}

class _BookInfoScreenState extends State<BookInfoScreen> {
  BookBloc get bookBloc => context.read<BookBloc>();
  FavoriteCubit get favoriteBloc => context.read<FavoriteCubit>();

  @override
  void initState() {
    favoriteBloc.init(widget.book);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showBook(widget.book.formats),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                          color: AppColors.purple,
                          borderRadius: BorderRadius.circular(16)),
                      child: const Center(child: Text("See Book")),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  if (state is FavoriteSelected) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => removeFromFavorite(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                              child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )),
                        ),
                      ),
                    );
                  }
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => addToFavorite(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Center(child: Icon(Icons.favorite)),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookImage(
              book: widget.book,
              size: const Size(100, 150),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "(${widget.book.downloadCount} downloads)",
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.book.title,
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.book.authors.map((e) => e.name).toList().join(","),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.semiGrey,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        if (widget.book.bookshelves.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            "Genre and Tags",
            maxLines: 3,
            style: TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              ...List.generate(
                widget.book.bookshelves.length,
                (index) {
                  final subject = widget.book.bookshelves[index];

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: index.isEven
                        ? const EdgeInsets.only(right: 10, bottom: 10)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      subject,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                },
              )
            ],
          )
        ]
      ],
    );
  }

  void showBook(Format formats) {
    if (formats.textHtml != "") {
      launchUrl(Uri.parse(formats.textHtml));
    } else if (formats.textPlain != "") {
      launchUrl(Uri.parse(formats.textPlain));
    } else {
      _showMyDialog();
    }
  }

  void addToFavorite() {
    favoriteBloc.onAddToFavorite(widget.book);
  }

  void removeFromFavorite() {
    favoriteBloc.onRemoveFromFavorite(widget.book);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No viewable version available'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                AppNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
