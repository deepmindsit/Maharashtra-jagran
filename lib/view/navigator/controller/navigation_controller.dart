import '../../../utils/exported_path.dart';

@lazySingleton
class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  static final List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    Bookmark(),
    ProfileScreen(),
  ];

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
