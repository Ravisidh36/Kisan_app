import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'loan_decision_mode_screen.dart';

class LeanPeriodScreen extends ConsumerStatefulWidget {
  const LeanPeriodScreen({super.key});

  @override
  ConsumerState<LeanPeriodScreen> createState() => _LeanPeriodScreenState();
}

class _LeanPeriodScreenState extends ConsumerState<LeanPeriodScreen> {
  late VoiceService _voiceService;
  late String _eventType;
  String? _selectedAction;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _selectRandomEvent();
    _initializeVoice();
  }

  void _selectRandomEvent() {
    final random = Random();
    const events = ['hailstorm', 'medical', 'pest'];
    _eventType = events[random.nextInt(events.length)];
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getLeanPeriodEventMessage(_eventType));
      await Future.delayed(const Duration(seconds: 2));
      await _voiceService.speak(_voiceService.getLeanPeriodActionPrompt());
    }
  }

  Future<void> _handleAction(String actionType) async {
    setState(() {
      _selectedAction = actionType;
      _isProcessing = true;
    });

    final gameState = ref.read(gameStateProvider);
    String feedbackText = '';

    if (actionType == 'savings') {
      if (gameState.savingsAmount >= 50000) {
        ref.read(gameStateProvider.notifier).handleLeanPeriod(_eventType, 'savings');
        feedbackText = 'Good! You used your savings. You avoided expensive loan interest.';
      } else {
        feedbackText = 'You do not have enough savings. You must take a loan or break investment.';
        setState(() => _isProcessing = false);
        return;
      }
    } else if (actionType == 'investment') {
      if (gameState.investmentAmount > 0) {
        ref.read(gameStateProvider.notifier).handleLeanPeriod(_eventType, 'investment');
        feedbackText = 'You broke your investment early. Money recovered, but growth lost.';
      } else {
        feedbackText = 'You have no investment to break. Choose another option.';
        setState(() => _isProcessing = false);
        return;
      }
    } else if (actionType == 'loan') {
      ref.read(gameStateProvider.notifier).handleLeanPeriod(_eventType, 'loan');
      feedbackText = 'You decided to take a loan. Let\'s find the best option.';
    }

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      if (actionType == 'loan') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoanDecisionModeScreen(),
          ),
        );
      } else {
        // Skip to fraud check
        ref.read(gameStateProvider.notifier).nextStep();
        Navigator.pushReplacementNamed(context, '/fraud_check');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    // Get event emoji/icon
    String eventTitle = '';
    IconData eventIcon = Icons.warning;
    Color eventColor = AppTheme.accentRed;

    switch (_eventType) {
      case 'hailstorm':
        eventTitle = 'Hailstorm!';
        eventIcon = Icons.cloud_download;
        break;
      case 'medical':
        eventTitle = 'Medical Emergency';
        eventIcon = Icons.local_hospital;
        break;
      case 'pest':
        eventTitle = 'Pest Attack!';
        eventIcon = Icons.bug_report;
        break;
    }

    return GameScreenContainer(
      title: 'Emergency!',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event icon
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: eventColor.withOpacity(0.1),
                ),
                child: Icon(
                  eventIcon,
                  size: 80,
                  color: eventColor,
                ),
              ),
              const SizedBox(height: 24),

              // Event title
              Text(
                eventTitle,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: eventColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You need ₹50,000 to survive this crisis!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Current status
              MoneyBar(
                currentMoney: gameState.currentMoney,
                maxMoney: 100000,
                label: 'Current Money',
              ),
              const SizedBox(height: 24),

              if (gameState.savingsAmount > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.savings, color: AppTheme.accentBlue),
                      const SizedBox(width: 8),
                      Text('Savings: ₹${gameState.savingsAmount}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              if (gameState.savingsAmount > 0)
                const SizedBox(height: 12),

              if (gameState.investmentAmount > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up, color: AppTheme.lightGreen),
                      const SizedBox(width: 8),
                      Text('Investment: ₹${gameState.investmentAmount}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              if (gameState.investmentAmount > 0)
                const SizedBox(height: 24),

              // Action buttons
              Text(
                'How will you get ₹50,000?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Use savings (if available)
              if (gameState.savingsAmount >= 50000)
                _buildActionButton(
                  'Use Savings',
                  'You have enough saved',
                  Icons.savings,
                  AppTheme.accentBlue,
                  'savings',
                  _selectedAction == 'savings',
                  () => _handleAction('savings'),
                )
              else if (gameState.savingsAmount > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.savings, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Use Savings'),
                            Text(
                              'You only have ₹${gameState.savingsAmount} (need ₹50000)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (gameState.savingsAmount >= 50000)
                const SizedBox(height: 12),

              // Break investment (if available)
              if (gameState.investmentAmount > 0)
                _buildActionButton(
                  'Break Investment',
                  'Get ₹${gameState.investmentAmount} from farm',
                  Icons.trending_up,
                  AppTheme.lightGreen,
                  'investment',
                  _selectedAction == 'investment',
                  () => _handleAction('investment'),
                ),
              if (gameState.investmentAmount > 0)
                const SizedBox(height: 12),

              // Take loan
              _buildActionButton(
                'Take a Loan',
                'Borrow from a lender',
                Icons.account_balance,
                AppTheme.primaryGreen,
                'loan',
                _selectedAction == 'loan',
                () => _handleAction('loan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String actionId,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: _isProcessing ? null : onTap,
      child: Card(
        elevation: isSelected ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: color, width: 3)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: color, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
