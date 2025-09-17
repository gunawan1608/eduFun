import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../models/materi.dart';
import '../models/soal.dart';
import '../models/user.dart';

class AppProvider extends ChangeNotifier {
  User? _currentUser;
  Map<String, dynamic> _userProgress = {};
  Map<String, dynamic> _userScores = {};
  Map<String, dynamic> _userAchievements = {};
  Map<String, dynamic> _appSettings = {};
  bool _isLoading = false;

  // Getters
  User? get currentUser => _currentUser;
  Map<String, dynamic> get userProgress => _userProgress;
  Map<String, dynamic> get userScores => _userScores;
  Map<String, dynamic> get userAchievements => _userAchievements;
  Map<String, dynamic> get appSettings => _appSettings;
  bool get isLoading => _isLoading;

  // Initialize app data
  Future<void> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load user data
      final userData = await StorageService.getUserData();
      if (userData != null) {
        _currentUser = User.fromMap(userData);
      } else {
        // Create default user
        _currentUser = User(nama: 'Adik Pintar');
        await saveUserData();
      }

      // Load progress, scores, achievements, and settings
      _userProgress = await StorageService.getProgress();
      _userScores = await StorageService.getScores();
      _userAchievements = await StorageService.getAchievements();
      _appSettings = await StorageService.getSettings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error initializing app: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save user data
  Future<void> saveUserData() async {
    if (_currentUser != null) {
      await StorageService.saveUserData(_currentUser!.toMap());
      notifyListeners();
    }
  }

