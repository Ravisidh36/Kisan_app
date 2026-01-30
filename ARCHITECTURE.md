# KisanPath: Farm Life Simulator - Refactored Architecture Guide

## Overview

KisanPath is a gamified financial literacy app for rural Indian farmers. This document explains the refactored codebase structure, how to navigate it, and where to make customizations.

## Project Structure

```
lib/
├── main.dart                    # App entry point with Riverpod and routing
├── core/
│   ├── theme/
│   │   └── app_theme.dart      # Global theme and colors
│   └── widgets/
│       └── common_widgets.dart # Reusable UI components (DecisionCard, MoneyBar, etc)
├── models/
│   ├── season_state.dart       # Main GameState class for game logic
│   └── loan_model.dart         # Loan products and loan tracking
├── providers/
│   └── game_state_provider.dart # Riverpod state management
├── services/
│   └── voice_service.dart      # Flutter TTS integration with localization
├── screens/
│   ├── home_screen.dart
│   ├── season_intro_screen.dart
│   ├── personal_decision_screen.dart
│   ├── farm_investment_screen.dart
│   ├── faulty_product_screen.dart
│   ├── lean_period_screen.dart
│   ├── loan_decision_mode_screen.dart
│   ├── blind_loan_selection_screen.dart
│   ├── loan_market_intro_screen.dart
│   ├── loan_detail_overlay_screen.dart
│   ├── loan_minimal_summary_screen.dart
│   ├── fraud_check_screen.dart
│   └── harvest_screen.dart
└── utils/
    └── language.dart           # Localization support (existing)
```

## Game Flow Sequence

The game follows a strict linear flow through these screens:

1. **HomeScreen** → Player selects "Start New Season"
2. **SeasonIntroScreen** → Shows starting conditions (₹50,000, 0 stress)
3. **PersonalDecisionScreen** → Allocate ₹20,000: Save/Invest/Spend
4. **FarmInvestmentScreen** → Choose seeds: Good (₹15K) or Cheap (₹8K)
5. **FaultyProductScreen** → 30% chance of faulty seeds (if cheap), or 10% (if good)
   - Options: Ignore, Fight, Register Complaint
6. **LeanPeriodScreen** → Random emergency (hailstorm, medical, pest)
   - Options: Use Savings, Break Investment, or Take Loan
7. **Loan Flow** (if "Take Loan" selected):
   - **LoanDecisionModeScreen** → Choose: Hurry (blind) or Think (informed)
   - **If Hurry (Blind Path)**:
     - BlindLoanSelectionScreen → Pick lender without details
     - LoanMinimalSummaryScreen → Show approved loan info
   - **If Think (Informed Path)**:
     - LoanMarketIntroScreen → Review all lenders (must long-press each)
     - LoanDetailOverlayScreen → Full loan details with narration
     - [Future: LoanComparisonMiniGameScreen] → Match features to lenders
     - InformedLoanChoiceScreen → Select loan with full knowledge
     - LoanFullSummaryScreen → Show final loan summary
8. **FraudCheckScreen** → OTP scam simulation
   - Options: Share OTP (lose ₹8000) or Refuse (safe)
9. **HarvestScreen** → Final results, learning insights, option to play again

## State Management with Riverpod

The app uses **Riverpod** for reactive state management.

### Key Providers:

**`gameStateProvider`** - The central game state notifier
```dart
ref.read(gameStateProvider)              // Get current state
ref.read(gameStateProvider.notifier)    // Get notifier for updates
```

**Common Notifier Methods:**
- `resetSeason()` - Reset for new game
- `nextStep()` - Increment season step
- `makePersonalDecision(type, amount)` - Handle personal decision phase
- `selectFarmInvestment(isGoodQuality, cost)` - Choose seeds
- `handleFaultyProduct(action)` - Process faulty product response
- `handleLeanPeriod(eventType, actionType)` - Handle emergency
- `takeLoan(product, amount, seasons, blind)` - Record loan
- `handleFraudOTP(sharedOTP)` - Record OTP decision
- `finalizeHarvest()` - Calculate final results

## Model Classes

