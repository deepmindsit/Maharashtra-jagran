import 'package:maharashtrajagran/utils/exported_path.dart';

Future<void> checkLogin(bool status) async {
  if (status) {
    LocalStorage.clear();
    Get.offAllNamed(Routes.login);

    // Show a professional-looking snackbar
    Get.snackbar(
      'Session Expired',
      'You have been logged out because your account was accessed from another device.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 8,
      isDismissible: true,
    );
  }
}
