// Route Structure and Navigation Reference
// lib/main.dart routes map - for easy reference

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

// ============================================================================
// GAME FLOW SEQUENCE AND NAVIGATION
// ============================================================================

// Main Game Flow Path:
// 
// HomeScreen (main())
//   └─> "Start New Season" button
//       └─> SeasonIntroScreen (route: '/season_intro')
//           └─> "Start Season" button
//               └─> PersonalDecisionScreen (route: '/personal_decision')
//                   └─> Save/Invest/Spend decision
//                       └─> FarmInvestmentScreen (route: '/farm_investment')
//                           └─> Good/Cheap seeds selection
//                               ├─> [30% chance] FaultyProductScreen
//                               │   └─> Ignore/Fight/Register response
//                               │       └─> LeanPeriodScreen
//                               └─> [No faulty] Direct to LeanPeriodScreen
//
// LeanPeriodScreen (route: '/lean_period')
//   └─> Emergency event (Hailstorm/Medical/Pest)
//       ├─> Use Savings
//       │   └─> LoanDecisionModeScreen (skipped)
//       │       └─> FraudCheckScreen
//       ├─> Break Investment
//       │   └─> LoanDecisionModeScreen (skipped)
//       │       └─> FraudCheckScreen
//       └─> Take Loan
//           └─> LoanDecisionModeScreen (route: '/loan_decision')
//               ├─> "Hurry" (Blind Path)
//               │   └─> BlindLoanSelectionScreen (route: '/blind_loan')
//               │       └─> Pick lender (Moneylender/Private/Government)
//               │           └─> LoanMinimalSummaryScreen (minimal info)
//               │               └─> FraudCheckScreen
//               │
//               └─> "Think" (Informed Path)
//                   └─> LoanMarketIntroScreen (route: '/loan_market')
//                       └─> Long-press each lender
//                           └─> LoanDetailOverlayScreen (modal overlay)
//                               └─> See full details per lender
//                                   └─> [Future: LoanComparisonMiniGameScreen]
//                                       └─> [Future: InformedLoanChoiceScreen]
//                                           └─> [Future: LoanFullSummaryScreen]
//                                               └─> FraudCheckScreen
//
// FraudCheckScreen (route: '/fraud_check')
//   └─> OTP Scam scenario
//       ├─> Share OTP (lose money, increase stress)
//       └─> Refuse (safe)
//           └─> HarvestScreen (route: '/harvest')
//               └─> Results + Learning Insights
//                   └─> "Play Again" button
//                       └─> Reset and return to HomeScreen

// ============================================================================
// NAVIGATION IMPLEMENTATION DETAILS
// ============================================================================

// PUSH NAVIGATION (Add to navigation stack):
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const NextScreen()),
);

// NAMED PUSH NAVIGATION:
Navigator.pushNamed(context, '/loan_decision');

// REPLACEMENT NAVIGATION (Replace current screen):
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HarvestScreen()),
);

// NAMED REPLACEMENT NAVIGATION:
Navigator.pushReplacementNamed(context, '/fraud_check');

// ============================================================================
// SCREEN DEPENDENCIES AND STATE FLOW
// ============================================================================

// HomeScreen
//   Dependencies: VoiceService, GameStateProvider
//   State Updates: None (navigation only)
//   Next Screens: SeasonIntroScreen

// SeasonIntroScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates: gameStateProvider.notifier.nextStep()
//   Next Screens: PersonalDecisionScreen

// PersonalDecisionScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates: 
//     - gameStateProvider.notifier.makePersonalDecision(type, amount)
//     - gameStateProvider.notifier.nextStep()
//   Next Screens: FarmInvestmentScreen

// FarmInvestmentScreen
//   Dependencies: GameStateProvider, VoiceService, Random
//   State Updates:
//     - gameStateProvider.notifier.selectFarmInvestment(isGood, cost)
//   Next Screens: FaultyProductScreen (30%/10% chance) or LeanPeriodScreen

// FaultyProductScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates:
//     - gameStateProvider.notifier.handleFaultyProduct(action)
//     - gameStateProvider.notifier.nextStep()
//   Next Screens: LeanPeriodScreen

