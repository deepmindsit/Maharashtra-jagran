import 'package:maharashtrajagran/utils/exported_path.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  final controller = getIt<BookmarkController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getBookmark();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(
        () =>
            controller.isFirstLoadRunning.isTrue
                ? LoadingWidget(color: primaryColor)
                : controller.bookmarkList.isEmpty
                ? noDataFound()
                : Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.pixels ==
                              scrollNotification.metrics.maxScrollExtent) {
                        controller.getMoreBookmark();
                      }
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildBookmarks(),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: primaryColor,
      title: Image.asset(Images.logoWhite, width: 0.5.sw),
    );
  }

  Widget buildLoader() {
    if (controller.isLoadMoreRunning.value) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: LoadingWidget(color: primaryColor),
      );
    } else if (!controller.hasMore.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget noDataFound() {
    return Center(
      child: SizedBox(
        width: Get.width * 0.5.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty_box.png'),
            const SizedBox(height: 20),
            const Text('No Bookmarks Found'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarks() {
    return ListView.builder(
      shrinkWrap: true,
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.bookmarkList.length,
      itemBuilder: (context, index) {
        final bookmark = controller.bookmarkList[index];
        return Bounceable(
          onTap: () {
            Get.toNamed(
              Routes.newsDetails,
              arguments: {'newsId': bookmark['id'].toString()},
            );
          },
          child: HorizontalNewsCard(
            isBookmarked: bookmark['is_bookmarked'] ?? false,
            image: bookmark['featured_image'] ?? '',
            title: bookmark['title'] ?? "-",
            date: bookmark['date_published'] ?? "",
            comment: bookmark['comments_count'] ?? '0',
            onTap: () async {
              final isCurrentlyBookmarked = bookmark['is_bookmarked'] ?? false;

              // Optimistic UI update
              controller.bookmarkList[index]['is_bookmarked'] =
                  !isCurrentlyBookmarked;
              controller.bookmarkList.refresh();
              try {
                if (!isCurrentlyBookmarked) {
                  // Add bookmark

                  await getIt<BookmarkController>().addBookmark(
                    bookmark['id'].toString(),
                  );
                } else {
                  // Remove bookmark
                  await getIt<BookmarkController>().removeBookmark(
                    bookmark['id'].toString(),
                  );
                }
                await controller.getBookmark(isLoading: false);
              } catch (e) {
                // If API fails, rollback UI state
                controller.bookmarkList[index]['is_bookmarked'] =
                    isCurrentlyBookmarked;
                controller.bookmarkList.refresh();

                // debugPrint("Bookmark error: $e");
                Get.snackbar(
                  "Error",
                  "Something went wrong. कृपया पुन्हा प्रयत्न करा.",
                );
              }
            },
          ),
        );
      },
    );
  }
}
