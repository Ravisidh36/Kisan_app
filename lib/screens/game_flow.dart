import 'package:flutter/material.dart';
import 'dart:math';
import '../models/game_state.dart';
import '../utils/language.dart';
import '../widgets/game_status_bar.dart';
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
    
    if (decision == 'save') {
      gameState.saved = true;
      // Savings: Money is already owned, just mark as saved (no deduction)
      gameState.goodDecisions.add('Saved ₹20,000');
      gameState.addHistory('Saved ₹20,000 (money still available)');
    } else if (decision == 'invest') {
      gameState.invested = true;
      gameState.money -= 20000; // Investment: money temporarily removed
      gameState.addHistory('Invested ₹20,000 in farm');
    } else {
      gameState.spent = true;
      gameState.money -= 20000; // Personal expense: money spent
      gameState.badDecisions.add('Spent ₹20,000 on personal expense');
      gameState.addHistory('Spent ₹20,000 on personal expense');
    }
    
    // Day progression: Phase 1 → Day 1, Phase 2 → Day 3
    gameState.day = 1;
    gameState.addHistory('Day 1 completed');
    _moveToPhase(2);
  }

  void _handlePhase2Result(bool quality) {
    gameState.investmentQuality = quality;
    gameState.money -= 30000; // Farm investment: ₹30,000
    
    if (quality) {
      gameState.addHistory('Bought quality farm supplies - ₹30,000');
    } else {
      gameState.addHistory('Bought faulty farm supplies - ₹30,000');
    }
    
    // Day progression: Phase 2 → Day 3
    gameState.day = 3;
    gameState.addHistory('Day 3: Farm investment made');
    
    if (!quality) {
      _moveToPhase(3);
    } else {
      _moveToPhase(4);
    }
  }

  void _handlePhase3Action(String action) {
    gameState.faultyProductAction = action;
    
    if (action == 'ignore') {
      gameState.stress += 20;
      gameState.badDecisions.add('Ignored faulty product');
      gameState.addHistory('Ignored faulty product - stress +20');
    } else if (action == 'fight') {
      gameState.stress += 25;
      gameState.badDecisions.add('Fought angrily');
      gameState.addHistory('Fought angrily - stress +25');
    } else {
      gameState.stress -= 10;
      if (gameState.stress < 0) gameState.stress = 0;
      gameState.goodDecisions.add('Registered complaint');
      gameState.addHistory('Registered complaint - product replaced, stress -10');
    }
    
    // Day progression: Phase 3 → Day 5
    gameState.day = 5;
    gameState.addHistory('Day 5: Product issue resolved');
    _moveToPhase(4);
  }

  void _handlePhase4Action(String event, String action) {
    gameState.leanPeriodEvent = event;
    gameState.leanPeriodAction = action;
    
    if (event == 'hailstorm' && action == 'subsidy') {
      gameState.money += 10000; // Subsidy adds money
      gameState.goodDecisions.add('Applied for subsidy');
      gameState.addHistory('Applied for subsidy - received ₹10,000');
    } else if (action == 'loan') {
      gameState.tookLoan = true;
      gameState.loanAmount = 20000;
      gameState.money += 20000; // Loan adds money
      gameState.stress += 15; // Loan increases stress
      gameState.badDecisions.add('Took loan of ₹20,000');
      gameState.addHistory('Took loan of ₹20,000 - stress +15');
    } else if (action == 'savings') {
      if (gameState.saved) {
        // Using savings: spending the saved money
        gameState.money -= 20000;
        gameState.goodDecisions.add('Used savings');
        gameState.addHistory('Used savings - spent ₹20,000');
      } else {
        gameState.badDecisions.add('No savings available');
        gameState.addHistory('Tried to use savings but had none');
      }
    } else if (action == 'withdraw') {
      if (gameState.invested) {
        gameState.money += 15000; // Early withdrawal: partial return
        gameState.badDecisions.add('Withdrew investment early');
        gameState.addHistory('Withdrew investment early - got ₹15,000');
      }
    }
    
    // Stress increase for medical/pesticide emergencies
    if (event == 'medical' || event == 'pesticide') {
      gameState.stress += 20;
      gameState.addHistory('Emergency situation - stress +20');
    }
    
    // Day progression: Phase 4 → Day 7
    gameState.day = 7;
    gameState.addHistory('Day 7: Emergency handled');
    _moveToPhase(5);
  }

  void _handlePhase5Action(bool sharedOTP) {
    gameState.fraudAction = sharedOTP;
    
    if (sharedOTP) {
      gameState.fraudPending = true;
      gameState.stress += 30; // Fraud increases stress significantly
      gameState.badDecisions.add('Shared OTP - fraud pending');
      gameState.addHistory('Shared OTP - fraud detected, stress +30');
    } else {
      gameState.goodDecisions.add('Avoided fraud');
      gameState.addHistory('Ignored suspicious message - avoided fraud');
    }
    
    // Day progression: Phase 5 → Day 9
    gameState.day = 9;
    gameState.addHistory('Day 9: Security check completed');
    _moveToPhase(6);
  }

  void _handlePhase6Complete() {
    // Day progression: Phase 6 → Day 15 (Harvest Day)
    gameState.day = 15;
    
    // Apply pending fraud if any (delayed impact)
    if (gameState.fraudPending) {
      gameState.money = 0;
      gameState.addHistory('Day 15: Fraud impact - All money lost!');
    }
    
    // Calculate harvest based on investment quality and stress
    int harvest = 0;
    int baseHarvest = 50000;
    
    // If invested, calculate return based on quality
    if (gameState.invested) {
      if (gameState.investmentQuality == true) {
        // Good quality: profit
        harvest = baseHarvest + 22000; // ₹20,000 investment + ₹2,000 profit
        gameState.addHistory('Day 15: Good harvest from quality investment - ₹$harvest');
      } else {
        // Faulty product: check how it was handled
        if (gameState.faultyProductAction == 'complaint') {
          harvest = baseHarvest + 18000; // ₹20,000 - ₹2,000 loss (complaint helped)
          gameState.addHistory('Day 15: Harvest with complaint resolution - ₹$harvest');
        } else {
          harvest = baseHarvest + 15000; // ₹20,000 - ₹5,000 loss (ignored/fought)
          gameState.addHistory('Day 15: Poor harvest due to faulty product - ₹$harvest');
        }
      }
    } else {
      // No investment: base harvest only
      harvest = baseHarvest;
      gameState.addHistory('Day 15: Basic harvest - ₹$harvest');
    }
    
    // Stress affects harvest (high stress = lower yield)
    if (gameState.stress >= 70) {
      harvest = (harvest * 0.9).round(); // 10% reduction
      gameState.addHistory('High stress reduced harvest by 10%');
    } else if (gameState.stress < 50) {
      harvest = (harvest * 1.1).round(); // 10% bonus
      gameState.addHistory('Low stress increased harvest by 10%');
    }
    
    gameState.harvestAmount = harvest;
    gameState.money += harvest;
    
    // Deduct loan if taken (with interest)
    if (gameState.tookLoan) {
      int totalLoan = gameState.loanAmount + (gameState.loanAmount * gameState.loanInterest ~/ 100);
      gameState.money -= totalLoan;
      gameState.addHistory('Loan repaid with interest - ₹$totalLoan deducted');
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
