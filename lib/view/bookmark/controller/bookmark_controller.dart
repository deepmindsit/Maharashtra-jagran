import 'package:maharashtrajagran/utils/exported_path.dart';

@lazySingleton
class BookmarkController extends GetxController {
  final ApiService _apiService = Get.find();
  // =================== FETCH Bookmark Data ===================
  /// Fetches Bookmark
  final page = 1.obs;
  final perPage = 10.obs;
  final isFirstLoadRunning = false.obs;

  final isLoadMoreRunning = false.obs;
  final hasMore = true.obs;
  final bookmarkList = [].obs;

  Future<void> getBookmark({bool isLoading = true}) async {
    if (isFirstLoadRunning.value) return;

    page.value = 1;
    hasMore.value = true;
    if (!await LocalStorage().isDemo()) bookmarkList.clear();

    if (isLoading) isFirstLoadRunning.value = true;
    final userId = await LocalStorage.getString('user_id');
    final token = await LocalStorage.getString('auth_key');
    try {
      final res = await _apiService.getBookmarks(
        userId,
        page.toString(),
        perPage.toString(),
        token!,
      );
      // log(res.toString(), name: 'getBookmark');
      if (res['common']['status'] == true) {
        if (res['data']['bookmarked_posts'] != null) {
          bookmarkList.value = res['data']['bookmarked_posts'];
        } else {
          hasMore.value = false;
        }
      }
      if (token.isNotEmpty && res['common']['user_login'] == false) {
        checkLogin(true);
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      if (isLoading) isFirstLoadRunning.value = false;
    }
  }

  Future<void> getMoreBookmark() async {
    if (hasMore.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false) {
      isLoadMoreRunning.value = true;
      page.value += 1;
      final userId = await LocalStorage.getString('user_id');
      final token = await LocalStorage.getString('auth_key');
      try {
        final res = await _apiService.getBookmarks(
          userId,
          page.toString(),
          perPage.toString(),
          token!,
        );

        final List fetchedNews = res['data']['bookmarked_posts'];
        if (fetchedNews.isNotEmpty) {
          bookmarkList.addAll(fetchedNews);
        } else {
          hasMore.value = false;
        }
      } catch (err) {
        showToast('Something went wrong. Please try again later.');
      }
      isLoadMoreRunning.value = false;
    }
  }

  // =================== Add Bookmark Data ===================
  final isLoading = false.obs;

  /// Add Bookmark
  Future<void> addBookmark(String newsId) async {
    isLoading.value = true;
    final token = await LocalStorage.getString('auth_key');
    try {
      final res = await _apiService.addBookmarks(newsId, token!);
      // log(res.toString(), name: 'addBookmark');
      if (res['common']['status'] == true) {
        showToast(res['common']['message']);
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      isLoading.value = false;
    }
  }

  /// remove Bookmark
  Future<void> removeBookmark(String newsId) async {
    isLoading.value = true;
    final token = await LocalStorage.getString('auth_key');
    try {
      final res = await _apiService.removeBookmarks(newsId, token!, 'remove');
      // log(res.toString(), name: 'removeBookmark');
      if (res['common']['status'] == true) {
        showToast(res['common']['message']);
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
