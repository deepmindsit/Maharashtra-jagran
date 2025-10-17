import '../utils/exported_path.dart';

class CustomWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final double size;
  final double spacing;

  const CustomWithIcon({
    super.key,
    required this.icon,
    required this.title,
    this.color = primaryLightGrey,
    this.size = 16,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(icon: icon, color: color, size: 16.sp),
        SizedBox(width: spacing),
        CustomText(
          title: title,
          fontSize: 12.sp,
          color: color,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
