import 'package:maharashtrajagran/utils/exported_path.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAboutUs();
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
            controller.isLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.h,
                    children: [
                      CustomText(
                        title:
                            controller.aboutUsData['heading'] ??
                            'आमच्या बद्दल...',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryGrey,
                      ),
                      Container(
                        height: Get.height * 0.15.h,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child:
                          // controller.aboutUsData['image'] != null
                          //     ? Image.network(
                          //       controller.aboutUsData['image'],
                          //       width: 0.5.sw,
                          //     )
                          //     :
                          Image.asset(Images.logoWhite, width: 0.5.sw),
                        ),
                      ),

                      CustomText(
                        title:
                            controller.aboutUsData['description'] ??
                            'महाराष्ट्र जागरण” हे एक मराठी वृत्तपत्र आहे जे महाराष्ट्रातील ताज्या घडामोडी, राजकारण, समाजकारण, मनोरंजन, खेळ, व्यापार आणि इतर महत्त्वाच्या घटनांची माहिती पुरवते. हे वृत्तपत्र लोकांपर्यंत महत्त्वाची बातमी पोहोचवण्याचे कार्य करते आणि महाराष्ट्रातील वाचक वर्गात लोकप्रिय आहे.',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: primaryGrey,
                        maxLines: 10,
                        style: TextStyle(height: 1.5),
                      ),
                    ],
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
}
