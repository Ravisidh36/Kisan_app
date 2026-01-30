import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'personal_decision_screen.dart';

class SeasonIntroScreen extends ConsumerStatefulWidget {
  const SeasonIntroScreen({super.key});

  @override
  ConsumerState<SeasonIntroScreen> createState() => _SeasonIntroScreenState();
}

class _SeasonIntroScreenState extends ConsumerState<SeasonIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _voiceService = VoiceService();
    _initializeAndSpeak();
  }

  Future<void> _initializeAndSpeak() async {
    await _voiceService.initialize();
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getSeasonIntroMessage());
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startSeason() {
    ref.read(gameStateProvider.notifier).nextStep();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonalDecisionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return GameScreenContainer(
      title: 'Season Start',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Farm Animation (simplified)
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
                ),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightGreen.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.landscape,
                    size: 120,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title and subtitle
              Column(
                children: [
                  Text(
                    'Beginning with ₹50,000 and zero stress',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppTheme.lightText,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Money and Stress display
              Column(
                children: [
                  MoneyBar(
                    currentMoney: gameState.currentMoney,
                    maxMoney: 100000,
                    label: 'Starting Money',
                  ),
                  const SizedBox(height: 24),
                  StressMeter(
                    stressLevel: gameState.stressLevel,
                    label: 'Starting Stress',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Start Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startSeason,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Season',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
