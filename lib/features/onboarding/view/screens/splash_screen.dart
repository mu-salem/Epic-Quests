import 'dart:ui';

import 'package:epicquests/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/data/local/secure_auth_storage.dart';
import '../../../tasks/data/repositories/sync_hero_profile_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final VideoPlayerController _videoController;
  final _authStorage = SecureAuthStorage();
  final _heroRepository = SyncHeroProfileRepository();

  bool _isReady = false;
  bool _started = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

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

      // Navigate after splash video completes
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  /// Determine where to navigate based on auth status and hero availability
  Future<void> _navigateToNextScreen() async {
    // Check if user is logged in
    final hasToken = await _authStorage.hasToken();

    if (!hasToken) {
      // Not logged in → go to Login
      if (mounted) context.go(AppRouter.login);
      return;
    }

    // User is logged in → check if they have heroes
    final lastHeroId = await _heroRepository.getLastSelectedHero();

    if (lastHeroId != null && lastHeroId.isNotEmpty) {
      // Has last selected hero → go to Home
      if (mounted) context.go('${AppRouter.home}?hero=$lastHeroId');
      return;
    }

    // Check if any heroes exist locally
    final allHeroes = await _heroRepository.listAllHeroes();

    if (allHeroes.isNotEmpty) {
      // Has heroes but no last selected → go to Home with first hero
      if (mounted) context.go('${AppRouter.home}?hero=${allHeroes.first}');
    } else {
      // No heroes yet → go to Avatar Selection to create first hero
      if (mounted) context.go(AppRouter.onboardingAvatar);
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
                child: Container(
                  color: AppColors.black.withValues(alpha: 0.35),
                ),
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
                left: 24.w,
                right: 24.w,
                child: PrimaryButton(
                  text: 'START ADVENTURE',
                  onPressed: _startAdventure,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
