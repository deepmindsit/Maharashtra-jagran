import '../../../utils/exported_path.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = getIt<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await LocalStorage.setString('user_id', '');
              await LocalStorage.setString('auth_key', '');
              Get.offAllNamed(Routes.mainScreen);
            },
            child: CustomText(
              title: 'आतासाठी वगळा',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 16.r),
        child: Form(
          key: controller.checkUserKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.r),

              // Title section
              CustomText(
                title: 'लॉगिन / साइनअप करा',
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              CustomText(
                title:
                    'आपल्या बातम्या वाचण्यासाठी खाते तयार करा किंवा लॉगिन करा',
                fontSize: 14.sp,
                maxLines: 2,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
                color: Colors.grey[600],
              ),
              SizedBox(height: 32.r),

              // Input field
              CustomText(
                title: 'मोबाईल/ईमेल',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              buildTextField(
                fillColor: Colors.grey[50],
                controller: controller.userNameController,
                keyboardType: TextInputType.text,
                validator: validateUserName,
                hintText: 'मोबाईल नंबर/ईमेल आयडी टाका',
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey[500]),
              ),
              SizedBox(height: 24.r),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50.r,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.checkUserKey.currentState!.validate()) {
                        await controller.checkUser();
                      }
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
                    child:
                        controller.isLoading.isTrue
                            ? LoadingWidget(color: Colors.white)
                            : CustomText(
                              title: "सुरू ठेवा",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                  ),
                ),
              ),
              SizedBox(height: 32.r),

              // // Divider with text
              // Row(
              //   children: [
              //     Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 16.r),
              //       child: Text(
              //         'किंवा सोशल लॉगिनसह सुरू ठेवा'.tr,
              //         style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              //       ),
              //     ),
              //     Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
              //   ],
              // ),
              // SizedBox(height: 24.r),
              //
              // // Social login buttons
              // SocialLoginButton(
              //   iconPath: Images.icGoogle,
              //   text: 'Google ने लॉगिन करा',
              //   onPressed: () {},
              // ),
              // SizedBox(height: 16.r),
              // SocialLoginButton(
              //   iconPath: Images.icFB,
              //   text: 'Facebook ने लॉगिन करा',
              //   onPressed: () {},
              // ),
              // SizedBox(height: 24.r),

              // Checkbox sections
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: primaryColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.r),
                        Expanded(
                          child: CustomText(
                            title:
                                'होय, मला "महाराष्ट्र जागरण" डेली न्यूज पोर्टल, स्वीकारायला आवडेल.',
                            fontSize: 12.sp,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.r),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: primaryColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.r),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(text: 'तसेच '),
                                TextSpan(
                                  text: 'नियम व अटी ',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(
                                            () => PolicyData(
                                              slug: 'terms-and-conditions',
                                            ),
                                          );
                                        },
                                ),
                                TextSpan(text: 'मला मान्य आहेत. आपली '),
                                TextSpan(
                                  text: 'प्रायव्हसी पॉलिसी ',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(
                                            () => PolicyData(
                                              slug: 'privacy-policy',
                                            ),
                                          );
                                        },
                                ),
                                TextSpan(text: 'वाचली आहे.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.r),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: EdgeInsets.symmetric(vertical: 14.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: primaryLightGrey, width: 0.5),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 24.r, height: 24.r),
          SizedBox(width: 12.r),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
