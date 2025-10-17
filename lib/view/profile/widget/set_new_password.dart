import 'package:maharashtrajagran/utils/exported_path.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final controller = getIt<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.resetPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title:
                    'कृपया नवीन पासवर्ड टाइप करा आणि त्याखालील बॉक्समध्ये तोच पासवर्ड पुन्हा टाइप करा. दोन्ही पासवर्ड एकसारखे असणे आवश्यक आहे.',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                maxLines: 10,
                color: primaryGrey,
              ),
              SizedBox(height: 12.r),
              CustomText(
                title: 'वर्तमान पासवर्ड',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              Obx(
                () => buildTextField(
                  fillColor: Colors.grey[50],
                  obscureText: controller.isCurrentObscure.value,
                  controller: controller.currentPwController,
                  keyboardType: TextInputType.text,
                  validator:
                      (value) =>
                          value!.trim().isEmpty
                              ? 'कृपया वर्तमान पासवर्ड टाका'.tr
                              : null,
                  hintText: 'वर्तमान पासवर्ड प्रविष्ट करा',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.isCurrentObscure.value =
                          !controller.isCurrentObscure.value;
                    },
                    child: HugeIcon(
                      icon:
                          controller.isCurrentObscure.isTrue
                              ? HugeIcons.strokeRoundedViewOff
                              : HugeIcons.strokeRoundedView,
                      color: primaryGrey,
                    ),
                  ),
                ),
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
                  fillColor: Colors.grey[50],
                  controller: controller.pwController,
                  keyboardType: TextInputType.text,
                  validator:
                      (value) =>
                          value!.trim().isEmpty
                              ? 'कृपया पासवर्ड टाका'.tr
                              : null,
                  hintText: 'पासवर्ड टाका',
                  obscureText: controller.isObscure.value,
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
              _buildSaveButton(),
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
      title: CustomText(
        title: 'नवीन पासवर्ड सेट करा',
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(
          height: 50.r,
          width: Get.width,
          child: Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.resetPasswordFormKey.currentState!.validate()) {
                  await controller.updatePassword();
                }
                // Save functionality
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
                  controller.isResetPwLoading.isTrue
                      ? LoadingWidget(color: Colors.white)
                      : CustomText(
                        title: "सबमिट करा",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
            ),
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
