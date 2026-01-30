import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'faulty_product_screen.dart';

class FarmInvestmentScreen extends ConsumerStatefulWidget {
  const FarmInvestmentScreen({super.key});

  @override
  ConsumerState<FarmInvestmentScreen> createState() =>
      _FarmInvestmentScreenState();
}

class _FarmInvestmentScreenState extends ConsumerState<FarmInvestmentScreen> {
  late VoiceService _voiceService;
  String? _selectedSeed;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(_voiceService.getFarmInvestmentPrompt());
    }
  }

  Future<void> _selectSeeds(bool isGoodQuality, int cost, String seedName) async {
    setState(() {
      _selectedSeed = seedName;
      _isProcessing = true;
    });

    // Select farm investment
    ref
        .read(gameStateProvider.notifier)
        .selectFarmInvestment(isGoodQuality, cost);

    // Voice feedback
    String feedbackText = isGoodQuality
        ? 'Excellent choice! Good seeds will give you better harvest despite higher cost.'
        : 'Budget choice. Cheap seeds risk damage, but save money now.';

    if (_voiceService.isVoiceEnabled()) {
      await _voiceService.speak(feedbackText);
    }

    // Random chance of faulty product (30% chance for cheap, 10% for good)
    final random = Random();
    bool hasFaultyProduct =
        random.nextDouble() < (isGoodQuality ? 0.1 : 0.3);

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      if (hasFaultyProduct) {
        // Go to faulty product screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FaultyProductScreen(),
          ),
        );
      } else {
        // Skip to lean period
        ref.read(gameStateProvider.notifier).nextStep();
        Navigator.of(context).pushReplacementNamed('/lean_period');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return GameScreenContainer(
      title: 'Farm Investment',
      showBackButton: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Money status
              MoneyBar(
                currentMoney: gameState.currentMoney,
                maxMoney: 100000,
                label: 'Current Money',
              ),
              const SizedBox(height: 30),

              // Farm investment prompt
              Text(
                'Choose your seeds carefully',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: AppTheme.darkText,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Seed options
              _buildSeedCard(
                context,
                'Good Seeds',
                'High yield, high quality',
                Icons.spa,
                AppTheme.lightGreen,
                '₹15000',
                true,
                _selectedSeed == 'good',
                () => _selectSeeds(true, 15000, 'good'),
              ),
              const SizedBox(height: 16),
              _buildSeedCard(
                context,
                'Cheap Seeds',
                'Low cost, higher risk',
                Icons.grass,
                AppTheme.accentOrange,
                '₹8000',
                false,
                _selectedSeed == 'cheap',
                () => _selectSeeds(false, 8000, 'cheap'),
              ),
              const SizedBox(height: 30),

              // Extra tools option (optional)
              _buildToolCard(
                context,
                'Extra Tools & Fertilizer',
                '+₹5,000 for better results',
                Icons.agriculture,
                '₹5000',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeedCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String cost,
    bool isGoodQuality,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: _isProcessing ? null : onTap,
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: color, width: 3)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 60, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Cost: $cost',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: 12),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: AppTheme.primaryGreen),
                      SizedBox(width: 4),
                      Text('Selected'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String cost,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppTheme.accentBlue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Text(
              '+$cost',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentBlue,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
