import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/custom_button.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: const Text(
          'Progress Belajar',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallProgress(),
            const SizedBox(height: 30),
            _buildSubjectProgress(),
            const SizedBox(height: 30),
            _buildAchievements(),
            const SizedBox(height: 30),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Progress Keseluruhan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Materi\nSelesai', '8', Icons.book_outlined),
              _buildStatItem('Soal\nBenar', '45', Icons.check_circle_outline),
              _buildStatItem('Skor\nTotal', '890', Icons.star_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'ComicNeue',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontFamily: 'ComicNeue',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubjectProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress per Mata Pelajaran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 16),
        _buildSubjectProgressCard('Bahasa Indonesia', 25, AppColors.bahasaIndonesia, Icons.book),
        const SizedBox(height: 12),
        _buildSubjectProgressCard('Matematika', 15, AppColors.matematika, Icons.calculate),
        const SizedBox(height: 12),
        _buildSubjectProgressCard('IPAS', 10, AppColors.ipas, Icons.science),
        const SizedBox(height: 12),
        _buildSubjectProgressCard('Pancasila', 5, AppColors.pancasila, Icons.favorite),
      ],
    );
  }

  Widget _buildSubjectProgressCard(String subject, int progress, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '$progress%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'ComicNeue',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pencapaian Terbaru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildAchievementBadge('Pembaca Hebat', AppColors.gold, Icons.auto_stories),
            const SizedBox(width: 12),
            _buildAchievementBadge('Ahli Hitung', AppColors.silver, Icons.calculate),
            const SizedBox(width: 12),
            _buildAchievementBadge('Penjelajah', AppColors.bronze, Icons.explore),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(String title, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'ComicNeue',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terakhir',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem('Menyelesaikan materi "Mengenal Huruf A-Z"', '2 jam lalu', Icons.book),
        _buildActivityItem('Mendapat skor 100 pada soal Matematika', '1 hari lalu', Icons.star),
        _buildActivityItem('Membuka materi "Bagian Tubuh Manusia"', '2 hari lalu', Icons.science),
      ],
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
