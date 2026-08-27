<?php
// save_rocweb_port.php
header('Content-Type: text/plain');

$data = json_decode(file_get_contents('php://input'), true);
$port = trim($data['port'] ?? '');

if (!preg_match('/^[0-9]{1,5}$/', $port) || (int)$port < 1 || (int)$port > 65535) {
    http_response_code(400);
    echo "Fehler: Ungültiger Port.";
    exit;
}

// 80/443 wären unser eigenes Apache/Webinterface - würde die Vorschau sich
// selbst einbetten lassen (endlose Verschachtelung).
if ((int)$port === 80 || (int)$port === 443) {
    http_response_code(400);
    echo "Fehler: Das ist der Port dieses Webinterfaces, nicht von RocWeb.";
    exit;
}

$filename = "/var/www/html/tmp/.rocweb_port";

if (@file_put_contents($filename, $port) === false) {
    http_response_code(500);
    echo "Fehler beim Schreiben.";
    exit;
}

chmod($filename, 0644);

echo "OK";
