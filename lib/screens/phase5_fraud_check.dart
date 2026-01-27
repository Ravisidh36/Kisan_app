import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/game_status_bar.dart';
import '../services/voice_service.dart';

class Phase5FraudCheck extends StatefulWidget {
  final GameState gameState;
  final Function(bool) onAction;

  const Phase5FraudCheck({
    super.key,
    required this.gameState,
    required this.onAction,
  });

  @override
  State<Phase5FraudCheck> createState() => _Phase5FraudCheckState();
}

class _Phase5FraudCheckState extends State<Phase5FraudCheck> {
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
      await _voiceService.speakPhrase('phase5_start');
      _voicePlayed = true;
    }
  }

  void _handleAction(bool sharedOTP) {
    if (sharedOTP) {
      _voiceService.speakPhrase('fraud_detected');
      _voiceService.speakPhrase('wrong_decision');
      _voiceService.speakPhrase('stress_increased');
    } else {
      _voiceService.speakPhrase('fraud_avoided');
      _voiceService.speakPhrase('good_choice');
    }
    widget.onAction(sharedOTP);
  }

  @override
  Widget build(BuildContext context) {
    // Generate fake OTP
    const fakeOTP = '394822';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Alert"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
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
                  const Icon(Icons.security, size: 100, color: Colors.red),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "BANK MESSAGE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Your OTP is: $fakeOTP\n\nDo NOT share with anyone!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: const Text(
                      "⚠️ Someone is asking for your OTP.\nWhat will you do?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAction(true),
                      icon: const Icon(Icons.share, size: 28),
                      label: const Text(
                        "Share OTP",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAction(false),
                      icon: const Icon(Icons.block, size: 28),
                      label: const Text(
                        "Ignore",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
