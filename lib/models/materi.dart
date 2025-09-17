class Materi {
  final int? id;
  final String judul;
  final String konten;
  final String kelas;
  final String mapel;
  final String? gambar;
  final String? audio;

  Materi({
    this.id,
    required this.judul,
    required this.konten,
    required this.kelas,
    required this.mapel,
    this.gambar,
    this.audio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'konten': konten,
      'kelas': kelas,
      'mapel': mapel,
      'gambar': gambar,
      'audio': audio,
    };
  }

  factory Materi.fromMap(Map<String, dynamic> map) {
    return Materi(
      id: map['id'],
      judul: map['judul'],
      konten: map['konten'],
      kelas: map['kelas'],
      mapel: map['mapel'],
      gambar: map['gambar'],
      audio: map['audio'],
    );
  }
}
