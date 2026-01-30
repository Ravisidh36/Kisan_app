import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'fraud_check_screen.dart';

/// Minimal loan summary for blind loans - very little information
class LoanMinimalSummaryScreen extends ConsumerStatefulWidget {
  const LoanMinimalSummaryScreen({super.key});

  @override
  ConsumerState<LoanMinimalSummaryScreen> createState() =>
      _LoanMinimalSummaryScreenState();
}

class _LoanMinimalSummaryScreenState extends ConsumerState<LoanMinimalSummaryScreen> {
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(
          'Your loan is approved! You will get ₹50,000 minus processing fee. You will pay back a fixed amount each season.');
    }
  }

  void _continue() {
    ref.read(gameStateProvider.notifier).nextStep();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FraudCheckScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final loan = gameState.activeLoan;

    return GameScreenContainer(
      title: 'Loan Approved',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),

              // Lender name
              Text(
                'Loan from ${loan?.lenderType.name.replaceAll('_', ' ').toUpperCase()}',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Loan details (minimal)
              if (loan != null) ...[
                _buildInfoRow(
                  context,
                  'Loan Amount',
                  '₹${loan.principal}',
                  Icons.money,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  'Processing Fee',
                  '₹${loan.processingFee}',
                  Icons.attach_money,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  'EMI Per Season',
                  '₹${loan.emiPerSeason}',
                  Icons.calendar_month,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  'Total Interest',
                  '₹${loan.totalInterest}',
                  Icons.trending_up,
                ),
                const SizedBox(height: 24),

                // Received amount
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You Received',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        '₹${loan.principal - loan.processingFee}',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Current status
              MoneyBar(
                currentMoney: gameState.currentMoney,
                maxMoney: 100000,
                label: 'Money After Loan',
              ),
              const SizedBox(height: 24),
              StressMeter(
                stressLevel: gameState.stressLevel,
                label: 'Current Stress',
              ),
              const SizedBox(height: 24),

              // Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.accentOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You will pay EMI every season. Make sure you have enough money!',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
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

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
        ),
      ],
    );
  }
}
