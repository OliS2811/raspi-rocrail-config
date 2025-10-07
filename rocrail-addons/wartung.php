<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<title>Lok- & Wagenwartung</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4 bg-light">
<h3>🚂 Lok- & Wagenwartung</h3>
<div id="wartung-table">Lade Lokdaten...</div>

<form id="wartungForm" class="mt-4">
  <div class="row g-2">
    <div class="col-md-3"><input class="form-control" id="lok" placeholder="Lok-ID" required></div>
    <div class="col-md-3"><input class="form-control" type="date" id="datum" required></div>
    <div class="col-md-4"><input class="form-control" id="text" placeholder="Kommentar" required></div>
    <div class="col-md-2"><button class="btn btn-primary w-100" type="submit">💾 Speichern</button></div>
  </div>
</form>

<script>
function ladeLoks() {
  fetch('api/wartung_list.php')
    .then(r=>r.json())
    .then(data=>{
      let html='<table class="table table-striped mt-3"><thead><tr><th>Lok</th><th>Typ</th><th>Adresse</th><th>Betriebszeit (h)</th><th>Letzte Wartung</th><th>Kommentar</th></tr></thead><tbody>';
      data.forEach(l=>{
        html+=`<tr><td>${l.id}</td><td>${l.engine}</td><td>${l.addr}</td><td>${l.runtime}</td><td>${l.last||'-'}</td><td>${l.comment||'-'}</td></tr>`;
      });
      html+='</tbody></table>';
      document.getElementById('wartung-table').innerHTML=html;
    });
}
document.getElementById('wartungForm').addEventListener('submit',e=>{
  e.preventDefault();
  const f=new FormData(e.target);
  fetch('api/wartung_save.php',{method:'POST',body:f})
    .then(r=>r.text())
    .then(t=>{alert(t);ladeLoks();});
});
ladeLoks();
</script>
</body>
</html>