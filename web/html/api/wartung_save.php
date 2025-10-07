<?php
// =============================================================
// 🚂 Wartungs-Addon für Rocrail Webinterface – Speichern
// Autor: Olli / 2025
// =============================================================

header('Content-Type: application/json; charset=utf-8');
error_reporting(0);

$wartungFile = '/var/www/html/data/wartung.json';
$backupDir   = '/var/www/html/data';

// --- Request prüfen ---
$input = file_get_contents('php://input');
if (!$input) {
    echo json_encode(['error' => 'Keine Daten empfangen.']);
    exit;
}

$data = json_decode($input, true);
if ($data === null) {
    echo json_encode(['error' => 'Ungültiges JSON.']);
    exit;
}

// --- Bestehende Daten laden ---
$wartung = [];
if (file_exists($wartungFile)) {
    $json = file_get_contents($wartungFile);
    $decoded = json_decode($json, true);
    if (is_array($decoded)) {
        $wartung = $decoded;
    }
}

// --- Backup anlegen ---
if (!is_dir($backupDir)) {
    mkdir($backupDir, 0775, true);
}

if (file_exists($wartungFile)) {
    $timestamp = date('Ymd-His');
    $backupFile = $backupDir . '/wartung_backup_' . $timestamp . '.json';
    copy($wartungFile, $backupFile);
}

// --- Neue Daten übernehmen ---
foreach ($data as $entry) {
    $id = $entry['id'] ?? '';
    if ($id === '') continue;

    $wartung[$id] = [
        'wartung' => trim($entry['wartung'] ?? ''),
        'notiz'   => trim($entry['notiz'] ?? ''),
        'status'  => isset($entry['status']) ? (bool)$entry['status'] : false
    ];
}

// --- Aufräumen: leere Einträge entfernen ---
foreach ($wartung as $id => $entry) {
    if ($entry['wartung'] === '' && $entry['notiz'] === '' && !$entry['status']) {
        unset($wartung[$id]);
    }
}

// --- Speichern ---
$result = file_put_contents(
    $wartungFile,
    json_encode($wartung, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)
);

if ($result === false) {
    echo json_encode(['error' => 'Fehler beim Schreiben von wartung.json']);
    exit;
}

echo json_encode(['success' => true, 'count' => count($wartung)]);
?>
