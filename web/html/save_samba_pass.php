<?php
// save_samba_pass.php
header('Content-Type: text/plain');

// Debug-Datei
$logfile = '/var/www/html/tmp/save_samba_pass_debug.log';
file_put_contents($logfile, "[DEBUG] Skript gestartet\n", FILE_APPEND);

// Eingabe lesen
$input = file_get_contents('php://input');
file_put_contents($logfile, "[DEBUG] Eingabe: $input\n", FILE_APPEND);

$data = json_decode($input, true);
$password = trim($data['password'] ?? '');

if ($password === '') {
    file_put_contents($logfile, "[FEHLER] Kein Passwort übermittelt\n", FILE_APPEND);
    http_response_code(400);
    echo "Fehler: Kein Passwort übermittelt.";
    exit;
}

$filename = "/var/www/html/tmp/.smbpass-pi";
file_put_contents($logfile, "[INFO] Schreibe Datei: $filename\n", FILE_APPEND);

// Datei schreiben
if (@file_put_contents($filename, $password . "\n") === false) {
    file_put_contents($logfile, "[FEHLER] Schreiben fehlgeschlagen\n", FILE_APPEND);
    http_response_code(500);
    echo "Fehler beim Schreiben.";
    exit;
}

// Besitzer und Rechte setzen
$chown = chown($filename, 'pi');
$chmod = chmod($filename, 0600);
file_put_contents($logfile, "[INFO] chown(pi): " . ($chown ? "OK" : "Fehler") . "\n", FILE_APPEND);
file_put_contents($logfile, "[INFO] chmod(600): " . ($chmod ? "OK" : "Fehler") . "\n", FILE_APPEND);

echo "OK";
