-- Database EduFun untuk Aplikasi Edukasi SD Kelas 1
-- Kurikulum Merdeka 2025

CREATE DATABASE IF NOT EXISTS edufun_db;
USE edufun_db;

-- Tabel untuk menyimpan data pengguna (anak-anak)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    progress INT DEFAULT 0,
    skor INT DEFAULT 0,
    materi_terakhir VARCHAR(255),
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tanggal_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan mata pelajaran
CREATE TABLE mata_pelajaran (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(50) NOT NULL,
    deskripsi TEXT,
    icon VARCHAR(50),
    warna VARCHAR(7), -- hex color code
    urutan INT DEFAULT 0
);

-- Tabel untuk menyimpan materi pembelajaran
CREATE TABLE materi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    judul VARCHAR(255) NOT NULL,
    konten TEXT NOT NULL,
    kelas VARCHAR(10) DEFAULT '1',
    mapel_id INT,
    gambar VARCHAR(255),
    audio VARCHAR(255),
    urutan INT DEFAULT 0,
    tanggal_buat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mapel_id) REFERENCES mata_pelajaran(id)
);

-- Tabel untuk menyimpan soal-soal
CREATE TABLE soal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_materi INT,
    tingkat_kesulitan ENUM('mudah', 'sedang', 'hots') DEFAULT 'mudah',
    pertanyaan TEXT NOT NULL,
    opsi_a VARCHAR(255) NOT NULL,
    opsi_b VARCHAR(255) NOT NULL,
    opsi_c VARCHAR(255) NOT NULL,
    opsi_d VARCHAR(255) NOT NULL,
    jawaban_benar CHAR(1) NOT NULL, -- A, B, C, atau D
    penjelasan TEXT,
    gambar VARCHAR(255),
    urutan INT DEFAULT 0,
    tanggal_buat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_materi) REFERENCES materi(id)
);

-- Tabel untuk menyimpan progress pengguna per materi
CREATE TABLE user_progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    materi_id INT,
    status ENUM('belum_mulai', 'sedang_belajar', 'selesai') DEFAULT 'belum_mulai',
    skor_tertinggi INT DEFAULT 0,
    waktu_selesai TIMESTAMP NULL,
    tanggal_mulai TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (materi_id) REFERENCES materi(id),
    UNIQUE KEY unique_user_materi (user_id, materi_id)
);

-- Tabel untuk menyimpan hasil quiz pengguna
CREATE TABLE quiz_results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    materi_id INT,
    tingkat_kesulitan ENUM('mudah', 'sedang', 'hots'),
    skor INT NOT NULL,
    total_soal INT NOT NULL,
    waktu_mulai TIMESTAMP,
    waktu_selesai TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (materi_id) REFERENCES materi(id)
);

-- Tabel untuk menyimpan pencapaian/achievement
CREATE TABLE achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    icon VARCHAR(50),
    syarat_skor INT DEFAULT 0,
    syarat_materi INT DEFAULT 0,
    warna VARCHAR(7)
);

-- Tabel untuk menyimpan pencapaian pengguna
CREATE TABLE user_achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    achievement_id INT,
    tanggal_dapat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (achievement_id) REFERENCES achievements(id),
    UNIQUE KEY unique_user_achievement (user_id, achievement_id)
);

-- Insert data mata pelajaran
INSERT INTO mata_pelajaran (nama, deskripsi, icon, warna, urutan) VALUES
('Bahasa Indonesia', 'Belajar membaca, menulis, dan berbahasa Indonesia', 'book', '#E91E63', 1),
('Matematika', 'Belajar angka, hitung-hitungan, dan logika', 'calculate', '#9C27B0', 2),
('IPAS', 'Ilmu Pengetahuan Alam dan Sosial', 'science', '#00BCD4', 3),
('Pancasila', 'Pendidikan karakter dan nilai-nilai Pancasila', 'favorite', '#FF5722', 4),
('Pendidikan Agama', 'Pendidikan agama dan moral', 'mosque', '#795548', 5);

-- Insert data materi Bahasa Indonesia
INSERT INTO materi (judul, konten, mapel_id, urutan) VALUES
('Mengenal Huruf A-Z', 'Mari belajar mengenal huruf dari A sampai Z dengan cara yang menyenangkan! Setiap huruf memiliki bentuk dan bunyi yang berbeda.', 1, 1),
('Membaca Kata Sederhana', 'Belajar membaca kata-kata sederhana seperti mama, papa, buku, dan lainnya. Mulai dari kata yang mudah dulu ya!', 1, 2),
('Menulis Huruf Kecil', 'Latihan menulis huruf kecil dengan benar dan rapi. Ingat, tulis dari atas ke bawah ya!', 1, 3),
('Mengenal Huruf Vokal', 'Huruf vokal adalah A, I, U, E, O. Mari belajar mengenal dan mengucapkannya!', 1, 4);

