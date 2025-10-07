<?php
// =============================================================
// 🚂 Lok- & Wagenwartung – Hauptseite
// Liest Rocrail loks.xml (nur lesend) und wartung.json (editierbar)
// =============================================================
?>
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <title>Lok- & Wagenwartung</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <style>
    body { background:#f5f7fb; padding:30px; }
    table td, table th { vertical-align: middle !important; }
    .badge-due { background:#e63946; }
    .badge-ok  { background:#2a9d8f; }
    .badge-soon{ background:#ffb703; color:#000; }
  </style>
</head>
<body>
<div class="container">
  <h3 class="mb-4"><i class="fa-solid fa-wrench"></i> Lok- & Wagenwartung</h3>

  <div class="mb-3">
    <button class="btn btn-sm btn-outline-secondary" onclick="loadData()">
      <i class="fa-solid fa-rotate"></i> Aktualisieren
    </button>
    <button class="btn btn-sm btn-success" onclick="saveData()">
      <i class="fa-solid fa-floppy-disk"></i> Änderungen speichern
    </button>
  </div>

  <div id="tableArea" class="table-responsive">
    <p><em>Daten werden geladen…</em></p>
  </div>

  <div id="alertBox" class="mt-3"></div>
</div>

<script>
function statusBadge(dateStr) {
  if(!dateStr) return '<span class="badge bg-secondary">–</span>';
  const date = new Date(dateStr);
  const diff = (Date.now() - date.getTime()) / (1000*3600*24);
  if(diff > 365) return `<span class="badge badge-due">Überfällig</span>`;
  if(diff > 300) return `<span class="badge badge-soon">bald</span>`;
  return `<span class="badge badge-ok">ok</span>`;
}

function loadData() {
  fetch('api/wartung_list.php')
    .then(r => r.json())
    .then(data => {
      let html = '<table class="table table-sm table-bordered align-middle">';
      html += '<thead class="table-light"><tr><th>ID</th><th>Name</th><th>Typ</th><th>Letzte Wartung</th><th>Status</th><th>Bemerkung</th></tr></thead><tbody>';
      data.forEach(row => {
        html += `<tr>
          <td>${row.id}</td>
          <td>${row.name}</td>
          <td>${row.type}</td>
          <td><input type="date" class="form-control form-control-sm" value="${row.last_service||''}" data-id="${row.id}" data-field="last_service"></td>
          <td>${statusBadge(row.last_service)}</td>
          <td><input type="text" class="form-control form-control-sm" value="${row.note||''}" data-id="${row.id}" data-field="note"></td>
        </tr>`;
      });
      html += '</tbody></table>';
      document.getElementById('tableArea').innerHTML = html;
    })
    .catch(e => {
      document.getElementById('tableArea').innerHTML = `<p class='text-danger'>Fehler beim Laden: ${e}</p>`;
    });
}

function saveData() {
  const inputs = document.querySelectorAll('input[data-id]');
  const data = {};
  inputs.forEach(inp => {
    const id = inp.dataset.id;
    if(!data[id]) data[id] = {};
    data[id][inp.dataset.field] = inp.value;
  });

  fetch('api/wartung_save.php', {
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify(data)
  })
  .then(r=>r.text())
  .then(txt=>{
    document.getElementById('alertBox').innerHTML = `<div class="alert alert-success p-2">${txt}</div>`;
    loadData();
  })
  .catch(err=>{
    document.getElementById('alertBox').innerHTML = `<div class="alert alert-danger p-2">${err}</div>`;
  });
}

loadData();
</script>
</body>
</html>
