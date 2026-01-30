import 'dart:math';
import 'loan_model.dart';

/// Tracks all game state for a single season/game
class GameState {
  // Basic resources
  int currentMoney;
  int stressLevel; // 0–100
  int seasonStep; // Current phase (1-6)

  // Money allocation
  int savingsAmount;
  int investmentAmount;
  
  // Investment details
  bool investmentQuality; // true = good seeds, false = cheap seeds
  int investmentYield; // Calculated at harvest

  // Loan details
  ActiveLoan? activeLoan;
  bool tookLoanBlind; // Whether loan decision was made without seeing details
  bool tookLoanInformed; // Whether loan decision was informed
  bool registeredComplaintForProduct; // Consumer rights decision

  // Decision flags
  String? personalDecisionType; // 'save', 'invest', 'spend'
  String? leanPeriodEventType; // 'hailstorm', 'medical', 'pest'
  String? leanPeriodActionType; // 'savings', 'investment', 'loan'
  bool sharedOTPWithFraud; // Fraud decision
  bool ignoreLoanRegretScreen; // Whether to skip regret screen

  // Event history and decisions
  List<String> eventHistory;
  List<int> moneyHistory;
  List<int> stressHistory;
  List<String> goodDecisions;
  List<String> badDecisions;

  // Harvest calculation
  int harvestBaseYield;
  int harvestFinalMoney;
  int harvestFinalStress;
  int harvestLoanRepaidAmount;

  GameState({
    this.currentMoney = 50000,
    this.stressLevel = 0,
    this.seasonStep = 0,
    this.savingsAmount = 0,
    this.investmentAmount = 0,
    this.investmentQuality = false,
    this.investmentYield = 0,
    this.activeLoan,
    this.tookLoanBlind = false,
    this.tookLoanInformed = false,
    this.registeredComplaintForProduct = false,
    this.personalDecisionType,
    this.leanPeriodEventType,
    this.leanPeriodActionType,
    this.sharedOTPWithFraud = false,
    this.ignoreLoanRegretScreen = false,
    this.harvestBaseYield = 0,
    this.harvestFinalMoney = 0,
    this.harvestFinalStress = 0,
    this.harvestLoanRepaidAmount = 0,
    List<String>? eventHistory,
    List<int>? moneyHistory,
    List<int>? stressHistory,
    List<String>? goodDecisions,
    List<String>? badDecisions,
  })  : eventHistory = eventHistory ?? [],
        moneyHistory = moneyHistory ?? [50000],
        stressHistory = stressHistory ?? [0],
        goodDecisions = goodDecisions ?? [],
        badDecisions = badDecisions ?? [];

  /// Reset game state to initial conditions
  void reset() {
    currentMoney = 50000;
    stressLevel = 0;
    seasonStep = 0;
    savingsAmount = 0;
    investmentAmount = 0;
    investmentQuality = false;
    investmentYield = 0;
    activeLoan = null;
    tookLoanBlind = false;
    tookLoanInformed = false;
    registeredComplaintForProduct = false;
    personalDecisionType = null;
    leanPeriodEventType = null;
    leanPeriodActionType = null;
    sharedOTPWithFraud = false;
    ignoreLoanRegretScreen = false;
    harvestBaseYield = 0;
    harvestFinalMoney = 0;
    harvestFinalStress = 0;
    harvestLoanRepaidAmount = 0;
    eventHistory.clear();
    moneyHistory.clear();
    moneyHistory.add(50000);
    stressHistory.clear();
    stressHistory.add(0);
    goodDecisions.clear();
    badDecisions.clear();
  }

  /// Add an event to history
  void addEvent(String event) {
    eventHistory.add(event);
  }

  /// Record money change and history
  void updateMoney(int amount, String reason) {
    currentMoney += amount;
    currentMoney = currentMoney.clamp(0, 10000000); // Ensure non-negative
    moneyHistory.add(currentMoney);
    addEvent('Money changed by ₹$amount ($reason)');
  }

  /// Record stress change
  void updateStress(int amount, String reason) {
    stressLevel = (stressLevel + amount).clamp(0, 100);
    stressHistory.add(stressLevel);
    addEvent('Stress changed by $amount ($reason)');
  }

  /// Deduct EMI for current season
  void deductEMI() {
    if (activeLoan != null && !activeLoan!.isFullyRepaid()) {
      int emiAmount = activeLoan!.emiPerSeason;
      if (currentMoney >= emiAmount) {
        updateMoney(-emiAmount, 'EMI payment');
        activeLoan!.recordEmiPayment();
        // Higher stress for higher EMI burden
        int stressIncrease = (emiAmount / 2000).toInt().clamp(1, 10);
        updateStress(stressIncrease, 'Loan EMI burden');
      } else {
        // Unable to pay full EMI - bad situation
        updateMoney(-currentMoney, 'Partial EMI payment');
        activeLoan!.recordEmiPayment();
        updateStress(15, 'Unable to pay full EMI');
      }
    }
  }

