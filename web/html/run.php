<?php
$allowed = range(0, 16);
$punkt = isset($_POST['punkt']) ? intval($_POST['punkt']) : -1;

header("Content-Type: text/plain");

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
