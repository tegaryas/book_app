import 'package:book_app/configs/colors.dart';
import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/routes.dart';
import 'package:book_app/states/search/search_cubit.dart';
import 'package:book_app/ui/widgets/book_image.dart';
import 'package:book_app/ui/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({Key? key}) : super(key: key);

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  @override
  void initState() {
    context.read<SearchCubit>().reset();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void _onPressClear() {
    _searchTextController.clear();
    context.read<SearchCubit>().reset();
  }

  void _getSearchBooks(String query) {
    if (query.isEmpty) {
      _onPressClear();
    } else {
      context.read<SearchCubit>().onSearchBook(query);
    }
  }

  void _onPressBook(Book? book) {
    if (book != null) {
      AppNavigator.push(Routes.bookInfo, book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          const SliverAppBar(
            centerTitle: false,
            title: Text("Search", style: TextStyle(color: Colors.white)),
          ),
          SliverToBoxAdapter(
            child: MainSearchBar(
              enabled: true,
              onChange: (query) => _getSearchBooks(query),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            ),
          ),
        ],
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return _buildLoading(context);
            } else if (state is SearchLoaded) {
              if (state.books.isEmpty) {
                return _buildSearchEmpty();
              }
              return _buildSearchList(state);
            } else if (state is SearchInitial) {
              return _buildInitital();
            } else {
              return _buildFailed();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFailed() {
    return const Center(
      child: Text(
        "Search Failed",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildInitital() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Gutendex',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              'Search a book that you want to find',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Gutendex',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              'The book you are looking for cannot be found',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchList(SearchLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 0,
        mainAxisExtent: 275,
      ),
      itemBuilder: (context, index) {
        final book = state.books[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _onPressBook(book);
            },
            splashColor: Colors.white10,
            highlightColor: Colors.white10,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookImage(
                  book: book,
                  size: const Size(100, 150),
                ),
                const SizedBox(height: 5),
                Flexible(
                    child: Text(
                  book.title,
                  maxLines: 3,
                  style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600),
                )),
                const SizedBox(height: 5),
                Flexible(
                    child: Text(
                  book.authors.map((e) => e.name).toList().join(","),
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.semiGrey,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.normal,
                  ),
                )),
              ],
            ),
          ),
        );
      },
      itemCount: state.books.length,
    );
  }
}
