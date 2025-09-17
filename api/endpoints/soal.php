<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/Soal.php';

$database = new Database();
$db = $database->getConnection();

$soal = new Soal($db);

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    // Parameter yang diperlukan: materi_id
    if (!isset($_GET['materi_id'])) {
        http_response_code(400);
        echo json_encode(array(
            "success" => false,
            "message" => "Parameter materi_id diperlukan."
        ));
        exit();
    }

    $materi_id = $_GET['materi_id'];
    $tingkat_kesulitan = isset($_GET['tingkat_kesulitan']) ? $_GET['tingkat_kesulitan'] : null;
    $random = isset($_GET['random']) ? $_GET['random'] : false;
    $limit = isset($_GET['limit']) ? intval($_GET['limit']) : 5;

    // Jika diminta soal random
    if ($random && $tingkat_kesulitan) {
        $stmt = $soal->getRandomByLevel($materi_id, $tingkat_kesulitan, $limit);
    } else {
        $stmt = $soal->getByMateriAndLevel($materi_id, $tingkat_kesulitan);
    }

    $num = $stmt->rowCount();

    if ($num > 0) {
        $soal_arr = array();
        $soal_arr["success"] = true;
        $soal_arr["data"] = array();

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);

            // Format opsi jawaban sebagai array
            $opsi_jawaban = array($opsi_a, $opsi_b, $opsi_c, $opsi_d);
            
            // Convert jawaban_benar (A,B,C,D) ke index (0,1,2,3)
            $jawaban_benar_index = ord(strtoupper($jawaban_benar)) - ord('A');

            $soal_item = array(
                "id" => $id,
                "id_materi" => $id_materi,
                "tingkat_kesulitan" => $tingkat_kesulitan,
                "pertanyaan" => $pertanyaan,
                "opsi_jawaban" => $opsi_jawaban,
                "jawaban_benar" => $jawaban_benar_index,
                "penjelasan" => $penjelasan,
                "gambar" => $gambar,
                "urutan" => $urutan
            );

            array_push($soal_arr["data"], $soal_item);
        }

        http_response_code(200);
        echo json_encode($soal_arr);
    } else {
        http_response_code(404);
        echo json_encode(array(
            "success" => false,
            "message" => "Tidak ada soal ditemukan untuk materi ini."
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
