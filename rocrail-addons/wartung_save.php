<?php
$wartung_json = __DIR__ . '/../data/wartung.json';

$lok   = $_POST['lok']   ?? '';
$datum = $_POST['datum'] ?? '';
$text  = $_POST['text']  ?? '';

if (!$lok || !$datum || !$text) {
  echo "❌ Ungültige Eingabe.";
  exit;
}

if (file_exists($wartung_json)) {
  $data = json_decode(file_get_contents($wartung_json), true);
} else {
  $data = [];
}

$data[$lok] = ["datum"=>$datum, "text"=>$text];
file_put_contents($wartung_json, json_encode($data, JSON_PRETTY_PRINT));

echo "✅ Wartung für $lok gespeichert.";
?>