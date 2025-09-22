import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BackgroundDecoration extends StatelessWidget {
  final Widget child;
  
  const BackgroundDecoration({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background illustrations
          Positioned(
            top: -50,
            right: -50,
            child: _buildCloud(100, AppColors.secondary.withOpacity(0.1)),
          ),
          Positioned(
            top: 150,
            left: -30,
            child: _buildCloud(80, AppColors.accent.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 200,
            right: -40,
            child: _buildCloud(120, AppColors.primary.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -30,
            left: 20,
            child: _buildStar(30, AppColors.gold.withOpacity(0.2)),
          ),
          Positioned(
            bottom: 100,
            left: 100,
            child: _buildStar(20, AppColors.accent.withOpacity(0.3)),
          ),
          Positioned(
            top: 300,
            right: 30,
            child: _buildStar(25, AppColors.primary.withOpacity(0.2)),
          ),
          // Main content
          child,
        ],
      ),
    );
  }

  Widget _buildCloud(double size, Color color) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
    );
  }

  Widget _buildStar(double size, Color color) {
    return Icon(
      Icons.star,
      size: size,
      color: color,
    );
  }
}
