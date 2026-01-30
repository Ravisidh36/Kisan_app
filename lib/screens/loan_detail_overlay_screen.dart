import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../models/loan_model.dart';
import '../services/voice_service.dart';

/// Modal showing full details of a loan product
class LoanDetailOverlayScreen extends ConsumerStatefulWidget {
  final LoanType lenderType;

  const LoanDetailOverlayScreen({
    Key? key,
    required this.lenderType,
  }) : super(key: key);

  @override
  ConsumerState<LoanDetailOverlayScreen> createState() =>
      _LoanDetailOverlayScreenState();
}

class _LoanDetailOverlayScreenState extends ConsumerState<LoanDetailOverlayScreen> {
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _narrateLoanDetails();
  }

  Future<void> _narrateLoanDetails() async {
    final product = LoanProduct.predefined[widget.lenderType]!;
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(
        _voiceService.getLoanDetailNarration(
          product.lenderName,
          product.interestRate,
          product.processingFee,
          product.hasSubsidy,
          product.hasCollateralRisk,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = LoanProduct.predefined[widget.lenderType]!;

    return Container(
      color: AppTheme.backgroundColor,
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lender name and icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _colorForLender(widget.lenderType)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _iconForLender(widget.lenderType),
                                size: 32,
                                color: _colorForLender(widget.lenderType),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.lenderName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Details sections
                        _buildDetailSection(
                          context,
                          'Interest Rate',
                          '${product.interestRate.toStringAsFixed(1)}% per year',
                          _colorForLender(widget.lenderType),
                          Icons.trending_up,
                        ),
                        const SizedBox(height: 20),

                        _buildDetailSection(
                          context,
                          'Processing Fee',
                          '₹${product.processingFee}',
                          AppTheme.accentOrange,
                          Icons.attach_money,
                        ),
                        const SizedBox(height: 20),

                        // Collateral risk
                        _buildFeatureRow(
                          context,
                          'Collateral Risk',
                          product.hasCollateralRisk
                              ? 'Your land is at risk if you cannot repay'
                              : 'Your land is safe - no collateral required',
                          product.hasCollateralRisk
                              ? AppTheme.accentRed
                              : AppTheme.lightGreen,
                          product.hasCollateralRisk
                              ? Icons.warning
                              : Icons.check_circle,
                        ),
                        const SizedBox(height: 20),

                        // Prepayment penalty
                        _buildFeatureRow(
                          context,
                          'Early Repayment',
                          product.hasPrepaymentPenalty
                              ? 'Penalty if you repay early'
                              : 'No penalty for early repayment',
                          product.hasPrepaymentPenalty
                              ? AppTheme.accentRed
                              : AppTheme.lightGreen,
                          product.hasPrepaymentPenalty
                              ? Icons.lock
                              : Icons.lock_open,
                        ),
                        const SizedBox(height: 20),

                        // Subsidy
                        if (product.hasSubsidy)
                          _buildFeatureRow(
                            context,
                            'Government Subsidy',
                            'You benefit from government subsidy program',
                            AppTheme.lightGreen,
                            Icons.card_giftcard,
                          ),

                        const SizedBox(height: 24),

                        // Example calculation
                        _buildCalculationExample(context, product),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Understood',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppTheme.lightText,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    String label,
    String description,
    Color color,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationExample(BuildContext context, LoanProduct product) {
    const principal = 50000;
    const seasons = 3;

    final emi = product.calculateEMIPerSeason(principal, seasons);
    final totalInterest = product.calculateTotalInterest(principal, seasons);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Example: ₹${principal} Loan over 3 seasons',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildCalcRow('EMI per season:', '₹$emi'),
          _buildCalcRow('Total interest:', '₹$totalInterest'),
          _buildCalcRow('Total repayment:', '₹${principal + totalInterest}'),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _colorForLender(LoanType type) {
    switch (type) {
      case LoanType.moneylender:
        return AppTheme.accentRed;
      case LoanType.privateBank:
        return AppTheme.accentBlue;
      case LoanType.govtAgriBank:
        return AppTheme.primaryGreen;
    }
  }

  IconData _iconForLender(LoanType type) {
    switch (type) {
      case LoanType.moneylender:
        return Icons.person;
      case LoanType.privateBank:
        return Icons.business;
      case LoanType.govtAgriBank:
        return Icons.account_balance;
    }
  }
}
