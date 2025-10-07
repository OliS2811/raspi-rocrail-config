<?php
header('Content-Type: application/json; charset=utf-8');

$sudoFile = '/etc/sudoers.d/rocrail-web';
$result = [
    'file_exists' => file_exists($sudoFile),
    'content_valid' => false,
    'message' => ''
];

if (!file_exists($sudoFile)) {
    $result['message'] = '❌ Sudo-Datei fehlt vollständig.';
    echo json_encode($result);
    exit;
}

// --- Analyse mit visudo ---
$check = shell_exec("sudo visudo -c -f $sudoFile 2>&1");
if (strpos($check, 'Analyse OK') !== false) {
    $result['content_valid'] = true;
    $result['message'] = '✅ Sudo-Konfiguration ist gültig.';
    echo json_encode($result);
    exit;
}

// --- Sonderfall: gültig, aber doppelte oder überlappende Einträge ---
if (strpos($check, 'Falsche Zugriffsrechte') !== false) {
    // Rechte korrigieren
    shell_exec("sudo chmod 440 $sudoFile");
    $check = shell_exec("sudo visudo -c -f $sudoFile 2>&1");
    if (strpos($check, 'Analyse OK') !== false) {
        $result['content_valid'] = true;
        $result['message'] = '🛠️ Sudo-Datei repariert und validiert.';
        echo json_encode($result);
        exit;
    }
}

// --- Wenn alles erlaubt, aber PHP prüft falsch (Fallback-Erkennung) ---
$wwwCanSudo = shell_exec("sudo -l -U www-data 2>/dev/null");
if (strpos($wwwCanSudo, '/usr/bin/git') !== false && strpos($wwwCanSudo, '/usr/bin/cp') !== false) {
    $result['content_valid'] = true;
    $result['message'] = '✅ Sudo-Konfiguration ist funktional (Fallback erkannt).';
    echo json_encode($result);
    exit;
}

// --- Wenn gar nichts passt ---
$result['message'] = '⚠️ Sudo-Datei vorhanden, aber fehlerhaft oder unvollständig.';
echo json_encode($result);
?>
