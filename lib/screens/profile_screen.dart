import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';

class ProfileScreen extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onClose;

  const ProfileScreen({
    super.key,
    required this.gameState,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar
              GameStatusBar(
                money: gameState.money,
                stress: gameState.stress,
                day: gameState.day,
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('Money History', Icons.account_balance_wallet, Colors.green, [
                        ...gameState.moneyHistory.asMap().entries.map((e) => 
                          'Day ${e.key + 1}: ₹${e.value}'
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSection('Stress History', Icons.mood, Colors.orange, [
                        ...gameState.stressHistory.asMap().entries.map((e) => 
                          'Day ${e.key + 1}: ${e.value}/100'
                        ),
                      ]),
                      const SizedBox(height: 20),
                      if (gameState.eventHistory.isNotEmpty)
                        _buildSection('Event History', Icons.history, Colors.blue, gameState.eventHistory),
                      const SizedBox(height: 20),
                      if (gameState.goodDecisions.isNotEmpty)
                        _buildSection('Good Decisions', Icons.check_circle, Colors.green, gameState.goodDecisions),
                      const SizedBox(height: 20),
                      if (gameState.badDecisions.isNotEmpty)
                        _buildSection('Bad Decisions', Icons.cancel, Colors.red, gameState.badDecisions),
                      const SizedBox(height: 20),
                      if (gameState.tookLoan)
                        _buildSection('Loans', Icons.account_balance, Colors.orange, [
                          'Loan Amount: ₹${gameState.loanAmount}',
                          'Interest Rate: ${gameState.loanInterest}%',
                        ]),
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

  Widget _buildSection(String title, IconData icon, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
