<?php
// =============================================================
// 🚂 Wartung: Liste abrufen
// Liest loks.xml und kombiniert sie mit wartung.json
// =============================================================
header('Content-Type: application/json; charset=utf-8');

$loksFile = '/home/pi/Documents/Rocrail/loks.xml';
$wartungFile = '/var/www/html/data/wartung.json';

// --- Lokdaten aus Rocrail ---
$loks = [];
if (file_exists($loksFile)) {
    $xml = simplexml_load_file($loksFile);
    foreach ($xml->children() as $lok) {
        if ($lok->getName() === 'loc' || $lok->getName() === 'car') {
            $id = (string)$lok['id'];
            $loks[$id] = [
                'id'   => $id,
                'name' => (string)$lok['desc'] ?: (string)$lok['id'],
                'type' => ($lok->getName() === 'loc' ? 'Lok' : 'Wagen'),
                'last_service' => '',
                'note' => ''
            ];
        }
    }
}

// --- Wartungsdaten kombinieren ---
if (file_exists($wartungFile)) {
    $custom = json_decode(file_get_contents($wartungFile), true);
    if (is_array($custom)) {
        foreach ($custom as $id => $info) {
            if (!isset($loks[$id])) continue;
            $loks[$id]['last_service'] = $info['last_service'] ?? '';
            $loks[$id]['note'] = $info['note'] ?? '';
        }
    }
}

echo json_encode(array_values($loks), JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
