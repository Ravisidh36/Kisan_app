import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/game_status_bar.dart';

class Phase4LeanPeriod extends StatelessWidget {
  final GameState gameState;
  final Function(String, String) onAction;

  const Phase4LeanPeriod({
    super.key,
    required this.gameState,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final events = ["hailstorm", "medical", "pesticide"];
    final event = events[Random().nextInt(3)];

    return Scaffold(
      appBar: AppBar(title: const Text("Lean Period")),
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
                const Icon(Icons.cloud, size: 80),
                const SizedBox(height: 20),
          Text(
            "Problem occurred: $event",
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 40),

          _btn("Use Savings", () => onAction(event, "savings")),
          _btn("Take Loan", () => onAction(event, "loan")),
          _btn("Withdraw Investment", () => onAction(event, "withdraw")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
