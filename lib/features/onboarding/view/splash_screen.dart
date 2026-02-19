import 'dart:ui';

import 'package:epicquests/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../core/routing/route_constants.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import 'avatar_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoController;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeInNextScreen;

  bool _isReady = false;
  bool _started = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fadeInNextScreen = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _videoController = VideoPlayerController.asset('assets/video/intro.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _isReady = true);
      });

    _videoController.addListener(_onVideoTick);
  }

  void _onVideoTick() {
    if (!_videoController.value.isInitialized) return;

    if (!_completed && _videoController.value.isCompleted) {
      _completed = true;

      _fadeController.forward().whenComplete(() {
        if (!mounted) return;
        context.go(RouteConstants.onboardingAvatar);
      });
    }
  }

  Future<void> _startAdventure() async {
    if (!_isReady || _started) return;

    setState(() => _started = true);

    await _videoController.seekTo(Duration.zero);
    await _videoController.play();
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoTick);
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!_isReady)
            const ColoredBox(color: AppColors.black)
          else ...[
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: AppColors.black.withValues(alpha: 0.35)),
              ),
            ),

            Center(
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            ),

            if (!_started) ...[
              Positioned(
                top: 100.h,
                left: 0,
                right: 0,
                child: Text(
                  'EPIC QUESTS',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
              ),

              Positioned(
                bottom: 80.h,
                left: 0,
                right: 0,
                child: PrimaryButton(
                  text: 'START ADVENTURE',
                  onPressed: _startAdventure,
                ),
              ),
            ],

            IgnorePointer(
              ignoring: true,
              child: FadeTransition(
                opacity: _fadeInNextScreen,
                child: const AvatarSelectionScreen(),
              ),
            ),

            IgnorePointer(
              ignoring: true,
              child: FadeTransition(
                opacity: _fadeInNextScreen,
                child: Container(
                  color: AppColors.black.withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
