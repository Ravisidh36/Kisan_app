import 'dart:math' as math;

/// Loan types available in the game
enum LoanType {
  moneylender,
  privateBank,
  govtAgriBank,
}

/// Represents a loan product with all details
class LoanProduct {
  final LoanType lenderType;
  final String lenderName;
  final double interestRate; // Annual percentage
  final int processingFee; // Fixed amount in rupees
  final bool hasCollateralRisk; // Whether land is at risk
  final bool hasPrepaymentPenalty; // Early repayment penalty
  final bool hasSubsidy; // Government subsidy benefit
  final String description; // Short description
  final String iconPath; // Asset path for lender icon

  LoanProduct({
    required this.lenderType,
    required this.lenderName,
    required this.interestRate,
    required this.processingFee,
    required this.hasCollateralRisk,
    required this.hasPrepaymentPenalty,
    required this.hasSubsidy,
    required this.description,
    required this.iconPath,
  });

  /// Predefined loan products
  static final Map<LoanType, LoanProduct> predefined = {
    LoanType.moneylender: LoanProduct(
      lenderType: LoanType.moneylender,
      lenderName: 'Moneylender',
      interestRate: 36.0, // 36% annual
      processingFee: 2000,
      hasCollateralRisk: true,
      hasPrepaymentPenalty: true,
      hasSubsidy: false,
      description: 'Fast money, very high interest and hidden fees',
      iconPath: 'assets/icons/moneylender.png',
    ),
    LoanType.privateBank: LoanProduct(
      lenderType: LoanType.privateBank,
      lenderName: 'Private Bank',
      interestRate: 14.0, // 14% annual
      processingFee: 1000,
      hasCollateralRisk: true,
      hasPrepaymentPenalty: false,
      hasSubsidy: false,
      description: 'Medium interest, standard terms',
      iconPath: 'assets/icons/private_bank.png',
    ),
    LoanType.govtAgriBank: LoanProduct(
      lenderType: LoanType.govtAgriBank,
      lenderName: 'Government Agricultural Bank',
      interestRate: 7.0, // 7% annual (with subsidy it's effectively lower)
      processingFee: 500,
      hasCollateralRisk: false,
      hasPrepaymentPenalty: false,
      hasSubsidy: true,
      description: 'Lowest interest with government subsidy, no collateral risk',
      iconPath: 'assets/icons/govt_bank.png',
    ),
  };

  /// Calculate EMI for a given loan amount and duration in seasons (assume 4 months per season)
  int calculateEMIPerSeason(int principal, int numberOfSeasons) {
    // Simple interest calculation for 4-month season
    // EMI = P * r / (12 * 100 * n) where n is in months
    double monthlyRate = interestRate / 100 / 12;
    int numberOfMonths = numberOfSeasons * 4;
    
    if (monthlyRate == 0) {
      return (principal / numberOfSeasons).toInt();
    }
    
    double emi = (principal * monthlyRate * math.pow(1 + monthlyRate, numberOfMonths)) /
        (math.pow(1 + monthlyRate, numberOfMonths) - 1);
    
    return emi.toInt();
  }

  /// Calculate total interest paid over loan tenure
  int calculateTotalInterest(int principal, int numberOfSeasons) {
    int emiPerSeason = calculateEMIPerSeason(principal, numberOfSeasons);
    int totalPaid = emiPerSeason * numberOfSeasons;
    return totalPaid - principal;
  }
}

/// Active loan taken by player
class ActiveLoan {
  final LoanType lenderType;
  final int principal; // Loan amount
  final double interestRate;
  final int processingFee;
  final bool hasCollateralRisk;
  final bool hasPrepaymentPenalty;
  final bool hasSubsidy;
  
  int remainingAmount; // Amount still to be repaid
  int totalInterest; // Total interest on this loan
  int seasonsTaken; // When loan was taken (phase number)
  int emiPerSeason; // EMI to be deducted each season
  int totalEmiPaid = 0; // Total EMI paid so far

  ActiveLoan({
    required this.lenderType,
    required this.principal,
    required this.interestRate,
    required this.processingFee,
    required this.hasCollateralRisk,
    required this.hasPrepaymentPenalty,
    required this.hasSubsidy,
    required this.remainingAmount,
    required this.totalInterest,
    required this.seasonsTaken,
    required this.emiPerSeason,
  });

  /// Record an EMI payment
  void recordEmiPayment() {
    if (remainingAmount > 0) {
      remainingAmount = (remainingAmount - emiPerSeason).clamp(0, remainingAmount);
      totalEmiPaid += emiPerSeason;
    }
  }

  /// Check if loan is fully repaid
  bool isFullyRepaid() => remainingAmount <= 0;
}
