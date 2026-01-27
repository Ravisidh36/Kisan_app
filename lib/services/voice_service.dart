import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _flutterTts = FlutterTts();
    
    // Set language to Hindi
    await _flutterTts!.setLanguage("hi-IN");
    await _flutterTts!.setSpeechRate(0.5);
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setPitch(1.0);
    
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (_flutterTts != null) {
      await _flutterTts!.speak(text);
    }
  }

  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
  }

  // Hindi translations for common phrases
  static const Map<String, String> hindiPhrases = {
    'phase1_start': 'पहला चरण: अपने पैसे का निर्णय लें',
    'phase2_start': 'दूसरा चरण: खेत में निवेश करें',
    'phase3_start': 'तीसरा चरण: खराब उत्पाद की समस्या',
    'phase4_start': 'चौथा चरण: मुश्किल समय',
    'phase5_start': 'पांचवां चरण: धोखाधड़ी जांच',
    'phase6_start': 'छठा चरण: फसल कटाई',
    'stress_increased': 'तनाव बढ़ गया',
    'money_added': 'पैसा जोड़ा गया',
    'wrong_decision': 'गलत निर्णय',
    'good_choice': 'अच्छा विकल्प',
    'saved_money': 'पैसे बचाए',
    'invested_money': 'निवेश किया',
    'spent_money': 'पैसा खर्च किया',
    'loan_taken': 'कर्ज लिया',
    'fraud_detected': 'धोखाधड़ी का पता चला',
    'fraud_avoided': 'धोखाधड़ी से बचा',
    'subsidy_applied': 'सब्सिडी के लिए आवेदन किया',
    'savings_used': 'बचत का उपयोग किया',
    'complaint_registered': 'शिकायत दर्ज की',
  };

  Future<void> speakPhrase(String key) async {
    final phrase = hindiPhrases[key] ?? key;
    await speak(phrase);
  }

  Future<void> speakCustom(String hindiText) async {
    await speak(hindiText);
  }
}
