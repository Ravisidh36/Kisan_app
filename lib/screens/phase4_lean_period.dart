import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/game_status_bar.dart';
import '../services/voice_service.dart';

class Phase4LeanPeriod extends StatefulWidget {
  final GameState gameState;
  final Function(String, String) onAction;

  const Phase4LeanPeriod({
    super.key,
    required this.gameState,
    required this.onAction,
  });

  @override
  State<Phase4LeanPeriod> createState() => _Phase4LeanPeriodState();
}

class _Phase4LeanPeriodState extends State<Phase4LeanPeriod> {
  final VoiceService _voiceService = VoiceService();
  bool _voicePlayed = false;
  
  String get event => widget.gameState.leanPeriodEvent ?? 'hailstorm';

  @override
  void initState() {
    super.initState();
    _playVoice();
  }

  Future<void> _playVoice() async {
    if (!_voicePlayed) {
      await _voiceService.initialize();
      await _voiceService.speakPhrase('phase4_start');
      _voicePlayed = true;
    }
  }

  void _handleAction(String action) {
    if (action == 'subsidy') {
      _voiceService.speakPhrase('subsidy_applied');
      _voiceService.speakPhrase('good_choice');
    } else if (action == 'savings') {
      _voiceService.speakPhrase('savings_used');
      _voiceService.speakPhrase('good_choice');
    } else if (action == 'loan') {
      _voiceService.speakPhrase('loan_taken');
      _voiceService.speakPhrase('stress_increased');
    } else {
      _voiceService.speakPhrase('wrong_decision');
    }
    widget.onAction(event, action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lean Period")),
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
                  Icon(
                    event == 'hailstorm' ? Icons.cloud : 
                    event == 'medical' ? Icons.local_hospital : Icons.bug_report,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event == 'hailstorm' ? "Hailstorm damaged crops!" :
                    event == 'medical' ? "Medical emergency!" : "Pest attack!",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Show options based on event type and past decisions
                  ..._buildOptions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions() {
    List<Widget> options = [];

    // IF HAILSTORM: Show "Apply Subsidy"
    if (event == 'hailstorm') {
      options.add(_btn(
        "Apply Subsidy",
        Icons.account_balance,
        Colors.green,
        () => _handleAction("subsidy"),
      ));
    } 
    // IF MEDICAL / PEST: Show options based on past choice
    else {
      // IF saved: Show "Use Savings ₹20,000"
      if (widget.gameState.saved) {
        options.add(_btn(
          "Use Savings ₹20,000",
          Icons.savings,
          Colors.blue,
          () => _handleAction("savings"),
        ));
      }

      // IF invested: Show "Withdraw Investment"
      if (widget.gameState.invested) {
        options.add(_btn(
          "Withdraw Investment",
          Icons.trending_down,
          Colors.orange,
          () => _handleAction("withdraw"),
        ));
      }

      // IF personalSpent: Show "Take Loan ₹20,000 (10%)"
      if (widget.gameState.personalSpent) {
        options.add(_btn(
          "Take Loan ₹20,000 (10%)",
          Icons.account_balance_wallet,
          Colors.red,
          () => _handleAction("loan"),
        ));
      }
    }

    return options;
  }

  Widget _btn(String text, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 28),
          label: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
