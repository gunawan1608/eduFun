<?php
class Materi {
    private $conn;
    private $table_name = "materi";

    public $id;
    public $judul;
    public $konten;
    public $kelas;
    public $mapel_id;
    public $gambar;
    public $audio;
    public $urutan;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Mendapatkan semua materi berdasarkan mata pelajaran
    function getByMapel($mapel_id) {
        $query = "SELECT m.*, mp.nama as mapel_nama 
                  FROM " . $this->table_name . " m
                  LEFT JOIN mata_pelajaran mp ON m.mapel_id = mp.id
                  WHERE m.mapel_id = ?
                  ORDER BY m.urutan ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $mapel_id);
        $stmt->execute();

        return $stmt;
    }

    // Mendapatkan materi berdasarkan ID
    function getById($id) {
        $query = "SELECT m.*, mp.nama as mapel_nama 
                  FROM " . $this->table_name . " m
                  LEFT JOIN mata_pelajaran mp ON m.mapel_id = mp.id
                  WHERE m.id = ?";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $id);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->id = $row['id'];
            $this->judul = $row['judul'];
            $this->konten = $row['konten'];
            $this->kelas = $row['kelas'];
            $this->mapel_id = $row['mapel_id'];
            $this->gambar = $row['gambar'];
            $this->audio = $row['audio'];
            $this->urutan = $row['urutan'];
            return true;
        }

        return false;
    }

    // Mendapatkan semua materi
    function getAll() {
        $query = "SELECT m.*, mp.nama as mapel_nama 
                  FROM " . $this->table_name . " m
                  LEFT JOIN mata_pelajaran mp ON m.mapel_id = mp.id
                  ORDER BY mp.urutan ASC, m.urutan ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt;
    }
}
?>
