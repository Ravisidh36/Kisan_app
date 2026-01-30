import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/season_state.dart';
import '../models/loan_model.dart';

/// Global state provider for the current game season
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});

/// Notifier for managing game state changes
class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState());

  /// Reset season to initial state
  void resetSeason() {
    state.reset();
    state = GameState(); // Create fresh instance
  }

  /// Move to next season step
  void nextStep() {
    state.seasonStep++;
    state = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      activeLoan: state.activeLoan,
      tookLoanBlind: state.tookLoanBlind,
      tookLoanInformed: state.tookLoanInformed,
      registeredComplaintForProduct: state.registeredComplaintForProduct,
      personalDecisionType: state.personalDecisionType,
      leanPeriodEventType: state.leanPeriodEventType,
      leanPeriodActionType: state.leanPeriodActionType,
      sharedOTPWithFraud: state.sharedOTPWithFraud,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );
  }

  /// Handle personal decision (save/invest/spend)
  void makePersonalDecision(String decisionType, int amount) {
    final newState = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      activeLoan: state.activeLoan,
      personalDecisionType: decisionType,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );

    if (decisionType == 'save') {
      newState.savingsAmount = amount;
      newState.currentMoney -= amount;
      newState.stressLevel = (newState.stressLevel - 5).clamp(0, 100);
      newState.goodDecisions.add('Saved ₹$amount');
      newState.addEvent('Decided to save ₹$amount - stress reduced');
    } else if (decisionType == 'invest') {
      newState.investmentAmount = amount;
      newState.currentMoney -= amount;
      newState.addEvent('Decided to invest ₹$amount in farm');
    } else if (decisionType == 'spend') {
      newState.currentMoney -= amount;
      newState.stressLevel = (newState.stressLevel + 5).clamp(0, 100);
      newState.badDecisions.add('Spent ₹$amount on personal expenses');
      newState.addEvent('Decided to spend ₹$amount - stress increased');
    }

    state = newState;
  }

  /// Select farm investment quality (good vs cheap seeds)
  void selectFarmInvestment(bool isGoodQuality, int cost) {
    state.investmentQuality = isGoodQuality;
    state.investmentAmount = cost;
    state.currentMoney -= cost;
    state = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      activeLoan: state.activeLoan,
      tookLoanBlind: state.tookLoanBlind,
      tookLoanInformed: state.tookLoanInformed,
      personalDecisionType: state.personalDecisionType,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );
  }

  /// Handle faulty product decision
  void handleFaultyProduct(String action) {
    final newState = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      activeLoan: state.activeLoan,
      tookLoanBlind: state.tookLoanBlind,
      tookLoanInformed: state.tookLoanInformed,
      personalDecisionType: state.personalDecisionType,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );

    if (action == 'ignore') {
      newState.stressLevel = (newState.stressLevel + 15).clamp(0, 100);
      newState.badDecisions.add('Ignored faulty product complaint');
    } else if (action == 'fight') {
      newState.stressLevel = (newState.stressLevel + 10).clamp(0, 100);
      newState.currentMoney -= 2000; // Legal fees
      newState.badDecisions.add('Fought with seller, lost time and money');
    } else if (action == 'register') {
      newState.currentMoney += 5000; // Refund
      newState.stressLevel = (newState.stressLevel - 5).clamp(0, 100);
      newState.registeredComplaintForProduct = true;
      newState.goodDecisions.add('Registered consumer complaint and got refund');
    }

    state = newState;
  }

  /// Handle lean period event and action
  void handleLeanPeriod(String eventType, String actionType) {
    final newState = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      activeLoan: state.activeLoan,
      tookLoanBlind: state.tookLoanBlind,
      tookLoanInformed: state.tookLoanInformed,
      registeredComplaintForProduct: state.registeredComplaintForProduct,
      personalDecisionType: state.personalDecisionType,
      leanPeriodEventType: eventType,
      leanPeriodActionType: actionType,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );

    if (actionType == 'savings') {
      newState.currentMoney += newState.savingsAmount;
      newState.savingsAmount = 0;
      newState.stressLevel = (newState.stressLevel - 5).clamp(0, 100);
      newState.goodDecisions.add('Used savings to survive lean period');
    } else if (actionType == 'investment') {
      newState.currentMoney += newState.investmentAmount;
      newState.investmentAmount = 0;
      newState.stressLevel = (newState.stressLevel + 5).clamp(0, 100);
      newState.badDecisions.add('Broke investment early due to emergency');
    } else if (actionType == 'loan') {
      // Will be handled by loan providers
      newState.stressLevel = (newState.stressLevel + 10).clamp(0, 100);
    }

    state = newState;
  }

  /// Take a loan
  void takeLoan(LoanProduct product, int loanAmount, int numberOfSeasons, {bool blind = false}) {
    final newState = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      registeredComplaintForProduct: state.registeredComplaintForProduct,
      personalDecisionType: state.personalDecisionType,
      leanPeriodEventType: state.leanPeriodEventType,
      leanPeriodActionType: state.leanPeriodActionType,
      tookLoanBlind: blind ? true : state.tookLoanBlind,
      tookLoanInformed: !blind ? true : state.tookLoanInformed,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );

    newState.takeLoan(product, loanAmount, numberOfSeasons);
    state = newState;
  }

  /// Handle fraud OTP decision
  void handleFraudOTP(bool sharedOTP) {
    final newState = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      activeLoan: state.activeLoan,
      tookLoanBlind: state.tookLoanBlind,
      tookLoanInformed: state.tookLoanInformed,
      registeredComplaintForProduct: state.registeredComplaintForProduct,
      personalDecisionType: state.personalDecisionType,
      leanPeriodEventType: state.leanPeriodEventType,
      leanPeriodActionType: state.leanPeriodActionType,
      sharedOTPWithFraud: sharedOTP,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );

    if (sharedOTP) {
      newState.currentMoney -= 8000;
      newState.stressLevel = (newState.stressLevel + 25).clamp(0, 100);
      newState.badDecisions.add('Shared OTP and lost ₹8000 to fraud');
    } else {
      newState.stressLevel = (newState.stressLevel - 10).clamp(0, 100);
      newState.goodDecisions.add('Refused to share OTP - stayed safe');
    }

    state = newState;
  }

  /// Finalize harvest and calculate results
  void finalizeHarvest() {
    state.finalizeHarvest();
    state = GameState(
      currentMoney: state.currentMoney,
      stressLevel: state.stressLevel,
      seasonStep: state.seasonStep,
      savingsAmount: state.savingsAmount,
      investmentAmount: state.investmentAmount,
      investmentQuality: state.investmentQuality,
      investmentYield: state.investmentYield,
      activeLoan: state.activeLoan,
      tookLoanBlind: state.tookLoanBlind,
      tookLoanInformed: state.tookLoanInformed,
      registeredComplaintForProduct: state.registeredComplaintForProduct,
      personalDecisionType: state.personalDecisionType,
      leanPeriodEventType: state.leanPeriodEventType,
      leanPeriodActionType: state.leanPeriodActionType,
      sharedOTPWithFraud: state.sharedOTPWithFraud,
      harvestBaseYield: state.harvestBaseYield,
      harvestFinalMoney: state.harvestFinalMoney,
      harvestFinalStress: state.harvestFinalStress,
      harvestLoanRepaidAmount: state.harvestLoanRepaidAmount,
      eventHistory: List.from(state.eventHistory),
      moneyHistory: List.from(state.moneyHistory),
      stressHistory: List.from(state.stressHistory),
      goodDecisions: List.from(state.goodDecisions),
      badDecisions: List.from(state.badDecisions),
    );
  }
}

/// Provider for loan products
final loanProductsProvider = Provider<Map<LoanType, LoanProduct>>((ref) {
  return LoanProduct.predefined;
});

/// Provider for selected loan (if any)
final selectedLoanProvider = StateProvider<LoanType?>((ref) => null);
