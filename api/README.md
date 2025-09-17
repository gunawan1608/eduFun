# EduFun API Documentation

REST API untuk aplikasi EduFun - Aplikasi Edukasi SD Kelas 1

## Base URL
```
http://localhost/edufun_api/endpoints/
```

## Endpoints

### 1. Materi (Learning Materials)

#### GET /materi.php
Mengambil data materi pembelajaran

**Parameters:**
- `mapel_id` (optional): ID mata pelajaran
- `id` (optional): ID materi spesifik

**Examples:**
```
GET /materi.php                    # Semua materi
GET /materi.php?mapel_id=1         # Materi Bahasa Indonesia
GET /materi.php?id=5               # Materi dengan ID 5
```

**Response Success:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "judul": "Mengenal Huruf A-Z",
      "konten": "Mari belajar mengenal huruf...",
      "kelas": "1",
      "mapel_id": 1,
      "mapel_nama": "Bahasa Indonesia",
      "gambar": null,
      "audio": null,
      "urutan": 1
    }
  ]
}
```

**Response Error:**
```json
{
  "success": false,
  "message": "Tidak ada materi ditemukan."
}
```

### 2. Soal (Quiz Questions)

#### GET /soal.php
Mengambil data soal quiz

**Parameters (Required):**
- `materi_id`: ID materi

**Parameters (Optional):**
- `tingkat_kesulitan`: mudah, sedang, hots
- `random`: true/false (untuk soal acak)
- `limit`: jumlah soal (default: 5)

**Examples:**
```
GET /soal.php?materi_id=1                                    # Semua soal materi 1
GET /soal.php?materi_id=1&tingkat_kesulitan=mudah          # Soal mudah materi 1
GET /soal.php?materi_id=1&tingkat_kesulitan=hots&random=true&limit=3  # 3 soal HOTS acak
```

**Response Success:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "id_materi": 1,
      "tingkat_kesulitan": "mudah",
      "pertanyaan": "Huruf pertama dalam alfabet adalah...",
      "opsi_jawaban": ["A", "B", "C", "D"],
      "jawaban_benar": 0,
      "penjelasan": "Huruf A adalah huruf pertama dalam alfabet.",
      "gambar": null,
      "urutan": 1
    }
  ]
}
```

**Response Error:**
```json
{
  "success": false,
  "message": "Parameter materi_id diperlukan."
}
```

## Database Schema

### Mata Pelajaran
- ID 1: Bahasa Indonesia
- ID 2: Matematika  
- ID 3: IPAS
- ID 4: Pancasila
- ID 5: Pendidikan Agama

### Tingkat Kesulitan
- `mudah`: Pengenalan konsep dasar
- `sedang`: Pemahaman dan penerapan
- `hots`: Higher Order Thinking Skills

## Error Codes

- `200`: Success
- `400`: Bad Request (parameter salah)
- `404`: Not Found (data tidak ditemukan)
- `405`: Method Not Allowed
- `500`: Internal Server Error

## Setup Development

1. **Database Configuration**
   ```php
   // config/database.php
   private $host = "localhost";
   private $db_name = "edufun_db";
   private $username = "root";
   private $password = "";
   ```

2. **CORS Headers**
   API sudah dikonfigurasi dengan CORS headers untuk development:
   ```php
   header("Access-Control-Allow-Origin: *");
   header("Content-Type: application/json; charset=UTF-8");
   ```

3. **Testing**
   Gunakan tools seperti Postman atau curl untuk testing:
   ```bash
   curl -X GET "http://localhost/edufun_api/endpoints/materi.php?mapel_id=1"
   ```

## Sample Data

Database sudah terisi dengan sample data:
- 4-5 materi per mata pelajaran
- 3-4 soal per materi dengan berbagai tingkat kesulitan
- Data mata pelajaran sesuai Kurikulum Merdeka 2025

## Security Notes

⚠️ **Development Only**: Konfigurasi ini hanya untuk development. Untuk production:
- Gunakan environment variables untuk database credentials
- Implementasi authentication/authorization
- Validasi input yang lebih ketat
- Rate limiting
- HTTPS only
