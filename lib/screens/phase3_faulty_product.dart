import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/game_status_bar.dart';
import '../services/voice_service.dart';

class Phase3FaultyProduct extends StatefulWidget {
  final GameState gameState;
  final Function(String) onAction;

  const Phase3FaultyProduct({
    super.key,
    required this.gameState,
    required this.onAction,
  });

  @override
  State<Phase3FaultyProduct> createState() => _Phase3FaultyProductState();
}

class _Phase3FaultyProductState extends State<Phase3FaultyProduct> {
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
      await _voiceService.speakPhrase('phase3_start');
      _voicePlayed = true;
    }
  }

  void _handleAction(String action) {
    if (action == 'complaint') {
      _voiceService.speakPhrase('complaint_registered');
      _voiceService.speakPhrase('good_choice');
    } else {
      _voiceService.speakPhrase('wrong_decision');
      _voiceService.speakPhrase('stress_increased');
    }
    widget.onAction(action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faulty Product"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          GameStatusBar(
            money: widget.gameState.money,
            stress: widget.gameState.stress,
            day: widget.gameState.day,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning, size: 80, color: Colors.red),
                const SizedBox(height: 20),

          const Text(
            "The product you bought is faulty.",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          _button("Ignore", Colors.grey, () {
            _handleAction("ignore");
          }),

          const SizedBox(height: 15),

          _button("Fight angrily", Colors.red, () {
            _handleAction("fight");
          }),

          const SizedBox(height: 15),

          _button("Register Complaint", Colors.green, () {
            _handleAction("complaint");
          }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(backgroundColor: color),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
