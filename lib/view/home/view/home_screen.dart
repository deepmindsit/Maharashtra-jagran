import 'package:maharashtrajagran/utils/exported_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = getIt<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getDashboard().then((v) {
        controller.loadSelectedCategories();
      });
      getIt<UpdateController>().checkForUpdate();
    });

    getIt<FirebaseTokenController>().updateToken();
    NotificationService().requestNotificationPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.isTrue
              ? Container(
                color: Colors.white,
                child: LoadingWidget(color: primaryColor),
              )
              : Scaffold(
                key: controller.scaffoldKey,
                backgroundColor: Colors.white,
                appBar: _buildAppBar(),
                drawer: CustomDrawer(),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTopCategories(),

                      CustomHeadline(
                        title: 'ताज्या बातम्या',
                        onTap: () {},
                        showMore: false,
                        color: primaryGreen,
                      ),
                      _buildRecentNews(),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.preferredNewsData.length,
                        itemBuilder: (context, index) {
                          final news = controller.preferredNewsData[index];
                          final widgetBuilder =
                              widgetsCycle[index % widgetsCycle.length];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomHeadline(
                                title: news['category_name'] ?? '',
                                onTap: () {
                                  Get.toNamed(
                                    Routes.newsList,
                                    arguments: {
                                      'catId': news['category_id'] ?? '',
                                      'catName': news['category_name'] ?? '',
                                    },
                                  );
                                },
                                color: primaryColor,
                              ),
                              widgetBuilder(news['news'], index),
                            ],
                          );
                        },
                      ),
                      _buildUpdateCategory(),
                    ],
                  ),
                ),
              ),
    );
  }

  // Cycle widgets list
  final List<Widget Function(dynamic, int)> widgetsCycle = [
    _buildMaharashtraNews,
    _buildHealthNews,
    _buildSportsNews,
  ];

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: primaryColor,
      centerTitle: true,
      title: Image.asset(Images.logoWhite, width: 0.5.sw),
      leading: IconButton(
        icon: Icon(HugeIcons.strokeRoundedMenu02),
        onPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(30.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            spacing: 8,
            children: [
              CustomText(
                title: 'Breaking news >',
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              Expanded(
                child: Obx(() {
                  final data = controller.marqueeData;
                  if (data.isEmpty) {
                    return SizedBox(
                      height: 30,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 30,
                    child: InfiniteMarquee(
                      frequency: const Duration(milliseconds: 30),
                      itemBuilder: (context, index) {
                        final item =
                            controller.marqueeData[index %
                                controller.marqueeData.length];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.newsDetails,
                                  arguments: {'newsId': item['id'].toString()},
                                );
                              },
                              child: CustomText(
                                title: item['title'] ?? '',
                                color: Colors.white,
                                textAlign: TextAlign.start,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(width: 70.w),
                          ],
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Get.toNamed(Routes.notificationList),
          child: Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.all(8.w).copyWith(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              HugeIcons.strokeRoundedNotification02,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),

        GestureDetector(
          onTap: () => Get.toNamed(Routes.newsListBySearch),
          child: Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.all(8.w).copyWith(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              HugeIcons.strokeRoundedSearch01,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategories() {
    return Container(
      height: Get.height * 0.05.h,
      decoration: BoxDecoration(color: primaryOrange),
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.only(left: 8),
          scrollDirection: Axis.horizontal,
          itemCount:
              // controller.categoriesData.length > 5
              //     ? 5
              //     :
              controller.categoriesData.length,
          itemBuilder: (context, index) {
            final category1 = controller.categoriesData[index];

            return Obx(
              () => GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.newsList,
                    arguments: {
                      'catId': category1['id']?.toString() ?? '',
                      'catName': category1['title'] ?? '',
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CustomText(
                        title: category1['title'].toString(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            controller.selectedIndex.value == index
                                ? primaryColor
                                : primaryGrey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentNews() {
    return Obx(
      () => SizedBox(
        height: 270.h,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          itemCount: controller.recentNewsData.length,
          itemBuilder: (context, index) {
            final news = controller.recentNewsData[index];
            return Bounceable(
              onTap: () {
                Get.toNamed(
                  Routes.newsDetails,
                  arguments: {'newsId': news['id'].toString()},
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: MainNewsCard(
                  isBookmarked: news['is_bookmarked'] ?? false,
                  image: news['featured_image']?.toString() ?? '',
                  title: news['title']?.toString() ?? "-",
                  date: news['date_published']?.toString() ?? "",
                  comment: news['comments_count']?.toString() ?? "0",
                  onTap: () async {
                    if (!await LocalStorage().isDemo()) {
                      Get.snackbar(
                        "सूचना",
                        "Login आवश्यक आहे.",
                        colorText: Colors.white,
                      );
                    } else {
                      final isCurrentlyBookmarked =
                          controller.recentNewsData[index]['is_bookmarked'] ??
                          false;

                      // Optimistic UI update
                      controller.recentNewsData[index]['is_bookmarked'] =
                          !isCurrentlyBookmarked;
                      controller.recentNewsData.refresh();
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
                        controller.recentNewsData[index]['is_bookmarked'] =
                            isCurrentlyBookmarked;
                        controller.recentNewsData.refresh();

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
            );
          },
        ),
      ),
    );
  }

  static Widget _buildMaharashtraNews(dynamic data, int i) {
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
            image: news['featured_image']?.toString() ?? '',
            title: news['title']?.toString() ?? "-",
            date: news['date_published']?.toString() ?? "",
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
                getIt<HomeController>()
                        .preferredNewsData[i]['news'][index]['is_bookmarked'] =
                    !isCurrentlyBookmarked;
                getIt<HomeController>().preferredNewsData.refresh();
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
                  getIt<HomeController>()
                          .preferredNewsData[i]['news'][index]['is_bookmarked'] =
                      isCurrentlyBookmarked;
                  getIt<HomeController>().preferredNewsData.refresh();

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

  static Widget _buildHealthNews(dynamic data, int i) {
    return SizedBox(
      height: Get.height * 0.28.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
            child: CompactNewsCard(
              isBookmarked: news['is_bookmarked'] ?? false,
              image: news['featured_image']?.toString() ?? '',
              title: news['title']?.toString() ?? "-",
              date: news['date_published']?.toString() ?? "",
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
                  getIt<HomeController>()
                          .preferredNewsData[i]['news'][index]['is_bookmarked'] =
                      !isCurrentlyBookmarked;
                  getIt<HomeController>().preferredNewsData.refresh();
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
                    getIt<HomeController>()
                            .preferredNewsData[i]['news'][index]['is_bookmarked'] =
                        isCurrentlyBookmarked;
                    getIt<HomeController>().preferredNewsData.refresh();

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
      ),
    );
  }

  static Widget _buildSportsNews(dynamic data, int i) {
    return SizedBox(
      height: Get.height * 0.25.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
            child: OverlayNewsCard(
              width: 0.8.sw,
              isBookmarked: news['is_bookmarked'] ?? false,
              image: news['featured_image']?.toString() ?? '',
              title: news['title']?.toString() ?? "-",
              date: news['date_published']?.toString() ?? "",
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
                  getIt<HomeController>()
                          .preferredNewsData[i]['news'][index]['is_bookmarked'] =
                      !isCurrentlyBookmarked;
                  getIt<HomeController>().preferredNewsData.refresh();
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
                    getIt<HomeController>()
                            .preferredNewsData[i]['news'][index]['is_bookmarked'] =
                        isCurrentlyBookmarked;
                    getIt<HomeController>().preferredNewsData.refresh();

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
      ),
    );
  }

  Widget _buildUpdateCategory() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w).copyWith(top: 12),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'तुमच्या आवडीचे विषय निवडा',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: primaryGrey,
            ),
            SizedBox(
              height: Get.height * 0.18.h, // Height for 3 rows
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select All button (optional)
                    // if (controller.categories.isNotEmpty)
                    //   GestureDetector(
                    //     onTap: () {
                    //       if (controller.selectedCategories.length ==
                    //           controller.categories.length) {
                    //         controller.clearSelection();
                    //       } else {
                    //         controller.selectAllCategories();
                    //       }
                    //     },
                    //     child: Container(
                    //       margin: EdgeInsets.only(bottom: 8),
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 14,
                    //         vertical: 10,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color:
                    //             controller.selectedCategories.length ==
                    //                     controller.categories.length
                    //                 ? Colors.green.shade100
                    //                 : Colors.grey.shade100,
                    //         border: Border.all(
                    //           color:
                    //               controller.selectedCategories.length ==
                    //                       controller.categories.length
                    //                   ? Colors.green
                    //                   : Colors.grey,
                    //         ),
                    //         borderRadius: BorderRadius.circular(25),
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(
                    //             controller.selectedCategories.length ==
                    //                     controller.categories.length
                    //                 ? Icons.check_box_rounded
                    //                 : Icons.check_box_outline_blank_rounded,
                    //             size: 16,
                    //             color:
                    //                 controller.selectedCategories.length ==
                    //                         controller.categories.length
                    //                     ? Colors.green.shade700
                    //                     : Colors.grey,
                    //           ),
                    //           SizedBox(width: 4),
                    //           Text(
                    //             'Select All',
                    //             style: TextStyle(
                    //               color:
                    //                   controller.selectedCategories.length ==
                    //                           controller.categories.length
                    //                       ? Colors.green.shade700
                    //                       : Colors.black,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),

                    // Categories in 3 columns with horizontal scrolling
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          direction: Axis.vertical,
                          runSpacing: 8,
                          spacing: 8,
                          children:
                              controller.categoriesData.map((cat) {
                                final isSelected = controller.selectedCategories
                                    .contains(cat["id"]);
                                return Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap:
                                        () => controller.toggleCategory(
                                          cat["id"] as int,
                                        ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? primaryColor
                                                  : Colors.grey,
                                          width: isSelected ? 2 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            cat["title"].toString(),
                                            style: TextStyle(
                                              color:
                                                  isSelected
                                                      ? primaryLightGrey
                                                      : Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: () async {
                  await controller.getDashboard();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: CustomText(
                  title: "तुमचं होमपेज अपडेट करा",
                  fontSize: 16.sp,
                  color: primaryGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
