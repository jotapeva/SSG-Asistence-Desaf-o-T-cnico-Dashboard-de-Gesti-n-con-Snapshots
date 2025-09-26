// Cargar opciones de brokers y campañas
function cargarFiltros() {
    fetch('dashboard_api.php?accion=listar_brokers')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (!Array.isArray(data)) { data = []; }
            var sel = document.getElementById('id_broker');
            for (var i = 0; i < data.length; i++) {
                var opt = document.createElement('option');
                opt.value = data[i].id;
                opt.text = data[i].nombre;
                sel.appendChild(opt);
            }
        });

    fetch('dashboard_api.php?accion=listar_campaigns')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (!Array.isArray(data)) { data = []; }
            var sel = document.getElementById('id_campaign');
            for (var i = 0; i < data.length; i++) {
                var opt = document.createElement('option');
                opt.value = data[i].id;
                opt.text = data[i].nombre;
                sel.appendChild(opt);
            }
        });
}

// Cargar lista de snapshots
function cargarSnapshots() {
    fetch('dashboard_api.php?accion=listar_snapshots')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (!Array.isArray(data)) { data = []; }
            var tbody = document.querySelector('#tabla_snapshots tbody');
            tbody.innerHTML = '';
            for (var i = 0; i < data.length; i++) {
                var fila = '<tr>'
                    + '<td>' + data[i].id + '</td>'
                    + '<td>' + data[i].fecha_creacion + '</td>'
                    + '<td>' + data[i].contactabilidad + '%</td>'
                    + '<td>' + data[i].penetracion_bruta + '%</td>'
                    + '<td>' + data[i].penetracion_neta + '%</td>'
                    + '<td><button onclick="verSnapshot(' + data[i].id + ')">Ver</button></td>'
                    + '</tr>';
                tbody.innerHTML += fila;
            }
        });
}

// Ver un snapshot
function verSnapshot(id) {
    fetch('dashboard_api.php?accion=ver_snapshot&id=' + id)
        .then(function(res) { return res.json(); })
        .then(function(snap) {
            document.getElementById('contactabilidad').innerText = snap.contactabilidad + '%';
            document.getElementById('penetracion_bruta').innerText = snap.penetracion_bruta + '%';
            document.getElementById('penetracion_neta').innerText = snap.penetracion_neta + '%';
        });
}

// Calcular métricas
function calcularMetricas() {
    var broker = document.getElementById('id_broker').value || '';
    var campaign = document.getElementById('id_campaign').value || '';
    fetch('dashboard_api.php?accion=calcular_metricas&broker=' + broker + '&campaign=' + campaign)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            document.getElementById('contactabilidad').innerText = data.contactabilidad + '%';
            document.getElementById('penetracion_bruta').innerText = data.penetracion_bruta + '%';
            document.getElementById('penetracion_neta').innerText = data.penetracion_neta + '%';
        });
}

// Guardar snapshot
function guardarSnapshot() {
    var nombre = prompt("Ingrese un nombre para el snapshot:") || "Snapshot sin nombre";
    var f_ini = document.getElementById('fecha_inicio').value.replace(/-/g,'') || '';
    var f_fin = document.getElementById('fecha_fin').value.replace(/-/g,'') || '';
    var broker = document.getElementById('id_broker').value;
    var campaign = document.getElementById('id_campaign').value;
    var filtro_broker = broker === "" ? "NULL" : broker;
    var filtro_campaign = campaign === "" ? "NULL" : campaign;
    var c = document.getElementById('contactabilidad').innerText.replace('%','') || 0;
    var pb = document.getElementById('penetracion_bruta').innerText.replace('%','') || 0;
    var pn = document.getElementById('penetracion_neta').innerText.replace('%','') || 0;

    var url = 'dashboard_api.php?accion=guardar_snapshot'
        + '&nombre=' + encodeURIComponent(nombre)
        + '&filtro_fecha_inicio=' + f_ini
        + '&filtro_fecha_fin=' + f_fin
        + '&filtro_id_broker=' + filtro_broker
        + '&filtro_id_campaign=' + filtro_campaign
        + '&contactabilidad=' + c
        + '&penetracion_bruta=' + pb
        + '&penetracion_neta=' + pn;

    fetch(url)
        .then(function(res) { return res.json(); })
        .then(function(resp) {
            if (resp.status == 'ok') {
                alert('Snapshot guardado con éxito');
                cargarSnapshots();
            } else {
                alert('Error: ' + resp.msg);
            }
        });
}

// Iniciar
window.onload = function() {
    cargarFiltros();
    cargarSnapshots();
    calcularMetricas();

    document.getElementById('aplicar_filtros').addEventListener('click', function() {
        calcularMetricas();
        cargarSnapshots();
    });

    document.getElementById('guardar_snapshot').addEventListener('click', function() {
        guardarSnapshot();
    });
};