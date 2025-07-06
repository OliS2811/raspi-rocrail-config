<?php
$output = shell_exec("iw dev wlan0 link 2>/dev/null");

if (strpos($output, "Connected") !== false) {
    preg_match("/SSID: (.+)/", $output, $ssid);
    preg_match("/signal: ([-0-9]+) dBm/", $output, $signal);
    echo "📶 Verbunden mit: " . ($ssid[1] ?? "Unbekannt") . " (Signal: " . ($signal[1] ?? "?") . " dBm)";
} else {
    echo "❌ Nicht verbunden";
}
?>
