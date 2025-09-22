import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/materi.dart';
import 'materi_screen.dart';

class SubjectScreen extends StatefulWidget {
  final String subject;

  const SubjectScreen({super.key, required this.subject});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Materi> materiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMateri();
  }

  void _loadMateri() {
    // Simulasi data materi (nanti akan diganti dengan API call)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        materiList = _getDummyMateri(widget.subject);
        isLoading = false;
      });
    });
  }

  List<Materi> _getDummyMateri(String subject) {
    switch (subject) {
      case 'bahasa_indonesia':
        return [
          Materi(
            id: 1,
            judul: 'Mengenal Huruf A-Z',
            konten: 'Mari belajar mengenal huruf dari A sampai Z dengan cara yang menyenangkan!',
            kelas: '1',
            mapel: 'Bahasa Indonesia',
          ),
          Materi(
            id: 2,
            judul: 'Membaca Kata Sederhana',
            konten: 'Belajar membaca kata-kata sederhana seperti mama, papa, buku, dan lainnya.',
            kelas: '1',
            mapel: 'Bahasa Indonesia',
          ),
          Materi(
            id: 3,
            judul: 'Menulis Huruf Kecil',
            konten: 'Latihan menulis huruf kecil dengan benar dan rapi.',
            kelas: '1',
            mapel: 'Bahasa Indonesia',
          ),
        ];
      case 'matematika':
        return [
          Materi(
            id: 4,
            judul: 'Mengenal Angka 1-10',
            konten: 'Yuk belajar mengenal angka 1 sampai 10 dengan cara yang seru!',
            kelas: '1',
            mapel: 'Matematika',
          ),
          Materi(
            id: 5,
            judul: 'Penjumlahan Sederhana',
            konten: 'Belajar menjumlahkan angka dengan bantuan gambar dan benda.',
            kelas: '1',
            mapel: 'Matematika',
          ),
          Materi(
            id: 6,
            judul: 'Pengurangan Sederhana',
            konten: 'Belajar mengurangi angka dengan cara yang mudah dipahami.',
            kelas: '1',
            mapel: 'Matematika',
          ),
        ];
      case 'ipas':
        return [
          Materi(
            id: 7,
            judul: 'Bagian Tubuh Manusia',
            konten: 'Mari mengenal bagian-bagian tubuh kita seperti kepala, tangan, dan kaki.',
            kelas: '1',
            mapel: 'IPAS',
          ),
          Materi(
            id: 8,
            judul: 'Hewan di Sekitar Kita',
            konten: 'Belajar mengenal hewan-hewan yang ada di sekitar rumah kita.',
            kelas: '1',
            mapel: 'IPAS',
          ),
        ];
      case 'pancasila':
        return [
          Materi(
            id: 9,
            judul: 'Berbagi dengan Teman',
            konten: 'Belajar pentingnya berbagi dan tolong-menolong dengan teman.',
            kelas: '1',
            mapel: 'Pancasila',
          ),
          Materi(
            id: 10,
            judul: 'Menghormati Orang Tua',
            konten: 'Cara menghormati dan menyayangi orang tua di rumah.',
            kelas: '1',
            mapel: 'Pancasila',
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _getSubjectColor(widget.subject),
        title: Text(
          _getSubjectTitle(widget.subject),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildMateriList(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getSubjectColor(widget.subject).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getSubjectColor(widget.subject).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _getSubjectIcon(widget.subject),
            size: 60,
            color: _getSubjectColor(widget.subject),
          ),
          const SizedBox(height: 12),
          Text(
            'Pilih materi yang ingin dipelajari',
            style: TextStyle(
              fontSize: 16,
              color: _getSubjectColor(widget.subject),
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Materi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: materiList.length,
          itemBuilder: (context, index) {
            final materi = materiList[index];
            return _buildMateriCard(materi, index);
          },
        ),
      ],
    );
  }

  Widget _buildMateriCard(Materi materi, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MateriScreen(materi: materi),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getSubjectColor(widget.subject),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materi.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      materi.konten,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontFamily: 'ComicNeue',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: _getSubjectColor(widget.subject),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'bahasa_indonesia':
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

  String _getSubjectTitle(String subject) {
    switch (subject) {
      case 'bahasa_indonesia':
        return AppStrings.bahasaIndonesia;
      case 'matematika':
        return AppStrings.matematika;
      case 'ipas':
        return AppStrings.ipas;
      case 'pancasila':
        return AppStrings.pancasila;
      default:
        return 'Mata Pelajaran';
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'bahasa_indonesia':
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
