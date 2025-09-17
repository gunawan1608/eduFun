import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/custom_button.dart';
import '../models/materi.dart';
import '../models/soal.dart';

class QuizScreen extends StatefulWidget {
  final Materi materi;
  final String tingkatKesulitan;

  const QuizScreen({
    super.key,
    required this.materi,
    required this.tingkatKesulitan,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  List<Soal> soalList = [];
  int currentIndex = 0;
  int? selectedAnswer;
  int correctAnswers = 0;
  bool showResult = false;
  bool isLoading = true;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _loadSoal();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSoal() {
    // Simulasi data soal (nanti akan diganti dengan API call)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        soalList = _getDummySoal();
        isLoading = false;
      });
    });
  }

  List<Soal> _getDummySoal() {
    // Contoh soal untuk Bahasa Indonesia
    if (widget.materi.mapel == 'Bahasa Indonesia') {
      return [
        Soal(
          id: 1,
          idMateri: widget.materi.id!,
          tingkatKesulitan: TingkatKesulitan.mudah,
          pertanyaan: 'Huruf pertama dalam alfabet adalah...',
          opsiJawaban: ['A', 'B', 'C', 'D'],
          jawabanBenar: 0,
          penjelasan: 'Huruf A adalah huruf pertama dalam alfabet.',
        ),
        Soal(
          id: 2,
          idMateri: widget.materi.id!,
          tingkatKesulitan: TingkatKesulitan.mudah,
          pertanyaan: 'Kata "MAMA" dimulai dengan huruf...',
          opsiJawaban: ['L', 'M', 'N', 'O'],
          jawabanBenar: 1,
          penjelasan: 'Kata MAMA dimulai dengan huruf M.',
        ),
        Soal(
          id: 3,
          idMateri: widget.materi.id!,
          tingkatKesulitan: TingkatKesulitan.sedang,
          pertanyaan: 'Manakah yang merupakan huruf vokal?',
          opsiJawaban: ['B', 'C', 'I', 'K'],
          jawabanBenar: 2,
          penjelasan: 'Huruf I adalah huruf vokal. Huruf vokal adalah A, I, U, E, O.',
        ),
      ];
    }
    // Contoh soal untuk Matematika
    else if (widget.materi.mapel == 'Matematika') {
      return [
        Soal(
          id: 4,
          idMateri: widget.materi.id!,
          tingkatKesulitan: TingkatKesulitan.mudah,
          pertanyaan: '2 + 1 = ?',
          opsiJawaban: ['2', '3', '4', '5'],
          jawabanBenar: 1,
          penjelasan: '2 + 1 = 3. Kita menambahkan 1 ke angka 2.',
        ),
        Soal(
          id: 5,
          idMateri: widget.materi.id!,
          tingkatKesulitan: TingkatKesulitan.mudah,
          pertanyaan: 'Angka setelah 5 adalah...',
          opsiJawaban: ['4', '6', '7', '8'],
          jawabanBenar: 1,
          penjelasan: 'Angka setelah 5 adalah 6.',
        ),
        Soal(
          id: 6,
          idMateri: widget.materi.id!,
          tingkatKesulitan: TingkatKesulitan.hots,
          pertanyaan: 'Ani punya 3 permen. Dia memberikan 1 permen ke adiknya. Berapa permen Ani sekarang?',
          opsiJawaban: ['1', '2', '3', '4'],
          jawabanBenar: 1,
          penjelasan: 'Ani punya 3 permen, memberikan 1, jadi sisa 3 - 1 = 2 permen.',
        ),
      ];
    }
    
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (soalList.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Quiz'),
        ),
        body: const Center(
          child: Text(
            'Belum ada soal tersedia',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'ComicNeue',
            ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 30),
            _buildQuestionCard(),
            const SizedBox(height: 30),
            _buildAnswerOptions(),
            const SizedBox(height: 30),
            _buildActionButton(),
          ],
        ),
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
          LinearProgressIndicator(
            value: (currentIndex + 1) / soalList.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getSubjectColor(widget.materi.mapel),
            ),
            minHeight: 8,
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
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _scaleAnimation.value : 1.0,
          child: Container(
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
                onTap: () => _selectAnswer(index),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isSelected 
                        ? _getSubjectColor(widget.materi.mapel).withOpacity(0.1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
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
          ),
        );
      },
    );
  }

  Widget _buildActionButton() {
    return CustomButton(
      text: currentIndex == soalList.length - 1 ? AppStrings.selesai : AppStrings.lanjut,
      icon: currentIndex == soalList.length - 1 ? Icons.check : Icons.arrow_forward,
      backgroundColor: _getSubjectColor(widget.materi.mapel),
      width: double.infinity,
      isEnabled: selectedAnswer != null,
      onPressed: _nextQuestion,
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
              CustomButton(
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
                CustomButton(
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
                    });
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
    
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _nextQuestion() {
    if (selectedAnswer == soalList[currentIndex].jawabanBenar) {
      correctAnswers++;
    }

    if (currentIndex < soalList.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        showResult = true;
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
