import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _progressKey = 'user_progress';
  static const String _scoresKey = 'user_scores';
  static const String _achievementsKey = 'user_achievements';
  static const String _settingsKey = 'app_settings';

  // Simpan data user
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(userData));
  }

  // Ambil data user
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  // Simpan progress materi
  static Future<void> saveProgress(int materiId, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    final progressData = await getProgress();
    progressData[materiId.toString()] = progress;
    await prefs.setString(_progressKey, json.encode(progressData));
  }

  // Ambil progress semua materi
  static Future<Map<String, dynamic>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressString = prefs.getString(_progressKey);
    if (progressString != null) {
      return json.decode(progressString);
    }
    return {};
  }

  // Simpan skor quiz
  static Future<void> saveQuizScore(int materiId, String difficulty, int score, int totalQuestions) async {
    final prefs = await SharedPreferences.getInstance();
    final scoresData = await getScores();
    
    final key = '${materiId}_$difficulty';
    final scoreData = {
      'score': score,
      'total': totalQuestions,
      'percentage': (score / totalQuestions * 100).round(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    scoresData[key] = scoreData;
    await prefs.setString(_scoresKey, json.encode(scoresData));
  }

  // Ambil semua skor
  static Future<Map<String, dynamic>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresString = prefs.getString(_scoresKey);
    if (scoresString != null) {
      return json.decode(scoresString);
    }
    return {};
  }

  // Simpan achievement yang didapat
  static Future<void> saveAchievement(String achievementId, String name, String description) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = await getAchievements();
    
    final achievementData = {
      'id': achievementId,
      'name': name,
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    achievements[achievementId] = achievementData;
    await prefs.setString(_achievementsKey, json.encode(achievements));
  }

  // Ambil semua achievement
  static Future<Map<String, dynamic>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsString = prefs.getString(_achievementsKey);
    if (achievementsString != null) {
      return json.decode(achievementsString);
    }
    return {};
  }

  // Cek apakah achievement sudah didapat
  static Future<bool> hasAchievement(String achievementId) async {
    final achievements = await getAchievements();
    return achievements.containsKey(achievementId);
  }

  // Simpan pengaturan aplikasi
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, json.encode(settings));
  }

  // Ambil pengaturan aplikasi
  static Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_settingsKey);
    if (settingsString != null) {
      return json.decode(settingsString);
    }
    return {
      'sound_enabled': true,
      'animation_enabled': true,
      'difficulty_auto_progress': true,
    };
  }

  // Hitung total skor
  static Future<int> getTotalScore() async {
    final scores = await getScores();
    int totalScore = 0;
    
    scores.forEach((key, value) {
      if (value is Map && value.containsKey('score')) {
        totalScore += (value['score'] as int);
      }
    });
    
    return totalScore;
  }

  // Hitung jumlah materi yang diselesaikan
  static Future<int> getCompletedMaterials() async {
    final progress = await getProgress();
    int completed = 0;
    
    progress.forEach((key, value) {
      if (value is int && value >= 100) {
        completed++;
      }
    });
    
    return completed;
  }

  // Reset semua data (untuk testing atau reset progress)
  static Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_progressKey);
    await prefs.remove(_scoresKey);
    await prefs.remove(_achievementsKey);
  }

  // Backup data ke string JSON
  static Future<String> backupData() async {
    final userData = await getUserData();
    final progress = await getProgress();
    final scores = await getScores();
    final achievements = await getAchievements();
    final settings = await getSettings();
    
    final backupData = {
      'user_data': userData,
      'progress': progress,
      'scores': scores,
      'achievements': achievements,
      'settings': settings,
      'backup_date': DateTime.now().toIso8601String(),
    };
    
    return json.encode(backupData);
  }

  // Restore data dari string JSON
  static Future<bool> restoreData(String backupString) async {
    try {
      final backupData = json.decode(backupString);
      
      if (backupData['user_data'] != null) {
        await saveUserData(backupData['user_data']);
      }
      
      final prefs = await SharedPreferences.getInstance();
      
      if (backupData['progress'] != null) {
        await prefs.setString(_progressKey, json.encode(backupData['progress']));
      }
      
      if (backupData['scores'] != null) {
        await prefs.setString(_scoresKey, json.encode(backupData['scores']));
      }
      
      if (backupData['achievements'] != null) {
        await prefs.setString(_achievementsKey, json.encode(backupData['achievements']));
      }
      
      if (backupData['settings'] != null) {
        await prefs.setString(_settingsKey, json.encode(backupData['settings']));
      }
      
      return true;
    } catch (e) {
      print('Error restoring data: $e');
      return false;
    }
  }
}
