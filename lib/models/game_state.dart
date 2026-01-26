class GameState {
  int money;
  int stress; // 0–100
  int day; // Day counter

  // Decisions
  bool invested;
  bool saved;
  bool spent;

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
    this.spent = false,
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
    spent = false;
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
    bool? spent,
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
    int? harvestAmount,
  }) {
    return GameState(
      money: money ?? this.money,
      stress: stress ?? this.stress,
      day: day ?? this.day,
      invested: invested ?? this.invested,
      saved: saved ?? this.saved,
      spent: spent ?? this.spent,
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
      harvestAmount: harvestAmount ?? this.harvestAmount,
      goodDecisions: List.from(goodDecisions),
      badDecisions: List.from(badDecisions),
    );
  }
}
