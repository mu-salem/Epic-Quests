import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:epicquests/core/theme/app_colors.dart';
import 'package:epicquests/core/widgets/widgets.dart';

class AddAvatarActions extends StatelessWidget {
  final VoidCallback onCreate;

  const AddAvatarActions({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 10.h,
        bottom: 20.h + bottomPadding + bottomSafeArea,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(top: BorderSide(color: AppColors.border, width: 2)),
      ),
      child: PrimaryButton(
        text: 'CREATE AVATAR',
        width: double.infinity,
        onPressed: onCreate,
        backgroundColor: AppColors.panelLight,
        borderColor: AppColors.accent,
        shadowColor: AppColors.accent,
        textColor: AppColors.backgroundDark,
      ),
    );
  }
}
