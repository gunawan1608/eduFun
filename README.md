# EduFun - Aplikasi Edukasi SD Kelas 1

Aplikasi edukasi interaktif untuk anak SD kelas 1 berdasarkan Kurikulum Merdeka 2025. Dirancang khusus untuk membuat belajar menjadi menyenangkan dengan gamifikasi, animasi, dan konten yang sesuai dengan perkembangan anak usia 6-7 tahun.

## 🎯 Fitur Utama

### 📚 Mata Pelajaran
- **Bahasa Indonesia**: Mengenal huruf, membaca kata sederhana, menulis
- **Matematika**: Angka 1-10, penjumlahan & pengurangan sederhana
- **IPAS**: Bagian tubuh, hewan, tumbuhan, cuaca
- **Pancasila**: Nilai-nilai karakter dan moral
- **Pendidikan Agama**: Dasar-dasar keagamaan

### 🎮 Sistem Pembelajaran Bertingkat
- **Mudah**: Pengenalan konsep dasar
- **Sedang**: Pemahaman dan penerapan
- **HOTS**: Soal berbasis situasi sehari-hari

### 🏆 Gamifikasi & Reward
- Sistem poin dan bintang
- Animasi interaktif saat menjawab benar
- Achievement badges
- Progress tracker visual

### 🎨 Desain Ramah Anak
- Warna-warna cerah dan menarik
- Font besar dan mudah dibaca (ComicNeue)
- Animasi sederhana dan menyenangkan
- Interface intuitif untuk anak-anak

## 🛠️ Teknologi yang Digunakan

### Frontend (Flutter)
- **Flutter SDK**: 3.27.1
- **Provider**: State management
- **HTTP**: API communication
- **SharedPreferences**: Local storage
- **Lottie**: Animasi
- **AudioPlayers**: Suara dan narasi

### Backend
- **Database**: MySQL
- **API**: PHP REST API
- **Server**: Apache/Nginx

### Packages Utama
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  audioplayers: ^5.2.1
  lottie: ^2.7.0
  provider: ^6.1.1
  sqflite: ^2.3.0
```

## 📱 Struktur Aplikasi

```
lib/
├── constants/          # Konstanta warna, string, dll
├── models/            # Model data (User, Materi, Soal)
├── providers/         # State management dengan Provider
├── screens/           # Halaman-halaman aplikasi
├── services/          # API service dan storage service
├── widgets/           # Widget reusable
└── main.dart         # Entry point aplikasi

api/
├── config/           # Konfigurasi database
├── models/           # Model PHP untuk database
└── endpoints/        # REST API endpoints

database/
└── edufun_database.sql  # Schema database MySQL
```

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK (3.27.1 atau lebih baru)
- Android Studio atau VS Code
- MySQL Server
- Apache/Nginx (untuk API)

### Langkah Instalasi

1. **Clone Repository**
```bash
git clone <repository-url>
cd edufun_1
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Setup Database**
```bash
# Import database schema
mysql -u root -p < database/edufun_database.sql
```

4. **Setup API**
- Copy folder `api/` ke web server (htdocs/www)
- Update konfigurasi database di `api/config/database.php`
- Pastikan web server berjalan (Apache/Nginx)

5. **Update API URL**
- Edit `lib/services/api_service.dart`
- Ganti `baseUrl` sesuai dengan server Anda

6. **Run Aplikasi**
```bash
flutter run
```

## 📊 Database Schema

### Tabel Utama
- `users`: Data pengguna anak
- `mata_pelajaran`: Daftar mata pelajaran
- `materi`: Konten pembelajaran
- `soal`: Bank soal dengan tingkat kesulitan
- `user_progress`: Progress belajar per user
- `quiz_results`: Hasil quiz
- `achievements`: Pencapaian/badge
- `user_achievements`: Achievement yang diraih user

## 🎯 Target Pengguna

- **Usia**: 6-7 tahun (Kelas 1 SD)
- **Platform**: Android (prioritas utama)
- **Lokasi**: Indonesia (Jakarta khususnya)
- **Kurikulum**: Kurikulum Merdeka 2025

## 🏗️ Roadmap Pengembangan

### Tahap 1 ✅
- [x] Struktur dasar aplikasi
- [x] Database dan API
- [x] Sistem materi dan soal
- [x] Progress tracker
- [x] Gamifikasi dasar

### Tahap 2 🚧
- [ ] Audio narasi untuk materi
- [ ] Animasi Lottie yang lebih interaktif
- [ ] Fitur orang tua (monitoring)
- [ ] Offline mode

### Tahap 3 📋
- [ ] Multiplayer quiz
- [ ] Leaderboard
- [ ] Konten video pembelajaran
- [ ] AI adaptive learning

## 🎨 Design Guidelines

### Warna Utama
- **Primary**: #4CAF50 (Hijau cerah)
- **Secondary**: #2196F3 (Biru cerah)
- **Accent**: #FF9800 (Orange)

### Warna Mata Pelajaran
- **Bahasa Indonesia**: #E91E63 (Pink)
- **Matematika**: #9C27B0 (Ungu)
- **IPAS**: #00BCD4 (Cyan)
- **Pancasila**: #FF5722 (Orange tua)
- **Agama**: #795548 (Coklat)

### Typography
- **Font Family**: ComicNeue
- **Sizes**: 12px - 36px
- **Weight**: Regular, Bold

## 🤝 Kontribusi

Kami menyambut kontribusi dari developer, educator, dan desainer untuk membuat aplikasi ini lebih baik.

### Cara Berkontribusi
1. Fork repository
2. Buat branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Kontak

- **Developer**: Tim EduFun
- **Email**: contact@edufun.id
- **Website**: https://edufun.id

## 🙏 Acknowledgments

- Kurikulum Merdeka Kemendikbudristek
- Flutter Community
- Icons by Icons8
- Illustrations by Storyset

---

**EduFun** - Belajar Seru untuk Masa Depan Cerah! 🌟
