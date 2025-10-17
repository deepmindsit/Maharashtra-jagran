import '../utils/exported_path.dart';

class NewsListByTags extends StatefulWidget {
  const NewsListByTags({super.key});

  @override
  State<NewsListByTags> createState() => _NewsListByTagsState();
}

class _NewsListByTagsState extends State<NewsListByTags> {
  final controller = getIt<NewsController>();

  @override
  void initState() {
    controller.tagId.value = Get.arguments['tagId'].toString();
    controller.tagName.value = Get.arguments['tagName'].toString();
    controller.getNewsByTag(controller.tagId.value);
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
          title: controller.tagName.value,
          fontSize: 22.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        // Image.asset(Images.logoWhite, width: 0.5.sw),
        centerTitle: true,
      ),
      body: Obx(
        () =>
            controller.isTagFirstLoadRunning.isTrue
                ? LoadingWidget(color: primaryColor)
                : controller.tagNewsList.isEmpty
                ? noDataFound()
                : Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.pixels ==
                              scrollNotification.metrics.maxScrollExtent) {
                        controller.getNewsMoreTag(controller.tagId.value);
                      }
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bounceable(
                            onTap: () {
                              Get.toNamed(
                                Routes.newsDetails,
                                arguments: {
                                  'newsId':
                                      controller.tagNewsList.first['id']
                                          .toString(),
                                },
                              );
                            },
                            child: OverlayNewsCard(
                              width: 1.sw,
                              isBookmarked:
                                  controller.tagNewsList.first['is_bookmarked'] ??
                                  false,
                              image:
                                  controller.tagNewsList.first['image']
                                      ?.toString() ??
                                  'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
                              title:
                                  controller.tagNewsList.first['title']
                                      ?.toString() ??
                                  "-",
                              date:
                                  controller.tagNewsList.first['date_published']
                                      ?.toString() ??
                                  "ऑगस्ट 19, 2025",
                              comment:
                                  controller.tagNewsList.first['comments_count']
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
                                      controller.tagNewsList[0]['is_bookmarked'] ??
                                      false;

                                  // Optimistic UI update
                                  controller.tagNewsList[0]['is_bookmarked'] =
                                      !isCurrentlyBookmarked;
                                  controller.tagNewsList.refresh();
                                  try {
                                    if (!isCurrentlyBookmarked) {
                                      await getIt<BookmarkController>()
                                          .addBookmark(
                                            controller.tagNewsList[0]['id']
                                                .toString(),
                                          );
                                    } else {
                                      await getIt<BookmarkController>()
                                          .removeBookmark(
                                            controller.tagNewsList[0]['id']
                                                .toString(),
                                          );
                                    }
                                  } catch (e) {
                                    controller.tagNewsList[0]['is_bookmarked'] =
                                        isCurrentlyBookmarked;
                                    controller.tagNewsList.refresh();

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
                            controller.tagNewsList.sublist(1),
                          ),

                          controller.tagNewsList.isEmpty
                              ? const SizedBox()
                              : buildLoader(),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget buildLoader() {
    if (controller.isTagLoadMoreRunning.value) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: LoadingWidget(color: primaryColor),
      );
    } else if (!controller.hasTagMore.value) {
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
            image:
                news['image']?.toString() ??
                'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
            title: news['title']?.toString() ?? "-",
            date: news['date']?.toString() ?? "ऑगस्ट 19, 2025",
            comment: news['comments_count']?.toString() ?? "0",
          ),
        );
      },
    );
  }
}
