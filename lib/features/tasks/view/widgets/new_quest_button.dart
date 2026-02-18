import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';


class NewQuestButton extends StatelessWidget {
  const NewQuestButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16.w,
          12.h,
          16.w,
          MediaQuery.of(context).padding.bottom + 16.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundDark.withOpacity(0.0),
              AppColors.backgroundDark.withOpacity(0.9),
              AppColors.backgroundDark,
            ],
          ),
        ),
        child: PrimaryButton(
          text: '+ NEW QUEST',
          width: double.infinity,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
