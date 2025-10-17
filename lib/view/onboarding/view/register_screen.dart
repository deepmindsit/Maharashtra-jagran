import 'package:maharashtrajagran/utils/exported_path.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
          key: controller.registerKey,
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
                  controller: controller.pwController,
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
              SizedBox(height: 12.r),
              CustomText(
                title: 'पासवर्डची पुष्टी करा',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              Obx(
                () => buildTextField(
                  obscureText: controller.isCObscure.value,
                  fillColor: Colors.grey[50],
                  controller: controller.cpwController,
                  keyboardType: TextInputType.text,
                  validator: validateConfirmPassword,
                  hintText: 'पासवर्डची पुष्टी करा',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.isCObscure.value =
                          !controller.isCObscure.value;
                    },
                    child: HugeIcon(
                      icon:
                          controller.isCObscure.isTrue
                              ? HugeIcons.strokeRoundedViewOff
                              : HugeIcons.strokeRoundedView,
                      color: primaryGrey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.r),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50.r,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.registerKey.currentState!.validate()) {
                        await controller.registerUser();
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
                        controller.isRegLoading.isTrue
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया पासवर्ड पुन्हा टाका';
    } else if (value != controller.pwController.text) {
      return 'पासवर्ड जुळत नाही';
    }
    return null;
  }
}
