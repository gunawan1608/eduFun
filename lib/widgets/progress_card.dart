import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProgressCard extends StatefulWidget {
  final String title;
  final int currentProgress;
  final int totalProgress;
  final Color color;
  final IconData icon;
  final String subtitle;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.title,
    required this.currentProgress,
    required this.totalProgress,
    required this.color,
    required this.icon,
    this.subtitle = '',
    this.onTap,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentProgress / widget.totalProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentProgress != oldWidget.currentProgress ||
        widget.totalProgress != oldWidget.totalProgress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.currentProgress / widget.totalProgress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.currentProgress / widget.totalProgress * 100).round();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: 8,
            shadowColor: widget.color.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withOpacity(0.1),
                      widget.color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: percentage >= 100 
                                ? AppColors.success 
                                : widget.color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (percentage >= 100)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              if (percentage >= 100)
                                const SizedBox(width: 4),
                              Text(
                                percentage >= 100 ? 'Selesai' : '$percentage%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    if (widget.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    
                    // Progress Bar dengan animasi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.color,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                            Text(
                              '${widget.currentProgress}/${widget.totalProgress}',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.color,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                              minHeight: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircularProgressCard extends StatefulWidget {
  final String title;
  final double progress; // 0.0 to 1.0
  final Color color;
  final IconData icon;
  final String centerText;
  final double size;

  const CircularProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.color,
    required this.icon,
    this.centerText = '',
    this.size = 120,
  });

  @override
  State<CircularProgressCard> createState() => _CircularProgressCardState();
}

class _CircularProgressCardState extends State<CircularProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(CircularProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'ComicNeue',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Stack(
                    children: [
                      // Background circle
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[300]!,
                        ),
                      ),
                      // Progress circle
                      CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 8,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                      // Center content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.icon,
                              color: widget.color,
                              size: 30,
                            ),
                            if (widget.centerText.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.centerText,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: widget.color,
                                  fontFamily: 'ComicNeue',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
