import 'package:maharashtrajagran/utils/exported_path.dart';

class OnboardingPage1 extends StatelessWidget {
  OnboardingPage1({super.key});

  final controller = getIt<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    Images.namaskar,
                    width: Get.width * 0.4.w,
                    height: Get.height * 0.2.h,
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    title: 'नमस्कार',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryGrey,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    title: 'तुमची आवडती सदरे',
                    // 'तुमच्या हातात संपूर्ण महाराष्ट्र,\nताज्या बातम्यांसह!',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                    color: primaryGrey.withValues(alpha: 0.8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children:
                      controller.data.map<Widget>((i) {
                        return Obx(
                          () => GestureDetector(
                            onTap:
                                () => controller.selectedIndex.value = i['id'],
                            child: FeatureCard(
                              isSelected:
                                  controller.selectedIndex.value == i['id'],
                              icon: i['icon']!,
                              title: i['title']!,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 30.h),
              IconButton.filledTonal(
                style: IconButton.styleFrom(
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                ),
                onPressed: () {
                  Get.toNamed(Routes.onboarding2);
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight02,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.4.w,

      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: primaryOrange.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: 30.w,
                height: 30.h,
                // color: primaryOrange,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CustomText(
            title: title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: primaryGrey,
            style: TextStyle(height: 1.3),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