-- Insert data materi Matematika
INSERT INTO materi (judul, konten, mapel_id, urutan) VALUES
('Mengenal Angka 1-10', 'Yuk belajar mengenal angka 1 sampai 10 dengan cara yang seru! Setiap angka punya bentuk yang unik.', 2, 1),
('Penjumlahan Sederhana', 'Belajar menjumlahkan angka dengan bantuan gambar dan benda. Penjumlahan itu seperti menambah mainan!', 2, 2),
('Pengurangan Sederhana', 'Belajar mengurangi angka dengan cara yang mudah dipahami. Pengurangan itu seperti mainan yang diambil.', 2, 3),
('Mengenal Bentuk Geometri', 'Mari mengenal bentuk-bentuk seperti lingkaran, segitiga, dan persegi yang ada di sekitar kita!', 2, 4);

-- Insert data materi IPAS
INSERT INTO materi (judul, konten, mapel_id, urutan) VALUES
('Bagian Tubuh Manusia', 'Mari mengenal bagian-bagian tubuh kita seperti kepala, tangan, kaki, dan fungsinya masing-masing.', 3, 1),
('Hewan di Sekitar Kita', 'Belajar mengenal hewan-hewan yang ada di sekitar rumah kita seperti kucing, anjing, ayam, dan burung.', 3, 2),
('Tumbuhan dan Bagiannya', 'Mengenal bagian-bagian tumbuhan seperti akar, batang, daun, bunga, dan buah.', 3, 3),
('Cuaca dan Musim', 'Belajar tentang cuaca seperti cerah, hujan, mendung, dan musim kemarau serta penghujan.', 3, 4);

-- Insert data materi Pancasila
INSERT INTO materi (judul, konten, mapel_id, urutan) VALUES
('Berbagi dengan Teman', 'Belajar pentingnya berbagi dan tolong-menolong dengan teman. Berbagi itu menyenangkan!', 4, 1),
('Menghormati Orang Tua', 'Cara menghormati dan menyayangi orang tua di rumah. Orang tua selalu sayang sama kita.', 4, 2),
('Rukun dengan Tetangga', 'Belajar hidup rukun dengan tetangga dan saling membantu satu sama lain.', 4, 3),
('Cinta Tanah Air', 'Mengenal Indonesia sebagai tanah air kita dan belajar mencintai negara.', 4, 4);

-- Insert contoh soal Bahasa Indonesia
INSERT INTO soal (id_materi, tingkat_kesulitan, pertanyaan, opsi_a, opsi_b, opsi_c, opsi_d, jawaban_benar, penjelasan, urutan) VALUES
(1, 'mudah', 'Huruf pertama dalam alfabet adalah...', 'A', 'B', 'C', 'D', 'A', 'Huruf A adalah huruf pertama dalam alfabet.', 1),
(1, 'mudah', 'Kata "MAMA" dimulai dengan huruf...', 'L', 'M', 'N', 'O', 'B', 'Kata MAMA dimulai dengan huruf M.', 2),
(1, 'sedang', 'Manakah yang merupakan huruf vokal?', 'B', 'C', 'I', 'K', 'C', 'Huruf I adalah huruf vokal. Huruf vokal adalah A, I, U, E, O.', 3),
(1, 'hots', 'Jika kamu melihat tulisan "BUKU", huruf apa yang ada di tengah?', 'B', 'U', 'K', 'O', 'B', 'Kata BUKU memiliki huruf B-U-K-U, jadi huruf di tengah adalah U (posisi ke-2 dan ke-3).', 4);

-- Insert contoh soal Matematika
INSERT INTO soal (id_materi, tingkat_kesulitan, pertanyaan, opsi_a, opsi_b, opsi_c, opsi_d, jawaban_benar, penjelasan, urutan) VALUES
(5, 'mudah', '2 + 1 = ?', '2', '3', '4', '5', 'B', '2 + 1 = 3. Kita menambahkan 1 ke angka 2.', 1),
(5, 'mudah', 'Angka setelah 5 adalah...', '4', '6', '7', '8', 'B', 'Angka setelah 5 adalah 6.', 2),
(5, 'sedang', '4 - 2 = ?', '1', '2', '3', '4', 'B', '4 - 2 = 2. Kita mengurangi 2 dari angka 4.', 3),
(5, 'hots', 'Ani punya 3 permen. Dia memberikan 1 permen ke adiknya. Berapa permen Ani sekarang?', '1', '2', '3', '4', 'B', 'Ani punya 3 permen, memberikan 1, jadi sisa 3 - 1 = 2 permen.', 4);

-- Insert data achievements
INSERT INTO achievements (nama, deskripsi, icon, syarat_skor, syarat_materi, warna) VALUES
('Pembaca Hebat', 'Menyelesaikan 5 materi Bahasa Indonesia', 'auto_stories', 400, 5, '#FFD700'),
('Ahli Hitung', 'Menyelesaikan 5 materi Matematika', 'calculate', 400, 5, '#C0C0C0'),
('Penjelajah Alam', 'Menyelesaikan 5 materi IPAS', 'explore', 400, 5, '#CD7F32'),
('Anak Pancasila', 'Menyelesaikan 5 materi Pancasila', 'favorite', 400, 5, '#FF5722'),
('Bintang Belajar', 'Mendapat skor total 1000', 'star', 1000, 0, '#FFD700'),
('Rajin Belajar', 'Menyelesaikan 10 materi', 'school', 0, 10, '#4CAF50');

-- Insert contoh user untuk testing
INSERT INTO users (nama, progress, skor) VALUES
('Andi', 25, 450),
('Sari', 15, 280),
('Budi', 30, 520);
