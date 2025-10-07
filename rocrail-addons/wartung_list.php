<?php
header('Content-Type: application/json');

$loks_xml = '/home/pi/Documents/Rocrail/loks.xml';
$wartung_json = __DIR__ . '/../data/wartung.json';

if (!file_exists($loks_xml)) {
  echo json_encode(["error" => "loks.xml nicht gefunden"]);
  exit;
}

$xml = simplexml_load_file($loks_xml);
$loks = [];
foreach ($xml->lclist->lc as $lok) {
  $id = (string)$lok['id'];
  $addr = (string)$lok['addr'];
  $engine = (string)$lok['engine'];
  $runtime = round(((int)$lok['runtime']) / 3600, 1);
  $loks[$id] = ["id"=>$id,"addr"=>$addr,"engine"=>$engine,"runtime"=>$runtime];
}

if (file_exists($wartung_json)) {
  $wartung = json_decode(file_get_contents($wartung_json), true);
  foreach ($wartung as $id => $data) {
    if (isset($loks[$id])) {
      $loks[$id]['last'] = $data['datum'];
      $loks[$id]['comment'] = $data['text'];
    }
  }
}

echo json_encode(array_values($loks), JSON_PRETTY_PRINT);
?>