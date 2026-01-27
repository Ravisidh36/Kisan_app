import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const KisanLifeSimulator());
}

class KisanLifeSimulator extends StatelessWidget {
  const KisanLifeSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kisan Life Simulator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
