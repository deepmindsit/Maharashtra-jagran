import 'package:maharashtrajagran/utils/exported_path.dart';

class ForgetVerifyOtp extends StatefulWidget {
  const ForgetVerifyOtp({super.key});

  @override
  State<ForgetVerifyOtp> createState() => _ForgetVerifyOtpState();
}

class _ForgetVerifyOtpState extends State<ForgetVerifyOtp> {
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
          key: controller.verifyOTPKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.r),

              // Title section
              CustomText(
                title: 'OTP टाका',
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              CustomText(
                title: 'कृपया तुमच्या ईमेल किंवा फोन नंबरवर आलेला OTP टाका.',
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
              buildPinPut(),
              SizedBox(height: 16.r),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50.r,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.verifyOTPKey.currentState!.validate()) {
                        await controller.forgetVerifyOtp();
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

  Widget buildPinPut() {
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 45.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    return Center(
      child: Pinput(
        validator:
            (value) =>
                value != null && value.isNotEmpty ? null : 'OTP is required',
        controller: controller.otpController,
        length: 4,
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: primaryColor),
          ),
        ),
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) => debugPrint('Entered PIN: $pin'),
      ),
    );
  }
}
