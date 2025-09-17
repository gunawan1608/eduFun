class User {
  final int? id;
  final String nama;
  final int progress;
  final int skor;
  final String? materiTerakhir;

  User({
    this.id,
    required this.nama,
    this.progress = 0,
    this.skor = 0,
    this.materiTerakhir,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'progress': progress,
      'skor': skor,
      'materi_terakhir': materiTerakhir,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nama: map['nama'],
      progress: map['progress'] ?? 0,
      skor: map['skor'] ?? 0,
      materiTerakhir: map['materi_terakhir'],
    );
  }
}
