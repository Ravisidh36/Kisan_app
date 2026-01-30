import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Large tappable decision button with icon and minimal text
class DecisionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;

  const DecisionCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DecisionCard> createState() => _DecisionCardState();
}

class _DecisionCardState extends State<DecisionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        await _controller.forward();
      },
      onTapUp: (_) async {
        await _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () async {
        await _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: widget.isSelected ? 12 : 4,
          color: widget.color.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: widget.isSelected ? Colors.white : Colors.transparent,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Money bar - thermometer style
class MoneyBar extends StatelessWidget {
  final int currentMoney;
  final int maxMoney;
  final String? label;

  const MoneyBar({
    Key? key,
    required this.currentMoney,
    this.maxMoney = 100000,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (currentMoney / maxMoney).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  minHeight: 20,
                  value: percentage,
                  backgroundColor: AppTheme.borderGrey,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_colorForPercentage(percentage)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: Text(
                '₹${currentMoney ~/ 1000}K',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _colorForPercentage(double percentage) {
    if (percentage < 0.2) return AppTheme.accentRed;
    if (percentage < 0.5) return AppTheme.accentOrange;
    return AppTheme.lightGreen;
  }
}

/// Stress meter - speedometer style
class StressMeter extends StatelessWidget {
  final int stressLevel; // 0-100
  final String? label;

  const StressMeter({
    Key? key,
    required this.stressLevel,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (stressLevel / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  minHeight: 20,
                  value: percentage,
                  backgroundColor: AppTheme.borderGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _colorForStress(stressLevel),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: Text(
                '$stressLevel%',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _colorForStress(int level) {
    if (level < 30) return AppTheme.lightGreen;
    if (level < 60) return AppTheme.accentOrange;
    return AppTheme.accentRed;
  }
}

/// Animated money change effect
class MoneyChangeAnimation extends StatefulWidget {
  final int amount;
  final bool isPositive;
  final VoidCallback onComplete;

  const MoneyChangeAnimation({
    Key? key,
    required this.amount,
    required this.isPositive,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<MoneyChangeAnimation> createState() => _MoneyChangeAnimationState();
}

class _MoneyChangeAnimationState extends State<MoneyChangeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Text(
          '${widget.isPositive ? '+' : '-'}₹${widget.amount}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.isPositive
                ? AppTheme.lightGreen
                : AppTheme.accentRed,
          ),
        ),
      ),
    );
  }
}

/// Simple loading indicator
class GameLoadingSpinner extends StatelessWidget {
  final String? message;

  const GameLoadingSpinner({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.primaryGreen,
            strokeWidth: 4,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.lightText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Game screen base container
class GameScreenContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? bottomBar;

  const GameScreenContainer({
    Key? key,
    required this.title,
    required this.child,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottomBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.green.shade100.withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: child,
                ),
              ),
              if (bottomBar != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: bottomBar!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
