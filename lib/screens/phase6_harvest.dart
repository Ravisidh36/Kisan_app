import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';
import '../services/voice_service.dart';

class Phase6Harvest extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onComplete;

  const Phase6Harvest({
    super.key,
    required this.gameState,
    required this.onComplete,
  });

  @override
  State<Phase6Harvest> createState() => _Phase6HarvestState();
}

class _Phase6HarvestState extends State<Phase6Harvest> {
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
      await _voiceService.speakPhrase('phase6_start');
      if (widget.gameState.fraudPending) {
        await Future.delayed(const Duration(seconds: 2));
        _voiceService.speakPhrase('fraud_detected');
        _voiceService.speakPhrase('wrong_decision');
      } else if (widget.gameState.harvestAmount > 0) {
        await Future.delayed(const Duration(seconds: 2));
        _voiceService.speakPhrase('money_added');
      }
      _voicePlayed = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('phase6_title')),
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
                  Icons.eco,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 30),
                Text(
                  Language.translate('phase6_harvest'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Column(
                    children: [
                      if (widget.gameState.fraudPending) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.red, width: 3),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.warning_amber, color: Colors.red, size: 50),
                              const SizedBox(height: 12),
                              const Text(
                                '⚠️ SUSPICIOUS TRANSACTION DETECTED ⚠️',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'All your money has been stolen!\nYou shared your OTP with fraudsters.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                      const Icon(
                        Icons.eco,
                        size: 60,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Harvest Complete!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (widget.gameState.harvestAmount > 0)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Harvest Earnings: ₹${widget.gameState.harvestAmount}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              if (widget.gameState.tookLoan) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Loan Repayment: ₹${widget.gameState.loanAmount + (widget.gameState.loanAmount * widget.gameState.loanInterest ~/ 100)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: widget.onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      Language.translate('view_summary'),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
