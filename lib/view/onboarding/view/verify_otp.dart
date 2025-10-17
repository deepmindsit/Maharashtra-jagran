import '../../../utils/exported_path.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final controller = getIt<OnboardingController>();

  @override
  void initState() {
    controller.startTimer();
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
          key: controller.verifyOtpKey,
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
                title: 'आपल्या मोबाईलवर पाठवलेला 4-अंकी कोड टाका',
                fontSize: 14.sp,
                maxLines: 2,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
                color: Colors.grey[600],
              ),
              SizedBox(height: 32.r),

              // Input field
              CustomText(
                title: 'OTP प्रविष्ट करा',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: primaryGrey,
              ),
              SizedBox(height: 8.r),
              buildPinPut(),
              SizedBox(height: 12.r),
              Obx(() {
                return Center(
                  child:
                      controller.start.value > 0
                          ? CustomText(
                            title:
                                'पुन्हा OTP पाठवा (${controller.start.value} सेकंदात)',
                            color: primaryLightGrey,
                            fontSize: 14.sp,
                          )
                          : GestureDetector(
                            onTap: () {
                              controller.resendOtp();
                            },
                            child: CustomText(
                              title: 'पुन्हा OTP पाठवा',
                              color: primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                );
              }),
              SizedBox(height: 10.r),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50.r,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      if (controller.verifyOtpKey.currentState!.validate()) {
                        await controller.verifyOtp();
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
                        controller.isVerifyLoading.isTrue
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

              // Divider with text
              Center(
                child: GestureDetector(
                  onTap: () {
                    controller.userNameController.clear();
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: CustomText(
                      title: 'मोबाईल नंबर बदलायचा आहे का?',
                      color: primaryLightGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.r),

              SizedBox(height: 24.r),
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
        controller: controller.pinController,
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
