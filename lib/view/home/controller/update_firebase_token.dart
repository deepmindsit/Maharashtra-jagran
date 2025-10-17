import '../../../utils/exported_path.dart';

@lazySingleton
class FirebaseTokenController extends GetxController {
  final ApiService _apiService = Get.find();

  Future<void> updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      await _apiService.updateFirebaseToken(token.toString());
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    }
  }
}