### GameState (`models/season_state.dart`)
Tracks all game data for one season:
- `currentMoney` - Player's cash
- `stressLevel` - 0-100 stress meter
- `seasonStep` - Current phase (0-6)
- `savingsAmount`, `investmentAmount` - Money allocation
- `investmentQuality` - Seed type chosen
- `activeLoan` - Current loan (if any)
- Decision flags (tookLoanBlind, sharedOTPWithFraud, etc)
- History tracking (eventHistory, moneyHistory, stressHistory)

Key Methods:
- `updateMoney(amount, reason)` - Change money with history
- `updateStress(amount, reason)` - Change stress
- `takeLoan(product, amount, seasons)` - Create active loan
- `calculateHarvestYield()` - Compute final harvest
- `getLearningInsights()` - Generate personalized learnings

### LoanProduct & ActiveLoan (`models/loan_model.dart`)
**LoanProduct:** Loan type definition with:
- `interestRate` - Annual percentage
- `processingFee` - Fixed fee
- `hasCollateralRisk` - Land at risk?
- `hasPrepaymentPenalty` - Early repayment penalty?
- `hasSubsidy` - Government subsidy?
- Methods: `calculateEMIPerSeason()`, `calculateTotalInterest()`

**Predefined Loans:**
```dart
LoanType.moneylender        // 36% interest, ₹2000 fee, risky
LoanType.privateBank        // 14% interest, ₹1000 fee, medium
LoanType.govtAgriBank       // 7% interest, ₹500 fee, subsidy
```

**ActiveLoan:** Loan taken by player
- Tracks principal, remaining amount, EMI per season
- Methods: `recordEmiPayment()`, `isFullyRepaid()`

## UI Components

All reusable components in `core/widgets/common_widgets.dart`:

### DecisionCard
```dart
DecisionCard(
  label: 'Save',
  icon: Icons.savings,
  color: AppTheme.accentBlue,
  onTap: () => handleDecision(),
  isSelected: true,
)
```

### MoneyBar (Thermometer Style)
```dart
MoneyBar(
  currentMoney: 50000,
  maxMoney: 100000,
  label: 'Current Money',
)
```

### StressMeter (Speedometer Style)
```dart
StressMeter(
  stressLevel: 45,
  label: 'Current Stress',
)
```

### GameScreenContainer
Base container for all game screens with consistent styling:
```dart
GameScreenContainer(
  title: 'Screen Title',
  showBackButton: true,
  child: Column(...),
  bottomBar: ElevatedButton(...),
)
```

## Voice Service Integration

The `VoiceService` in `services/voice_service.dart` handles text-to-speech:

```dart
final voiceService = VoiceService();
await voiceService.initialize();  // Initialize TTS
await voiceService.speak('Hello farmer!');

// Screen-specific methods with pre-written scripts:
voiceService.getHomeScreenGreeting()
voiceService.getSeasonIntroMessage()
voiceService.getPersonalDecisionPrompt()
voiceService.getFarmInvestmentPrompt()
voiceService.getLeanPeriodEventMessage(eventType)
voiceService.getLoanDetailsPrompt()
voiceService.getFraudOtpPrompt()
```

All methods have Hindi translations ready in the `phrases` map.

## Customization Guide

### Changing Interest Rates and Loan Terms

Edit `lib/models/loan_model.dart`, in `LoanProduct.predefined`:

```dart
LoanType.moneylender: LoanProduct(
  interestRate: 36.0,           // Change this for different interest
  processingFee: 2000,          // Change this fee
  hasSubsidy: false,            // Toggle subsidy
  // ... other fields
)
```

### Adjusting Game Difficulty

**In `lib/screens/farm_investment_screen.dart`:**
```dart
// Change faulty product probabilities:
bool hasFaultyProduct = random.nextDouble() < 0.3;  // 30% for cheap seeds
// Higher = more faulty products = harder game
```

**In `lib/models/season_state.dart`, `calculateHarvestYield()`:**
```dart
// Adjust base yield amounts:
int baseYield = investmentQuality 
  ? 30000 + random.nextInt(10000)  // Change these numbers
  : 15000 + random.nextInt(8000);
```

**In `lib/screens/lean_period_screen.dart`:**
Change the emergency requirement:
```dart
'You need ₹50,000 to survive this crisis!'  // Change amount
```

