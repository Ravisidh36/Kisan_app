import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../services/voice_service.dart';
import 'blind_loan_selection_screen.dart';
import 'loan_market_intro_screen.dart';

/// First decision: Hurry vs Think (blind vs informed loan choice)
class LoanDecisionModeScreen extends ConsumerStatefulWidget {
  const LoanDecisionModeScreen({super.key});

  @override
  ConsumerState<LoanDecisionModeScreen> createState() =>
      _LoanDecisionModeScreenState();
}

class _LoanDecisionModeScreenState extends ConsumerState<LoanDecisionModeScreen> {
  late VoiceService _voiceService;
  String? _selectedMode;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getLoanDecisionModePrompt());
    }
  }

  Future<void> _selectMode(String mode) async {
    setState(() {
      _selectedMode = mode;
      _isProcessing = true;
    });

    String feedbackText = mode == 'hurry'
        ? 'You decided to hurry. Let\'s get you money fast!'
        : 'Good choice! Taking time to understand loans will save you money.';

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      if (mode == 'hurry') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BlindLoanSelectionScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoanMarketIntroScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenContainer(
      title: 'Loan Decision',
      showBackButton: true,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'You need to borrow money. What will you do?',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: AppTheme.darkText,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Hurry option
              DecisionCard(
                label: 'Just Give Me Money!\n(Hurry)',
                icon: Icons.flash_on,
                color: AppTheme.accentOrange,
                isSelected: _selectedMode == 'hurry',
                onTap: () => _selectMode('hurry'),
              ),
              const SizedBox(height: 24),

              // Think option
              DecisionCard(
                label: 'Let Me Compare\nLoans First (Think)',
                icon: Icons.compare_arrows,
                color: AppTheme.primaryGreen,
                isSelected: _selectedMode == 'think',
                onTap: () => _selectMode('think'),
              ),
              const SizedBox(height: 24),

              // Info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose wisely:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '⚡ Hurry means less information but faster money\n'
                      '🤔 Compare means more time but better choice',
                      style: Theme.of(context).textTheme.bodySmall,
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
