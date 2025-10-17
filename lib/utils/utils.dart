import 'package:maharashtrajagran/utils/exported_path.dart';

String? validateUserName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'कृपया मोबाईल नंबर/ईमेल आयडी टाका';
  }

  // Check if value is numeric (possible mobile number)
  final numericRegex = RegExp(r'^[0-9]+$');
  if (numericRegex.hasMatch(value)) {
    if (value.length != 10) {
      return 'कृपया वैध मोबाईल नंबर टाका (१० अंकांचा)';
    }
    return null; // valid mobile
  }

  // Otherwise, check for valid email
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  if (!emailRegex.hasMatch(value)) {
    return 'कृपया वैध ईमेल आयडी टाका';
  }

  return null; // valid email
}

launchURL(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
