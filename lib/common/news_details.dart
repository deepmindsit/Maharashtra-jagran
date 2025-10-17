import 'package:maharashtrajagran/utils/exported_path.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({super.key});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  final controller = getIt<NewsController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      getData(true);
    });

    super.initState();
  }

  Future<void> getData(bool isLoadingData) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getNewsDetails(
        Get.arguments['newsId'].toString(),
        isLoadingData: isLoadingData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Obx(
        () =>
            controller.isLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : RefreshIndicator(
                  onRefresh: () async {
                    await controller.getNewsDetails(
                      Get.arguments['newsId'].toString(),
                    );
                  },
                  child: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              _buildHeaderSection(),
                              // Image Section
                              _buildImageSection(),
                              // Content Section
                              _buildContentSection(),
                            ],
                          ),
                        ),
                        // Comments Section
                        _buildCommentsSection(),
                        // Related News Section
                        _buildRelatedNewsSection(),
                      ],
                    ),
                  ),
                ),
      ),
      // bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: primaryColor,
      title: Image.asset(Images.logoWhite, width: 0.5.sw),
      centerTitle: true,
      actions: [
        Obx(
          () => IconButton(
            onPressed: () async {
              if (!await LocalStorage().isDemo()) {
                Get.snackbar(
                  "सूचना",
                  "Login आवश्यक आहे.",
                  colorText: Colors.white,
                );
              } else {
                final isCurrentlyBookmarked =
                    controller.detailsData['is_bookmarked'] ?? false;

                // Optimistic UI update
                controller.detailsData['is_bookmarked'] =
                    !isCurrentlyBookmarked;
                controller.detailsData.refresh();
                try {
                  if (!isCurrentlyBookmarked) {
                    // Add bookmark

                    await getIt<BookmarkController>().addBookmark(
                      Get.arguments['newsId'].toString(),
                    );
                  } else {
                    // Remove bookmark
                    await getIt<BookmarkController>().removeBookmark(
                      Get.arguments['newsId'].toString(),
                    );
                  }
                  getData(false);
                } catch (e) {
                  // If API fails, rollback UI state
                  controller.detailsData['is_bookmarked'] =
                      !isCurrentlyBookmarked;
                  controller.detailsData.refresh();

                  // debugPrint("Bookmark error: $e");
                  Get.snackbar(
                    "Error",
                    "Something went wrong. कृपया पुन्हा प्रयत्न करा.",
                  );
                }
              }
            },
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.detailsData['is_bookmarked'] == true
                    ? Icons.bookmark_outlined
                    : HugeIcons.strokeRoundedBookmark02,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _shareNews,
          icon: Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              HugeIcons.strokeRoundedShare08,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          CustomText(
            title: controller.detailsData['title'] ?? '-',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            maxLines: 4,
            textAlign: TextAlign.start,
            color: primaryGrey,
          ),
          SizedBox(height: 12.h),
          // Meta Information
          Row(
            children: [
              CustomWithIcon(
                icon: HugeIcons.strokeRoundedClock01,
                title: controller.detailsData['date'] ?? '-',
              ),
              SizedBox(width: 16.w),
              CustomWithIcon(
                icon: HugeIcons.strokeRoundedComment01,
                title:
                    '${controller.detailsData['comments_count']?.toString() ?? '0'} Comments',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            FadeInImage(
              placeholder: AssetImage(Images.defaultImage),
              image: NetworkImage(
                controller.detailsData['image']?.toString() ??
                    'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
              ),
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 220.h,
                  color: Colors.grey[200],
                  child: Image.asset(
                    Images.defaultImage,
                    // Icons.broken_image,
                    // size: 40.sp,
                    // color: Colors.grey[400],
                  ),
                );
              },
              width: double.infinity,
              height: 220.h,
              fit: BoxFit.cover,
            ),
            // Gradient overlay for better text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          HtmlWidget(
            controller.detailsData['description'] ?? '-',
            textStyle: TextStyle(fontSize: 14.sp, height: 1.6),
          ),
          SizedBox(height: 24.h),
          // Tags
          if (controller.detailsData['tags'] != null &&
              controller.detailsData['tags'].isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'टॅग्ज',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: const Color(0xFF1F2937),
                ),
                SizedBox(height: 12.h),
                _buildTags(),
                SizedBox(height: 24.h),
                const Divider(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children:
          controller.detailsData['tags'].map<Widget>((tag) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.newsListByTag,
                  arguments: {
                    'tagId': tag['id']?.toString() ?? '',
                    'tagName': tag['title'] ?? '',
                  },
                );
              },
              child: Chip(
                surfaceTintColor: Colors.white,
                label: CustomText(
                  title: tag['title'] ?? '',
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }).toList(),
    );
  }

  SliverList _buildCommentsSection() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    title: 'प्रतिक्रिया',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    color: primaryGrey,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    title:
                        '(${controller.detailsData['comments_count'] ?? "0"})',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                    color: primaryGrey,
                  ),
                ],
              ),
              ..._buildCommentItem(),
              SizedBox(height: 16.h),
              _buildAddComment(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ]),
    );
  }

  List<Widget> _buildCommentItem() {
    return List.generate(controller.comments.length, (index) {
      return Container(
        padding: EdgeInsets.all(12.r),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE5E7EB),
                radius: 20.r,
                child: Icon(
                  Icons.person,
                  size: 20.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
              title: CustomText(
                title:
                    controller.comments[index]['comment_by'] ??
                    'Maharashtra Jagran',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: const Color(0xFF1F2937),
              ),
              subtitle: CustomText(
                title: controller.comments[index]['date'] ?? 'ऑगस्ट 19, 2025',
                fontSize: 12.sp,
                textAlign: TextAlign.start,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8.h),
            CustomText(
              title: controller.comments[index]['content'] ?? '-',
              fontSize: 14.sp,
              maxLines: 3,
              textAlign: TextAlign.start,
              color: const Color(0xFF374151),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddComment() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: 'प्रतिक्रिया व्यक्त करा',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            color: const Color(0xFF1F2937),
          ),
          SizedBox(height: 8.h),
          CustomText(
            title:
                'आपला ई-मेल अड्रेस प्रकाशित केला जाणार नाही. आवश्यक फील्डस * मार्क केले आहेत',
            fontSize: 12.sp,
            maxLines: 2,
            textAlign: TextAlign.start,
            color: const Color(0xFF6B7280),
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'टिप्पणी*',
            controller: controller.commentController,
            maxLines: 4,
            validator:
                (value) =>
                    value!.trim().isEmpty ? 'कृपया टिप्पणी टाका'.tr : null,
            hintText: 'आपली टिप्पणी येथे टाइप करा...',
          ),
          SizedBox(height: 16.h),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!await LocalStorage().isDemo()) {
                    Get.snackbar(
                      "सूचना",
                      "Login आवश्यक आहे.",
                      colorText: Colors.white,
                    );
                  } else {
                    if (controller.commentController.text.isNotEmpty) {
                      await controller.addNewsComment(
                        Get.arguments['newsId'].toString(),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child:
                    controller.isCommentLoading.isTrue
                        ? LoadingWidget(color: Colors.white)
                        : CustomText(
                          title: "सबमिट",
                    fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildRelatedNewsSection() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        // padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadline(
              title: 'संबंधित लेख',
              onTap: () {},
              showMore: false,
              color: primaryGreen,
            ),

            SizedBox(height: 8.h),
            SizedBox(
              height: 270.h,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.relatedNews.length,
                itemBuilder: (context, index) {
                  final news = controller.relatedNews[index];
                  return Bounceable(
                    onTap: () {
                      Get.toNamed(
                        Routes.newsDetails,
                        arguments: {'newsId': news['id'].toString()},
                        preventDuplicates: false,
                      );
                    },
                    child: MainNewsCard(
                      isBookmarked: news['is_bookmarked'] ?? false,
                      image:
                          news['image']?.toString() ??
                          'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
                      title: news['title']?.toString() ?? "-",
                      date: news['date']?.toString() ?? "ऑगस्ट 19, 2025",
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
                              news['is_bookmarked'] ?? false;

                          // Optimistic UI update
                          controller.relatedNews[index]['is_bookmarked'] =
                              !isCurrentlyBookmarked;
                          controller.detailsData.refresh();
                          try {
                            if (!isCurrentlyBookmarked) {
                              // Add bookmark

                              await getIt<BookmarkController>().addBookmark(
                                Get.arguments['newsId'].toString(),
                              );
                            } else {
                              // Remove bookmark
                              await getIt<BookmarkController>().removeBookmark(
                                Get.arguments['newsId'].toString(),
                              );
                            }
                            getData(false);
                          } catch (e) {
                            // If API fails, rollback UI state
                            controller.relatedNews[index]['is_bookmarked'] =
                                !isCurrentlyBookmarked;
                            controller.detailsData.refresh();

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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
          color: const Color(0xFF374151),
        ),
        SizedBox(height: 8.r),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: maxLines > 1 ? 12.h : 0,
            ),
          ),
        ),
      ],
    );
  }

  void _shareNews() {
    // Local IP link (clickable in Telegram/WhatsApp)
    final String httpLink =
        // 'https://maharashtrajagran.com/newsDetails/${Get.arguments['newsId'].toString()}';
        'https://maharashtrajagran.com/${controller.categories.first['slug']}/${controller.detailsData['slug']}/${Get.arguments['newsId'].toString()}';

    SharePlus.instance.share(ShareParams(text: httpLink));
  }
}

// class NewsDetails extends StatefulWidget {
//   const NewsDetails({super.key});
//
//   @override
//   State<NewsDetails> createState() => _NewsDetailsState();
// }
//
// class _NewsDetailsState extends State<NewsDetails> {
//   final controller = getIt<NewsController>();
//
//   @override
//   void initState() {
//     controller.getNewsDetails(Get.arguments['newsId'].toString());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: Obx(
//         () =>
//             controller.isLoading.isTrue
//                 ? LoadingWidget(color: primaryColor)
//                 : SingleChildScrollView(
//                   padding: EdgeInsets.all(12.r),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //title
//                       CustomText(
//                         title: controller.detailsData['title'] ?? '-',
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                         maxLines: 4,
//                         textAlign: TextAlign.start,
//                         color: primaryGrey,
//                       ),
//                       //date
//                       Row(
//                         spacing: 8.w,
//
//                         children: [
//                           CustomWithIcon(
//                             icon: HugeIcons.strokeRoundedClock01,
//                             title: controller.detailsData['date'] ?? '-',
//                           ),
//                           CustomWithIcon(
//                             icon: HugeIcons.strokeRoundedComment01,
//                             title:
//                                 controller.detailsData['comments_count']
//                                     ?.toString() ??
//                                 '0',
//                           ),
//                         ],
//                       ),
//                       // Image Section
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16.r),
//                         child: Stack(
//                           children: [
//                             FadeInImage(
//                               placeholder: AssetImage(Images.defaultImage),
//                               image: NetworkImage(
//                                 controller.detailsData['image'] ??
//                                     'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
//                               ),
//                               imageErrorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   width: double.infinity,
//                                   height: 180.h,
//                                   color: Colors.grey[200],
//                                   child: Image.asset(
//                                     Images.defaultImage,
//
//                                     // color: Colors.grey[400],
//                                   ),
//                                 );
//                               },
//                               width: double.infinity,
//                               height: 180.h,
//                               fit: BoxFit.cover,
//                             ),
//                             // Gradient overlay for better text readability
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 height: 60.h,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
//                                     colors: [
//                                       Colors.black.withValues(alpha: 0.7),
//                                       Colors.transparent,
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       //description
//                       HtmlWidget(controller.detailsData['description'] ?? '-'),
//
//                       //Tags
//                       CustomText(
//                         title: 'टॅग्ज',
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                         textAlign: TextAlign.start,
//                         color: primaryGrey,
//                       ),
//                       _buildTags(),
//                       Divider(),
//                       _buildComments(),
//                       _buildAddComment(),
//                       CustomHeadline(
//                         title: 'संबंधित लेख',
//                         onTap: () {},
//                         color: primaryGreen,
//                       ),
//                       _buildRelatedNews(),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }
//
//   AppBar _buildAppBar() {
//     return AppBar(
//       iconTheme: const IconThemeData(color: Colors.white),
//       surfaceTintColor: Colors.white,
//       foregroundColor: Colors.black,
//       backgroundColor: primaryColor,
//       title: Image.asset(Images.logoWhite, width: 0.5.sw),
//       actions: [
//         GestureDetector(
//           onTap: () => Get.toNamed(Routes.notificationList),
//           child: Container(
//             padding: EdgeInsets.all(8.w),
//             margin: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.4),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               HugeIcons.strokeRoundedBookmark01,
//               color: Colors.white,
//               size: 20.sp,
//             ),
//           ),
//         ),
//
//         GestureDetector(
//           onTap: () => Get.toNamed(Routes.notificationList),
//           child: Container(
//             padding: EdgeInsets.all(8.w),
//             margin: EdgeInsets.all(8.w).copyWith(right: 12),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.4),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               HugeIcons.strokeRoundedShare08,
//               color: Colors.white,
//               size: 20.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTags() {
//     return Wrap(
//       crossAxisAlignment: WrapCrossAlignment.start,
//       alignment: WrapAlignment.start,
//       runAlignment: WrapAlignment.start,
//       runSpacing: 8,
//       spacing: 8,
//       children:
//           controller.detailsData['tags'].map<Widget>((tag) {
//             return Container(
//               margin: EdgeInsets.only(right: 8),
//               child: GestureDetector(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: primaryTextGrey,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: CustomText(
//                     title: tag['title'] ?? '',
//                     fontSize: 10.sp,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//     );
//   }
//
//   Widget _buildComments() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             CustomText(
//               title: 'प्रतिक्रिया',
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//               textAlign: TextAlign.start,
//               color: primaryGrey,
//             ),
//             CustomText(
//               title: '(${controller.detailsData['comments_count']})',
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               textAlign: TextAlign.start,
//               color: primaryGrey,
//             ),
//           ],
//         ),
//
//         ListTile(
//           leading: CircleAvatar(
//             backgroundColor: primaryTextGrey,
//             radius: 22.r,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(100.r),
//               child: FadeInImage(
//                 fit: BoxFit.cover,
//                 placeholder: AssetImage(Images.defaultImage),
//                 image: NetworkImage(
//                   'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
//                 ),
//                 imageErrorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     // width: double.infinity,
//                     // height: 180.h,
//                     color: Colors.grey[200],
//                     child: Icon(
//                       Icons.broken_image,
//                       size: 40.sp,
//                       color: Colors.grey[400],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           title: CustomText(
//             title: 'Maharashtra Jagran',
//             fontSize: 14.sp,
//             fontWeight: FontWeight.bold,
//             textAlign: TextAlign.start,
//             color: primaryGrey,
//           ),
//           subtitle: CustomText(
//             title: 'ऑगस्ट 19, 2025',
//             fontSize: 12.sp,
//             textAlign: TextAlign.start,
//             color: primaryLightGrey,
//           ),
//         ),
//         CustomText(
//           title: 'सुरक्षिततेवर प्रश्नचिन्ह! 200 प्रवासी अडकले, जीव धोक्यात…',
//           fontSize: 14.sp,
//           maxLines: 3,
//           fontWeight: FontWeight.w500,
//           textAlign: TextAlign.start,
//           color: primaryGrey,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAddComment() {
//     return Container(
//       padding: EdgeInsets.all(8.w),
//       color: primaryTextGrey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             title: 'प्रतिक्रिया व्यक्त करा',
//             fontSize: 14.sp,
//             fontWeight: FontWeight.bold,
//             textAlign: TextAlign.start,
//             color: primaryGrey,
//           ),
//           CustomText(
//             title:
//                 'आपला ई-मेल अड्रेस प्रकाशित केला जाणार नाही. आवश्यक फील्डस * मार्क केले आहेत',
//             fontSize: 12.sp,
//             maxLines: 3,
//             textAlign: TextAlign.start,
//             color: primaryGrey,
//           ),
//           _buildInputField(
//             label: 'टिप्पणी*',
//             controller: controller.commentController,
//             maxLines: 3,
//             validator:
//                 (value) =>
//                     value!.trim().isEmpty ? 'कृपया टिप्पणी टाका'.tr : null,
//             hintText: 'टिप्पणी टाका',
//           ),
//           SizedBox(height: 12.h),
//           SafeArea(
//             child: SizedBox(
//               height: 50.r,
//               width: Get.width,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // if(controller.updateProfileFormKey.currentState!.validate()){
//                   //
//                   // }
//                   // Save functionality
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   elevation: 0,
//                   shadowColor: Colors.transparent,
//                 ),
//                 child: CustomText(
//                   title: "कंमेन्ट द्या",
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRelatedNews() {
//     return Obx(
//           () => SizedBox(
//         height: Get.height * 0.38.h,
//         child: ListView.builder(
//           shrinkWrap: true,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           scrollDirection: Axis.horizontal,
//           itemCount: controller.detailsData['related_news'].length,
//           itemBuilder: (context, index) {
//             final news = controller.detailsData['related_news'][index];
//             return Bounceable(
//               onTap: () {
//                 Get.toNamed(
//                   Routes.newsDetails,
//                   arguments: {'newsId': news['id'].toString()},
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: MainNewsCard(
//                   image:
//                   news['image']?.toString() ??
//                       'https://c.ndtvimg.com/2019-09/p92rlgf8_pune-floods-ani_625x300_26_September_19.jpg?downsize=545:307',
//                   title: news['title']?.toString() ?? "-",
//                   date: news['date']?.toString() ?? "ऑगस्ट 19, 2025",
//                   comment: news['comments_count']?.toString() ?? "0",
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputField({
//     required String label,
//     required TextEditingController controller,
//     required String? Function(String?)? validator,
//     required String hintText,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           title: label,
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//           textAlign: TextAlign.start,
//           color: const Color(0xFF374151),
//         ),
//         SizedBox(height: 8.r),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             // boxShadow: [
//             //   BoxShadow(
//             //     color: Colors.black.withOpacity(0.05),
//             //     blurRadius: 4,
//             //     offset: const Offset(0, 2),
//             //   ),
//             // ],
//           ),
//           child: TextFormField(
//             controller: controller,
//             validator: validator,
//             maxLines: maxLines,
//             keyboardType: keyboardType,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white,
//               hintText: hintText,
//               hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16.w,
//                 vertical: maxLines > 1 ? 12.h : 0,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
