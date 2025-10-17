import '../utils/exported_path.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    controller.getLegalPage(widget.slug);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isPolicyLoading.isTrue
              ? Container(
                color: Colors.white,
                child: LoadingWidget(color: primaryColor),
              )
              : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: Colors.white),
                  surfaceTintColor: Colors.white,
                  foregroundColor: Colors.black,
                  backgroundColor: primaryColor,
                  title: CustomText(
                    title: controller.legalPage['title'] ?? '',
                    fontSize: 22.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(
                    controller.legalPage['description'] ?? '-',
                    textStyle: TextStyle(fontSize: 14.sp, height: 1.6),
                  ),
                ),

                // WebViewWidget(controller: _controller),
              ),
    );
  }
}
