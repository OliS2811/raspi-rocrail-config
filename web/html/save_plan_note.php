<?php
// save_plan_note.php
header('Content-Type: text/plain');

$data = json_decode(file_get_contents('php://input'), true);
$note = trim($data['note'] ?? '');

if ($note === '') {
    http_response_code(400);
    echo "Fehler: Keine Notiz übermittelt.";
    exit;
}

$note = str_replace(["\r", "\n", "|"], ' ', $note);
$filename = "/var/www/html/tmp/.plan_note";

if (@file_put_contents($filename, $note) === false) {
    http_response_code(500);
    echo "Fehler beim Schreiben.";
    exit;
}

chown($filename, 'pi');
chmod($filename, 0600);

echo "OK";
