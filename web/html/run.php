<?php
$allowed = range(0, 20);
$punkt = isset($_POST['punkt']) ? intval($_POST['punkt']) : -1;

header("Content-Type: text/plain");
header("X-Accel-Buffering: no");
ini_set('zlib.output_compression', '0');

// Ausgabe sofort durchreichen statt am Skriptende gepuffert auf einmal zu
// senden - sonst sieht das Webinterface bei langen Läufen (Samba-Install,
// Updates) minutenlang nur den Spinner, obwohl das Skript längst Fortschritt
// meldet.
while (ob_get_level() > 0) {
    ob_end_flush();
}
ob_implicit_flush(true);

if ($punkt === 15) {
    echo "✅ [INFO] Setze Samba-Passwort für Benutzer 'pi'...\n";

    $cmd = "sudo /usr/local/bin/set_samba_pass.sh";
    exec($cmd, $output, $ret);
    echo implode("\n", $output) . "\n";

} elseif (in_array($punkt, $allowed)) {
    $script = escapeshellcmd("/var/www/html/punkt{$punkt}.sh");
    passthru("sudo -u pi $script");
} else {
    http_response_code(400);
    echo "Ungültiger Menüpunkt.";
}
