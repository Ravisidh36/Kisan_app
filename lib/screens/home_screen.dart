import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/common_widgets.dart';
import '../providers/game_state_provider.dart';
import '../services/voice_service.dart';
import 'season_intro_screen.dart';
import 'how_to_play_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late VoiceService _voiceService;
  bool _voiceEnabled = true;

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    await _voiceService.initialize();
    if (mounted && _voiceEnabled) {
      await _voiceService.speak(_voiceService.getHomeScreenGreeting());
    }
  }

  void _startNewSeason() {
    // Reset game state and navigate to season intro
    ref.read(gameStateProvider.notifier).resetSeason();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeasonIntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.green.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 40),

                // App Title
                Text(
                  'KisanPath',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppTheme.primaryGreen,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Farm Life Simulator',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppTheme.lightText,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Start Game Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _startNewSeason,
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: const Text('Start New Season'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // How to Play Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HowToPlayScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Text('How to Play'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      side: const BorderSide(
                        color: AppTheme.primaryGreen,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                // Voice Toggle
                Card(
                  elevation: 0,
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Voice Guidance',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: _voiceEnabled,
                          onChanged: (value) {
                            setState(() {
                              _voiceEnabled = value;
                              _voiceService.setVoiceEnabled(value);
                            });
                          },
                          activeColor: AppTheme.primaryGreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
