<?php
$data = json_decode(file_get_contents('php://input'), true);
if (!empty($data['ssid']) && !empty($data['password'])) {
    file_put_contents('/tmp/wifi_ssid', $data['ssid']);
    file_put_contents('/tmp/wifi_pass', $data['password']);
    echo 'OK';
} else {
    echo 'FEHLER';
}
?>
