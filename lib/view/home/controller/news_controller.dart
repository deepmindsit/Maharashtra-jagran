import 'package:maharashtrajagran/utils/exported_path.dart';

@lazySingleton
class NewsController extends GetxController {
  final ApiService _apiService = Get.find();
  final commentController = TextEditingController();

  //news List
  final categoryName = ''.obs;
  final categoryId = ''.obs;

  //news Details
  final isLoading = false.obs;
  final isCommentLoading = false.obs;
  final detailsData = {}.obs;
  final comments = [].obs;
  final relatedNews = [].obs;
  final categories = [].obs;

  Future<void> getNewsDetails(
    String newsId, {
    bool isLoadingData = true,
  }) async {
    if (isLoadingData) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.newsDetails(newsId, userId);
      // log(res.toString(), name: 'getNewsDetails');
      if (res['common']['status'] == true) {
        detailsData.value = res['data'] ?? {};
        comments.value = res['data']['comments'] ?? [];
        relatedNews.value = res['data']['related_news'] ?? [];
        categories.value = res['data']['categories'] ?? [];
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      if (isLoadingData) isLoading.value = false;
    }
  }

  //news by category
  final page = 1.obs;
  final perPage = 10.obs;
  final isFirstLoadRunning = false.obs;
  final isLoadMoreRunning = false.obs;
  final hasMore = true.obs;
  final newsList = [].obs;

  Future<void> getNewsByCategory(String catId, {bool isRefresh = false}) async {
    if (isFirstLoadRunning.value) return;

    page.value = 1;
    hasMore.value = true;
    newsList.clear();

    isFirstLoadRunning.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.newsByCategory(
        catId,
        page.toString(),
        perPage.toString(),
        userId,
      );
      // log(res.toString(), name: 'getNewsByCategory');
      if (res['common']['status'] == true) {
        if (res['data']['news'] != null) {
          newsList.value = res['data']['news'];
        } else {
          hasMore.value = false;
        }
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      isFirstLoadRunning.value = false;
    }
  }

  Future<void> getNewsMoreCategory(String catId) async {
    if (hasMore.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false) {
      isLoadMoreRunning.value = true;
      page.value += 1;
      final userId = await LocalStorage.getString('user_id');
      try {
        final res = await _apiService.newsByCategory(
          catId,
          page.toString(),
          perPage.toString(),
          userId,
        );

        final List fetchedNews = res['data']['news'];
        if (fetchedNews.isNotEmpty) {
          newsList.addAll(fetchedNews);
        } else {
          hasMore.value = false;
        }
      } catch (err) {
        showToast('Something went wrong. Please try again later.');
      }
      isLoadMoreRunning.value = false;
    }
  }

  Future<void> addNewsComment(String newsId) async {
    isCommentLoading.value = true;
    final token = await LocalStorage.getString('auth_key');
    try {
      final res = await _apiService.addComment(
        newsId,
        token!,
        commentController.text.trim(),
      );
      // log(res.toString(), name: 'addNewsComment');
      if (res['common']['status'] == true) {
        commentController.clear();
        showToast(res['common']['message']);
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isCommentLoading.value = false;
    }
  }

  //news by tags
  final tagName = ''.obs;
  final tagId = ''.obs;
  final tagPage = 1.obs;
  final tagPerPage = 10.obs;
  final isTagFirstLoadRunning = false.obs;
  final isTagLoadMoreRunning = false.obs;
  final hasTagMore = true.obs;
  final tagNewsList = [].obs;

  Future<void> getNewsByTag(String tagId, {bool isRefresh = false}) async {
    if (isTagFirstLoadRunning.value) return;

    tagPage.value = 1;
    hasTagMore.value = true;
    tagNewsList.clear();

    isTagFirstLoadRunning.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final res = await _apiService.newsByTag(
        tagId,
        tagPage.toString(),
        tagPerPage.toString(),
        userId,
      );
      // log(res.toString(), name: 'getNewsByTag');
      if (res['common']['status'] == true) {
        if (res['data']['news'] != null) {
          tagNewsList.value = res['data']['news'];
        } else {
          hasTagMore.value = false;
        }
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      isTagFirstLoadRunning.value = false;
    }
  }

  Future<void> getNewsMoreTag(String tagId) async {
    if (hasTagMore.value == true &&
        isTagFirstLoadRunning.value == false &&
        isTagLoadMoreRunning.value == false) {
      isTagLoadMoreRunning.value = true;
      tagPage.value += 1;
      final userId = await LocalStorage.getString('user_id');
      try {
        final res = await _apiService.newsByTag(
          tagId,
          tagPage.toString(),
          tagPerPage.toString(),
          userId,
        );
        final List fetchedNews = res['data']['news'];
        if (fetchedNews.isNotEmpty) {
          tagNewsList.addAll(fetchedNews);
        } else {
          hasTagMore.value = false;
        }
      } catch (err) {
        showToast('Something went wrong. Please try again later.');
      }
      isTagLoadMoreRunning.value = false;
    }
  }
}
