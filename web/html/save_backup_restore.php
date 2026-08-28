<?php
// save_backup_restore.php
header('Content-Type: text/plain');

$data = json_decode(file_get_contents('php://input'), true);
$path = trim($data['path'] ?? '');

// Grobe Formatprüfung - die eigentliche Absicherung (Datei muss real
// existieren und aus einem bekannten Backup-Verzeichnis stammen) passiert
// in punkt23.sh, das den Pfad gegen die tatsächliche Backup-Liste prüft.
if (!preg_match('#^/[A-Za-z0-9_./-]+/rocrail_backup_[0-9_-]+\.zip$#', $path)) {
    http_response_code(400);
    echo "Fehler: Ungültiger Pfad.";
    exit;
}

$filename = "/var/www/html/tmp/.backup_restore";

if (@file_put_contents($filename, $path) === false) {
    http_response_code(500);
    echo "Fehler beim Schreiben.";
    exit;
}

chmod($filename, 0644);

echo "OK";
