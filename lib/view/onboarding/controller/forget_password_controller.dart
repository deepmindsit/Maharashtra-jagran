import 'dart:developer';

import 'package:maharashtrajagran/utils/exported_path.dart';

@lazySingleton
class ForgetPasswordController extends GetxController {
  final ApiService _apiService = Get.find();
  final inputController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final loginKey = GlobalKey<FormState>();
  final verifyOTPKey = GlobalKey<FormState>();
  final resetKey = GlobalKey<FormState>();
  final isObscure = true.obs;

  Future<void> forgetPassword() async {
    isLoading.value = true;
    try {
      final res = await _apiService.forgetPassword(inputController.text.trim());
      log(res.toString(), name: 'forgetPassword');
      if (res['common']['status'] == true) {
        Get.toNamed(
          Routes.forgetVerifyOtp,
          arguments: {'mobile': inputController.text.trim()},
        );
        showToast(res['common']['message'] ?? '');
      } else {
        showToast(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetVerifyOtp() async {
    isLoading.value = true;
    try {
      final res = await _apiService.forgetVerifyOtp(
        inputController.text.trim(),
        otpController.text.trim(),
      );
      log(res.toString(), name: 'forgetVerifyOtp');
      if (res['common']['status'] == true) {
        if (res['data']['verified'] == true) {
          LocalStorage.setString('auth_key', res['data']['verification_token']);
          showToast(res['common']['message'] ?? '');
          Get.toNamed(Routes.forgetResetPassword);
        }
      } else {
        showToast(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetVerifyReset() async {
    isLoading.value = true;
    final token = await LocalStorage.getString('auth_key');
    try {
      final res = await _apiService.forgetPasswordReset(
        inputController.text.trim(),
        token!,
        passwordController.text.trim(),
      );
      log(res.toString(), name: 'forgetVerifyReset');
      if (res['common']['status'] == true) {
        LocalStorage.setString('user_id', res['data']['user_id'].toString());
        showToast(res['common']['message'] ?? '');
        Get.offAllNamed(Routes.mainScreen);
      } else {
        showToast(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
