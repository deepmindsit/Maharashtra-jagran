import '../../../utils/exported_path.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final controller = getIt<OnboardingController>();
  String number = '';
  @override
  void initState() {
    number = Get.arguments['mobile']?.toString() ?? '';
    controller.userController.text = number;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 16.r),
        child: Form(
          key: controller.loginKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.r),

              // Title section
              CustomText(
                title: 'तुमचं अकाउंट तयार करा.',
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              CustomText(
                title: 'कृपया तुमचा इमेल अड्रेस टाइप करा आणि पासवर्ड सेट कथा.',
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
                controller: controller.userController,
                keyboardType: TextInputType.text,
                validator:
                    (value) =>
                        value!.trim().isEmpty ? 'Please enter email'.tr : null,
                hintText: 'मोबाईल नंबर/ईमेल आयडी टाका',
              ),
              SizedBox(height: 12.r),
              CustomText(
                title: 'पासवर्ड',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              Obx(
                () => buildTextField(
                  obscureText: controller.isObscure.value,
                  fillColor: Colors.grey[50],
                  controller: controller.passwordController,
                  keyboardType: TextInputType.text,
                  validator:
                      (value) =>
                          value!.trim().isEmpty
                              ? 'Please enter password'.tr
                              : null,
                  hintText: 'पासवर्ड टाका',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.isObscure.value = !controller.isObscure.value;
                    },
                    child: HugeIcon(
                      icon:
                          controller.isObscure.isTrue
                              ? HugeIcons.strokeRoundedViewOff
                              : HugeIcons.strokeRoundedView,
                      color: primaryGrey,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.r),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.forgetPassword),
                    child: CustomText(
                      title: 'पासवर्ड विसरला',
                      fontSize: 14.sp,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50.r,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.loginKey.currentState!.validate()) {
                        await controller.login();
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
                        controller.isLoginLoading.isTrue
                            ? LoadingWidget(color: Colors.white)
                            : CustomText(
                              title: "लॉगिन करा",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                  ),
                ),
              ),
              SizedBox(height: 32.r),
            ],
          ),
        ),
      ),
    );
  }
}
