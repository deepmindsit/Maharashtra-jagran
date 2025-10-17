import 'exported_path.dart';

class AllDialog {
  void showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      titleStyle: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to logout?",
      middleTextStyle: const TextStyle(color: Colors.black87),
      textCancel: "Cancel",
      cancelTextColor: Colors.grey[700],
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // Clear token or user data here
        LocalStorage.clear();
        Get.offAllNamed(Routes.login);
      },
    );
  }

  void showDeleteAccountDialog() {
    Get.defaultDialog(
      title: "⚠️ Delete Account",
      titleStyle: TextStyle(color: primaryGrey, fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to Delete Account?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        await getIt<ProfileController>().deleteAccount();
        Get.back(); // close dialog
        LocalStorage.clear();
        Get.offAllNamed(Routes.login);
      },
    );
  }
}
