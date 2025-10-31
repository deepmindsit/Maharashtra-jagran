import 'dart:developer';

import 'package:maharashtrajagran/utils/exported_path.dart';

@lazySingleton
class SearchDataController extends GetxController {
  final ApiService _apiService = Get.find();
  final searchText = ''.obs;
  final searchController = TextEditingController();
  final searchList = [].obs;

  //news by category
  final page = 1.obs;
  final perPage = 10.obs;
  final isFirstLoadRunning = false.obs;
  final isLoadMoreRunning = false.obs;
  final hasMore = true.obs;

  Future<void> getNewsBySearch(String query, {bool isRefresh = false}) async {
    if (isFirstLoadRunning.value) return;

    page.value = 1;
    hasMore.value = true;
    searchList.clear();

    isFirstLoadRunning.value = true;
    try {
      log(searchController.text, name: 'keyword');
      final userId = await LocalStorage.getString('user_id');
      final res = await _apiService.newsBySearch(
        query,
        // searchController.text.trim(),
        page.toString(),
        perPage.toString(),
        userId,
      );
      log(res.toString(), name: 'getNewsBySearch');
      if (res['common']['status'] == true) {
        if (res['data']['news'] != null) {
          searchList.value = res['data']['news'];
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

  Future<void> getNewsMoreSearch(String query) async {
    if (hasMore.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false) {
      isLoadMoreRunning.value = true;
      page.value += 1;
      try {
        final userId = await LocalStorage.getString('user_id');
        final res = await _apiService.newsBySearch(
          query,
          // searchController.text.trim(),
          page.toString(),
          perPage.toString(),
          userId,
        );

        final List fetchedNews = res['data']['news'];
        if (fetchedNews.isNotEmpty) {
          searchList.addAll(fetchedNews);
        } else {
          hasMore.value = false;
        }
      } catch (err) {
        showToast('Something went wrong. Please try again later.');
      }
      isLoadMoreRunning.value = false;
    }
  }
}
