import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/game_status_bar.dart';

class Phase5FraudCheck extends StatelessWidget {
  final GameState gameState;
  final Function(bool) onAction;

  const Phase5FraudCheck({
    super.key,
    required this.gameState,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    // Generate fake OTP
    final fakeOTP = '394822';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Alert"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          GameStatusBar(
            money: gameState.money,
            stress: gameState.stress,
            day: gameState.day,
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
                      onPressed: () => onAction(true),
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
                      onPressed: () => onAction(false),
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
