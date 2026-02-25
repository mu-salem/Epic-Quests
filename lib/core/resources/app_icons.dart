import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  AppIcons._();

  static const String _basePath = 'assets/icons';

  // Helper method to create a RepaintBoundary wrapped SVG
  static Widget _buildIcon(
    String path, {
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) {
    return RepaintBoundary(
      child: SvgPicture.asset(
        '$_basePath/$path',
        width: width,
        height: height,
        colorFilter: colorFilter,
      ),
    );
  }

  // Define static getters/methods for each icon
  static Widget achievementBadge({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'achievementBadgeIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget completedQuest({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'completedQuestIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget heroProfile({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'heroProfileIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget highPriority({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'highPriorityIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget homeQuest({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'homeQuestIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget levelProgressBar({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'levelProgressBarIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget lowPriority({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'lowPriorityIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget mediumPriority({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'mediumPriorityIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget monthlyCalendar({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'monthlyCalendarIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget pomodoroSession({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'pomodoroSessionIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget pomodoroTimer({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'pomodoroTimerIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget questChecklist({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'questChecklistIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget questScroll({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'questScrollIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget rewardMedal({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'rewardMedalIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget settingsGear({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'settingsGearIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget statsBarChart({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'statsBarChartIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget streakFire({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'streakFireIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget timeSpentHourglass({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'timeSpentHourglassIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget urgentQuest({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'urgentQuestIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );

  static Widget weeklyQuestCalendar({
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) => _buildIcon(
    'weeklyQuestCalendarIcon.svg',
    width: width,
    height: height,
    colorFilter: colorFilter,
  );
}
