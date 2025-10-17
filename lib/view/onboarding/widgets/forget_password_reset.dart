import 'package:maharashtrajagran/utils/exported_path.dart';

class ForgetPasswordReset extends StatefulWidget {
  const ForgetPasswordReset({super.key});

  @override
  State<ForgetPasswordReset> createState() => _ForgetPasswordResetState();
}

class _ForgetPasswordResetState extends State<ForgetPasswordReset> {
  final controller = getIt<ForgetPasswordController>();

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
          key: controller.resetKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.r),

              // Title section
              CustomText(
                title: 'नवीन पासवर्ड टाका',
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              CustomText(
                title: 'कृपया तुमचा नवीन पासवर्ड टाका.',
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
                controller: controller.inputController,
                keyboardType: TextInputType.text,
                validator: validateUserName,
                hintText: 'मोबाईल नंबर/ईमेल आयडी टाका',
              ),
              SizedBox(height: 12.r),
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

              SizedBox(height: 16.r),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50.r,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.resetKey.currentState!.validate()) {
                        await controller.forgetVerifyReset();
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
