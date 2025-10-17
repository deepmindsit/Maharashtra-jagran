import '../utils/exported_path.dart';

class CompactNewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String comment;
  final bool isBookmarked;
  final VoidCallback? onTap;

  const CompactNewsCard({
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
      width: 0.6.sw - 16.w, // 50% of screen width minus padding
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4.r,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: SizedBox(
              width: double.infinity,
              height:
                  Get.height *
                  0.17.h, // Slightly smaller height for compactness
              child: FadeInImage(
                placeholder: AssetImage(Images.defaultImage),
                image: NetworkImage(image),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
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
          Padding(
            padding: EdgeInsets.all(8.r), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomText(
                  title: title,
                  fontSize: 12.sp, // Smaller font size
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  color: primaryGrey,
                ),

                SizedBox(height: 6.h),
                // CustomText(
                //   title:
                //       "महाराष्ट्र जागरण डेस्क: स्मृतिभ्रंश हा मेंदूशी-संबंधित एक गंभीर आजार आहे, ज्यामध्ये मेंदू-च्या पेशी खराब होतात. स्मृतिभ्रंशामुळे माणसाची विचार करण्याची, समजून घेण्याची आणिबोलण्याची क्षमता…",
                //   fontSize: 12.sp, // Smaller font size
                //   fontWeight: FontWeight.w300,
                //   maxLines: 4,
                //   textAlign: TextAlign.start,
                //   color: primaryLightGrey,
                // ),
                // SizedBox(height: 6.h),
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
        ],
      ),
    );
  }
}
