<?php
// save_plan_restore.php
header('Content-Type: text/plain');

$data = json_decode(file_get_contents('php://input'), true);
$hash = trim($data['hash'] ?? '');

if (!preg_match('/^[0-9a-f]{7,40}$/', $hash)) {
    http_response_code(400);
    echo "Fehler: Ungültige Version.";
    exit;
}

$filename = "/var/www/html/tmp/.plan_restore";

if (@file_put_contents($filename, $hash) === false) {
    http_response_code(500);
    echo "Fehler beim Schreiben.";
    exit;
}

chown($filename, 'pi');
chmod($filename, 0600);

echo "OK";
