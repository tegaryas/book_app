part of '../home.dart';

class _BookGrid extends StatefulWidget {
  const _BookGrid();

  @override
  _BookGridState createState() => _BookGridState();
}

class _BookGridState extends State<_BookGrid> {
  static const double _endReachedThreshold = 200;

  final GlobalKey<NestedScrollViewState> _scrollKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  BookBloc get bookBloc => context.read<BookBloc>();

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      bookBloc.add(const BookLoadStarted());
      _scrollKey.currentState?.innerController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollKey.currentState?.innerController.dispose();
    _scrollKey.currentState?.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _onScroll() {
    final innerController = _scrollKey.currentState?.innerController;

    if (innerController == null || !innerController.hasClients) return;

    final thresholdReached =
        innerController.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      bookBloc.add(BookLoadMoreStarted());
    }
  }

  Future _onRefresh() async {
    bookBloc.add(const BookLoadStarted());

    return bookBloc.stream
        .firstWhere((e) => e.status != BookStateStatus.loading);
  }

  void _onBookPress(Book book) {
    bookBloc.add(BookSelectChanged(bookId: book.id));

    AppNavigator.push(Routes.bookInfo, book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: AppColors.purple,
        child: const Icon(Icons.keyboard_arrow_up),
      ),
      body: NestedScrollView(
        key: _scrollKey,
        controller: _scrollController,
        headerSliverBuilder: (_, __) => [
          MainSliverAppBar(
            context: context,
            onTrailingPress: () {
              AppNavigator.push(Routes.favoriteBooks);
            },
          ),
          SliverToBoxAdapter(
              child: GestureDetector(
            onTap: () {
              AppNavigator.push(Routes.searchBooks);
            },
            child: const MainSearchBar(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            ),
          )),
        ],
        body: BookStateStatusSelector((status) {
          switch (status) {
            case BookStateStatus.loading:
              return _buildLoading();

            case BookStateStatus.loadSuccess:
            case BookStateStatus.loadMoreSuccess:
            case BookStateStatus.loadingMore:
              return _buildGrid();

            case BookStateStatus.loadFailure:
            case BookStateStatus.loadMoreFailure:
              return _buildError();

            default:
              return Container();
          }
        }),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.purple),
    );
  }

  Widget _buildGrid() {
    return CustomScrollView(
      slivers: [
        BookRefreshControl(onRefresh: _onRefresh),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: NumberOfBooksSelector((numberOfBooks) {
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 0,
                mainAxisExtent: 275,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return BookSelector(index, (book, _) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _onBookPress(book);
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
                              book.authors
                                  .map((e) => e.name)
                                  .toList()
                                  .join(","),
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
                  });
                },
                childCount: numberOfBooks,
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: BookCanLoadMoreSelector((canLoadMore) {
            if (!canLoadMore) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.only(bottom: 28),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: AppColors.purple),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildError() {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Container(
            padding: const EdgeInsets.only(bottom: 28),
            alignment: Alignment.center,
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.black26,
            ),
          ),
        ),
      ],
    );
  }
}
