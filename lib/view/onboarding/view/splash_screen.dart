import '../../../utils/exported_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final controller = getIt<OnboardingController>();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 1.02,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      if (NotificationService.hasHandledNotificationNavigation) return;

      final token = await LocalStorage.getString('auth_key');
      final isOnboarding = await LocalStorage.getBool('onboarding') ?? false;
      token != null
          ? Get.offAllNamed(Routes.mainScreen)
          : !isOnboarding
          ? Get.offAllNamed(Routes.onboarding1)
          : Get.offAllNamed(Routes.login);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initialize();
  // }
  //
  // Future<void> _initialize() async {
  //   // Wait for the first frame to complete before navigating
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Future.delayed(const Duration(seconds: 1));
  //     controller.expanded.value = true;
  //
  //     bool isConnected = await InternetConnectionChecker.instance.hasConnection;
  //
  //     // if (isConnected) {
  //     //   token != null
  //     //       ? Get.offAllNamed(Routes.mainScreen)
  //     //       : Get.offAllNamed(Routes.login);
  //     // } else {
  //     //   showNoInternetDialog();
  //     // }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Image.asset(
          Images.splashScreen,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );

    //   Obx(
    //   () => Material(
    //     surfaceTintColor: Colors.white,
    //     color: Colors.white,
    //     child:AnimatedCrossFade(
    //       firstCurve: Curves.fastOutSlowIn,
    //       crossFadeState:
    //       !controller.expanded.value
    //           ? CrossFadeState.showFirst
    //           : CrossFadeState.showSecond,
    //       duration: controller.transitionDuration,
    //       firstChild: Container(),
    //       secondChild: _logoRemainder(),
    //       alignment: Alignment.centerLeft,
    //       sizeCurve: Curves.easeInOut,
    //     ),
    //   ),
    // );
  }
}
