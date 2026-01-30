import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../models/loan_model.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'loan_minimal_summary_screen.dart';

/// Blind loan selection - user picks quickly without details
class BlindLoanSelectionScreen extends ConsumerStatefulWidget {
  const BlindLoanSelectionScreen({super.key});

  @override
  ConsumerState<BlindLoanSelectionScreen> createState() =>
      _BlindLoanSelectionScreenState();
}

class _BlindLoanSelectionScreenState extends ConsumerState<BlindLoanSelectionScreen> {
  late VoiceService _voiceService;
  LoanType? _selectedLender;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getBlindLoanPrompt());
    }
  }

  Future<void> _selectLender(LoanType lenderType) async {
    setState(() {
      _selectedLender = lenderType;
      _isProcessing = true;
    });

    // Get product and take loan
    final product = LoanProduct.predefined[lenderType]!;
    const loanAmount = 50000;
    const seasons = 3; // Assume 3 seasons to repay

    ref
        .read(gameStateProvider.notifier)
        .takeLoan(product, loanAmount, seasons, blind: true);

    String feedbackText =
        'You chose ${product.lenderName}. Your loan is approved!';

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanMinimalSummaryScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenContainer(
      title: 'Choose Your Lender',
      showBackButton: true,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Instructions
              Text(
                'Choose any lender. No time for details!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Lender options - just icons, no details
              _buildLenderCard(
                'Moneylender',
                Icons.person,
                AppTheme.accentRed,
                LoanType.moneylender,
              ),
              const SizedBox(height: 16),
              _buildLenderCard(
                'Private Bank',
                Icons.business,
                AppTheme.accentBlue,
                LoanType.privateBank,
              ),
              const SizedBox(height: 16),
              _buildLenderCard(
                'Government Bank',
                Icons.account_balance,
                AppTheme.primaryGreen,
                LoanType.govtAgriBank,
              ),
              const SizedBox(height: 24),

              // Warning message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentRed, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: AppTheme.accentRed),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'WARNING: Choosing without details can cost you money!',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentRed,
                            ),
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

  Widget _buildLenderCard(
    String name,
    IconData icon,
    Color color,
    LoanType lenderType,
  ) {
    final isSelected = _selectedLender == lenderType;

    return GestureDetector(
      onTap: _isProcessing ? null : () => _selectLender(lenderType),
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: color, width: 3)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: color),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Selected'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
