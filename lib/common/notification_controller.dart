import '../utils/exported_path.dart';

@lazySingleton
class NotificationController extends GetxController {
  final ApiService _apiService = Get.find();

  final page = 1.obs;
  final perPage = 10.obs;
  final hasNextPage = true.obs;
  final isMoreLoading = false.obs;
  final isLoading = false.obs;

  final notificationData = [].obs;

  // =================== FETCH dashboard Data ===================
  /// Fetches getNotificationInitial
  Future<void> getNotificationInitial({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    page.value = 1;
    try {
      final res = await _apiService.getNotification(
        page.value.toString(),
        perPage.value.toString(),
      );
      if (res['common']['status'] == true) {
        notificationData.value = res['data']['notifications'] ?? [];
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Fetches getNotificationLoadMore
  Future<void> getNotificationLoadMore() async {
    isMoreLoading.value = true;
    try {
      page.value += 1;
      final res = await _apiService.getNotification(
        page.value.toString(),
        perPage.value.toString(),
      );
      if (res['common']['status'] == true) {
        final List fetchedPosts = res['data']['notifications'];
        if (fetchedPosts.isNotEmpty) {
          notificationData.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  // Future<void> readNotification(String notificationId) async {
  //   final userId = await LocalStorage.getString('user_id') ?? '';
  //   try {
  //     final res = await _apiService.readNotification(userId, notificationId);
  //     if (res['common']['status'] == true) {
  //       await getNotificationInitial(showLoading: false);
  //       // notificationData.value = res['data'] ?? [];
  //     }
  //   } catch (e) {
  //     showToast('Something went wrong. Please try again later.');
  //     // debugPrint("Login error: $e");
  //   } finally {}
  // }
}
