import 'package:maharashtrajagran/utils/exported_path.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final controller = getIt<NewsController>();

  @override
  void initState() {
    controller.categoryId.value = Get.arguments['catId'].toString();
    controller.categoryName.value = Get.arguments['catName'].toString();
    controller.getNewsByCategory(controller.categoryId.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        backgroundColor: primaryColor,
        title: CustomText(
          title: controller.categoryName.value,
          fontSize: 22.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        // Image.asset(Images.logoWhite, width: 0.5.sw),
        centerTitle: true,
      ),
      body: Obx(
        () =>
            controller.isFirstLoadRunning.isTrue
                ? LoadingWidget(color: primaryColor)
                : controller.newsList.isEmpty
                ? noDataFound()
                : Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.pixels ==
                              scrollNotification.metrics.maxScrollExtent) {
                        controller.getNewsMoreCategory(
                          controller.categoryId.value,
                        );
                      }
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Bounceable(
                              onTap: () {
                                Get.toNamed(
                                  Routes.newsDetails,
                                  arguments: {
                                    'newsId':
                                        controller.newsList.first['id']
                                            .toString(),
                                  },
                                );
                              },
                              child: OverlayNewsCard(
                                width: 1.sw,
                                isBookmarked:
                                    controller
                                        .newsList
                                        .first['is_bookmarked'] ??
                                    false,
                                image:
                                    controller.newsList.first['image']
                                        ?.toString() ??
                                    '',
                                title:
                                    controller.newsList.first['title']
                                        ?.toString() ??
                                    "-",
                                date:
                                    controller.newsList.first['date']
                                        ?.toString() ??
                                    "",
                                comment:
                                    controller.newsList.first['comments_count']
                                        ?.toString() ??
                                    "0",
                                onTap: () async {
                                  if (!await LocalStorage().isDemo()) {
                                    Get.snackbar(
                                      "सूचना",
                                      "Login आवश्यक आहे.",
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    final isCurrentlyBookmarked =
                                        controller
                                            .newsList[0]['is_bookmarked'] ??
                                        false;

                                    // Optimistic UI update
                                    controller.newsList[0]['is_bookmarked'] =
                                        !isCurrentlyBookmarked;
                                    controller.newsList.refresh();
                                    try {
                                      if (!isCurrentlyBookmarked) {
                                        await getIt<BookmarkController>()
                                            .addBookmark(
                                              controller.newsList[0]['id']
                                                  .toString(),
                                            );
                                      } else {
                                        await getIt<BookmarkController>()
                                            .removeBookmark(
                                              controller.newsList[0]['id']
                                                  .toString(),
                                            );
                                      }
                                    } catch (e) {
                                      controller.newsList[0]['is_bookmarked'] =
                                          isCurrentlyBookmarked;
                                      controller.newsList.refresh();

                                      // debugPrint("Bookmark error: $e");
                                      Get.snackbar(
                                        "Error",
                                        "Something went wrong. कृपया पुन्हा प्रयत्न करा.",
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            _buildMaharashtraNews(
                              controller.newsList.sublist(1),
                            ),

                            controller.newsList.isEmpty
                                ? const SizedBox()
                                : buildLoader(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      ),
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
            const Text('No Data Found'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildMaharashtraNews(dynamic data) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final news = data[index];
        return Bounceable(
          onTap: () {
            Get.toNamed(
              Routes.newsDetails,
              arguments: {'newsId': news['id'].toString()},
            );
          },
          child: HorizontalNewsCard(
            isBookmarked: news['is_bookmarked'] ?? false,
            image: news['image']?.toString() ?? '',
            title: news['title']?.toString() ?? "-",
            date: news['date']?.toString() ?? "",
            comment: news['comments_count']?.toString() ?? "0",
            onTap: () async {
              if (!await LocalStorage().isDemo()) {
                Get.snackbar(
                  "सूचना",
                  "Login आवश्यक आहे.",
                  colorText: Colors.white,
                );
              } else {
                final isCurrentlyBookmarked = news['is_bookmarked'] ?? false;

                // Optimistic UI update
                getIt<NewsController>().newsList.sublist(
                      1,
                    )[index]['is_bookmarked'] =
                    !isCurrentlyBookmarked;
                getIt<NewsController>().newsList.refresh();
                try {
                  if (!isCurrentlyBookmarked) {
                    // Add bookmark

                    await getIt<BookmarkController>().addBookmark(
                      news['id'].toString(),
                    );
                  } else {
                    // Remove bookmark
                    await getIt<BookmarkController>().removeBookmark(
                      news['id'].toString(),
                    );
                  }
                } catch (e) {
                  // If API fails, rollback UI state
                  getIt<NewsController>().newsList.sublist(
                        1,
                      )[index]['is_bookmarked'] =
                      !isCurrentlyBookmarked;
                  getIt<NewsController>().newsList.refresh();

                  // debugPrint("Bookmark error: $e");
                  Get.snackbar(
                    "Error",
                    "Something went wrong. कृपया पुन्हा प्रयत्न करा.",
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
