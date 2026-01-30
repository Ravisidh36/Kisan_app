import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/season_intro_screen.dart';
import 'screens/personal_decision_screen.dart';
import 'screens/farm_investment_screen.dart';
import 'screens/faulty_product_screen.dart';
import 'screens/lean_period_screen.dart';
import 'screens/loan_decision_mode_screen.dart';
import 'screens/blind_loan_selection_screen.dart';
import 'screens/loan_market_intro_screen.dart';
import 'screens/fraud_check_screen.dart';
import 'screens/harvest_screen.dart';

void main() {
  runApp(const ProviderScope(child: KisanPathApp()));
}

class KisanPathApp extends StatelessWidget {
  const KisanPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisanPath: Farm Life Simulator',
      theme: AppTheme.lightTheme,

      // ✅ Use ONLY routes (NO home)
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/season_intro': (context) => const SeasonIntroScreen(),
        '/personal_decision': (context) => const PersonalDecisionScreen(),
        '/farm_investment': (context) => const FarmInvestmentScreen(),
        '/faulty_product': (context) => const FaultyProductScreen(),
        '/lean_period': (context) => const LeanPeriodScreen(),
        '/loan_decision': (context) => const LoanDecisionModeScreen(),
        '/blind_loan': (context) => const BlindLoanSelectionScreen(),
        '/loan_market': (context) => const LoanMarketIntroScreen(),
        '/fraud_check': (context) => const FraudCheckScreen(),
        '/harvest': (context) => const HarvestScreen(),
      },
    );
  }
}
