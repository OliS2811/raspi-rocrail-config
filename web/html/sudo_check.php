<?php
header("Content-Type: application/json; charset=utf-8");

// Prüfen, ob sudoers-Datei existiert
$sudoFile = "/etc/sudoers.d/rocrail-web";
$status = [
    "file_exists" => file_exists($sudoFile),
    "content_valid" => false,
    "message" => "",
];

// Inhalt prüfen, falls vorhanden
if ($status["file_exists"]) {
    $content = @file_get_contents($sudoFile);
    if (strpos($content, "www-data ALL=(pi) NOPASSWD") !== false) {
        $status["content_valid"] = true;
        $status["message"] = "✅ Rocrail Webinterface ist vorbereitet (sudo-Regeln aktiv).";
    } else {
        $status["message"] = "⚠️ Sudo-Datei vorhanden, aber fehlerhaft oder unvollständig.";
    }
} else {
    $status["message"] = "⚠️ Sudo-Regeln fehlen. Add-ons können evtl. nicht ausgeführt werden.";
}

echo json_encode($status, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
