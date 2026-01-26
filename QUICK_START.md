# Quick Start Guide

## Running the App

1. **Install Flutter** (if not already installed)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Testing on Different Devices

### Android
```bash
flutter run -d android
```

### iOS (Mac only)
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome
```

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS (Mac only)
```bash
flutter build ios --release
```

## Key Features to Test

1. **Language Switching**: Change language from home screen
2. **Game Flow**: Complete all 6 phases
3. **Decision Consequences**: Try different choices to see outcomes
4. **Summary Screen**: Review decisions and final results

## Troubleshooting

- **Build errors**: Run `flutter clean` then `flutter pub get`
- **Dependencies**: Ensure Flutter SDK is 3.0.0 or higher
- **Device not found**: Run `flutter devices` to see available devices
