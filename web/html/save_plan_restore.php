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

// Keine chown() auf 'pi': www-data darf Dateien nicht an einen anderen
// Nutzer übertragen (nur root darf das). punkt19.sh liest die Datei als
// "pi" ohne Root-Eskalation, deshalb muss sie für alle lesbar bleiben -
// unkritisch, da hier nur ein Git-Hash drinsteht.
chmod($filename, 0644);

echo "OK";
