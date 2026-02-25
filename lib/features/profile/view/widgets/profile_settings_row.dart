import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileSettingsRow extends StatelessWidget {
  final bool isSoundEnabled;
  final VoidCallback onToggleSound;
  final VoidCallback onStatsPressed;
  final VoidCallback onAccountPressed;

  const ProfileSettingsRow({
    super.key,
    required this.isSoundEnabled,
    required this.onToggleSound,
    required this.onStatsPressed,
    required this.onAccountPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcons.settingsGear(width: 14.w, height: 14.h),
              SizedBox(width: 8.w),
              Text(
                '[ SETTINGS ]',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 7.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _ToggleRow(
            icon: '🔊',
            label: 'Sound Effects',
            value: isSoundEnabled,
            onChanged: (_) => onToggleSound(),
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.border, height: 1),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onStatsPressed,
            child: Row(
              children: [
                AppIcons.statsBarChart(width: 18.w, height: 18.h),
                SizedBox(width: 10.w),
                Text(
                  'View Full Statistics',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 16.sp,
                    color: AppColors.accent,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: AppColors.accent, size: 20.r),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.border, height: 1),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onAccountPressed,
            child: Row(
              children: [
                Icon(Icons.person_outline, color: AppColors.accent, size: 18.w),
                SizedBox(width: 10.w),
                Text(
                  'Account & Security',
                  style: TextStyle(
                    fontFamily: 'VT323',
                    fontSize: 16.sp,
                    color: AppColors.accent,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: AppColors.accent, size: 20.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: TextStyle(fontSize: 16.sp)),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          inactiveTrackColor: AppColors.border,
        ),
      ],
    );
  }
}
