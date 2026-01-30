import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'harvest_screen.dart';

class FraudCheckScreen extends ConsumerStatefulWidget {
  const FraudCheckScreen({super.key});

  @override
  ConsumerState<FraudCheckScreen> createState() => _FraudCheckScreenState();
}

class _FraudCheckScreenState extends ConsumerState<FraudCheckScreen> {
  late VoiceService _voiceService;
  String? _selectedAction;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getFraudOtpPrompt());
    }
  }

  Future<void> _handleDecision(bool sharedOTP) async {
    setState(() {
      _selectedAction = sharedOTP ? 'share' : 'refuse';
      _isProcessing = true;
    });

    ref.read(gameStateProvider.notifier).handleFraudOTP(sharedOTP);

    String feedbackText = sharedOTP
        ? 'Oh no! That was a scam. You lost ₹8000 and stress increased. Never share OTP!'
        : 'Smart choice! You refused and protected your account. Your stress actually decreased!';

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      ref.read(gameStateProvider.notifier).finalizeHarvest();
      ref.read(gameStateProvider.notifier).nextStep();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HarvestScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return GameScreenContainer(
      title: 'Fraud Alert',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phone call visual
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentOrange.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  size: 80,
                  color: AppTheme.accentOrange,
                ),
              ),
              const SizedBox(height: 24),

              // Alert message
              Text(
                'Incoming Call',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Unknown Caller',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"Hello! Your bank account has unusual activity. We need to verify using OTP. What is your OTP?"',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Current status
              MoneyBar(
                currentMoney: gameState.currentMoney,
                maxMoney: 100000,
                label: 'Your Money',
              ),
              const SizedBox(height: 20),
              StressMeter(
                stressLevel: gameState.stressLevel,
                label: 'Your Stress',
              ),
              const SizedBox(height: 24),

              // Decision buttons
              DecisionCard(
                label: 'Share OTP',
                icon: Icons.phone,
                color: AppTheme.accentRed,
                isSelected: _selectedAction == 'share',
                onTap: () => _handleDecision(true),
              ),
              const SizedBox(height: 20),
              DecisionCard(
                label: 'Refuse & Hang Up',
                icon: Icons.phone_disabled,
                color: AppTheme.primaryGreen,
                isSelected: _selectedAction == 'refuse',
                onTap: () => _handleDecision(false),
              ),
              const SizedBox(height: 24),

              // Learning note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: AppTheme.accentRed),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REMEMBER',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentRed,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Banks and governments NEVER ask for OTP by phone or SMS. This is a common fraud. Protect your OTP!',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