### Adding More Lean Period Events

In `lib/screens/lean_period_screen.dart`:
```dart
const events = ['hailstorm', 'medical', 'pest', 'YOUR_EVENT'];

// Add corresponding voice messages in VoiceService:
case 'your_event':
  return 'Your custom event message here';
```

### Customizing Voice Lines

Edit `lib/services/voice_service.dart`:

```dart
String getHomeScreenGreeting() {
  return _translate('homeGreeting', 'Your custom greeting here');
}

// Add Hindi translations:
'homeGreeting': 'आपका हिंदी अनुवाद यहाँ',
```

### Changing Colors and Theme

Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryGreen = Color(0xFF2E7D32);  // Change these
static const Color accentOrange = Color(0xFFFF9800);
// ... more colors
```

### Adding New Screens

1. Create new screen file in `lib/screens/`
2. Import necessary dependencies (MaterialApp, Riverpod, etc)
3. Create ConsumerStatefulWidget that watches gameStateProvider
4. Use GameScreenContainer for consistent styling
5. Add route in `lib/main.dart` routes map
6. Navigate using Navigator.push() or named routes

## EMI Calculation Logic

The app calculates EMI (Equated Monthly Installment) for loans:

```dart
// Located in LoanModel.calculateEMIPerSeason():
double monthlyRate = interestRate / 100 / 12;
int numberOfMonths = numberOfSeasons * 4;  // 4 months per season

// Formula: EMI = P * r * (1+r)^n / ((1+r)^n - 1)
double emi = (principal * monthlyRate * (1 + monthlyRate).pow(numberOfMonths)) /
    ((1 + monthlyRate).pow(numberOfMonths) - 1);
```

To tweak loan repayment burden, adjust:
- `interestRate` in LoanProduct
- Number of seasons (currently 3 seasons to repay)

## Testing Different Paths

You can navigate directly by using named routes in development:

```dart
// In any screen:
Navigator.pushNamed(context, '/harvest');  // Skip to harvest
Navigator.pushNamed(context, '/fraud_check');  // Skip to fraud
```

## Learning Insights System

After harvest, the game generates insights based on decisions:

```dart
gameState.getLearningInsights()  // Returns list of personalized learnings
```

Add more insights in `models/season_state.dart`, `getLearningInsights()` method:

```dart
if (tookLoanBlind && activeLoan != null) {
  if (activeLoan!.lenderType == LoanType.moneylender) {
    insights.add('Your custom learning message here');
  }
}
```

## Future Enhancements

Placeholder screens for future implementation:
- **LoanComparisonMiniGameScreen** - Drag-and-drop loan comparison game
- **InformedLoanChoiceScreen** - Final loan selection with full info
- **LoanFullSummaryScreen** - Detailed loan summary
- **BlindRegretScreen** - Show cost of blind choice vs informed choice
- **Next Season** - Multi-season progression

These can be added by creating screens and extending the flow in respective parent screens.

## Offline-First Design

The app is designed for offline use:
- No network calls required
- All assets bundled with APK
- Voice data stored locally (flutter_tts)
- Game state stored in memory (can be enhanced with local persistence)

To persist game data across app sessions, integrate:
```dart
import 'package:shared_preferences/shared_preferences.dart';
// Save gameState to SharedPreferences
// Load on app startup
```

## Troubleshooting

**Voice not working?**
- Check flutter_tts initialization
- Ensure device language supports TTS
- In HomeScreen, toggle voice switch

**Routing issues?**
- Ensure all screens are added to `main.dart` routes map
- Use Navigator.push() for new route, pushReplacement() to replace current

**State not updating?**
- Ensure ConsumerWidget/ConsumerState is used
- Watch correct provider: `ref.watch(gameStateProvider)`
- Use notifier for updates: `ref.read(gameStateProvider.notifier).method()`

## Contact & Support

For questions about this refactored architecture, refer to:
- Riverpod documentation: https://riverpod.dev
- Flutter Material Design: https://material.io/design
- flutter_tts package: https://pub.dev/packages/flutter_tts

---

**Last Updated:** January 2026
**App Version:** 2.0 (Refactored)
**Status:** Buildable and fully functional
