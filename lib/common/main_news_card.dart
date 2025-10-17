import '../utils/exported_path.dart';

class MainNewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String comment;
  final bool isBookmarked;
  final VoidCallback? onTap;

  const MainNewsCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.comment,
    required this.isBookmarked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.7.sw,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Image Section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Stack(
              children: [
                FadeInImage(
                  placeholder: AssetImage(Images.defaultImage),
                  image: NetworkImage(image),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 100.h,
                      color: Colors.grey[200],
                      child: Image.asset(
                        Images.defaultImage,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                ),

                /// Gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Content Section
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                CustomText(
                  title: title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  color: primaryGrey,
                ),

                SizedBox(height: 8.h),

                /// Metadata Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
        ],
      ),
    );
  }
}
