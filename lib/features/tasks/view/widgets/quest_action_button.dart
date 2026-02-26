import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestActionButton extends StatelessWidget {
  final Widget iconWidget;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const QuestActionButton({
    super.key,
    required this.iconWidget,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 7.sp,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
