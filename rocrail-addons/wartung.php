<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<title>Lok- & Wagenwartung</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f7f9fc; padding:30px; }
.table td, .table th { vertical-align: middle; }
</style>
</head>
<body class="container">

<h3 class="mb-4"><i class="bi bi-wrench-adjustable"></i> Lok- & Wagenwartung</h3>

<div class="mb-3 d-flex gap-2">
  <button class="btn btn-outline-primary btn-sm" onclick="ladeDaten()">🔄 Aktualisieren</button>
  <button class="btn btn-success btn-sm" onclick="speichern()">💾 Änderungen speichern</button>
</div>

<table class="table table-bordered table-sm align-middle">
  <thead class="table-light">
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Typ</th>
      <th>Letzte Wartung</th>
      <th>Status</th>
      <th>Bemerkung</th>
    </tr>
  </thead>
  <tbody id="wartung-tabelle">
    <tr><td colspan="6" class="text-center text-muted">🔍 Lade Daten...</td></tr>
  </tbody>
</table>

<div id="meldung" class="mt-3 small text-success"></div>

<script>
async function ladeDaten() {
  const tbody = document.getElementById("wartung-tabelle");
  tbody.innerHTML = "<tr><td colspan='6' class='text-center text-muted'>🔄 Lade Daten...</td></tr>";

  const res = await fetch("api/wartung_list.php");
  const data = await res.json();

  if (!Array.isArray(data) || data.length === 0) {
    tbody.innerHTML = "<tr><td colspan='6' class='text-center text-muted'>Keine Loks oder Wagen gefunden.</td></tr>";
    return;
  }

  tbody.innerHTML = "";
  data.forEach(lok => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${lok.id}</td>
      <td>${lok.name}</td>
      <td>${lok.type}</td>
      <td><input type="text" class="form-control form-control-sm wartung" value="${lok.wartung || ""}" placeholder="tt.mm.jjjj"></td>
      <td class="text-center"><input type="checkbox" class="form-check-input status" ${lok.status ? "checked" : ""}></td>
      <td><input type="text" class="form-control form-control-sm notiz" value="${lok.notiz || ""}"></td>
    `;
    tbody.appendChild(tr);
  });
}

async function speichern() {
  const rows = document.querySelectorAll("#wartung-tabelle tr");
  const daten = [];

  rows.forEach(row => {
    const id = row.children[0]?.innerText.trim();
    if (!id) return;
    const wartung = row.querySelector(".wartung")?.value.trim() || "";
    const notiz   = row.querySelector(".notiz")?.value.trim() || "";
    const status  = row.querySelector(".status")?.checked || false;
    daten.push({ id, wartung, notiz, status });
  });

  const res = await fetch("api/wartung_save.php", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(daten)
  });
  const result = await res.json();

  const meldung = document.getElementById("meldung");
  if (result.success) {
    meldung.textContent = `✅ ${result.count} Einträge gespeichert (${new Date().toLocaleTimeString()})`;
    meldung.classList.replace("text-danger","text-success");
  } else {
    meldung.textContent = "❌ Fehler: " + (result.error || "unbekannt");
    meldung.classList.replace("text-success","text-danger");
  }
}

// Initial laden
ladeDaten();
</script>
</body>
</html>
