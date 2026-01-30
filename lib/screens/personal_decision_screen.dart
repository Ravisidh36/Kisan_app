import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'farm_investment_screen.dart';

class PersonalDecisionScreen extends ConsumerStatefulWidget {
  const PersonalDecisionScreen({super.key});

  @override
  ConsumerState<PersonalDecisionScreen> createState() =>
      _PersonalDecisionScreenState();
}

class _PersonalDecisionScreenState extends ConsumerState<PersonalDecisionScreen> {
  late VoiceService _voiceService;
  String? _selectedDecision;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getPersonalDecisionPrompt());
    }
  }

  Future<void> _makeDecision(String decisionType) async {
    setState(() {
      _selectedDecision = decisionType;
      _isProcessing = true;
    });

    // Apply decision with ₹20,000
    const amountPerDecision = 20000;
    ref.read(gameStateProvider.notifier).makePersonalDecision(
          decisionType,
          amountPerDecision,
        );

    // Play voice feedback
    String feedbackText = '';
    if (decisionType == 'save') {
      feedbackText = 'Good! You saved ₹20,000 for emergencies. Stress reduced.';
    } else if (decisionType == 'invest') {
      feedbackText = 'You invested ₹20,000 in your farm. Let\'s see how it grows.';
    } else {
      feedbackText = 'You spent ₹20,000 on personal needs. But stress increased.';
    }

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    // Wait a bit for animations, then navigate
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmInvestmentScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return GameScreenContainer(
      title: 'Personal Decision',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Money status
              MoneyBar(
                currentMoney: gameState.currentMoney,
                maxMoney: 100000,
                label: 'Current Money',
              ),
              const SizedBox(height: 24),

              // Decision prompt
              Text(
                'You have ₹20,000 to allocate. What will you do?',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: AppTheme.darkText,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Three decision cards
              DecisionCard(
                label: 'Save',
                icon: Icons.savings,
                color: AppTheme.accentBlue,
                isSelected: _selectedDecision == 'save',
                onTap: () => _makeDecision('save'),
              ),
              const SizedBox(height: 16),
              DecisionCard(
                label: 'Invest in Farm',
                icon: Icons.trending_up,
                color: AppTheme.primaryGreen,
                isSelected: _selectedDecision == 'invest',
                onTap: () => _makeDecision('invest'),
              ),
              const SizedBox(height: 16),
              DecisionCard(
                label: 'Spend',
                icon: Icons.shopping_bag,
                color: AppTheme.accentOrange,
                isSelected: _selectedDecision == 'spend',
                onTap: () => _makeDecision('spend'),
              ),
              const SizedBox(height: 24),

              // Helper text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.accentBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Saving reduces stress. Investing in farm can increase yield. Spending on personal needs increases stress.',
                        style: Theme.of(context).textTheme.bodySmall,
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
