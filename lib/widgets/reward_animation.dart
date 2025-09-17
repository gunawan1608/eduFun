import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';

class RewardAnimation extends StatefulWidget {
  final bool show;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onComplete;

  const RewardAnimation({
    super.key,
    required this.show,
    required this.message,
    this.icon = Icons.star,
    this.color = AppColors.gold,
    this.onComplete,
  });

  @override
  State<RewardAnimation> createState() => _RewardAnimationState();
}

class _RewardAnimationState extends State<RewardAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _confettiController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));
  }

  @override
  void didUpdateWidget(RewardAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _startAnimation();
    } else if (!widget.show && oldWidget.show) {
      _resetAnimation();
    }
  }

  void _startAnimation() {
    _scaleController.forward();
    _rotationController.repeat();
    _confettiController.forward();
    
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _resetAnimation();
        widget.onComplete?.call();
      }
    });
  }

  void _resetAnimation() {
    _scaleController.reset();
    _rotationController.reset();
    _confettiController.reset();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Stack(
          children: [
            // Confetti background
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(_confettiController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main reward content
            Center(
              child: AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.color.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.icon,
                                  size: 80,
                                  color: widget.color,
                                ),
                                const SizedBox(height: 16),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    widget.message,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: widget.color,
                                      fontFamily: 'ComicNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;
  final List<ConfettiParticle> particles = [];

  ConfettiPainter(this.animationValue) {
    // Generate confetti particles
    for (int i = 0; i < 50; i++) {
      particles.add(ConfettiParticle());
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(animationValue, size);
      particle.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ConfettiParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late Color color;
  late double size;
  late double rotation;
  late double rotationSpeed;

  ConfettiParticle() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = -0.1;
    vx = (math.Random().nextDouble() - 0.5) * 0.02;
    vy = math.Random().nextDouble() * 0.01 + 0.01;
    color = [
      AppColors.gold,
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.red,
      Colors.blue,
      Colors.green,
    ][math.Random().nextInt(7)];
    size = math.Random().nextDouble() * 8 + 4;
    rotation = 0;
    rotationSpeed = (math.Random().nextDouble() - 0.5) * 0.2;
  }

  void update(double animationValue, Size size) {
    if (animationValue == 0) {
      reset();
      return;
    }

    x += vx;
    y += vy;
    rotation += rotationSpeed;

    // Reset if particle goes off screen
    if (y > 1.1 || x < -0.1 || x > 1.1) {
      reset();
    }
  }

  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(x * canvasSize.width, y * canvasSize.height);
    canvas.rotate(rotation);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size, height: size),
      paint,
    );
    canvas.restore();
  }
}

// Widget untuk animasi bintang yang muncul
class StarAnimation extends StatefulWidget {
  final bool show;
  final int count;
  final Duration duration;

  const StarAnimation({
    super.key,
    required this.show,
    this.count = 5,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<StarAnimation> createState() => _StarAnimationState();
}

class _StarAnimationState extends State<StarAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Offset>> _positionAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = [];
    _scaleAnimations = [];
    _positionAnimations = [];

    for (int i = 0; i < widget.count; i++) {
      final controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      );

      final scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          i * 0.1,
          0.5 + i * 0.1,
          curve: Curves.elasticOut,
        ),
      ));

      final angle = (i / widget.count) * 2 * math.pi;
      final radius = 100.0;
      final endX = math.cos(angle) * radius;
      final endY = math.sin(angle) * radius;

      final positionAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(endX, endY),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));

      _controllers.add(controller);
      _scaleAnimations.add(scaleAnimation);
      _positionAnimations.add(positionAnimation);
    }
  }

  @override
  void didUpdateWidget(StarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      for (var controller in _controllers) {
        controller.forward();
      }
    } else if (!widget.show && oldWidget.show) {
      for (var controller in _controllers) {
        controller.reset();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return Stack(
      children: List.generate(widget.count, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: _positionAnimations[index].value,
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: const Icon(
                  Icons.star,
                  color: AppColors.gold,
                  size: 30,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
