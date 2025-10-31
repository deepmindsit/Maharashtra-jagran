import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Client> getHttpClient() async {
  final ioc =
      HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
  return IOClient(ioc);
}

class AllUrl {

  // static const String baseUrl = "http://192.168.29.37/mjagran/api";
  static const String baseUrl = "https://maharashtrajagran.com/api";
  static const String login = '$baseUrl/login.php';
  static const String verifyOtp = '$baseUrl/verify_otp.php';
  static const String checkUser = '$baseUrl/check_user.php';
  static const String register = '$baseUrl/register.php';
  static const String dashboard = '$baseUrl/dashboard.php';
  static const String categories = '$baseUrl/list_categories.php';
  static const String aboutUs = '$baseUrl/about_us.php';
  static const String getProfile = '$baseUrl/get_profile.php';
  static const String editProfile = '$baseUrl/update_profile.php';
  static const String updatePassword = '$baseUrl/update_password.php';
  static const String bookmarkPost = '$baseUrl/bookmark_post.php';
  static const String addComment = '$baseUrl/add_comment.php';
  static const String getBookmarks = '$baseUrl/get_bookmarks.php';
  static const String addBookmarks = '$baseUrl/bookmark_post.php';
  static const String deleteProfile = '$baseUrl/delete_profile.php';
  static const String legalPage = '$baseUrl/get_legal_page.php';
  static const String newsDetails = '$baseUrl/news_details.php';
  static const String newsByCategory = '$baseUrl/get_news_by_category.php';
  static const String newsByTag = '$baseUrl/get_news_by_tag.php';
  // static const String newsBySearch = '$baseUrl/get_news_by_keyword.php';
  static const String newsBySearch = '$baseUrl/global_search.php';
  static const String getNotification = '$baseUrl/get_notifications.php';
  static const String updateFirebaseToken =
      '$baseUrl/update_firebase_token.php';

  static const String forgetPassword = '$baseUrl/forgot_password_request.php';
  static const String forgetVerifyOtp =
      '$baseUrl/forgot_password_verify_otp.php';
  static const String forgetPasswordReset =
      '$baseUrl/forgot_password_reset.php';
}
