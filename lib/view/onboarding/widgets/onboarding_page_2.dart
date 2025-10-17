import 'package:maharashtrajagran/utils/exported_path.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  final controller = getIt<OnboardingController>();
  final controller2 = getIt<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller2.getCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () =>
            controller2.isCatLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        // Header section with greeting
                        Column(
                          children: [
                            Image.asset(
                              Images.icPage,
                              width: Get.width * 0.4.w,
                              height: Get.height * 0.2.h,
                            ),
                            SizedBox(height: 16.h),
                            CustomText(
                              title: 'तुमच्या आवडीचे विषय निवडा',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryGrey,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              title:
                                  'तुम्हाला सर्वाधिक आवडणारे किमान\n४ विषय निवडा. हे विषय तुम्ही कधीही\nबदलू शकता.',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              maxLines: 3,
                              color: primaryGrey.withValues(alpha: 0.8),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        _buildCategories(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
      ),

      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: () async {
            if (controller2.selectedCategories.length <= 3) {
              Get.snackbar("सूचना", "किमान 4 category निवडणे आवश्यक आहे.");
            } else {
              await LocalStorage.setBool('onboarding', true);
              Get.offAllNamed(Routes.login);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25.r),
            ),

            width: Get.width * 0.4.w,
            height: 50,
            margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.3.w,
              vertical: 8,
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight02,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(
      () => Center(
        child: Wrap(
          runSpacing: 8,
          spacing: 8,
          children:
              controller2.categoriesListData
                  .where((cat) => cat["slug"] != 'latest-news') // ✅ filter
                  .map((cat) {
                    final isSelected = controller2.selectedCategories.contains(
                      cat["id"],
                    );

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap:
                            () => controller2.toggleCategory(cat["id"] as int),
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width * 0.4.w, // ✅ fixed
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
