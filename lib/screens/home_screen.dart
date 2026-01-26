import 'package:flutter/material.dart';
import 'game_flow.dart';
import 'how_to_play_screen.dart';
import '../utils/language.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Language.translate('app_title'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                _buildLargeButton(
                  context,
                  Language.translate('start_game'),
                  Icons.play_arrow,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameFlow(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildLargeButton(
                  context,
                  Language.translate('how_to_play'),
                  Icons.help_outline,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HowToPlayScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildLargeButton(
                  context,
                  Language.translate('change_language'),
                  Icons.language,
                  Colors.orange,
                  () {
                    _showLanguageDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 30),
        label: Text(
          text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Language.translate('change_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () {
                setState(() {
                  Language.setLanguage('en');
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('हिंदी'),
              onTap: () {
                setState(() {
                  Language.setLanguage('hi');
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
