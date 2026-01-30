# KisanPath: Farm Life Simulator - README

A gamified financial literacy mobile application for rural Indian farmers built with Flutter and Dart. This app teaches critical financial concepts through interactive gameplay and consequences.

## Quick Overview

KisanPath simulates one complete crop season where farmers make decisions about:
- **Saving vs. Investing** personal funds
- **Choosing quality levels** for farm inputs
- **Responding to emergencies** with available resources
- **Comparing loan options** informed vs. blind choices
- **Protecting against fraud** (OTP scams)

Every choice impacts final earnings, stress levels, and learning outcomes.

## Key Features

✅ **Complete Single-Season Simulation** (10-15 minute gameplay)
- Personal money decision (Save/Invest/Spend)
- Farm investment with quality selection
- Faulty product handling (consumer rights)
- Emergency response planning
- **Advanced Loan System**:
  - Blind path: Fast money, risky
  - Informed path: Compare lenders, understand terms
  - Three loan types: Moneylender, Private Bank, Government Bank
  - EMI calculation and repayment tracking
  - Hidden fees and subsidy benefits

✅ **Voice Integration**
- Hindi and English support via flutter_tts
- All screens have voice narration
- Optional toggle in home screen

✅ **Offline-First**
- No internet required
- All content bundled
- Optimized for low-bandwidth environments

✅ **Accessible Design**
- Large icons for low-literacy users
- Color-coded decisions (green=good, red=risk, orange=warning)
- Minimal text, maximum visuals
- Smooth animations and feedback

## Game Phases

### 1. Home Screen
- Start new season
- View instructions
- Toggle voice guidance

### 2. Season Intro
- See starting money (₹50,000) and stress (0)
- Introduction to the game

### 3. Personal Decision
- Allocate ₹20,000: Save (reduces stress), Invest (farm growth), or Spend (increases stress)

### 4. Farm Investment
- Choose seeds: Good (₹15K, high yield) or Cheap (₹8K, risky)
- Decision sets probability for faulty products

### 5. Faulty Product (Conditional)
- 30% chance with cheap seeds, 10% with good seeds
- Response options: Ignore (lose money), Fight (pay fees), Register Complaint (get refund + learn rights)

### 6. Lean Period Emergency
- Random event: Hailstorm, Medical Emergency, or Pest Attack
- Solutions: Use Savings, Break Investment, or Take Loan

### 7. Loan Decision (If Taking Loan)

**Path A: Hurry/Blind**
1. Blind Loan Selection → Pick lender without details
2. Minimal Summary → See approved amount
3. Continue to fraud

**Path B: Think/Informed**
1. Loan Market Intro → See all lenders with hints
2. Loan Detail Overlay → Long-press each to learn full details
3. Comparison Mini-Game → Match features to lenders [Future]
4. Informed Choice → Select with full knowledge
5. Full Summary → Understand complete terms
6. Continue to fraud

### 8. Fraud Check
- OTP scam scenario
- Choose: Share OTP (lose ₹8000) or Refuse (stay safe)

### 9. Harvest & Results
- Final money calculated (starting + harvest - loan repayment)
- Stress level status
- Personalized learning insights based on decisions
- Option to play again

## Technical Architecture

### Stack
- **Flutter** - Cross-platform UI
- **Dart** - Programming language
- **Riverpod** - State management
- **flutter_tts** - Voice narration
- **Material Design 3** - UI framework

### Project Structure

```
lib/
├── main.dart                    # App entry + routing
├── core/
│   ├── theme/app_theme.dart   # Colors & styles
│   └── widgets/               # Common UI components
├── models/
│   ├── season_state.dart      # Game state logic
│   └── loan_model.dart        # Loan calculations
├── providers/
│   └── game_state_provider.dart # Riverpod state
├── services/
│   └── voice_service.dart     # TTS integration
└── screens/                    # 12 game screens
```

### State Management

**Riverpod** manages the central `GameState` via `gameStateProvider`:

