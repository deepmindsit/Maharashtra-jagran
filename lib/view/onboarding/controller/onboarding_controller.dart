
import '../../../utils/exported_path.dart';

@lazySingleton
class OnboardingController extends GetxController {
  final ApiService _apiService = Get.find();
  final selectedIndex = RxnInt();
  final userNameController = TextEditingController();
  final pinController = TextEditingController();
  final List data = [
    {
      'title': 'ठळक आणि ताज्या घडामोडींचे नोटिफिकेशन मिळवा',
      'icon': Images.icNotification,
      'id': 1,
    },
    {
      'title': 'मुख्यपृष्ठावरील विभाग आवडीनुसार निवडा',
      'icon': Images.icCategory,
      'id': 2,
    },
    {
      'title': 'ऑफलाईन वाचनासाठी लेख सेव्ह करा',
      'icon': Images.icBookmark,
      'id': 3,
    },
  ];

  // =================== check user Data ===================
  ///  Check user api
  final isLoading = false.obs;
  final checkUserKey = GlobalKey<FormState>();

  Future<void> checkUser() async {
    isLoading.value = true;
    try {
      // LocalStorage.clear();
      final res = await _apiService.checkUser(userNameController.text.trim());
      // log(res.toString(), name: 'checkUser');
      if (res['common']['status'] == true) {
        if (res['data']['user_exists'] == true) {
          Get.toNamed(
            Routes.login2,
            arguments: {'mobile': userNameController.text.trim()},
          );
        } else {
          Get.toNamed(
            Routes.verifyOtp,
            arguments: {'mobile': userNameController.text.trim()},
          );
        }
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =================== verify otp Data ===================
  ///  Check user api
  var start = 30.obs;
  Timer? _timer;
  final isVerifyLoading = false.obs;
  final verifyOtpKey = GlobalKey<FormState>();

  Future<void> verifyOtp() async {
    isLoading.value = true;
    try {
      final res = await _apiService.verifyOtp(
        userNameController.text.trim(),
        pinController.text.trim(),
      );
      // log(res.toString(), name: 'verifyOtp');
      if (res['common']['status'] == true) {
        LocalStorage.setString('auth_key', res['data']['verification_token']);
        showToast(res['common']['message']);
        Get.toNamed(
          Routes.register,
          arguments: {'mobile': userNameController.text.trim()},
        );
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    start.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        timer.cancel();
      } else {
        start.value--;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resendOtp() {
    checkUser();
    startTimer();
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }

  // =================== register user ===================
  ///  register user api
  final isRegLoading = false.obs;
  final registerKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final pwController = TextEditingController();
  final cpwController = TextEditingController();
  final isObscure = true.obs;
  final isCObscure = true.obs;

  Future<void> registerUser() async {
    isRegLoading.value = true;
    try {
      final token = await LocalStorage.getString('auth_key');
      final res = await _apiService.register(
        userNameController.text.trim(),
        pwController.text.trim(),
        cpwController.text.trim(),
        token!,
      );
      // log(res.toString(), name: 'registerUser');
      if (res['common']['status'] == true) {
        LocalStorage.setString('user_id', res['data']['user_id'].toString());
        Get.offAllNamed(Routes.mainScreen);
        userNameController.clear();
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isRegLoading.value = false;
    }
  }

  // =================== login user Data ===================
  ///  login user api
  final isLoginLoading = false.obs;
  final loginKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  Future<void> login() async {
    isLoginLoading.value = true;
    try {
      final res = await _apiService.loginUser(
        userNameController.text.trim(),
        passwordController.text.trim(),
      );
      // log(res.toString(), name: 'login');
      if (res['common']['status'] == true) {
        LocalStorage.setString('user_id', res['data']['user_id'].toString());
        LocalStorage.setString('auth_key', res['data']['session_token']);
        showToast(res['common']['message']);
        Get.offAllNamed(Routes.mainScreen);
        userNameController.clear();
      }
    } catch (e) {
      showToast('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isLoginLoading.value = false;
    }
  }
}
