import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'home_screen.dart';

class HarvestScreen extends ConsumerStatefulWidget {
  const HarvestScreen({super.key});

  @override
  ConsumerState<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends ConsumerState<HarvestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _voiceService = VoiceService();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAgain() {
    ref.read(gameStateProvider.notifier).resetSeason();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final insights = gameState.getLearningInsights();

    return GameScreenContainer(
      title: 'Season Complete!',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Season Over
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                      parent: _animationController, curve: Curves.easeOut),
                ),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    size: 100,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Final Results Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildResultRow(
                        context,
                        'Starting Money',
                        '₹50,000',
                        Icons.money,
                      ),
                      const Divider(),
                      _buildResultRow(
                        context,
                        'Harvest Yield',
                        '₹${gameState.harvestBaseYield}',
                        Icons.local_florist,
                      ),
                      const Divider(),
                      _buildResultRow(
                        context,
                        'Loan Repaid',
                        gameState.harvestLoanRepaidAmount > 0
                            ? '-₹${gameState.harvestLoanRepaidAmount}'
                            : 'No loan',
                        Icons.account_balance,
                      ),
                      const Divider(),
                      _buildResultRow(
                        context,
                        'Final Money',
                        '₹${gameState.harvestFinalMoney}',
                        Icons.wallet,
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Final Stress
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Final Stress Level',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    StressMeter(
                      stressLevel: gameState.harvestFinalStress,
                      label: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Learning Insights
              if (insights.isNotEmpty) ...[
                Text(
                  'What You Learned',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ...insights.map((insight) => _buildInsightCard(context, insight)),
                const SizedBox(height: 24),
              ],

              // Decision Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Decisions',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (gameState.goodDecisions.isNotEmpty) ...[
                      Text(
                        'Good Choices:',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightGreen,
                            ),
                      ),
                      ...gameState.goodDecisions
                          .map((d) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text('✓ $d',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall),
                              ))
                          .toList(),
                      const SizedBox(height: 12),
                    ],
                    if (gameState.badDecisions.isNotEmpty) ...[
                      Text(
                        'Challenges:',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentRed,
                            ),
                      ),
                      ...gameState.badDecisions
                          .map((d) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text('✗ $d',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall),
                              ))
                          .toList(),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _playAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Play Another Season',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                  color: isHighlight
                      ? AppTheme.primaryGreen
                      : AppTheme.darkText,
                  fontSize: isHighlight ? 18 : 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, String insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
