<?php
error_reporting(0);
header("Content-Type: application/json; charset=UTF-8");

$loksFile = "/home/pi/Documents/Rocrail/loks.xml";
$wartungFile = "/var/www/html/data/wartung.json";

if (!file_exists($loksFile)) {
    echo json_encode(["error" => "Datei nicht gefunden: $loksFile"]);
    exit;
}

$xmlContent = file_get_contents($loksFile);
$xml = @simplexml_load_string($xmlContent);

if ($xml === false) {
    echo json_encode(["error" => "Fehler beim Einlesen der XML-Datei"]);
    exit;
}

$loks = [];

// --- Lokliste (aktuelle Rocrail-Struktur) ---
if (isset($xml->lclist->lc)) {
    foreach ($xml->lclist->lc as $lc) {
        $attrs = [];
        foreach ($lc->attributes() as $k => $v) {
            $attrs[$k] = (string)$v;
        }

        $loks[] = [
            "id"   => $attrs["id"] ?? "",
            "name" => $attrs["desc"] ?? ($attrs["shortid"] ?? $attrs["id"]),
            "type" => "lok"
        ];
    }
}

// --- Wagenliste (optional) ---
if (isset($xml->carlist->car)) {
    foreach ($xml->carlist->car as $car) {
        $attrs = [];
        foreach ($car->attributes() as $k => $v) {
            $attrs[$k] = (string)$v;
        }

        $loks[] = [
            "id"   => $attrs["id"] ?? "",
            "name" => $attrs["desc"] ?? $attrs["id"],
            "type" => "wagen"
        ];
    }
}

// --- Wartungsdaten einlesen ---
$wartung = [];
if (file_exists($wartungFile)) {
    $data = json_decode(file_get_contents($wartungFile), true);
    if (is_array($data)) $wartung = $data;
}

// --- Zusammenführen ---
foreach ($loks as &$lok) {
    $id = $lok["id"];
    if (isset($wartung[$id])) {
        $lok["wartung"] = $wartung[$id]["wartung"] ?? "";
        $lok["notiz"]   = $wartung[$id]["notiz"] ?? "";
    } else {
        $lok["wartung"] = "";
        $lok["notiz"]   = "";
    }
}

echo json_encode($loks, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
