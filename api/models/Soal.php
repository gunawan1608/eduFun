<?php
class Soal {
    private $conn;
    private $table_name = "soal";

    public $id;
    public $id_materi;
    public $tingkat_kesulitan;
    public $pertanyaan;
    public $opsi_a;
    public $opsi_b;
    public $opsi_c;
    public $opsi_d;
    public $jawaban_benar;
    public $penjelasan;
    public $gambar;
    public $urutan;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Mendapatkan soal berdasarkan materi dan tingkat kesulitan
    function getByMateriAndLevel($materi_id, $tingkat_kesulitan = null) {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE id_materi = ?";
        
        if ($tingkat_kesulitan) {
            $query .= " AND tingkat_kesulitan = ?";
        }
        
        $query .= " ORDER BY urutan ASC";

        $stmt = $this->conn->prepare($query);
        
        if ($tingkat_kesulitan) {
            $stmt->bindParam(1, $materi_id);
            $stmt->bindParam(2, $tingkat_kesulitan);
        } else {
            $stmt->bindParam(1, $materi_id);
        }
        
        $stmt->execute();

        return $stmt;
    }

    // Mendapatkan soal berdasarkan ID
    function getById($id) {
        $query = "SELECT * FROM " . $this->table_name . " WHERE id = ?";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $id);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->id = $row['id'];
            $this->id_materi = $row['id_materi'];
            $this->tingkat_kesulitan = $row['tingkat_kesulitan'];
            $this->pertanyaan = $row['pertanyaan'];
            $this->opsi_a = $row['opsi_a'];
            $this->opsi_b = $row['opsi_b'];
            $this->opsi_c = $row['opsi_c'];
            $this->opsi_d = $row['opsi_d'];
            $this->jawaban_benar = $row['jawaban_benar'];
            $this->penjelasan = $row['penjelasan'];
            $this->gambar = $row['gambar'];
            $this->urutan = $row['urutan'];
            return true;
        }

        return false;
    }

    // Mendapatkan soal random berdasarkan tingkat kesulitan
    function getRandomByLevel($materi_id, $tingkat_kesulitan, $limit = 5) {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE id_materi = ? AND tingkat_kesulitan = ?
                  ORDER BY RAND() LIMIT ?";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $materi_id);
        $stmt->bindParam(2, $tingkat_kesulitan);
        $stmt->bindParam(3, $limit, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt;
    }
}
?>
