enum TingkatKesulitan { mudah, sedang, hots }

class Soal {
  final int? id;
  final int idMateri;
  final TingkatKesulitan tingkatKesulitan;
  final String pertanyaan;
  final List<String> opsiJawaban;
  final int jawabanBenar; // index dari opsi jawaban yang benar (0-3)
  final String penjelasan;
  final String? gambar;

  Soal({
    this.id,
    required this.idMateri,
    required this.tingkatKesulitan,
    required this.pertanyaan,
    required this.opsiJawaban,
    required this.jawabanBenar,
    required this.penjelasan,
    this.gambar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_materi': idMateri,
      'tingkat_kesulitan': tingkatKesulitan.name,
      'pertanyaan': pertanyaan,
      'opsi_jawaban': opsiJawaban.join('|'), // simpan sebagai string dengan separator
      'jawaban_benar': jawabanBenar,
      'penjelasan': penjelasan,
      'gambar': gambar,
    };
  }

  factory Soal.fromMap(Map<String, dynamic> map) {
    return Soal(
      id: map['id'],
      idMateri: map['id_materi'],
      tingkatKesulitan: TingkatKesulitan.values.firstWhere(
        (e) => e.name == map['tingkat_kesulitan'],
        orElse: () => TingkatKesulitan.mudah,
      ),
      pertanyaan: map['pertanyaan'],
      opsiJawaban: map['opsi_jawaban'].split('|'),
      jawabanBenar: map['jawaban_benar'],
      penjelasan: map['penjelasan'],
      gambar: map['gambar'],
    );
  }
}
