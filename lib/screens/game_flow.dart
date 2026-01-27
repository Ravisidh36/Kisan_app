import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'phase1_personal_decision.dart';
import 'phase2_farm_investment.dart';
import 'phase3_faulty_product.dart';
import 'phase4_lean_period.dart';
import 'phase5_fraud_check.dart';
import 'phase6_harvest.dart';
import 'summary_screen.dart';
import 'profile_screen.dart';

class GameFlow extends StatefulWidget {
  const GameFlow({super.key});

  @override
  State<GameFlow> createState() => _GameFlowState();
}

class _GameFlowState extends State<GameFlow> {
  late GameState gameState;
  int currentPhase = 1;
  bool showProfile = false;

  @override
  void initState() {
    super.initState();
    gameState = GameState();
    gameState.addHistory('Game started');
  }

  void _handlePhase1Decision(String decision) {
    gameState.personalDecision = decision;
    
    // NO MONEY SHOULD CHANGE HERE - only set flags
    if (decision == 'save') {
      gameState.saved = true;
      gameState.stress -= 5; // Good decision → -5 stress
      if (gameState.stress < 0) gameState.stress = 0;
      gameState.goodDecisions.add('Saved ₹20,000');
      gameState.addHistory('Day 1: Decided to save ₹20,000 - stress -5');
    } else if (decision == 'invest') {
      gameState.invested = true;
      gameState.addHistory('Day 1: Decided to invest ₹20,000');
    } else if (decision == 'expense') {
      gameState.personalSpent = true;
      gameState.badDecisions.add('Spent ₹20,000 on personal expense');
      gameState.addHistory('Day 1: Decided to spend ₹20,000 on personal expense');
    }
    
    // Day progression: Phase 1 → Day 1
    gameState.day = 1;
    _moveToPhase(2);
  }

  void _handlePhase2Result(bool quality) {
    // DO NOT change money yet - only store result
    gameState.investmentQuality = quality;
    
    if (quality) {
      gameState.addHistory('Day 3: Bought quality farm supplies');
    } else {
      gameState.addHistory('Day 3: Bought faulty farm supplies');
    }
    
    // Day progression: Phase 2 → Day 3
    gameState.day = 3;
    
    if (!quality) {
      _moveToPhase(3);
    } else {
      // Generate lean period event when entering Phase 4
      if (gameState.leanPeriodEvent == null) {
        final events = ["hailstorm", "medical", "pesticide"];
        gameState.leanPeriodEvent = events[Random().nextInt(3)];
      }
      _moveToPhase(4);
    }
  }

  void _handlePhase3Action(String action) {
    gameState.faultyProductAction = action;
    
    // Stress rules: Complaint → -10 stress, others increase stress
    if (action == 'ignore') {
      gameState.stress += 20;
      gameState.badDecisions.add('Ignored faulty product');
      gameState.addHistory('Day 5: Ignored faulty product - stress +20');
    } else if (action == 'fight') {
      gameState.stress += 25;
      gameState.badDecisions.add('Fought angrily');
      gameState.addHistory('Day 5: Fought angrily - stress +25');
    } else if (action == 'complaint') {
      gameState.stress -= 10;
      if (gameState.stress < 0) gameState.stress = 0;
      gameState.goodDecisions.add('Registered complaint');
      gameState.addHistory('Day 5: Registered complaint - stress -10');
    }
    
    // Day progression: Phase 3 → Day 5
    gameState.day = 5;
    // Generate lean period event when entering Phase 4
    if (gameState.leanPeriodEvent == null) {
      final events = ["hailstorm", "medical", "pesticide"];
      gameState.leanPeriodEvent = events[Random().nextInt(3)];
    }
    _moveToPhase(4);
  }

  void _handlePhase4Action(String event, String action) {
    gameState.leanPeriodEvent = event;
    gameState.leanPeriodAction = action;
    
    // DO NOT change money here - only set flags
    if (event == 'hailstorm' && action == 'subsidy') {
      gameState.subsidyApplied = true;
      gameState.stress -= 5; // Good decision → -5 stress
      if (gameState.stress < 0) gameState.stress = 0;
      gameState.goodDecisions.add('Applied for subsidy');
      gameState.addHistory('Day 7: Applied for subsidy (₹10,000 will be added at harvest) - stress -5');
    } else if (action == 'loan') {
      gameState.tookLoan = true;
      gameState.loanAmount = 20000;
      gameState.stress += 20; // Loan → +20 stress (instant update)
      gameState.badDecisions.add('Took loan of ₹20,000');
      gameState.addHistory('Day 7: Took loan of ₹20,000 - stress +20');
    } else if (action == 'savings') {
      if (gameState.saved) {
        gameState.savingsUsed = true;
        gameState.stress -= 5; // Good decision → -5 stress
        if (gameState.stress < 0) gameState.stress = 0;
        gameState.goodDecisions.add('Used savings');
        gameState.addHistory('Day 7: Used savings (₹20,000 will be available at harvest) - stress -5');
      } else {
        gameState.badDecisions.add('No savings available');
        gameState.addHistory('Day 7: Tried to use savings but had none');
      }
    } else if (action == 'withdraw') {
      if (gameState.invested) {
        gameState.investmentWithdrawn = true;
        // Withdraw investment - profit/loss will be calculated at harvest
        gameState.addHistory('Day 7: Withdrew investment (returns calculated at harvest)');
      }
    }
    
    // Stress increase for medical/pesticide emergencies
    if (event == 'medical' || event == 'pesticide') {
      gameState.stress += 20;
      gameState.addHistory('Day 7: Emergency situation - stress +20');
    }
    
    // Day progression: Phase 4 → Day 7
    gameState.day = 7;
    _moveToPhase(5);
  }

