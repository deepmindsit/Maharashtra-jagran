import '../utils/exported_path.dart';

class HorizontalNewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String comment;
  final VoidCallback? onTap;
  final bool isBookmarked;

  const HorizontalNewsCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.comment,
    this.onTap,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.9.sw,
      height: 120.h,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              bottomLeft: Radius.circular(16.r),
            ),
            child: SizedBox(
              width: 120.w,
              height: double.infinity,
              child: FadeInImage(
                placeholder: AssetImage(Images.defaultImage),
                image: NetworkImage(image),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: Get.width * 0.1.w,
                    color: Colors.grey[200],
                    child: Image.asset(
                      Images.defaultImage,
                      fit: BoxFit.contain,
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Expanded(
                    child: CustomText(
                      title: title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      color: primaryGrey,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Metadata Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      CustomWithIcon(
                        icon: HugeIcons.strokeRoundedClock01,
                        title: date,
                      ),
                      CustomWithIcon(
                        icon: HugeIcons.strokeRoundedComment01,
                        title: comment,
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: CustomWithIcon(
                          icon:
                              isBookmarked
                                  ? Icons.bookmark_outlined
                                  : HugeIcons.strokeRoundedBookmark02,
                          title: '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
