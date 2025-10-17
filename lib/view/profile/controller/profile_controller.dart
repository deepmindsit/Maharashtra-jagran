import 'package:maharashtrajagran/utils/exported_path.dart';

@lazySingleton
class ProfileController extends GetxController {
  final ApiService _apiService = Get.find();
  //edit Profile
  void setPrevData() {
    nameController.text = profileData['display_name'] ?? '';
    mobileController.text = profileData['phone_number'] ?? '';
    emailController.text = profileData['email'] ?? '';
  }

  final updateProfileFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  //reset Password
  final resetPasswordFormKey = GlobalKey<FormState>();
  final currentPwController = TextEditingController();
  final pwController = TextEditingController();
  final cpwController = TextEditingController();
  final isObscure = true.obs;
  final isCurrentObscure = true.obs;
  final isCObscure = true.obs;
  final isResetPwLoading = false.obs;

  /// Reset Password
  Future<void> updatePassword() async {
    isResetPwLoading.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.updatePassword(
        userId,
        currentPwController.text.trim(),
        pwController.text.trim(),
        cpwController.text.trim(),
      );
      // log(res.toString(), name: 'updatePassword');
      if (res['common']['status'] == true) {
        showToast(res['common']['message'] ?? '');
        Get.back();
        currentPwController.clear();
        pwController.clear();
        cpwController.clear();
      } else {
        showToast(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isResetPwLoading.value = false;
    }
  }

  //about Us
  final isLoading = false.obs;
  final aboutUsData = {}.obs;

  // =================== FETCH About Data ===================
  /// Fetches About
  Future<void> getAboutUs() async {
    isLoading.value = true;
    try {
      final res = await _apiService.getAboutUs();
      // log(res.toString(), name: 'getAboutUs');
      if (res['common']['status'] == true) {
        aboutUsData.value = res['data'] ?? {};
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =================== FETCH Profile Data ===================

  final profileData = {}.obs;

  /// Fetches Profile
  Future<void> getProfile() async {
    isLoading.value = true;
    profileData.clear();
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.getProfile(userId);
      // log(res.toString(), name: 'getAboutUs');
      if (res['common']['status'] == true) {
        profileData.value = res['data'] ?? {};
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Profile
  Future<void> updateProfile() async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.editProfile(
        userId,
        nameController.text.trim(),
        emailController.text.trim(),
        mobileController.text.trim(),
      );
      // log(res.toString(), name: 'updateProfile');
      if (res['common']['status'] == true) {
        showToast(res['common']['message'] ?? '');
        await getProfile();
        Get.back();
      } else {
        showToast(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      isLoading.value = false;
    }
  }

  // =================== FETCH Legal Page Data ===================
  final isPolicyLoading = false.obs;
  final legalPage = {}.obs;

  /// Fetches getLegalPage
  Future<void> getLegalPage(String slug) async {
    isPolicyLoading.value = true;
    try {
      final res = await _apiService.legalPage(slug);
      // log(res.toString(), name: 'getLegalPage');
      if (res['common']['status'] == true) {
        legalPage.value = res['data'] ?? {};
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isPolicyLoading.value = false;
    }
  }

  /// Fetches deleteAccount
  Future<void> deleteAccount() async {
    isPolicyLoading.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.deleteProfile(userId);
      // log(res.toString(), name: 'deleteAccount');
      if (res['common']['status'] == true) {
        showToast(res['common']['message'] ?? '');
      } else {
        showToast(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isPolicyLoading.value = false;
    }
  }
  //
  // //notification permission
  // final isNotificationEnabled = false.obs;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  //
  // void checkPermissionStatus() async {
  //   bool granted = false;
  //
  //   if (Platform.isIOS) {
  //     final result = await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin
  //         >()
  //         ?.requestPermissions(alert: false, badge: false, sound: false);
  //     granted = result ?? false;
  //   } else if (Platform.isAndroid) {
  //     granted = await Permission.notification.isGranted;
  //   }
  //
  //   isNotificationEnabled.value = granted;
  // }
  //
  // void toggleNotification(bool value) async {
  //   if (value) {
  //     // Request permission
  //     if (Platform.isIOS) {
  //       final result = await flutterLocalNotificationsPlugin
  //           .resolvePlatformSpecificImplementation<
  //             IOSFlutterLocalNotificationsPlugin
  //           >()
  //           ?.requestPermissions(alert: true, badge: true, sound: true);
  //       isNotificationEnabled.value = result ?? false;
  //     } else if (Platform.isAndroid) {
  //       if (await Permission.notification.isDenied) {
  //         final status = await Permission.notification.request();
  //         isNotificationEnabled.value = status.isGranted;
  //       } else {
  //         isNotificationEnabled.value = true;
  //       }
  //     }
  //   } else {
  //     // Cannot revoke system permission programmatically
  //     isNotificationEnabled.value = false;
  //     Get.snackbar(
  //       "Info",
  //       "To turn off notifications, please go to system settings.",
  //     );
  //   }
  // }
}
