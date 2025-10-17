import 'package:maharashtrajagran/utils/exported_path.dart';

class UpdateCategory extends StatefulWidget {
  const UpdateCategory({super.key});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<HomeController>().getCategories();
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
            getIt<HomeController>().isCatLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : _buildCategories(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(12),
          height: 50.r,
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: CustomText(
              title: "सेव्ह",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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

  Widget _buildCategories() {
    return Obx(
      () => Center(
        child: Wrap(
          runSpacing: 8,
          spacing: 8,
          children:
              // getIt<HomeController>().categoriesListData.map((cat) {
              getIt<HomeController>().categoriesListData
                  .where((cat) => cat["slug"] != 'latest-news')
                  .map((cat) {
                    final isSelected = getIt<HomeController>()
                        .selectedCategories
                        .contains(cat["id"]);

                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap:
                            () => getIt<HomeController>().toggleCategory(
                              cat["id"] as int,
                            ),
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width * 0.4.w,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? primaryColor : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: CustomText(
                            title: cat["name"].toString(),
                            fontSize: 14.sp,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  isSelected ? primaryLightGrey : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  .toList(),
        ),
      ),
    );
  }
}