  void _handlePhase5Action(bool sharedOTP) {
    gameState.fraudAction = sharedOTP;
    
    // DO NOT DEDUCT MONEY HERE - only set flag
    if (sharedOTP) {
      gameState.fraudPending = true;
      gameState.stress += 30; // Fraud → +30 stress (instant update)
      gameState.badDecisions.add('Shared OTP - fraud pending');
      gameState.addHistory('Day 9: Shared OTP - fraud detected, stress +30');
    } else {
      gameState.stress -= 5; // Good decision → -5 stress
      if (gameState.stress < 0) gameState.stress = 0;
      gameState.goodDecisions.add('Avoided fraud');
      gameState.addHistory('Day 9: Ignored suspicious message - avoided fraud - stress -5');
    }
    
    // Day progression: Phase 5 → Day 9
    gameState.day = 9;
    _moveToPhase(6);
  }

  void _handlePhase6Complete() {
    // Day progression: Phase 6 → Day 15 (Harvest Day)
    gameState.day = 15;
    
    // HARVEST PHASE: ONLY PLACE WHERE MONEY CHANGES
    // Apply all effects TOGETHER
    
    int moneyChange = 0;
    int baseHarvest = 50000;
    
    // 1. IF fraudPending → money = 0
    if (gameState.fraudPending) {
      gameState.money = 0;
      gameState.addHistory('Day 15: Fraud impact - All money lost!');
      gameState.harvestAmount = 0;
      _moveToPhase(7);
      return;
    }
    
    // 2. IF invested AND NOT withdrawn: profit → +22000, loss → +18000
    if (gameState.invested && !gameState.investmentWithdrawn) {
      if (gameState.investmentQuality == true) {
        // Profit: +22000
        moneyChange += 22000;
        gameState.addHistory('Day 15: Investment profit - +₹22,000');
      } else {
        // Loss: +18000
        moneyChange += 18000;
        gameState.addHistory('Day 15: Investment loss - +₹18,000');
      }
    } else if (gameState.investmentWithdrawn) {
      // Early withdrawal: partial return based on quality
      if (gameState.investmentQuality == true) {
        moneyChange += 15000; // Early withdrawal with profit
        gameState.addHistory('Day 15: Early investment withdrawal - +₹15,000');
      } else {
        moneyChange += 12000; // Early withdrawal with loss
        gameState.addHistory('Day 15: Early investment withdrawal - +₹12,000');
      }
    }
    
    // 3. IF subsidyApplied → +10000
    if (gameState.subsidyApplied) {
      moneyChange += 10000;
      gameState.addHistory('Day 15: Subsidy received - +₹10,000');
    }
    
    // 4. IF savingsUsed → +20000 (savings available for use)
    if (gameState.savingsUsed) {
      moneyChange += 20000;
      gameState.addHistory('Day 15: Savings used - +₹20,000');
    }
    
    // Base harvest
    int harvest = baseHarvest + moneyChange;
    gameState.harvestAmount = harvest;
    gameState.money += harvest;
    gameState.addHistory('Day 15: Harvest complete - Total: ₹$harvest');
    
    // 5. IF loanTaken: Deduct loan + 10% interest
    if (gameState.tookLoan) {
      int totalLoan = gameState.loanAmount + (gameState.loanAmount * gameState.loanInterest ~/ 100);
      gameState.money -= totalLoan;
      gameState.addHistory('Day 15: Loan repaid with interest - ₹$totalLoan deducted');
    }
    
    _moveToPhase(7);
  }

  void _moveToPhase(int phase) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          currentPhase = phase;
        });
      }
    });
  }

  void _restartGame() {
    setState(() {
      gameState.reset();
      currentPhase = 1;
      showProfile = false;
    });
  }

  void _toggleProfile() {
    setState(() {
      showProfile = !showProfile;
    });
  }

  Widget _buildPhaseScreen() {
    switch (currentPhase) {
      case 1:
        return Phase1PersonalDecision(
          gameState: gameState,
          onDecision: _handlePhase1Decision,
        );
      case 2:
        return Phase2FarmInvestment(
          gameState: gameState,
          onResult: _handlePhase2Result,
        );
      case 3:
        return Phase3FaultyProduct(
          gameState: gameState,
          onAction: _handlePhase3Action,
        );
      case 4:
        return Phase4LeanPeriod(
          gameState: gameState,
          onAction: _handlePhase4Action,
        );
      case 5:
        return Phase5FraudCheck(
          gameState: gameState,
          onAction: _handlePhase5Action,
        );
      case 6:
        return Phase6Harvest(
          gameState: gameState,
          onComplete: _handlePhase6Complete,
        );
      case 7:
        return SummaryScreen(
          gameState: gameState,
          onPlayAgain: _restartGame,
        );
      default:
        return Phase1PersonalDecision(
          gameState: gameState,
          onDecision: _handlePhase1Decision,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showProfile) {
      return ProfileScreen(
        gameState: gameState,
        onClose: _toggleProfile,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildPhaseScreen(),
          // Profile button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: _toggleProfile,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
