import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// Red outlined button for deleting avatar
class DeleteAvatarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteAvatarButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.delete_outline, size: 20.sp),
      label: Text(
        'DELETE AVATAR',
        style: AppTextStyles.bodyM.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error, width: 2),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
