import 'package:maharashtrajagran/utils/exported_path.dart';

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final selectedIndex = RxnInt();
  final selectedId = 0.obs;
  final selectedCategories = <int>[].obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Optional: Add methods for convenience
  final List<int> defaultSelectedCategories = [
    5,
    4,
    26,
    24,
    3,
    15,
    16,
    18,
    20,
    22,
    17,
    19,
    23,
  ];

  void toggleCategory(int categoryId) async {
    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }
    await _saveSelectedCategories();
  }

  Future<void> _saveSelectedCategories() async {
    List<String> ids = selectedCategories.map((e) => e.toString()).toList();
    await LocalStorage.setStringList(bookmarkKey, ids);
  }

  Future<void> loadSelectedCategories() async {
    List<String> ids = await LocalStorage.getStringList(bookmarkKey);
    final stored = ids.map(int.parse).toList();
    // ✅ merge stored and defaults, without duplicates
    final merged = List<int>.from(stored);

    for (var def in defaultSelectedCategories) {
      if (!merged.contains(def)) {
        merged.add(def);
      }
    }
    selectedCategories.assignAll(merged);
    _saveSelectedCategories();
  }

  //dashboard api
  final isLoading = false.obs;
  final isCatLoading = false.obs;
  final dashboardData = {}.obs;
  final marqueeData = [].obs;
  final recentNewsData = [].obs;
  final categoriesData = [].obs;
  final categoriesListData = [].obs;
  final preferredNewsData = [].obs;

  // =================== FETCH dashboard Data ===================
  /// Fetches dashboard
  Future<void> getDashboard() async {
    isLoading.value = true;
    final token = await LocalStorage.getString('auth_key');
    final userId = await LocalStorage.getString('user_id');
    final prefer = await LocalStorage.getStringList(bookmarkKey);
    try {
      final res = await _apiService.getDashboard(token, userId, prefer);
      if (res['common']['status'] == true) {
        dashboardData.value = res['data'] ?? {};
        marqueeData.value = res['data']['marquee'] ?? [];
        recentNewsData.value = res['data']['recent_news'] ?? [];
        categoriesData.value = res['data']['categories'] ?? [];
        preferredNewsData.value = res['data']['preferred_news'] ?? [];
      }
      // log('getDashboard');
      // log(token.toString());
      // log(res.toString());
      if (token!.isNotEmpty && res['common']['user_login'] == false) {
        checkLogin(true);
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      isLoading.value = false;
    }
  }

  // =================== FETCH Categories Data ===================
  /// Fetches dashboard
  Future<void> getCategories() async {
    isCatLoading.value = true;
    try {
      final res = await _apiService.getCategories();
      if (res['common']['status'] == true) {
        categoriesListData.value = res['data']['categories'] ?? [];
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
    } finally {
      isCatLoading.value = false;
    }
  }
}
