import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';

class Phase3FaultyProduct extends StatelessWidget {
  final GameState gameState;
  final Function(String) onAction;

  const Phase3FaultyProduct({
    super.key,
    required this.gameState,
    required this.onAction,
  });

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
            money: gameState.money,
            stress: gameState.stress,
            day: gameState.day,
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
            onAction("ignore");
          }),

          const SizedBox(height: 15),

          _button("Fight angrily", Colors.red, () {
            onAction("fight");
          }),

          const SizedBox(height: 15),

          _button("Register Complaint", Colors.green, () {
            onAction("complaint");
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
