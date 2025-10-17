import '../utils/exported_path.dart';

class OverlayNewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String comment;
  final String? category;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final double width;

  const OverlayNewsCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.comment,
    this.category,
    this.onTap,
    required this.width,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 200.h,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          _buildImageSection(),

          // Gradient Overlay
          _buildGradientOverlay(),

          // Category Badge (top left)
          // if (category != null) _buildCategoryBadge(context),

          // Content Overlay (bottom)
          _buildContentOverlay(context),

          // Interactive Elements (top right)
          // _buildInteractiveElements(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: FadeInImage(
        placeholder: AssetImage(Images.defaultImage),
        image: NetworkImage(image),
        imageErrorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[100],
            child: Image.asset(Images.defaultImage, fit: BoxFit.contain),
          );
        },
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  // Widget _buildCategoryBadge(BuildContext context) {
  //   return Positioned(
  //     top: 12.h,
  //     left: 12.w,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).primaryColor.withOpacity(0.9),
  //         borderRadius: BorderRadius.circular(20.r),
  //       ),
  //       child: Text(
  //         category!,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 10.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContentOverlay(BuildContext context) {
    return Positioned(
      left: 12.w,
      right: 12.w,
      bottom: 12.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),

          // Metadata Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date and Comments
              Row(
                children: [
                  _buildMetadataItem(
                    icon: HugeIcons.strokeRoundedClock01,
                    text: date,
                    iconSize: 12.sp,
                    textSize: 10.sp,
                  ),
                  SizedBox(width: 12.w),
                  _buildMetadataItem(
                    icon: HugeIcons.strokeRoundedComment01,
                    text: comment,
                    iconSize: 12.sp,
                    textSize: 10.sp,
                  ),
                ],
              ),

              // Read More Arrow
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark_outlined
                        : HugeIcons.strokeRoundedBookmark02,
                    size: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildInteractiveElements() {
  //   return Positioned(
  //     top: 12.h,
  //     right: 12.w,
  //     child: Row(
  //       children: [
  //         // Bookmark Button
  //         Container(
  //           padding: EdgeInsets.all(6.r),
  //           decoration: BoxDecoration(
  //             color: Colors.black.withOpacity(0.5),
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(
  //             Icons.bookmark_border_rounded,
  //             size: 16.sp,
  //             color: Colors.white,
  //           ),
  //         ),
  //
  //         SizedBox(width: 8.w),
  //
  //         // // Share Button
  //         // Container(
  //         //   padding: EdgeInsets.all(6.r),
  //         //   decoration: BoxDecoration(
  //         //     color: Colors.black.withOpacity(0.5),
  //         //     shape: BoxShape.circle,
  //         //   ),
  //         //   child: Icon(
  //         //     Icons.share_rounded,
  //         //     size: 16.sp,
  //         //     color: Colors.white,
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMetadataItem({
    required IconData icon,
    required String text,
    required double iconSize,
    required double textSize,
  }) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.8)),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: textSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