// LeanPeriodScreen
//   Dependencies: GameStateProvider, VoiceService, Random
//   State Updates:
//     - gameStateProvider.notifier.handleLeanPeriod(eventType, actionType)
//     - gameStateProvider.notifier.nextStep()
//   Next Screens: 
//     - FraudCheckScreen (if Savings/Investment used)
//     - LoanDecisionModeScreen (if Loan chosen)

// LoanDecisionModeScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates: None
//   Next Screens: 
//     - BlindLoanSelectionScreen (Hurry path)
//     - LoanMarketIntroScreen (Think path)

// BlindLoanSelectionScreen
//   Dependencies: GameStateProvider, VoiceService, LoanProduct
//   State Updates:
//     - gameStateProvider.notifier.takeLoan(product, amount, seasons, blind: true)
//   Next Screens: LoanMinimalSummaryScreen

// LoanMinimalSummaryScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates: gameStateProvider.notifier.nextStep()
//   Next Screens: FraudCheckScreen

// LoanMarketIntroScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates: Tracks viewed loans locally
//   Next Screens: 
//     - LoanDetailOverlayScreen (via showModalBottomSheet)
//     - [Future: LoanComparisonMiniGameScreen]

// LoanDetailOverlayScreen
//   Dependencies: VoiceService
//   State Updates: None
//   Next Screens: Returns to LoanMarketIntroScreen (modal dismiss)

// FraudCheckScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates:
//     - gameStateProvider.notifier.handleFraudOTP(sharedOTP)
//     - gameStateProvider.notifier.finalizeHarvest()
//     - gameStateProvider.notifier.nextStep()
//   Next Screens: HarvestScreen

// HarvestScreen
//   Dependencies: GameStateProvider, VoiceService
//   State Updates: None (read-only for results)
//   Next Screens:
//     - HomeScreen (via playAgain button with resetSeason)

// ============================================================================
// CONDITIONAL BRANCHING LOGIC
// ============================================================================

// Faulty Product Decision:
bool hasFaultyProduct = random.nextDouble() < (isGoodQuality ? 0.1 : 0.3);
if (hasFaultyProduct) {
  Navigator.push(...FaultyProductScreen);
} else {
  Navigator.pushReplacementNamed(context, '/lean_period');
}

// Loan Decision Path Selection:
if (decisionMode == 'hurry') {
  Navigator.push(...BlindLoanSelectionScreen);
} else {
  Navigator.push(...LoanMarketIntroScreen);
}

// Lean Period Response Options:
if (actionType == 'savings') {
  // Check if sufficient savings, deduct, skip loan, go to fraud
} else if (actionType == 'investment') {
  // Check if investment exists, break it, skip loan, go to fraud
} else if (actionType == 'loan') {
  // Navigate to LoanDecisionModeScreen
}

// ============================================================================
// STATE PERSISTENCE ACROSS NAVIGATION
// ============================================================================

// All state is maintained in Riverpod's gameStateProvider
// No matter which path is taken, game state is NOT reset unless:
// 1. resetSeason() is explicitly called (at play again)
// 2. App is completely closed

// Example: If player goes from PersonalDecision -> FarmInvestment
// The personal decision data is preserved in gameState

// ============================================================================
// ADDING NEW SCREENS
// ============================================================================

// Step 1: Create screen file
// File: lib/screens/new_screen.dart
class NewScreen extends ConsumerStatefulWidget {
  const NewScreen({super.key});
  @override
  ConsumerState<NewScreen> createState() => _NewScreenState();
}
class _NewScreenState extends ConsumerState<NewScreen> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    return GameScreenContainer(
      title: 'New Screen',
      child: Column(...),
    );
  }
}

// Step 2: Add route to main.dart
routes: {
  '/new_screen': (context) => const NewScreen(),
}

// Step 3: Import in main.dart
import 'screens/new_screen.dart';

// Step 4: Navigate to it
Navigator.pushNamed(context, '/new_screen');

// ============================================================================
// TESTING NAVIGATION
// ============================================================================

// To test specific paths without playing full game:

// Skip to harvest:
// In main.dart temporarily: home: const HarvestScreen(),

// Skip to loan market:
// In main.dart temporarily: home: const LoanMarketIntroScreen(),

// Skip to fraud:
// In main.dart temporarily: home: const FraudCheckScreen(),

// To reset and start from home:
// ref.read(gameStateProvider.notifier).resetSeason();
// Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

// ============================================================================
