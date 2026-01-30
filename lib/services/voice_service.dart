import 'package:flutter_tts/flutter_tts.dart';

/// Enhanced voice service with screen-specific scripts and localization hooks
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  String _currentLanguage = 'en-US'; // Default to English
  bool _voiceEnabled = true;

  /// Static map of Hindi phrases
  static const Map<String, String> hindiPhrases = {
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

  Future<void> initialize({String language = 'en-US'}) async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();

      // Set language
      await _flutterTts!.setLanguage(language);
      _currentLanguage = language;

      // Configure speech parameters
      await _flutterTts!.setSpeechRate(0.5);
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.0);

      _isInitialized = true;
    } catch (e) {
      print('VoiceService initialization failed: $e');
      _voiceEnabled = false;
    }
  }

  /// Speak text using TTS if enabled
  Future<void> speak(String text) async {
    if (!_voiceEnabled) return;

    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_flutterTts != null && text.isNotEmpty) {
        await _flutterTts!.speak(text);
      }
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts!.stop();
      }
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  /// Set whether voice is enabled
  void setVoiceEnabled(bool enabled) {
    _voiceEnabled = enabled;
  }

  /// Get voice enabled status
  bool isVoiceEnabled() => _voiceEnabled;

  /// Change language for TTS
  Future<void> setLanguage(String language) async {
    try {
      if (_flutterTts != null) {
        await _flutterTts!.setLanguage(language);
        _currentLanguage = language;
      }
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  // ===== SCREEN-SPECIFIC VOICE SCRIPTS =====
  // These can be easily extended with translations

  /// Home screen greeting
  String getHomeScreenGreeting() {
    return _translate('homeGreeting',
        'Welcome to Kisan Life Simulator. Learn to manage your farm wisely.');
  }

  /// Season intro message
  String getSeasonIntroMessage() {
    return _translate('seasonIntro',
        'You are starting a new crop season with 50,000 rupees and no stress. Make wise decisions to succeed.');
  }

  /// Personal decision phase prompt
  String getPersonalDecisionPrompt() {
    return _translate('personalDecision',
        'You have 20,000 rupees. Do you want to save, invest in your farm, or spend on personal needs?');
  }

  /// Farm investment phase prompt
  String getFarmInvestmentPrompt() {
    return _translate('farmInvestment',
        'Choose your seeds. Good seeds cost more but give better harvest. Cheap seeds are risky.');
  }

  /// Faulty product discovered
  String getFaultyProductMessage() {
    return _translate('faultyProduct',
        'Oh no! Your seeds are faulty. Will you ignore, fight, or register a complaint?');
  }

  /// Lean period event intro
  String getLeanPeriodEventMessage(String eventType) {
    switch (eventType) {
      case 'hailstorm':
        return _translate('hailstorm',
            'A terrible hailstorm has destroyed parts of your field! You need money to recover.');
      case 'medical':
        return _translate('medical',
            'A family member is sick and needs medical treatment. You need 50,000 rupees.');
      case 'pest':
        return _translate('pest',
            'Pests have attacked your crops! You need emergency treatment.');
      default:
        return _translate('emergency',
            'An emergency has happened! You need money quickly.');
    }
  }

  /// Lean period action options
  String getLeanPeriodActionPrompt() {
    return _translate('leanPeriodAction',
        'You can use your savings, break your investment, or take a loan. What will you do?');
  }

  /// Loan decision prompt
  String getLoanDecisionModePrompt() {
    return _translate('loanMode',
        'Do you want money quickly without checking details, or will you compare loans carefully?');
  }

  /// Blind loan prompt
  String getBlindLoanPrompt() {
    return _translate('blindLoan',
        'You are in a hurry. Choose any loan quickly.');
  }

  /// Loan details prompt
  String getLoanDetailsPrompt() {
    return _translate('loanDetails',
        'Tap each loan to hear full details. Compare all three before choosing.');
  }

  /// Loan detail narration
  String getLoanDetailNarration(String lenderName, double interestRate,
      int fee, bool hasSubsidy, bool hasCollateral) {
    String narrative = '$lenderName: Interest rate is ${interestRate.toStringAsFixed(1)} percent. ';
    narrative += 'Processing fee is $fee rupees. ';
    if (hasSubsidy) {
      narrative +=
          'This lender has government subsidy which helps you. ';
    }
    if (hasCollateral) {
      narrative += 'Warning: Your land is at risk if you do not repay. ';
    } else {
      narrative +=
          'Good news: Your land is not at risk. ';
    }
    return _translate('loanDetail_$lenderName', narrative);
  }

  /// Mini-game comparison prompt
  String getComparisonMiniGamePrompt() {
    return _translate('comparison',
        'Match each loan feature to the correct lender. Drag and drop to compare.');
  }

  /// Fraud OTP prompt
  String getFraudOtpPrompt() {
    return _translate('fraudOtp',
        'Someone is asking for your OTP. Do you share it or refuse?');
  }

  /// Harvest summary message
  String getHarvestSummaryMessage(int finalMoney, int finalStress) {
    return _translate('harvest',
        'Your season is over. Final money: $finalMoney rupees. Final stress: $finalStress percent.');
  }

  // ===== HELPER METHODS =====

  /// Translation helper (placeholder for future localization)
  String _translate(String key, String defaultText) {
    // TODO: Implement proper localization map
    // For now, return defaultText
    // This method allows easy switching to multiple languages later
    return defaultText;
  }

  /// Get all translated phrases (for potential offline use)
  static const Map<String, Map<String, String>> phrases = {
    'en-US': {
      'homeGreeting':
          'Welcome to Kisan Life Simulator. Learn to manage your farm wisely.',
      'seasonIntro':
          'You are starting a new crop season with 50,000 rupees and no stress.',
      'personalDecision':
          'You have 20,000 rupees. Do you want to save, invest, or spend?',
      'farmInvestment':
          'Choose your seeds. Good seeds cost more but give better harvest.',
      'faultyProduct':
          'Oh no! Your seeds are faulty. Will you ignore, fight, or register?',
      'hailstorm':
          'A terrible hailstorm has destroyed your field!',
      'medical':
          'A family member needs medical treatment. You need 50,000 rupees.',
      'pest':
          'Pests have attacked your crops!',
      'leanPeriodAction':
          'Use your savings, break investment, or take a loan.',
      'loanMode':
          'Do you want money quickly, or will you compare loans carefully?',
      'blindLoan':
          'You are in a hurry. Choose any loan quickly.',
      'loanDetails':
          'Tap each loan to hear full details. Compare all three.',
      'comparison':
          'Match each loan feature to the correct lender.',
      'fraudOtp':
          'Someone is asking for your OTP. Do you share it or refuse?',
      'harvest':
          'Your season is over. See your final results.',
    },
    'hi-IN': {
      'homeGreeting':
          'किसान जीवन सिम्युलेटर में स्वागत है। अपने खेत को समझदारी से चलाएं।',
      'seasonIntro':
          'आप एक नई फसल का मौसम शुरू कर रहे हैं 50,000 रुपये और शून्य तनाव के साथ।',
      'personalDecision':
          'आपके पास 20,000 रुपये हैं। क्या आप बचाना, निवेश, या खर्च करना चाहते हैं?',
      'farmInvestment':
          'अपने बीज चुनें। अच्छे बीज ज्यादा कीमत के होते हैं लेकिन बेहतर फसल देते हैं।',
      'faultyProduct':
          'अरे! आपके बीज खराब हैं। क्या आप अनदेखा, लड़ाई, या शिकायत दर्ज करेंगे?',
      'hailstorm':
          'एक भयानक ओलावृष्टि ने आपके खेत को नष्ट कर दिया है!',
      'medical':
          'एक परिवार के सदस्य को चिकित्सा की आवश्यकता है। आपको 50,000 रुपये की जरूरत है।',
      'pest':
          'कीटों ने आपकी फसलों पर हमला किया है!',
      'loanMode':
          'क्या आप जल्दी पैसा चाहते हैं, या आप ऋणों की तुलना करेंगे?',
      'fraudOtp':
          'कोई आपका OTP मांग रहा है। क्या आप इसे साझा करते हैं या मना करते हैं?',
    },
  };

  Future<void> speakPhrase(String key) async {
    final phrase = hindiPhrases[key] ?? key;
    await speak(phrase);
  }

  Future<void> speakCustom(String hindiText) async {
    await speak(hindiText);
  }
}
