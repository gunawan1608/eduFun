import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/custom_button.dart';
import '../models/materi.dart';
import 'quiz_screen.dart';

class MateriScreen extends StatefulWidget {
  final Materi materi;

  const MateriScreen({super.key, required this.materi});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _getSubjectColor(widget.materi.mapel),
        title: Text(
          widget.materi.judul,
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildContent(),
                    const SizedBox(height: 30),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getSubjectColor(widget.materi.mapel),
            _getSubjectColor(widget.materi.mapel).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getSubjectColor(widget.materi.mapel).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getSubjectIcon(widget.materi.mapel),
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            widget.materi.judul,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              widget.materi.mapel,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'ComicNeue',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: AppColors.accent,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Mari Belajar!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Placeholder untuk gambar materi
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: _getSubjectColor(widget.materi.mapel).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _getSubjectColor(widget.materi.mapel).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 60,
                  color: _getSubjectColor(widget.materi.mapel).withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gambar Materi',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getSubjectColor(widget.materi.mapel).withOpacity(0.7),
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            widget.materi.konten,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontFamily: 'ComicNeue',
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tips belajar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Baca dengan perlahan dan pahami setiap bagian ya!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontFamily: 'ComicNeue',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: 'Latihan Soal',
          icon: Icons.quiz,
          backgroundColor: _getSubjectColor(widget.materi.mapel),
          width: double.infinity,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  materi: widget.materi,
                  tingkatKesulitan: 'mudah',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: AppStrings.kembali,
          icon: Icons.arrow_back,
          backgroundColor: AppColors.textSecondary,
          width: double.infinity,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Color _getSubjectColor(String mapel) {
    switch (mapel.toLowerCase()) {
      case 'bahasa indonesia':
        return AppColors.bahasaIndonesia;
      case 'matematika':
        return AppColors.matematika;
      case 'ipas':
        return AppColors.ipas;
      case 'pancasila':
        return AppColors.pancasila;
      default:
        return AppColors.primary;
    }
  }

  IconData _getSubjectIcon(String mapel) {
    switch (mapel.toLowerCase()) {
      case 'bahasa indonesia':
        return Icons.book;
      case 'matematika':
        return Icons.calculate;
      case 'ipas':
        return Icons.science;
      case 'pancasila':
        return Icons.favorite;
      default:
        return Icons.school;
    }
  }
}
