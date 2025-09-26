<?php
$host = "localhost";
$db   = "Prometeus_CRM";
$user = "root";
$pass = "root1";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}
?>