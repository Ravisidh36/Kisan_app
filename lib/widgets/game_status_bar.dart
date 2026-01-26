import 'package:flutter/material.dart';
import 'dart:math' as math;

class GameStatusBar extends StatelessWidget {
  final int money;
  final int stress;
  final int day;

  const GameStatusBar({
    super.key,
    required this.money,
    required this.stress,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Money Bar
          _buildMoneyBar(),
          const SizedBox(height: 12),
          // Stress Meter and Day Counter Row
          Row(
            children: [
              Expanded(
                child: _buildStressMeter(),
              ),
              const SizedBox(width: 16),
              _buildDayCounter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyBar() {
    const int maxMoney = 100000;
    final double progress = (money / maxMoney).clamp(0.0, 1.0);
    
    Color barColor;
    if (progress <= 0.3) {
      barColor = Colors.red;
    } else if (progress <= 0.6) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Money',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Text(
              '₹${money.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            // Create gradient colors based on progress
            List<Color> gradientColors;
            if (value <= 0.3) {
              gradientColors = [Colors.red.shade400, Colors.red.shade600];
            } else if (value <= 0.6) {
              gradientColors = [Colors.orange.shade400, Colors.orange.shade600];
            } else {
              gradientColors = [Colors.green.shade400, Colors.green.shade600];
            }

            return Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Background
                    Container(
                      color: Colors.grey.shade200,
                    ),
                    // Progress with gradient
                    FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStressMeter() {
    final double stressValue = stress.clamp(0, 100).toDouble();
    final double angle = (stressValue / 100) * math.pi; // 0 to 180 degrees

    Color stressColor;
    if (stressValue <= 40) {
      stressColor = Colors.green;
    } else if (stressValue <= 70) {
      stressColor = Colors.yellow;
    } else {
      stressColor = Colors.red;
    }

    return Column(
      children: [
        const Text(
          'Stress',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          width: 80,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: angle),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, animatedAngle, child) {
              return CustomPaint(
                painter: StressMeterPainter(
                  value: stressValue,
                  angle: animatedAngle,
                  color: stressColor,
                ),
                child: Center(
                  child: Text(
                    '${stressValue.toInt()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: stressColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayCounter() {
    return Column(
      children: [
        const Text(
          'Day',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '📅',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Day $day',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StressMeterPainter extends CustomPainter {
  final double value;
  final double angle;
  final Color color;

  StressMeterPainter({
    required this.value,
    required this.angle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final Paint valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final Paint needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw background arc (semicircle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left (180 degrees)
      math.pi, // Draw 180 degrees (semicircle)
      false,
      backgroundPaint,
    );

    // Draw value arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left
      angle, // Draw based on stress value
      false,
      valuePaint,
    );

    // Draw needle
    final needleLength = radius - 5;
    final needleEndX = center.dx + needleLength * math.cos(math.pi + angle);
    final needleEndY = center.dy + needleLength * math.sin(math.pi + angle);

    canvas.drawLine(
      center,
      Offset(needleEndX, needleEndY),
      needlePaint,
    );

    // Draw center dot
    canvas.drawCircle(center, 4, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(StressMeterPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.angle != angle || oldDelegate.color != color;
  }
}
