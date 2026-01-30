import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../models/loan_model.dart';
import '../services/voice_service.dart';
import 'loan_detail_overlay_screen.dart';

/// Show loan options with hints - user needs to long-press to see details
class LoanMarketIntroScreen extends ConsumerStatefulWidget {
  const LoanMarketIntroScreen({super.key});

  @override
  ConsumerState<LoanMarketIntroScreen> createState() =>
      _LoanMarketIntroScreenState();
}

class _LoanMarketIntroScreenState extends ConsumerState<LoanMarketIntroScreen> {
  late VoiceService _voiceService;
  late Set<LoanType> _viewedLoans;

  @override
  void initState() {
    super.initState();
    _viewedLoans = {};
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getLoanDetailsPrompt());
    }
  }

  void _viewLoanDetails(LoanType lenderType) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LoanDetailOverlayScreen(lenderType: lenderType),
    );

    if (result == true) {
      setState(() {
        _viewedLoans.add(lenderType);
      });
    }
  }

  bool _allLoansViewed() {
    return _viewedLoans.contains(LoanType.moneylender) &&
        _viewedLoans.contains(LoanType.privateBank) &&
        _viewedLoans.contains(LoanType.govtAgriBank);
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenContainer(
      title: 'Compare Loans',
      showBackButton: true,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Instructions
              Text(
                'Tap each loan to learn details',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Compare all before choosing',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppTheme.lightText,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Loan cards with hints
              _buildLoanHintCard(
                'Moneylender',
                'Fast money, high interest',
                Icons.person,
                AppTheme.accentRed,
                LoanType.moneylender,
                _viewedLoans.contains(LoanType.moneylender),
              ),
              const SizedBox(height: 16),
              _buildLoanHintCard(
                'Private Bank',
                'Medium interest, standard terms',
                Icons.business,
                AppTheme.accentBlue,
                LoanType.privateBank,
                _viewedLoans.contains(LoanType.privateBank),
              ),
              const SizedBox(height: 16),
              _buildLoanHintCard(
                'Government Bank',
                'Lowest interest, subsidy benefit',
                Icons.account_balance,
                AppTheme.primaryGreen,
                LoanType.govtAgriBank,
                _viewedLoans.contains(LoanType.govtAgriBank),
              ),
              const SizedBox(height: 24),

              // Show comparison button when all viewed
              if (_allLoansViewed())
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.primaryGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Great! You\'ve reviewed all loans. Now choose wisely.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!_allLoansViewed()) ...[
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
                          'Review all ${3 - _viewedLoans.length} loans to unlock comparison',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_allLoansViewed()) const SizedBox(height: 24),
              if (_allLoansViewed())
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/comparison_game');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Compare Loans',
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

  Widget _buildLoanHintCard(
    String name,
    String hint,
    IconData icon,
    Color color,
    LoanType lenderType,
    bool isViewed,
  ) {
    return GestureDetector(
      onLongPress: () => _viewLoanDetails(lenderType),
      onTap: () => _viewLoanDetails(lenderType),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isViewed
              ? BorderSide(color: color, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon, size: 48, color: color),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hint,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (isViewed)
                        const Icon(Icons.check_circle,
                            color: AppTheme.primaryGreen)
                      else
                        const Icon(Icons.info_outline, color: Colors.grey),
                      const SizedBox(height: 4),
                      Text(
                        isViewed ? 'Viewed' : 'Tap',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 11,
                              color: isViewed
                                  ? AppTheme.primaryGreen
                                  : Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