  /// Take a loan with given details
  void takeLoan(LoanProduct product, int loanAmount, int numberOfSeasons) {
    int emiPerSeason = product.calculateEMIPerSeason(loanAmount, numberOfSeasons);
    int totalInterest = product.calculateTotalInterest(loanAmount, numberOfSeasons);

    activeLoan = ActiveLoan(
      lenderType: product.lenderType,
      principal: loanAmount,
      interestRate: product.interestRate,
      processingFee: product.processingFee,
      hasCollateralRisk: product.hasCollateralRisk,
      hasPrepaymentPenalty: product.hasPrepaymentPenalty,
      hasSubsidy: product.hasSubsidy,
      remainingAmount: loanAmount + product.processingFee,
      totalInterest: totalInterest,
      seasonsTaken: seasonStep,
      emiPerSeason: emiPerSeason,
    );

    // Add loan amount minus processing fee
    updateMoney(loanAmount - product.processingFee, 'Loan received');
    updateStress(10, 'Took loan');
  }

  /// Calculate harvest yield based on seed quality and luck
  int calculateHarvestYield() {
    int baseYield = 0;
    final random = Random();

    if (investmentQuality) {
      // Good seeds: base 30,000 + variance
      baseYield = 30000 + random.nextInt(10000);
      if (registeredComplaintForProduct) {
        baseYield += 5000; // Bonus for taking action
      }
    } else {
      // Cheap seeds: base 15,000 + variance
      baseYield = 15000 + random.nextInt(8000);
    }

    // Stress penalty: higher stress = lower yield
    int stressPenalty = (stressLevel / 10 * 1000).toInt();
    baseYield = (baseYield - stressPenalty).clamp(5000, 50000);

    return baseYield;
  }

  /// Generate final harvest result
  void finalizeHarvest() {
    // Calculate yield
    harvestBaseYield = calculateHarvestYield();

    // Start with harvest + any remaining savings/investment
    harvestFinalMoney = currentMoney + harvestBaseYield;

    // Deduct remaining loan if taken
    if (activeLoan != null) {
      harvestLoanRepaidAmount = activeLoan!.totalEmiPaid;
      if (!activeLoan!.isFullyRepaid()) {
        // Add remaining loan as debt that affects final score
        harvestFinalMoney -= activeLoan!.remainingAmount;
      }
    }

    harvestFinalMoney = harvestFinalMoney.clamp(0, 10000000);
    harvestFinalStress = stressLevel;

    addEvent('Season completed. Final money: ₹$harvestFinalMoney');
  }

  /// Get summary of good/bad decisions for learning
  Map<String, dynamic> getDecisionSummary() {
    return {
      'goodDecisions': goodDecisions,
      'badDecisions': badDecisions,
      'tookLoanBlind': tookLoanBlind,
      'tookLoanInformed': tookLoanInformed,
      'registeredComplaint': registeredComplaintForProduct,
      'sharedOTP': sharedOTPWithFraud,
      'investmentQuality': investmentQuality,
      'usedSavings': leanPeriodActionType == 'savings',
      'withdrawalInvestment': leanPeriodActionType == 'investment',
    };
  }

  /// Get learning insights based on decisions
  List<String> getLearningInsights() {
    List<String> insights = [];

    // Loan insights
    if (tookLoanBlind && activeLoan != null) {
      if (activeLoan!.lenderType == LoanType.moneylender) {
        insights.add(
            'You took a blind loan from a moneylender and paid extra ₹${activeLoan!.totalInterest} in interest. '
            'Next time, compare loans before deciding.');
      }
    }

    if (tookLoanInformed && activeLoan != null) {
      if (activeLoan!.lenderType == LoanType.govtAgriBank) {
        insights.add(
            'Smart choice! You chose an informed loan from the government bank and saved money with lower interest.');
      }
    }

    // OTP insight
    if (sharedOTPWithFraud) {
      insights.add('Sharing your OTP cost you money and stress. Never share OTP with anyone!');
    } else if (seasonStep >= 5) {
      insights.add('Good! You protected your account by refusing to share your OTP.');
    }

    // Complaint insight
    if (registeredComplaintForProduct) {
      insights.add('Registering a complaint for faulty product was a wise choice for consumer protection.');
    }

    // Savings vs Loan
    if (leanPeriodActionType == 'savings') {
      insights.add('Using your savings helped you avoid expensive loan interest.');
    }

    if (investmentQuality) {
      insights.add('Investing in good quality seeds gave you a better harvest.');
    }

    return insights;
  }
}
