import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'lean_period_screen.dart';

class FaultyProductScreen extends ConsumerStatefulWidget {
  const FaultyProductScreen({super.key});

  @override
  ConsumerState<FaultyProductScreen> createState() =>
      _FaultyProductScreenState();
}

class _FaultyProductScreenState extends ConsumerState<FaultyProductScreen> {
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
      await _voiceService.speak(_voiceService.getFaultyProductMessage());
    }
  }

  Future<void> _handleAction(String action) async {
    setState(() {
      _selectedAction = action;
      _isProcessing = true;
    });

    // Apply decision
    ref.read(gameStateProvider.notifier).handleFaultyProduct(action);

    // Play voice feedback
    String feedbackText = '';
    if (action == 'ignore') {
      feedbackText = 'You ignored the problem. Your stress increased and yield will suffer.';
    } else if (action == 'fight') {
      feedbackText =
          'You fought with the seller. It cost money and time, but did not solve the problem.';
    } else {
      feedbackText =
          'Excellent! You registered a consumer complaint and got your money back. Consumer rights protect you!';
    }

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      ref.read(gameStateProvider.notifier).nextStep();
      Navigator.pushReplacementNamed(context, '/lean_period');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return GameScreenContainer(
      title: 'Faulty Product Alert!',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Alert icon with animation
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentRed.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  size: 80,
                  color: AppTheme.accentRed,
                ),
              ),
              const SizedBox(height: 30),

              // Problem description
              Text(
                'Your seeds are faulty!',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppTheme.accentRed,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'The seeds you bought are damaged. This happens sometimes when you buy cheap products or from unreliable sellers.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppTheme.lightText,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Current status
              MoneyBar(
                currentMoney: gameState.currentMoney,
                maxMoney: 100000,
                label: 'Current Money',
              ),
              const SizedBox(height: 20),
              StressMeter(
                stressLevel: gameState.stressLevel,
                label: 'Current Stress',
              ),
              const SizedBox(height: 40),

              // Action options
              Text(
                'What will you do?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Option 1: Ignore
              _buildActionCard(
                context,
                'Ignore',
                'Forget about it and move on',
                Icons.sentiment_dissatisfied,
                AppTheme.accentRed,
                'ignore',
                _selectedAction == 'ignore',
                () => _handleAction('ignore'),
              ),
              const SizedBox(height: 12),

              // Option 2: Fight
              _buildActionCard(
                context,
                'Fight Seller',
                'Argue and demand refund (costs time)',
                Icons.sentiment_very_dissatisfied,
                AppTheme.accentOrange,
                'fight',
                _selectedAction == 'fight',
                () => _handleAction('fight'),
              ),
              const SizedBox(height: 12),

              // Option 3: Register complaint
              _buildActionCard(
                context,
                'Register Complaint',
                'File consumer complaint (best solution)',
                Icons.check_circle,
                AppTheme.lightGreen,
                'register',
                _selectedAction == 'register',
                () => _handleAction('register'),
              ),
              const SizedBox(height: 30),

              // Learning note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppTheme.accentBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Learn About Consumer Rights',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'As a consumer, you have rights! Registering a complaint protects you and gets results.',
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

  Widget _buildActionCard(
    BuildContext context,
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
