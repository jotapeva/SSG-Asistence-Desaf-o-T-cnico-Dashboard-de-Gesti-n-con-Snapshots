<?php
include 'conexion.php'; // conexión a la base
header('Content-Type: application/json; charset=utf-8');

$accion = isset($_GET['accion']) ? $_GET['accion'] : '';

if ($accion == 'listar_brokers') {
    $r = mysqli_query($conn, "SELECT id, CONCAT(nombre,' ',apellido) AS nombre FROM users WHERE id_tipo=1 ORDER BY nombre");
    $data = array();
    while ($f = mysqli_fetch_assoc($r)) { $data[] = $f; }
    echo json_encode($data);
    exit;
}

if ($accion == 'listar_campaigns') {
    $r = mysqli_query($conn, "SELECT id, nombre FROM campaigns ORDER BY nombre");
    $data = array();
    while ($f = mysqli_fetch_assoc($r)) { $data[] = $f; }
    echo json_encode($data);
    exit;
}

if ($accion == 'listar_snapshots') {
    $r = mysqli_query($conn, "SELECT * FROM dashboard_snapshots ORDER BY fecha_creacion DESC");
    $data = array();
    while ($f = mysqli_fetch_assoc($r)) { $data[] = $f; }
    echo json_encode($data);
    exit;
}

if ($accion == 'ver_snapshot') {
    $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
    $r = mysqli_query($conn, "SELECT * FROM dashboard_snapshots WHERE id=$id");
    $f = mysqli_fetch_assoc($r);
    echo json_encode($f ? $f : array());
    exit;
}

if ($accion == 'calcular_metricas') {
    $broker = isset($_GET['broker']) ? intval($_GET['broker']) : 0;
    $campaign = isset($_GET['campaign']) ? intval($_GET['campaign']) : 0;
    $filtro = "WHERE 1=1";
    if ($broker)   $filtro .= " AND g.id_broker=$broker";
    if ($campaign) $filtro .= " AND g.id_campaign=$campaign";

    $r = mysqli_query($conn, "SELECT 
        COUNT(CASE WHEN id_resultado=1 THEN 1 END) contactadas,
        COUNT(*) total
        FROM gestiones g $filtro");
    $row = mysqli_fetch_assoc($r);
    $contact = $row['total']>0 ? round($row['contactadas']/$row['total']*100,2) : 0;

    $r = mysqli_query($conn, "SELECT 
        COUNT(CASE WHEN id_resultado=2 THEN 1 END) exitosas,
        COUNT(*) total
        FROM gestiones g $filtro");
    $row = mysqli_fetch_assoc($r);
    $bruta = $row['total']>0 ? round($row['exitosas']/$row['total']*100,2) : 0;

    $r = mysqli_query($conn, "SELECT 
        COUNT(CASE WHEN id_resultado=2 THEN 1 END) exitosas,
        COUNT(CASE WHEN id_resultado<>0 THEN 1 END) atendidas
        FROM gestiones g $filtro");
    $row = mysqli_fetch_assoc($r);
    $neta = $row['atendidas']>0 ? round($row['exitosas']/$row['atendidas']*100,2) : 0;

    echo json_encode(array(
        'contactabilidad' => $contact,
        'penetracion_bruta' => $bruta,
        'penetracion_neta' => $neta
    ));
    exit;
}

if ($accion == 'guardar_snapshot') {
    $nombre   = mysqli_real_escape_string($conn, $_GET['nombre']);
    $f_ini    = empty($_GET['filtro_fecha_inicio']) ? "NULL" : "'".$_GET['filtro_fecha_inicio']."'";
    $f_fin    = empty($_GET['filtro_fecha_fin'])    ? "NULL" : "'".$_GET['filtro_fecha_fin']."'";
    $broker   = empty($_GET['filtro_id_broker'])   ? "NULL" : intval($_GET['filtro_id_broker']);
    $campaign = empty($_GET['filtro_id_campaign']) ? "NULL" : intval($_GET['filtro_id_campaign']);
    $c  = is_numeric($_GET['contactabilidad'])     ? $_GET['contactabilidad'] : 0;
    $pb = is_numeric($_GET['penetracion_bruta'])   ? $_GET['penetracion_bruta'] : 0;
    $pn = is_numeric($_GET['penetracion_neta'])    ? $_GET['penetracion_neta'] : 0;

    $sql = "INSERT INTO dashboard_snapshots
        (nombre,filtro_fecha_inicio,filtro_fecha_fin,filtro_id_broker,filtro_id_campaign,contactabilidad,penetracion_bruta,penetracion_neta)
        VALUES ('$nombre',$f_ini,$f_fin,$broker,$campaign,$c,$pb,$pn)";
    if (mysqli_query($conn, $sql)) {
        echo json_encode(array('status'=>'ok'));
    } else {
        echo json_encode(array('status'=>'error','msg'=>mysqli_error($conn)));
    }
    exit;
}

echo json_encode(array('status'=>'error','msg'=>'Acción no válida'));
?>