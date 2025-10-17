import '../utils/exported_path.dart';

void showToast(String status) {
  Fluttertoast.showToast(
    msg: status,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: primaryLightGrey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
