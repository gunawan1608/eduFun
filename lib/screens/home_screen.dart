import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/subject_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/background_decoration.dart';
import 'subject_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundDecoration(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 30),
                
                // Greeting
                _buildGreeting(),
                const SizedBox(height: 30),
                
                // Subject Cards
                _buildSubjectGrid(context),
                const SizedBox(height: 30),
                
                // Progress Button
                _buildProgressButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.school,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              AppStrings.appSubtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, Adik! 👋',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk belajar sambil bermain!',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.pilihMataPelajaran,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
          children: [
            SubjectCard(
              title: AppStrings.bahasaIndonesia,
              subtitle: 'Membaca & Menulis',
              icon: Icons.book,
              color: AppColors.bahasaIndonesia,
              progress: 25,
              onTap: () => _navigateToSubject(context, 'bahasa_indonesia'),
            ),
            SubjectCard(
              title: AppStrings.matematika,
              subtitle: 'Angka & Hitung',
              icon: Icons.calculate,
              color: AppColors.matematika,
              progress: 15,
              onTap: () => _navigateToSubject(context, 'matematika'),
            ),
            SubjectCard(
              title: AppStrings.ipas,
              subtitle: 'Alam & Lingkungan',
              icon: Icons.science,
              color: AppColors.ipas,
              progress: 10,
              onTap: () => _navigateToSubject(context, 'ipas'),
            ),
            SubjectCard(
              title: AppStrings.pancasila,
              subtitle: 'Nilai & Karakter',
              icon: Icons.favorite,
              color: AppColors.pancasila,
              progress: 5,
              onTap: () => _navigateToSubject(context, 'pancasila'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressButton(BuildContext context) {
    return CustomButton(
      text: AppStrings.progressSaya,
      icon: Icons.trending_up,
      backgroundColor: AppColors.accent,
      width: double.infinity,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProgressScreen(),
          ),
        );
      },
    );
  }

  void _navigateToSubject(BuildContext context, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectScreen(subject: subject),
      ),
    );
  }
}