  // Update user progress for a specific material
  Future<void> updateProgress(int materiId, int progress) async {
    _userProgress[materiId.toString()] = progress;
    await StorageService.saveProgress(materiId, progress);
    
    // Update user's overall progress
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        nama: _currentUser!.nama,
        progress: _calculateOverallProgress(),
        skor: _currentUser!.skor,
        materiTerakhir: materiId.toString(),
      );
      await saveUserData();
    }
    
    notifyListeners();
  }

  // Save quiz score
  Future<void> saveQuizScore(int materiId, String difficulty, int score, int totalQuestions) async {
    await StorageService.saveQuizScore(materiId, difficulty, score, totalQuestions);
    _userScores = await StorageService.getScores();
    
    // Update user's total score
    if (_currentUser != null) {
      final totalScore = await StorageService.getTotalScore();
      _currentUser = User(
        id: _currentUser!.id,
        nama: _currentUser!.nama,
        progress: _currentUser!.progress,
        skor: totalScore,
        materiTerakhir: _currentUser!.materiTerakhir,
      );
      await saveUserData();
    }
    
    // Check for new achievements
    await _checkAchievements();
    
    notifyListeners();
  }

  // Get progress for specific material
  int getMateriProgress(int materiId) {
    return _userProgress[materiId.toString()] ?? 0;
  }

  // Get best score for specific material and difficulty
  Map<String, dynamic>? getMateriScore(int materiId, String difficulty) {
    final key = '${materiId}_$difficulty';
    return _userScores[key];
  }

  // Check if user has specific achievement
  bool hasAchievement(String achievementId) {
    return _userAchievements.containsKey(achievementId);
  }

  // Add new achievement
  Future<void> addAchievement(String achievementId, String name, String description) async {
    if (!hasAchievement(achievementId)) {
      await StorageService.saveAchievement(achievementId, name, description);
      _userAchievements = await StorageService.getAchievements();
      notifyListeners();
    }
  }

  // Update app settings
  Future<void> updateSettings(Map<String, dynamic> newSettings) async {
    _appSettings.addAll(newSettings);
    await StorageService.saveSettings(_appSettings);
    notifyListeners();
  }

  // Get setting value
  T getSetting<T>(String key, T defaultValue) {
    return _appSettings[key] ?? defaultValue;
  }

  // Calculate overall progress percentage
  int _calculateOverallProgress() {
    if (_userProgress.isEmpty) return 0;
    
    int totalProgress = 0;
    int completedMaterials = 0;
    
    _userProgress.forEach((key, value) {
      if (value is int) {
        totalProgress += value;
        if (value >= 100) completedMaterials++;
      }
    });
    
    return _userProgress.length > 0 
        ? (totalProgress / (_userProgress.length * 100) * 100).round()
        : 0;
  }

  // Check for new achievements based on current progress
  Future<void> _checkAchievements() async {
    final totalScore = await StorageService.getTotalScore();
    final completedMaterials = await StorageService.getCompletedMaterials();
    
    // Achievement: Bintang Belajar (Total score 1000)
    if (totalScore >= 1000 && !hasAchievement('bintang_belajar')) {
      await addAchievement(
        'bintang_belajar',
        'Bintang Belajar',
        'Mendapat skor total 1000 poin!'
      );
    }
    
    // Achievement: Rajin Belajar (Complete 10 materials)
    if (completedMaterials >= 10 && !hasAchievement('rajin_belajar')) {
      await addAchievement(
        'rajin_belajar',
        'Rajin Belajar',
        'Menyelesaikan 10 materi pembelajaran!'
      );
    }
    
    // Achievement: Pembaca Hebat (Complete 5 Bahasa Indonesia materials)
    final bahasaProgress = _getSubjectCompletedCount(1); // Assuming mapel_id 1 is Bahasa Indonesia
    if (bahasaProgress >= 5 && !hasAchievement('pembaca_hebat')) {
      await addAchievement(
        'pembaca_hebat',
        'Pembaca Hebat',
        'Menyelesaikan 5 materi Bahasa Indonesia!'
      );
    }
    
    // Achievement: Ahli Hitung (Complete 5 Matematika materials)
    final matematikaProgress = _getSubjectCompletedCount(2); // Assuming mapel_id 2 is Matematika
    if (matematikaProgress >= 5 && !hasAchievement('ahli_hitung')) {
      await addAchievement(
        'ahli_hitung',
        'Ahli Hitung',
        'Menyelesaikan 5 materi Matematika!'
      );
    }
  }

  // Get completed materials count for specific subject
  int _getSubjectCompletedCount(int mapelId) {
    // This is a simplified version - in real app, you'd need to track which materials belong to which subject
    // For now, we'll return a placeholder value
    return 0;
  }

  // Reset all user data (for testing or new user)
  Future<void> resetUserData() async {
    await StorageService.resetAllData();
    _currentUser = User(nama: 'Adik Pintar');
    _userProgress = {};
    _userScores = {};
    _userAchievements = {};
    _appSettings = await StorageService.getSettings();
    await saveUserData();
    notifyListeners();
  }

  // Backup user data
  Future<String> backupUserData() async {
    return await StorageService.backupData();
  }

  // Restore user data from backup
  Future<bool> restoreUserData(String backupData) async {
    final success = await StorageService.restoreData(backupData);
    if (success) {
      await initializeApp();
    }
    return success;
  }

  // Get total statistics
  Map<String, int> getTotalStatistics() {
    return {
      'total_score': _currentUser?.skor ?? 0,
      'completed_materials': _userProgress.values.where((v) => v >= 100).length,
      'total_achievements': _userAchievements.length,
      'overall_progress': _calculateOverallProgress(),
    };
  }

  // Get recent activities (last 5 activities)
  List<Map<String, dynamic>> getRecentActivities() {
    List<Map<String, dynamic>> activities = [];
    
    // Add recent quiz scores
    _userScores.forEach((key, value) {
      if (value is Map && value.containsKey('timestamp')) {
        activities.add({
          'type': 'quiz',
          'title': 'Menyelesaikan quiz',
          'timestamp': value['timestamp'],
          'score': value['score'],
          'total': value['total'],
        });
      }
    });
    
    // Add recent achievements
    _userAchievements.forEach((key, value) {
      if (value is Map && value.containsKey('timestamp')) {
        activities.add({
          'type': 'achievement',
          'title': 'Mendapat ${value['name']}',
          'timestamp': value['timestamp'],
        });
      }
    });
    
    // Sort by timestamp and take last 5
    activities.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return activities.take(5).toList();
  }
}
