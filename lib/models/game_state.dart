class GameState {
  int money;
  int stress; // 0–100
  int day; // Day counter

  // Decisions
  bool invested;
  bool saved;
  bool personalSpent; // Personal expense decision

  // Loan
  bool tookLoan;
  int loanAmount;
  int loanInterest;

  // Flow tracking
  String currentPhase;
  String? personalDecision;
  bool? investmentQuality;
  String? faultyProductAction;
  String? leanPeriodEvent;
  String? leanPeriodAction;
  bool? fraudAction;
  bool fraudPending; // Fraud will impact in next phase
  bool subsidyApplied; // Subsidy applied for hailstorm
  bool savingsUsed; // Savings used during lean period
  bool investmentWithdrawn; // Investment withdrawn early

  // Outcome
  int harvestAmount;

  // History tracking
  List<String> eventHistory;
  List<int> moneyHistory;
  List<int> stressHistory;
  List<String> goodDecisions;
  List<String> badDecisions;

  GameState({
    this.money = 50000,
    this.stress = 0,
    this.day = 1,
    this.invested = false,
    this.saved = false,
    this.personalSpent = false,
    this.tookLoan = false,
    this.loanAmount = 0,
    this.loanInterest = 10,
    this.currentPhase = 'home',
    this.personalDecision,
    this.investmentQuality,
    this.faultyProductAction,
    this.leanPeriodEvent,
    this.leanPeriodAction,
    this.fraudAction,
    this.fraudPending = false,
    this.subsidyApplied = false,
    this.savingsUsed = false,
    this.investmentWithdrawn = false,
    this.harvestAmount = 0,
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

  void reset() {
    money = 50000;
    stress = 0;
    day = 1;
    invested = false;
    saved = false;
    personalSpent = false;
    tookLoan = false;
    loanAmount = 0;
    loanInterest = 10;
    currentPhase = 'home';
    personalDecision = null;
    investmentQuality = null;
    faultyProductAction = null;
    leanPeriodEvent = null;
    leanPeriodAction = null;
    fraudAction = null;
    fraudPending = false;
    subsidyApplied = false;
    savingsUsed = false;
    investmentWithdrawn = false;
    harvestAmount = 0;
    eventHistory.clear();
    moneyHistory.clear();
    moneyHistory.add(50000);
    stressHistory.clear();
    stressHistory.add(0);
    goodDecisions.clear();
    badDecisions.clear();
  }

  void addHistory(String event) {
    eventHistory.add('Day $day: $event');
    moneyHistory.add(money);
    stressHistory.add(stress);
  }

  void incrementDay() {
    day++;
  }

  GameState copyWith({
    int? money,
    int? stress,
    int? day,
    bool? invested,
    bool? saved,
    bool? personalSpent,
    bool? tookLoan,
    int? loanAmount,
    int? loanInterest,
    String? currentPhase,
    String? personalDecision,
    bool? investmentQuality,
    String? faultyProductAction,
    String? leanPeriodEvent,
    String? leanPeriodAction,
    bool? fraudAction,
    bool? fraudPending,
    bool? subsidyApplied,
    bool? savingsUsed,
    bool? investmentWithdrawn,
    int? harvestAmount,
  }) {
    return GameState(
      money: money ?? this.money,
      stress: stress ?? this.stress,
      day: day ?? this.day,
      invested: invested ?? this.invested,
      saved: saved ?? this.saved,
      personalSpent: personalSpent ?? this.personalSpent,
      tookLoan: tookLoan ?? this.tookLoan,
      loanAmount: loanAmount ?? this.loanAmount,
      loanInterest: loanInterest ?? this.loanInterest,
      currentPhase: currentPhase ?? this.currentPhase,
      personalDecision: personalDecision ?? this.personalDecision,
      investmentQuality: investmentQuality ?? this.investmentQuality,
      faultyProductAction:
          faultyProductAction ?? this.faultyProductAction,
      leanPeriodEvent: leanPeriodEvent ?? this.leanPeriodEvent,
      leanPeriodAction: leanPeriodAction ?? this.leanPeriodAction,
      fraudAction: fraudAction ?? this.fraudAction,
      fraudPending: fraudPending ?? this.fraudPending,
      subsidyApplied: subsidyApplied ?? this.subsidyApplied,
      savingsUsed: savingsUsed ?? this.savingsUsed,
      investmentWithdrawn: investmentWithdrawn ?? this.investmentWithdrawn,
      harvestAmount: harvestAmount ?? this.harvestAmount,
      goodDecisions: List.from(goodDecisions),
      badDecisions: List.from(badDecisions),
    );
  }
}
