import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';
import '../services/voice_service.dart';

class Phase1PersonalDecision extends StatefulWidget {
  final GameState gameState;
  final Function(String) onDecision;

  const Phase1PersonalDecision({
    super.key,
    required this.gameState,
    required this.onDecision,
  });

  @override
  State<Phase1PersonalDecision> createState() => _Phase1PersonalDecisionState();
}

class _Phase1PersonalDecisionState extends State<Phase1PersonalDecision> {
  final VoiceService _voiceService = VoiceService();
  bool _voicePlayed = false;

  @override
  void initState() {
    super.initState();
    _playVoice();
  }

  Future<void> _playVoice() async {
    if (!_voicePlayed) {
      await _voiceService.initialize();
      await _voiceService.speakPhrase('phase1_start');
      _voicePlayed = true;
    }
  }

  void _handleDecision(String decision) {
    // Voice feedback
    if (decision == 'save') {
      _voiceService.speakPhrase('saved_money');
      _voiceService.speakPhrase('good_choice');
    } else if (decision == 'invest') {
      _voiceService.speakPhrase('invested_money');
    } else {
      _voiceService.speakPhrase('spent_money');
      _voiceService.speakPhrase('wrong_decision');
    }
    widget.onDecision(decision);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('phase1_title')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade100,
              Colors.green.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Game Status Bar
              GameStatusBar(
                money: widget.gameState.money,
                stress: widget.gameState.stress,
                day: widget.gameState.day,
              ),
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        size: 100,
                        color: Colors.green,
                      ),
                const SizedBox(height: 30),
                Text(
                  Language.translate('phase1_description'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                _buildLargeButton(
                  context,
                  Language.translate('save'),
                  Icons.savings,
                  Colors.blue,
                  () => _handleDecision('save'),
                ),
                const SizedBox(height: 20),
                _buildLargeButton(
                  context,
                  Language.translate('invest'),
                  Icons.trending_up,
                  Colors.orange,
                  () => _handleDecision('invest'),
                ),
                const SizedBox(height: 20),
                _buildLargeButton(
                  context,
                  Language.translate('personal_expense'),
                  Icons.shopping_cart,
                  Colors.red,
                  () => _handleDecision('expense'),
                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 35),
        label: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
