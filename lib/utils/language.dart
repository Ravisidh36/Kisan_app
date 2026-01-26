class Language {
  static String currentLanguage = 'en';

  static Map<String, Map<String, String>> translations = {
    'en': {
      // Home Screen
      'app_title': 'Kisan Life Simulator',
      'start_game': 'Start Game',
      'how_to_play': 'How to Play',
      'change_language': 'Change Language',
      
      // How to Play
      'how_to_play_title': 'How to Play',
      'how_to_play_text': 'Make financial decisions and see their consequences. Learn through experience!',
      'back': 'Back',
      
      // Phase 1
      'phase1_title': 'Personal Decision',
      'phase1_description': '₹20,000 available',
      'save': 'Save',
      'invest': 'Invest',
      'personal_expense': 'Personal Expense',
      
      // Phase 2
      'phase2_title': 'Farm Investment',
      'phase2_description': 'Buy seeds, tools, fertilizer – ₹30,000',
      'phase2_warning': 'Investment can give profit or loss.',
      'buy': 'Buy',
      'skip': 'Skip',
      
      // Phase 3
      'phase3_title': 'Faulty Product',
      'phase3_description': 'Product quality is poor!',
      'ignore': 'Ignore',
      'fight_angrily': 'Fight Angrily',
      'register_complaint': 'Register Complaint',
      'product_replaced': 'Product replaced!',
      
      // Phase 4
      'phase4_title': 'Emergency',
      'phase4_hailstorm': 'Hailstorm damaged crops!',
      'phase4_medical': 'Medical emergency!',
      'phase4_pesticide': 'Pesticide needed!',
      'apply_subsidy': 'Apply for Subsidy',
      'use_savings': 'Use Savings',
      'take_loan': 'Take Loan ₹20,000',
      'withdraw_investment': 'Withdraw Investment',
      'subsidy_received': 'Subsidy received: ₹10,000',
      
      // Phase 5
      'phase5_title': 'Bank Alert',
      'phase5_message': 'Share OTP to receive money',
      'share_otp': 'Share OTP',
      'ignore_alert': 'Ignore',
      'fraud_warning': 'This was a fraud! Money lost.',
      'fraud_safe': 'You avoided fraud!',
      
      // Phase 6
      'phase6_title': 'Harvest Time',
      'phase6_harvest': 'Harvest Complete!',
      'loan_deduction': 'Loan deducted with interest',
      
      // Summary
      'summary_title': 'Game Summary',
      'starting_money': 'Starting Money',
      'final_money': 'Final Money',
      'stress_level': 'Stress Level',
      'loan_taken': 'Loan Taken',
      'no_loan': 'No Loan',
      'good_decisions': 'Good Decisions',
      'bad_decisions': 'Bad Decisions',
      'play_again': 'Play Again',
      'review_decisions': 'Review Decisions',
      'view_summary': 'View Summary',
      
      // Common
      'money': 'Money',
      'stress': 'Stress',
      'yes': 'Yes',
      'no': 'No',
    },
    'hi': {
      // Home Screen
      'app_title': 'किसान जीवन सिम्युलेटर',
      'start_game': 'खेल शुरू करें',
      'how_to_play': 'कैसे खेलें',
      'change_language': 'भाषा बदलें',
      
      // How to Play
      'how_to_play_title': 'कैसे खेलें',
      'how_to_play_text': 'वित्तीय निर्णय लें और उनके परिणाम देखें। अनुभव से सीखें!',
      'back': 'वापस',
      
      // Phase 1
      'phase1_title': 'व्यक्तिगत निर्णय',
      'phase1_description': '₹20,000 उपलब्ध',
      'save': 'बचत करें',
      'invest': 'निवेश करें',
      'personal_expense': 'व्यक्तिगत खर्च',
      
      // Phase 2
      'phase2_title': 'खेत निवेश',
      'phase2_description': 'बीज, उपकरण, उर्वरक खरीदें – ₹30,000',
      'phase2_warning': 'निवेश से लाभ या हानि हो सकती है।',
      'buy': 'खरीदें',
      'skip': 'छोड़ें',
      
      // Phase 3
      'phase3_title': 'खराब उत्पाद',
      'phase3_description': 'उत्पाद की गुणवत्ता खराब है!',
      'ignore': 'नजरअंदाज करें',
      'fight_angrily': 'गुस्से से लड़ें',
      'register_complaint': 'शिकायत दर्ज करें',
      'product_replaced': 'उत्पाद बदल दिया गया!',
      
      // Phase 4
      'phase4_title': 'आपातकाल',
      'phase4_hailstorm': 'ओलावृष्टि से फसल क्षतिग्रस्त!',
      'phase4_medical': 'चिकित्सा आपातकाल!',
      'phase4_pesticide': 'कीटनाशक की जरूरत!',
      'apply_subsidy': 'सब्सिडी के लिए आवेदन करें',
      'use_savings': 'बचत का उपयोग करें',
      'take_loan': 'कर्ज लें ₹20,000',
      'withdraw_investment': 'निवेश वापस लें',
      'subsidy_received': 'सब्सिडी प्राप्त: ₹10,000',
      
      // Phase 5
      'phase5_title': 'बैंक अलर्ट',
      'phase5_message': 'पैसा प्राप्त करने के लिए OTP साझा करें',
      'share_otp': 'OTP साझा करें',
      'ignore_alert': 'नजरअंदाज करें',
      'fraud_warning': 'यह एक धोखाधड़ी थी! पैसा खो गया।',
      'fraud_safe': 'आपने धोखाधड़ी से बचा लिया!',
      
      // Phase 6
      'phase6_title': 'फसल का समय',
      'phase6_harvest': 'फसल पूरी!',
      'loan_deduction': 'ब्याज के साथ कर्ज कटौती',
      
      // Summary
      'summary_title': 'खेल सारांश',
      'starting_money': 'शुरुआती पैसा',
      'final_money': 'अंतिम पैसा',
      'stress_level': 'तनाव स्तर',
      'loan_taken': 'कर्ज लिया',
      'no_loan': 'कोई कर्ज नहीं',
      'good_decisions': 'अच्छे निर्णय',
      'bad_decisions': 'बुरे निर्णय',
      'play_again': 'फिर से खेलें',
      'review_decisions': 'निर्णयों की समीक्षा करें',
      'view_summary': 'सारांश देखें',
      
      // Common
      'money': 'पैसा',
      'stress': 'तनाव',
      'yes': 'हाँ',
      'no': 'नहीं',
    },
  };

  static String translate(String key) {
    return translations[currentLanguage]?[key] ?? key;
  }

  static void setLanguage(String lang) {
    currentLanguage = lang;
  }
}
