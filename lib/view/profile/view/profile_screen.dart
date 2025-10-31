import 'package:maharashtrajagran/utils/exported_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = getIt<ProfileController>();
  String token = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getProfile();
    });
    checkLogin();
    // controller.checkPermissionStatus();
    super.initState();
  }

  Future<void> checkLogin() async {
    token = (await LocalStorage.getString('auth_key'))!;
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
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () async {
                          if (!await LocalStorage().isDemo()) {
                            Get.snackbar(
                              "सूचना",
                              "Login आवश्यक आहे.",
                              colorText: Colors.white,
                            );
                          } else {
                            Get.toNamed(
                              Routes.editProfile,
                              arguments: {'data': controller.profileData},
                            );
                          }
                        },

                        title: CustomText(
                          title:
                              controller.profileData['display_name'] ??
                              'Welcome to Maharashtra Jagran',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        subtitle:
                            token.isEmpty
                                ? SizedBox(
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () => Get.offAllNamed(Routes.login),
                                    child: CustomText(
                                      textAlign: TextAlign.start,
                                      title: 'लॉगिन',
                                      fontSize: 14.sp,
                                      color: primaryColor,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                                : CustomText(
                                  title: 'माझे प्रोफाइल',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        onTap: () => Get.toNamed(Routes.updateCategory),
                        title: CustomText(
                          title: 'पहिल्या पानावरील तुमची आवडती सदरे',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      Divider(height: 1),
                      ListTile(
                        onTap:
                            () => Get.to(
                              () => PolicyData(slug: 'privacy-policy'),
                            ),
                        title: CustomText(
                          title: 'गोपनीयतेचे धोरण',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        onTap:
                            () => Get.to(
                              () => PolicyData(slug: 'terms-and-conditions'),
                            ),
                        title: CustomText(
                          title: 'अटी व शर्ती',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        onTap:
                            () => launchURL(
                              'https://play.google.com/store/apps/details?id=com.mjagran.android',
                            ),
                        title: CustomText(
                          title: 'रेटिंग द्या',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        onTap: () => Get.toNamed(Routes.aboutUs),
                        title: CustomText(
                          title: 'आमच्या विषयी',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        onTap:
                            () => launchURL(
                              'https://play.google.com/store/apps/details?id=com.mjagran.android',
                            ),
                        title: CustomText(
                          title: 'ॲपसंदर्भात फीडबॅक द्या',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: CustomText(
                          title: 'आवृत्ती',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                        trailing: CustomText(
                          title: '1.0.5',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
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
