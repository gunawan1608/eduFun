import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/materi.dart';
import '../models/soal.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/edufun_api/endpoints';
  
  // Mendapatkan semua materi berdasarkan mata pelajaran
  static Future<List<Materi>> getMateriByMapel(int mapelId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/materi.php?mapel_id=$mapelId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          List<Materi> materiList = [];
          for (var item in data['data']) {
            materiList.add(Materi.fromMap(item));
          }
          return materiList;
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil data materi');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getMateriByMapel: $e');
      // Return dummy data jika API gagal
      return _getDummyMateri(mapelId);
    }
  }

  // Mendapatkan materi berdasarkan ID
  static Future<Materi?> getMateriById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/materi.php?id=$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          return Materi.fromMap(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Materi tidak ditemukan');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getMateriById: $e');
      return null;
    }
  }

  // Mendapatkan soal berdasarkan materi dan tingkat kesulitan
  static Future<List<Soal>> getSoalByMateri(int materiId, {String? tingkatKesulitan}) async {
    try {
      String url = '$baseUrl/soal.php?materi_id=$materiId';
      if (tingkatKesulitan != null) {
        url += '&tingkat_kesulitan=$tingkatKesulitan';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          List<Soal> soalList = [];
          for (var item in data['data']) {
            soalList.add(Soal.fromMap(item));
          }
          return soalList;
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil data soal');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getSoalByMateri: $e');
      // Return dummy data jika API gagal
      return _getDummySoal(materiId, tingkatKesulitan);
    }
  }

  // Mendapatkan soal random berdasarkan tingkat kesulitan
  static Future<List<Soal>> getRandomSoal(int materiId, String tingkatKesulitan, {int limit = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/soal.php?materi_id=$materiId&tingkat_kesulitan=$tingkatKesulitan&random=true&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          List<Soal> soalList = [];
          for (var item in data['data']) {
            soalList.add(Soal.fromMap(item));
          }
          return soalList;
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil data soal');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getRandomSoal: $e');
      // Return dummy data jika API gagal
      return _getDummySoal(materiId, tingkatKesulitan).take(limit).toList();
    }
  }

  // Dummy data untuk fallback ketika API tidak tersedia
  static List<Materi> _getDummyMateri(int mapelId) {
    Map<int, List<Materi>> dummyData = {
      1: [ // Bahasa Indonesia
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
      ],
      2: [ // Matematika
        Materi(
          id: 5,
          judul: 'Mengenal Angka 1-10',
          konten: 'Yuk belajar mengenal angka 1 sampai 10 dengan cara yang seru!',
          kelas: '1',
          mapel: 'Matematika',
        ),
        Materi(
          id: 6,
          judul: 'Penjumlahan Sederhana',
          konten: 'Belajar menjumlahkan angka dengan bantuan gambar dan benda.',
          kelas: '1',
          mapel: 'Matematika',
        ),
      ],
    };

    return dummyData[mapelId] ?? [];
  }

  static List<Soal> _getDummySoal(int materiId, String? tingkatKesulitan) {
    List<Soal> allSoal = [
      Soal(
        id: 1,
        idMateri: 1,
        tingkatKesulitan: TingkatKesulitan.mudah,
        pertanyaan: 'Huruf pertama dalam alfabet adalah...',
        opsiJawaban: ['A', 'B', 'C', 'D'],
        jawabanBenar: 0,
        penjelasan: 'Huruf A adalah huruf pertama dalam alfabet.',
      ),
      Soal(
        id: 2,
        idMateri: 1,
        tingkatKesulitan: TingkatKesulitan.sedang,
        pertanyaan: 'Manakah yang merupakan huruf vokal?',
        opsiJawaban: ['B', 'C', 'I', 'K'],
        jawabanBenar: 2,
        penjelasan: 'Huruf I adalah huruf vokal. Huruf vokal adalah A, I, U, E, O.',
      ),
      Soal(
        id: 3,
        idMateri: 5,
        tingkatKesulitan: TingkatKesulitan.mudah,
        pertanyaan: '2 + 1 = ?',
        opsiJawaban: ['2', '3', '4', '5'],
        jawabanBenar: 1,
        penjelasan: '2 + 1 = 3. Kita menambahkan 1 ke angka 2.',
      ),
    ];

    // Filter berdasarkan materi dan tingkat kesulitan
    return allSoal.where((soal) {
      bool materiMatch = soal.idMateri == materiId;
      bool levelMatch = tingkatKesulitan == null || 
                       soal.tingkatKesulitan.name == tingkatKesulitan;
      return materiMatch && levelMatch;
    }).toList();
  }
}
