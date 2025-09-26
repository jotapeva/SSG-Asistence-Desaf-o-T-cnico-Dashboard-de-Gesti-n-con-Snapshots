-- LAS CONSULTAS FUERON PENSADAS SOBRE PHP Y NO PARA SER PLASMADAS EN MYSQL, PERO SE MUESTRAN AQUI APROXIMADAS COMO SE VERIAN EN SQL
use Prometeus_CRM;
-- listar_brokers
SELECT
    id,
    CONCAT(nombre, ' ', apellido) AS nombre
FROM users
WHERE id_tipo = 1
ORDER BY nombre;

-- listar_campaigns
SELECT
    id,
    nombre
FROM campaigns
ORDER BY nombre;

-- listar_snapshots
SELECT
    *
FROM dashboard_snapshots
ORDER BY fecha_creacion DESC;

-- ver_snapshot

-- Usa el id recibido por GET:

SELECT
    *
FROM dashboard_snapshots
WHERE id = :id;
-- (aquí :id es un entero pasado por parámetro)

-- METRICAS
-- Contactabilidad
-- Dependiendo de los filtros, se pueden añadir condiciones.
SELECT
    COUNT(CASE WHEN id_resultado = 1 THEN 1 END) AS contactadas,
    COUNT(*) AS total
FROM gestiones g
WHERE 1 = 1
  AND (:broker IS NULL OR g.id_broker = :broker)
  AND (:campaign IS NULL OR g.id_campaign = :campaign);


-- Penetración bruta

SELECT
    COUNT(CASE WHEN id_resultado = 2 THEN 1 END) AS exitosas,
    COUNT(*) AS total
FROM gestiones g
WHERE 1 = 1
 AND (:broker IS NULL OR g.id_broker = :broker)
  AND (:campaign IS NULL OR g.id_campaign = :campaign);


-- Penetración neta

SELECT
    COUNT(CASE WHEN id_resultado = 2  THEN 1 END) AS exitosas,
    COUNT(CASE WHEN id_resultado <> 0 THEN 1 END) AS atendidas
FROM gestiones g
WHERE 1 = 1
  AND (:broker IS NULL OR g.id_broker = :broker)
  AND (:campaign IS NULL OR g.id_campaign = :campaign);

-- :id, :broker y :campaign son parámetros de consulta que tu aplicación debe vincular antes de ejecutar.