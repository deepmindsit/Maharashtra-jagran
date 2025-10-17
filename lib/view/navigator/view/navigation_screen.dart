import '../../../utils/exported_path.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  final controller = getIt<NavigationController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child:
              NavigationController.widgetOptions[controller.currentIndex.value],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            boxShadow: [
              if (theme.brightness == Brightness.light)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              else
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: BottomNavigationBar(
              backgroundColor: primaryColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              currentIndex: controller.currentIndex.value,
              onTap: controller.updateIndex,

              items: [
                _buildNavItem(
                  HugeIcons.strokeRoundedAnalyticsUp,
                  'होमपेज',
                  0,
                  controller.currentIndex.value == 0,
                ),
                _buildNavItem(
                  HugeIcons.strokeRoundedBookmark01,
                  'सेव्ह्',
                  1,
                  controller.currentIndex.value == 1,
                ),
                _buildNavItem(
                  HugeIcons.strokeRoundedUser,
                  'युझर अकॉउंट',
                  2,
                  controller.currentIndex.value == 2,
                  iconSize: Get.width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isSelected, {
    double? iconSize,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: primaryColor,
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child:
            index == 0
                ? Image.asset(
                  Images.mAlphabet,
                  width: Get.width * 0.055.w,
                  // color: isSelected ? Colors.transparent : Colors.white70,
                )
                : HugeIcon(
                  size: iconSize ?? Get.width * 0.06,
                  icon: icon,
                  color: isSelected ? Colors.white : Colors.white38,
                ),
      ),
      label: label,
    );
  }
}
