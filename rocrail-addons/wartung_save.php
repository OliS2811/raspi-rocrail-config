<?php
// =============================================================
// 🚂 Wartung: Änderungen speichern
// Schreibt nur wartung.json (nie loks.xml!)
// =============================================================
header('Content-Type: text/plain; charset=utf-8');
$wartungFile = '/var/www/html/data/wartung.json';

$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    http_response_code(400);
    echo "Ungültige Eingabedaten.";
    exit;
}

$current = file_exists($wartungFile)
    ? json_decode(file_get_contents($wartungFile), true)
    : [];

if (!is_array($current)) $current = [];

foreach ($input as $id => $entry) {
    $current[$id]['last_service'] = $entry['last_service'] ?? '';
    $current[$id]['note'] = $entry['note'] ?? '';
}

file_put_contents($wartungFile, json_encode($current, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
chmod($wartungFile, 0664);
echo "Änderungen gespeichert.";
