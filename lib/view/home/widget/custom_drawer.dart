import '../../../utils/exported_path.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final controller = getIt<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.6.sw,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Obx(
        () =>
            controller.isCatLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          12,
                          Get.height * 0.07.h,
                          12,
                          12,
                        ),
                        decoration: BoxDecoration(color: primaryColor),
                        child: FadeInImage(
                          placeholder: AssetImage(Images.defaultImage),
                          image: AssetImage(Images.logoWhite),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Images.defaultImage,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            );
                          },
                          fit: BoxFit.contain,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                      _buildCategories(),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(
      () => Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children:
            controller.categoriesListData.map((cat) {
              final isSelected =
                  controller.selectedId.value == cat["id"] as int;
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.newsList,
                    arguments: {
                      'catId': cat['id']?.toString() ?? '',
                      'catName': cat['name'] ?? '',
                    },
                  );
                  controller.selectedId.value = cat["id"] as int;
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   Images.defaultImage,
                      //   width: 30.w,
                      //   color: isSelected ? primaryColor : primaryLightGrey,
                      //   fit: BoxFit.contain,
                      // ),
                      const SizedBox(width: 6),
                      CustomText(
                        title: cat["name"].toString(),
                        fontSize: 14.sp,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: isSelected ? primaryColor : primaryLightGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
