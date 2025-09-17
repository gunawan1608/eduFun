<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/Materi.php';

$database = new Database();
$db = $database->getConnection();

$materi = new Materi($db);

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    // Cek apakah ada parameter mapel_id
    if (isset($_GET['mapel_id'])) {
        $mapel_id = $_GET['mapel_id'];
        $stmt = $materi->getByMapel($mapel_id);
    } 
    // Cek apakah ada parameter id untuk materi spesifik
    else if (isset($_GET['id'])) {
        $id = $_GET['id'];
        if ($materi->getById($id)) {
            $materi_item = array(
                "id" => $materi->id,
                "judul" => $materi->judul,
                "konten" => $materi->konten,
                "kelas" => $materi->kelas,
                "mapel_id" => $materi->mapel_id,
                "gambar" => $materi->gambar,
                "audio" => $materi->audio,
                "urutan" => $materi->urutan
            );
            
            http_response_code(200);
            echo json_encode(array(
                "success" => true,
                "data" => $materi_item
            ));
            exit();
        } else {
            http_response_code(404);
            echo json_encode(array(
                "success" => false,
                "message" => "Materi tidak ditemukan."
            ));
            exit();
        }
    } 
    // Jika tidak ada parameter, ambil semua materi
    else {
        $stmt = $materi->getAll();
    }

    $num = $stmt->rowCount();

    if ($num > 0) {
        $materi_arr = array();
        $materi_arr["success"] = true;
        $materi_arr["data"] = array();

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);

            $materi_item = array(
                "id" => $id,
                "judul" => $judul,
                "konten" => $konten,
                "kelas" => $kelas,
                "mapel_id" => $mapel_id,
                "mapel_nama" => $mapel_nama,
                "gambar" => $gambar,
                "audio" => $audio,
                "urutan" => $urutan
            );

            array_push($materi_arr["data"], $materi_item);
        }

        http_response_code(200);
        echo json_encode($materi_arr);
    } else {
        http_response_code(404);
        echo json_encode(array(
            "success" => false,
            "message" => "Tidak ada materi ditemukan."
        ));
    }
} else {
    http_response_code(405);
    echo json_encode(array(
        "success" => false,
        "message" => "Method tidak diizinkan."
    ));
}
?>
