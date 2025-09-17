import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isEnabled;
  final IconData? icon;
  final Duration animationDuration;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isEnabled = true,
    this.icon,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: AnimatedContainer(
                duration: widget.animationDuration,
                width: widget.width,
                height: widget.height ?? 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: widget.isEnabled
                      ? LinearGradient(
                          colors: [
                            widget.backgroundColor ?? AppColors.primary,
                            (widget.backgroundColor ?? AppColors.primary)
                                .withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.isEnabled
                      ? null
                      : Colors.grey[400],
                  boxShadow: widget.isEnabled && !_isPressed
                      ? [
                          BoxShadow(
                            color: (widget.backgroundColor ?? AppColors.primary)
                                .withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        AnimatedRotation(
                          turns: _isPressed ? 0.1 : 0.0,
                          duration: widget.animationDuration,
                          child: Icon(
                            widget.icon,
                            size: 24,
                            color: widget.textColor ?? Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      AnimatedDefaultTextStyle(
                        duration: widget.animationDuration,
                        style: TextStyle(
                          fontSize: _isPressed ? 17 : 18,
                          fontWeight: FontWeight.bold,
                          color: widget.textColor ?? Colors.white,
                          fontFamily: 'ComicNeue',
                        ),
                        child: Text(widget.text),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget untuk tombol dengan efek bounce
class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;

  const BounceButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
