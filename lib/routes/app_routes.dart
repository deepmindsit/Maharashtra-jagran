
import '../utils/exported_path.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.onboarding1, page: () => OnboardingPage1()),
    GetPage(name: Routes.onboarding2, page: () => OnboardingPage2()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.login2, page: () => LoginScreen2()),
    GetPage(name: Routes.forgetPassword, page: () => ForgetPassword()),
    GetPage(name: Routes.forgetVerifyOtp, page: () => ForgetVerifyOtp()),
    GetPage(name: Routes.forgetResetPassword, page: () => ForgetPasswordReset()),
    GetPage(name: Routes.verifyOtp, page: () => VerifyOtp()),
    GetPage(name: Routes.register, page: () => RegisterScreen()),
    GetPage(name: Routes.mainScreen, page: () => NavigationScreen()),
    GetPage(name: Routes.updateCategory, page: () => UpdateCategory()),
    GetPage(name: Routes.setNewPassword, page: () => SetNewPassword()),
    GetPage(name: Routes.aboutUs, page: () => AboutUs()),
    GetPage(name: Routes.editProfile, page: () => EditProfile()),
    GetPage(name: Routes.newsDetails, page: () => NewsDetails()),
    GetPage(name: Routes.newsList, page: () => NewsList()),
    GetPage(name: Routes.newsListByTag, page: () => NewsListByTags()),
    GetPage(name: Routes.newsListBySearch, page: () => NewsListBySearch()),
    GetPage(name: Routes.notificationList, page: () => NotificationList()),
  ];
}
