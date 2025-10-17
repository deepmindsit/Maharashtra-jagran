import 'package:maharashtrajagran/utils/exported_path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    controller.setPrevData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: controller.updateProfileFormKey,
          child: Column(
            children: [
              // Name field
              _buildInputField(
                label: 'नाव *',
                controller: controller.nameController,
                validator:
                    (value) =>
                        value!.trim().isEmpty ? 'कृपया नाव टाका'.tr : null,
                hintText: 'नाव टाका',
              ),
              // SizedBox(height: 16.h),

              // Gender and Date of Birth row
              // Row(
              //   children: [
              //     Expanded(child: _buildGenderDropdown()),
              //     SizedBox(width: 12.w),
              //     Expanded(child: _buildDatePickerField()),
              //   ],
              // ),
              SizedBox(height: 16.h),
              _buildInputField(
                label: 'मोबाईल',
                controller: controller.mobileController,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.trim().isEmpty
                            ? 'कृपया मोबाईल क्रमांक टाका'.tr
                            : null,
                hintText: 'मोबाईल क्रमांक',
              ),
              SizedBox(height: 16.h),
              _buildInputField(
                label: 'ईमेल',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value!.trim().isEmpty ? 'कृपया ईमेल टाका'.tr : null,
                hintText: 'ईमेल टाका',
              ),
              // Mobile and Email row
              SizedBox(height: 16.h),

              // // Address field
              // _buildInputField(
              //   label: 'पत्ता',
              //   controller: controller.addressController,
              //   maxLines: 3,
              //   validator:
              //       (value) =>
              //           value!.trim().isEmpty ? 'कृपया पत्ता टाका'.tr : null,
              //   hintText: 'पत्ता टाका',
              // ),
              // SizedBox(height: 24.h),

              // Reset Password Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.setNewPassword);
                  },
                  icon: Icon(Icons.lock_reset, size: 20.r, color: primaryColor),
                  label: CustomText(
                    title: 'पासवर्ड रीसेट करा',
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
          color: const Color(0xFF374151),
        ),
        SizedBox(height: 8.r),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.05),
            //     blurRadius: 4,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: maxLines > 1 ? 12.h : 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildGenderDropdown() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomText(
  //         title: 'लिंग *',
  //         fontSize: 14.sp,
  //         fontWeight: FontWeight.w500,
  //         textAlign: TextAlign.start,
  //         color: const Color(0xFF374151),
  //       ),
  //       SizedBox(height: 8.r),
  //       Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12.r),
  //           // boxShadow: [
  //           //   BoxShadow(
  //           //     color: Colors.black.withOpacity(0.05),
  //           //     blurRadius: 4,
  //           //     offset: const Offset(0, 2),
  //           //   ),
  //           // ],
  //         ),
  //         child: DropdownButtonFormField<String>(
  //           value: controller.selectedGender.value,
  //           decoration: InputDecoration(
  //             filled: true,
  //             fillColor: Colors.white,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12.r),
  //               borderSide: BorderSide.none,
  //             ),
  //             contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
  //           ),
  //           items:
  //               controller.genderOptions.map((String value) {
  //                 return DropdownMenuItem<String>(
  //                   value: value,
  //                   child: Text(value),
  //                 );
  //               }).toList(),
  //           onChanged: (newValue) {
  //             controller.selectedGender.value = newValue;
  //             controller.genderController.text = newValue!;
  //           },
  //           hint: Text(
  //             'लिंग निवडा',
  //             style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildDatePickerField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomText(
  //         title: 'जन्मतारीख *',
  //         fontSize: 14.sp,
  //         fontWeight: FontWeight.w500,
  //         textAlign: TextAlign.start,
  //         color: const Color(0xFF374151),
  //       ),
  //       SizedBox(height: 8.r),
  //       Container(
  //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
  //         child: TextFormField(
  //           controller: controller.dobController,
  //           readOnly: true,
  //           onTap: () async {
  //             final DateTime? picked = await showDatePicker(
  //               context: context,
  //               initialDate: controller.selectedDate ?? DateTime.now(),
  //               firstDate: DateTime(1900),
  //               lastDate: DateTime.now(),
  //               builder: (context, child) {
  //                 return Theme(
  //                   data: Theme.of(context).copyWith(
  //                     colorScheme: ColorScheme.light(
  //                       primary: primaryColor,
  //                       onPrimary: Colors.white,
  //                       onSurface: Colors.black,
  //                     ),
  //                   ),
  //                   child: child!,
  //                 );
  //               },
  //             );
  //             if (picked != null && picked != controller.selectedDate) {
  //               controller.selectedDate = picked;
  //               controller.dobController.text =
  //                   "${picked.day}/${picked.month}/${picked.year}";
  //             }
  //           },
  //           decoration: InputDecoration(
  //             filled: true,
  //             fillColor: Colors.white,
  //             hintText: 'जन्मतारीख निवडा',
  //             hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12.r),
  //               borderSide: BorderSide.none,
  //             ),
  //             contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
  //             suffixIcon: Icon(
  //               Icons.calendar_today,
  //               size: 20.r,
  //               color: primaryColor,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => AllDialog().showLogoutDialog(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: BorderSide.none,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: CustomText(
              title: 'लॉगआउट',
              fontSize: 14.sp,
              // fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => AllDialog().showDeleteAccountDialog(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: CustomText(
              title: 'वापरकर्ता हटवा',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 50.r,
          child: Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.updateProfileFormKey.currentState!.validate()) {
                  await controller.updateProfile();
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
                        title: "जतन करा",
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

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: primaryColor,
      title: CustomText(
        title: 'माझे प्रोफाइल',
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
