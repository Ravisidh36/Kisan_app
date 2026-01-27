import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';
import '../services/voice_service.dart';

class Phase2FarmInvestment extends StatefulWidget {
  final GameState gameState;
  final Function(bool) onResult;

  const Phase2FarmInvestment({
    super.key,
    required this.gameState,
    required this.onResult,
  });

  @override
  State<Phase2FarmInvestment> createState() => _Phase2FarmInvestmentState();
}

class _Phase2FarmInvestmentState extends State<Phase2FarmInvestment> {
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
      await _voiceService.speakPhrase('phase2_start');
      _voicePlayed = true;
    }
  }

  void _handleBuy() {
    final random = Random();
    final quality = random.nextDouble() > 0.3;
    if (quality) {
      _voiceService.speakPhrase('good_choice');
    } else {
      _voiceService.speakPhrase('wrong_decision');
    }
    widget.onResult(quality);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('phase2_title')),
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
              GameStatusBar(
                money: widget.gameState.money,
                stress: widget.gameState.stress,
                day: widget.gameState.day,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                const Icon(
                  Icons.agriculture,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 30),
                Text(
                  Language.translate('phase2_description'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Text(
                    Language.translate('phase2_warning'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton.icon(
                    onPressed: _handleBuy,
                    icon: const Icon(Icons.shopping_cart, size: 35),
                    label: Text(
                      Language.translate('buy'),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
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
}
