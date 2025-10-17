import 'package:maharashtrajagran/utils/exported_path.dart';

class NewsListBySearch extends StatefulWidget {
  const NewsListBySearch({super.key});

  @override
  State<NewsListBySearch> createState() => _NewsListBySearchState();
}

class _NewsListBySearchState extends State<NewsListBySearch> {
  final controller = getIt<SearchDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        backgroundColor: primaryColor,
        title: Image.asset(Images.logoWhite, width: 0.5.sw),
        centerTitle: true,
      ),
      body: Obx(
        () => NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.getNewsMoreSearch();
            }
            return true;
          },
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              _buildInputField(
                onChanged: (v) async => await controller.getNewsBySearch(),
                label: 'शोधा *',
                controller1: controller.searchController,
                validator:
                    (value) =>
                        value!.trim().isEmpty ? 'कृपया नाव शोधा'.tr : null,
                hintText: 'शोधा',
              ),
              controller.isFirstLoadRunning.isTrue
                  ? Expanded(child: LoadingWidget(color: primaryColor))
                  : controller.searchList.isEmpty
                  ? noDataFound()
                  : _buildMaharashtraNews(controller.searchList),

              controller.searchList.isEmpty ? const SizedBox() : buildLoader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller1,
    required String? Function(String?)? validator,
    required String hintText,
    int maxLines = 1,
    void Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: TextFormField(
        controller: controller1,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          prefixIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: Colors.grey,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              controller.searchList.clear();
              controller.searchController.clear();
            },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCancel01,
              color: Colors.grey,
            ),
          ),
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: maxLines > 1 ? 12.h : 0,
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
