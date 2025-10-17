import 'package:maharashtrajagran/utils/exported_path.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLinkString();
      if (initialLink != null) _handleDeepLink(initialLink);
    } catch (_) {}

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleDeepLink(uri.toString());
    }, onError: (_) {});
  }

  void _handleDeepLink(String link) {
    Uri uri = Uri.parse(link);
    String? id;

    // ✅ Handle https://maharashtrajagran.com/newsDetails/{id}
    if (uri.scheme.startsWith('https') && uri.host == 'maharashtrajagran.com') {
      id = uri.pathSegments.last;
      // if (uri.pathSegments.contains("newsDetails")) {
      //   id = uri.pathSegments.last;
      // }
    }
    // ✅ Handle custom scheme: mjagran://news/details/{id}
    else if (uri.scheme == 'mjagran' &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == "news" &&
        uri.pathSegments.length > 2 &&
        uri.pathSegments[1] == "details") {
      id = uri.pathSegments[2];
    }

    if (id != null) {
      Get.toNamed(Routes.newsDetails, arguments: {'newsId': id});
    }
  }
}
