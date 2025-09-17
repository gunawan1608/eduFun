import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/animated_button.dart';
import '../widgets/reward_animation.dart';
import '../models/materi.dart';
import '../models/soal.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';

class EnhancedQuizScreen extends StatefulWidget {
  final Materi materi;
  final String tingkatKesulitan;

  const EnhancedQuizScreen({
    super.key,
    required this.materi,
    required this.tingkatKesulitan,
  });

  @override
  State<EnhancedQuizScreen> createState() => _EnhancedQuizScreenState();
}

class _EnhancedQuizScreenState extends State<EnhancedQuizScreen>
    with TickerProviderStateMixin {
  List<Soal> soalList = [];
  int currentIndex = 0;
  int? selectedAnswer;
  int correctAnswers = 0;
  bool showResult = false;
  bool isLoading = true;
  bool showReward = false;
  bool showFeedback = false;
  bool isAnswerCorrect = false;
  
  late AnimationController _questionController;
  late AnimationController _feedbackController;
  late Animation<double> _questionAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _feedbackScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSoal();
  }

  void _initializeAnimations() {
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _questionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.easeOutCubic,
    ));

    _feedbackScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _questionController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _loadSoal() async {
    try {
      final soal = await ApiService.getRandomSoal(
        widget.materi.id!,
        widget.tingkatKesulitan,
        limit: 5,
      );
      
      setState(() {
        soalList = soal;
        isLoading = false;
      });
      
      _questionController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat soal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: _getSubjectColor(widget.materi.mapel),
              ),
              const SizedBox(height: 20),
              const Text(
                'Memuat soal...',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'ComicNeue',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (soalList.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: _getSubjectColor(widget.materi.mapel),
          title: const Text('Quiz'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              const Text(
                'Belum ada soal tersedia',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'ComicNeue',
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              AnimatedButton(
                text: 'Kembali',
                onPressed: () => Navigator.pop(context),
                backgroundColor: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      );
    }

    if (showResult) {
      return _buildResultScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _getSubjectColor(widget.materi.mapel),
        title: Text(
          'Quiz ${widget.materi.judul}',
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: AnimatedBuilder(
              animation: _questionController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _questionAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressIndicator(),
                        const SizedBox(height: 30),
                        _buildQuestionCard(),
                        const SizedBox(height: 30),
                        _buildAnswerOptions(),
                        const SizedBox(height: 30),
                        if (!showFeedback) _buildActionButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Feedback overlay
          if (showFeedback) _buildFeedbackOverlay(),
          
          // Reward animation
          RewardAnimation(
            show: showReward,
            message: isAnswerCorrect ? 'Hebat!' : 'Coba lagi!',
            icon: isAnswerCorrect ? Icons.star : Icons.refresh,
            color: isAnswerCorrect ? AppColors.success : AppColors.accent,
            onComplete: () {
              setState(() {
                showReward = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${currentIndex + 1} dari ${soalList.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'ComicNeue',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(soalList[currentIndex].tingkatKesulitan),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getDifficultyText(soalList[currentIndex].tingkatKesulitan),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: (currentIndex + 1) / soalList.length),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getSubjectColor(widget.materi.mapel),
                ),
                minHeight: 8,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getSubjectColor(widget.materi.mapel),
            _getSubjectColor(widget.materi.mapel).withOpacity(0.8),
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
          const Icon(
            Icons.help_outline,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            soalList[currentIndex].pertanyaan,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions() {
    return Column(
      children: List.generate(
        soalList[currentIndex].opsiJawaban.length,
        (index) => _buildAnswerOption(index),
      ),
    );
  }

  Widget _buildAnswerOption(int index) {
    bool isSelected = selectedAnswer == index;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isSelected 
                ? _getSubjectColor(widget.materi.mapel)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: showFeedback ? null : () => _selectAnswer(index),
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isSelected 
                  ? _getSubjectColor(widget.materi.mapel).withOpacity(0.1)
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getSubjectColor(widget.materi.mapel)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    soalList[currentIndex].opsiJawaban[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected 
                          ? _getSubjectColor(widget.materi.mapel)
                          : AppColors.textPrimary,
                      fontFamily: 'ComicNeue',
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return AnimatedButton(
      text: currentIndex == soalList.length - 1 ? AppStrings.selesai : 'Jawab',
      icon: currentIndex == soalList.length - 1 ? Icons.check : Icons.send,
      backgroundColor: _getSubjectColor(widget.materi.mapel),
      width: double.infinity,
      isEnabled: selectedAnswer != null,
      onPressed: _submitAnswer,
    );
  }

  Widget _buildFeedbackOverlay() {
    return AnimatedBuilder(
      animation: _feedbackController,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Transform.scale(
                scale: _feedbackScaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(40),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                        size: 80,
                        color: isAnswerCorrect ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isAnswerCorrect ? AppStrings.jawabanBenar : AppStrings.jawabanSalah,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isAnswerCorrect ? AppColors.success : AppColors.error,
                          fontFamily: 'ComicNeue',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        soalList[currentIndex].penjelasan,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          fontFamily: 'ComicNeue',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      AnimatedButton(
                        text: currentIndex == soalList.length - 1 ? AppStrings.selesai : AppStrings.lanjut,
                        icon: currentIndex == soalList.length - 1 ? Icons.check : Icons.arrow_forward,
                        backgroundColor: _getSubjectColor(widget.materi.mapel),
                        onPressed: _nextQuestion,
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

  Widget _buildResultScreen() {
    double percentage = (correctAnswers / soalList.length) * 100;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      percentage >= 80 ? AppColors.success : AppColors.accent,
                      percentage >= 80 ? AppColors.success.withOpacity(0.7) : AppColors.accent.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: (percentage >= 80 ? AppColors.success : AppColors.accent).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      percentage >= 80 ? Icons.emoji_events : Icons.thumb_up,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      percentage >= 80 ? AppStrings.selamat : AppStrings.bagusSkali,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Skor: $correctAnswers/${soalList.length}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${percentage.toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AnimatedButton(
                text: 'Kembali ke Materi',
                icon: Icons.arrow_back,
                backgroundColor: AppColors.primary,
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              if (percentage < 80)
                AnimatedButton(
                  text: AppStrings.coba_lagi,
                  icon: Icons.refresh,
                  backgroundColor: AppColors.accent,
                  width: double.infinity,
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                      selectedAnswer = null;
                      correctAnswers = 0;
                      showResult = false;
                      showFeedback = false;
                    });
                    _loadSoal();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    if (selectedAnswer == null) return;

    isAnswerCorrect = selectedAnswer == soalList[currentIndex].jawabanBenar;
    
    if (isAnswerCorrect) {
      correctAnswers++;
    }

    setState(() {
      showFeedback = true;
      showReward = true;
    });

    _feedbackController.forward();
  }

  void _nextQuestion() {
    _feedbackController.reset();
    
    if (currentIndex < soalList.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        showFeedback = false;
      });
      
      _questionController.reset();
      _questionController.forward();
    } else {
      // Save quiz result
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.saveQuizScore(
        widget.materi.id!,
        widget.tingkatKesulitan,
        correctAnswers,
        soalList.length,
      );
      
      setState(() {
        showResult = true;
        showFeedback = false;
      });
    }
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

  Color _getDifficultyColor(TingkatKesulitan tingkat) {
    switch (tingkat) {
      case TingkatKesulitan.mudah:
        return AppColors.mudah;
      case TingkatKesulitan.sedang:
        return AppColors.sedang;
      case TingkatKesulitan.hots:
        return AppColors.hots;
    }
  }

  String _getDifficultyText(TingkatKesulitan tingkat) {
    switch (tingkat) {
      case TingkatKesulitan.mudah:
        return AppStrings.mudah;
      case TingkatKesulitan.sedang:
        return AppStrings.sedang;
      case TingkatKesulitan.hots:
        return AppStrings.hots;
    }
  }
}
