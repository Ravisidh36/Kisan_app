# Kisan Life Simulator

A gamified financial literacy mobile application for rural farmers built with Flutter.

## Overview

This app teaches financial decision-making through an interactive simulation. Users learn through consequences, not theory. The app is designed to be:
- Simple and visual
- Offline-friendly
- Usable by low-literacy users
- Optimized for low-end devices

## Features

- **6 Game Phases**: Personal decisions, farm investment, faulty product handling, lean period events, fraud checks, and harvest
- **Bilingual Support**: English and Hindi
- **Visual Learning**: Large buttons, icons, minimal text
- **Consequence-Based Education**: Learn through gameplay outcomes
- **No Internet Required**: Fully offline functionality

## Game Flow

1. **Phase 1 - Personal Decision**: Choose to save, invest, or spend ₹20,000
2. **Phase 2 - Farm Investment**: Buy seeds, tools, fertilizer for ₹30,000 (may be faulty)
3. **Phase 3 - Faulty Product**: Handle poor quality products (if applicable)
4. **Phase 4 - Lean Period**: Deal with emergencies (hailstorm, medical, pesticide)
5. **Phase 5 - Fraud Check**: Avoid financial fraud attempts
6. **Phase 6 - Harvest**: Calculate final earnings and loan deductions
7. **Summary**: Review decisions and outcomes

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── game_state.dart      # Game state management
├── screens/
│   ├── home_screen.dart     # Home screen
│   ├── game_flow.dart       # Main game flow controller
│   ├── phase1_personal_decision.dart
│   ├── phase2_farm_investment.dart
│   ├── phase3_faulty_product.dart
│   ├── phase4_lean_period.dart
│   ├── phase5_fraud_check.dart
│   ├── phase6_harvest.dart
│   ├── summary_screen.dart
│   └── how_to_play_screen.dart
└── utils/
    └── language.dart        # Language translation system
```

## Game State Variables

- `money`: Current money (starts at ₹50,000)
- `stress`: Stress level (0-100)
- `invested`: Whether user invested
- `saved`: Whether user saved money
- `tookLoan`: Whether user took a loan
- `loanAmount`: Loan amount if taken
- `loanInterest`: Interest rate (10%)

## Educational Goals

The app teaches:
- Saving discipline
- Loan consequences
- Investment risk awareness
- Fraud awareness
- Consumer rights
- Financial planning

All learning happens through gameplay and outcomes, not quizzes or long explanations.

## Design Principles

- Large, touch-friendly buttons
- Minimal text with icons
- Simple navigation
- Material Design UI
- Gradient backgrounds for visual appeal
- Color-coded actions (green = good, red = warning)

## Language Support

Currently supports:
- English (en)
- Hindi (hi)

To add more languages, edit `lib/utils/language.dart` and add translations to the `translations` map.

## License

This project is created for educational purposes.