```dart
// In screens:
final gameState = ref.watch(gameStateProvider);                    // Read state
ref.read(gameStateProvider.notifier).makePersonalDecision(...)     // Update state
```

The notifier handles all state transitions and business logic.

## Customization

See **ARCHITECTURE.md** for detailed customization:
- Interest rates and loan terms
- Faulty product probabilities
- Emergency amounts
- Voice lines (with translations)
- Colors and themes
- Adding new screens

Quick examples:

**Change moneylender interest rate** (`models/loan_model.dart`):
```dart
interestRate: 36.0,  // Change this value
```

**Adjust difficulty** (`screens/farm_investment_screen.dart`):
```dart
bool hasFaultyProduct = random.nextDouble() < 0.3;  // Increase for harder game
```

**Add custom voice line** (`services/voice_service.dart`):
```dart
String getCustomMessage() {
  return _translate('key', 'Your message here');
}
```

## Installation & Running

### Prerequisites
- Flutter 3.0.0+
- Dart SDK
- Android SDK 21+ (minimum)

### Setup

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release
```

## Loan System Details

The app includes a sophisticated loan comparison system:

| Feature | Moneylender | Private Bank | Government Bank |
|---------|-------------|--------------|-----------------|
| Interest Rate | 36% | 14% | 7% |
| Fee | ₹2,000 | ₹1,000 | ₹500 |
| Collateral Risk | Yes (land at risk) | Yes | No |
| Early Repayment Penalty | Yes | No | No |
| Government Subsidy | No | No | Yes |

**EMI Calculation:**
```
EMI = P × r × (1+r)^n / ((1+r)^n - 1)
where r = monthly interest rate, n = number of months
```

For a ₹50,000 loan over 3 seasons:
- Moneylender: ~₹18,000 EMI per season (total interest: ₹4,000)
- Private Bank: ~₹17,800 EMI per season (total interest: ₹3,400)
- Government Bank: ~₹17,400 EMI per season (total interest: ₹2,200)

## Voice Integration

All screens have optional voice guidance in English and Hindi:

```dart
// Initialize voice
final voiceService = VoiceService();
await voiceService.initialize();

// Speak text
await voiceService.speak('Hello farmer!');

// Screen-specific prompts
await voiceService.speak(voiceService.getPersonalDecisionPrompt());
```

## Learning Outcomes

Players learn about:
1. **Financial planning** - Saving vs. investing tradeoffs
2. **Quality decisions** - How cutting corners affects outcomes
3. **Consumer rights** - Faulty products and complaint process
4. **Emergency management** - Resource allocation under stress
5. **Loan literacy** - Interest rates, fees, terms comparison
6. **Fraud awareness** - OTP protection and scam recognition

Each season generates personalized insights tied to player decisions.

## Future Enhancements

Planned features:
- Loan comparison mini-game (drag-and-drop matching)
- Multi-season progression
- Difficulty levels
- Leaderboards
- Offline persistence (SharedPreferences)
- Additional languages (Tamil, Marathi, etc.)

## Troubleshooting

**Flutter not found?**
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

**Voice not working?**
- Ensure device supports TTS
- Check language is set correctly
- Toggle voice in home screen

**Routing issues?**
- Check all routes are registered in main.dart
- Use `Navigator.push()` for new route, `pushReplacement()` to replace current

**State not updating?**
- Ensure using `ConsumerWidget` or `ConsumerState`
- Watch provider: `ref.watch(gameStateProvider)`
- Update: `ref.read(gameStateProvider.notifier).method()`

## Contact & Resources

- **Flutter docs**: https://flutter.dev/docs
- **Riverpod**: https://riverpod.dev
- **Material Design**: https://material.io/design
- **flutter_tts**: https://pub.dev/packages/flutter_tts

---

**Version:** 2.0 (Refactored - Jan 2026)
**Status:** ✅ Fully functional and buildable
**License:** [Specify your license]
