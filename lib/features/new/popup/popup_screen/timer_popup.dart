import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:freshbite/core/appbar/custom_appbar.dart';


class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int totalSeconds = 300; // 5 minutes default
  int remainingSeconds = 300;
  bool isRunning = false;
  bool isCompleted = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (remainingSeconds > 0) {
      setState(() {
        isRunning = true;
        isCompleted = false;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            isRunning = false;
            isCompleted = true;
            timer.cancel();
          }
        });
      });
    }
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
    });
    _timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      isCompleted = false;
      remainingSeconds = totalSeconds;
    });
    _timer?.cancel();
  }

  void restartTimer() {
    setState(() {
      isCompleted = false;
      remainingSeconds = totalSeconds;
    });
    startTimer();
  }

  void adjustTime(int seconds) {
    if (!isRunning) {
      setState(() {
        totalSeconds = math.max(60, totalSeconds + seconds);
        remainingSeconds = totalSeconds;
      });
    }
  }

  String formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  double get progress {
    if (totalSeconds == 0) return 0;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Instructions',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,

          ),
        ),
      ),
      body: Column(
        children: [
          // Timer Tab
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Timer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 3,
                  width: 60,
                  color: const Color(0xFF2D4A2D),
                ),
              ],
            ),
          ),

          // Timer Content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Timer Circle
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Progress Circle
                          CustomPaint(
                            size: const Size(280, 280),
                            painter: CircularProgressPainter(
                              progress: progress,
                              backgroundColor: Colors.grey[200]!,
                              progressColor: const Color(0xFF2D4A2D),
                            ),
                          ),
                          // Center Content
                          if (isCompleted)
                            const Icon(
                              Icons.notifications_outlined,
                              size: 80,
                              color: Color(0xFF2D4A2D),
                            )
                          else
                            Text(
                              formatTime(remainingSeconds),
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minus Button
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: isRunning ? null : () => adjustTime(-60),
                            iconSize: 20,
                          ),
                        ),

                        const SizedBox(width: 24),

                        // Play/Pause Button
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2D4A2D),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isRunning ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (isRunning) {
                                pauseTimer();
                              } else if (isCompleted) {
                                restartTimer();
                              } else {
                                startTimer();
                              }
                            },
                            iconSize: 28,
                          ),
                        ),

                        const SizedBox(width: 24),

                        // Plus Button
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: isRunning ? null : () => adjustTime(60),
                            iconSize: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Action Buttons
                    if (!isCompleted) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isRunning ? pauseTimer : startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D4A2D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isRunning ? 'PAUSE' : 'START',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: resetTimer,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF2D4A2D),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'RESET',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D4A2D),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: restartTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D4A2D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'RESTART',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: resetTimer,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF2D4A2D),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'RESET',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D4A2D),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}