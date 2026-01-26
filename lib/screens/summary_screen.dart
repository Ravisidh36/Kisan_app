import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';

class SummaryScreen extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onPlayAgain;

  const SummaryScreen({
    Key? key,
    required this.gameState,
    required this.onPlayAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isStable =
        gameState.stress < 50 && gameState.money >= 50000;

    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('summary_title')),
        backgroundColor: isStable ? Colors.green : Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isStable
                ? [Colors.green.shade100, Colors.green.shade50]
                : [Colors.orange.shade100, Colors.orange.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              GameStatusBar(
                money: gameState.money,
                stress: gameState.stress,
                day: gameState.day,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                Icon(
                  isStable
                      ? Icons.sentiment_very_satisfied
                      : Icons.sentiment_dissatisfied,
                  size: 100,
                  color: isStable ? Colors.green : Colors.orange,
                ),

                const SizedBox(height: 25),

                Text(
                  Language.translate('summary_title'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _infoCard(
                  '${Language.translate('starting_money')}: ₹50,000',
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),

                _infoCard(
                  '${Language.translate('final_money')}: ₹${gameState.money}',
                  Icons.monetization_on,
                  gameState.money >= 50000
                      ? Colors.green
                      : Colors.red,
                ),

                _infoCard(
                  '${Language.translate('stress_level')}: ${gameState.stress}/100',
                  Icons.mood,
                  gameState.stress < 50
                      ? Colors.green
                      : Colors.red,
                ),

                _infoCard(
                  gameState.tookLoan
                      ? '${Language.translate('loan_taken')}: ₹${gameState.loanAmount}'
                      : Language.translate('no_loan'),
                  Icons.account_balance,
                  gameState.tookLoan
                      ? Colors.orange
                      : Colors.green,
                ),

                const SizedBox(height: 30),

                if (gameState.goodDecisions.isNotEmpty) ...[
                  _sectionTitle(
                    Language.translate('good_decisions'),
                    Colors.green,
                  ),
                  ...gameState.goodDecisions.map(
                    (e) => _listItem(e, Colors.green),
                  ),
                ],

                if (gameState.badDecisions.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle(
                    Language.translate('bad_decisions'),
                    Colors.red,
                  ),
                  ...gameState.badDecisions.map(
                    (e) => _listItem(e, Colors.red),
                  ),
                ],

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: onPlayAgain,
                    icon: const Icon(Icons.refresh, size: 28),
                    label: Text(
                      Language.translate('play_again'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _infoCard(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _listItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
