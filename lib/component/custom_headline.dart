import 'package:maharashtrajagran/utils/exported_path.dart';

class CustomHeadline extends StatelessWidget {
  final String title;
  final bool showMore;
  final Color color;
  final VoidCallback onTap;
  const CustomHeadline({
    super.key,
    required this.title,
    this.showMore = true,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Left Title
          CustomText(
            title: title,
            fontSize: !showMore ? 16.sp : 14.sp,
            fontWeight: FontWeight.bold,
            color: primaryGrey,
          ),

          /// Middle Divider Line
          !showMore
              ? const Spacer()
              : Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 1.5.h,
                  color: color, // divider color
                ),
              ),

          /// "अधिक वाचा" Button
          !showMore
              ? const Spacer()
              : GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: primaryLightGrey, width: 0.8),
                    color: Colors.white, // bg color (optional)
                  ),
                  child: CustomText(
                    title: 'अधिक वाचा',
                    fontSize: 12.sp,
                    color: primaryLightGrey,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
