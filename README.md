# SSG Assistance – Desafío Técnico: Dashboard de Gestión con Snapshots

## Descripción del proyecto

Este proyecto es un **Dashboard web** que permite visualizar métricas de contacto y ventas, aplicar filtros por fechas, agentes y campañas, y guardar snapshots de los resultados.  
Lo desarrollé como un desafío personal para aprender nuevas tecnologías y mejorar mi manera de presentar información.

El objetivo principal era **crear un sistema funcional desde cero**, integrando PHP, MySQL y JavaScript, y mostrar métricas clave de supervisión de campañas.

---

## Prioridades y enfoque

Parte del desafío consiste en **priorizar dentro del tiempo disponible**. Para este proyecto, decidí enfocarme primero en:

1. **Conexión y consultas de datos**: asegurarme de que la API en PHP pudiera traer correctamente la información de MySQL.
2. **Visualización de métricas**: calcular y mostrar contactabilidad, penetración bruta y penetración neta.
3. **Filtros dinámicos**: permitir filtrar por fecha, agente y campaña.
4. **Snapshots**: almacenar los resultados filtrados para consultas posteriores.

El enfoque de priorización fue **hacer que el flujo básico funcionara primero**: desde la base de datos hasta la visualización en el frontend. Una vez establecida esta funcionalidad principal, implementé filtros y la funcionalidad de snapshots.

---

## Mi experiencia al desarrollarlo

Cuando empecé, no tenía experiencia previa con PHP. Solo había trabajado con bases de datos y algo de HTML/CSS/JS, pero nunca había creado una API.  

Para resolverlo:

- Investigué tutoriales, documentación y ejemplos de PHP y MySQL.
- Me apoyé en inteligencia artificial para comprender mejor cómo estructurar la API y conectar todo.
- Aprendí a usar `fetch` en JavaScript para consumir datos dinámicos y manejar respuestas JSON.
- Resolví errores de sintaxis en SQL y depuré consultas complejas.
- Utilice mucha ia para corregir errores de sintaxis ya que no tenia idea

Fue un proceso de **prueba y error**, pero me permitió aprender mucho en poco tiempo.

---

## Instalación y ejecución

### Requisitos

- [XAMPP](https://www.apachefriends.org/index.html) (incluye Apache y MySQL)

### Pasos

1. **Instalar XAMPP**: asegurarse de seleccionar Apache y MySQL durante la instalación.
2. **Clonar o copiar el proyecto**: colocar los archivos dentro de la carpeta `htdocs` (por ejemplo: `C:\xampp\htdocs\dashboard`).
3. **Iniciar servicios**: abrir el Panel de Control de XAMPP y arrancar Apache y MySQL.
4. **Abrir el Dashboard**: en el navegador, entrar a `http://localhost/dashboard/index.html`.

---

## Base de datos

1. Crear la base de datos e importar las tablas y datos de ejemplo incluidos en el repositorio.
2. Crear una tabla extra para los snapshots:

```sql
USE Prometeus_CRM;

CREATE TABLE dashboard_snapshots (
    id INT(10) NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(64) NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    filtro_fecha_inicio INT(8) DEFAULT NULL, -- YYYYMMDD
    filtro_fecha_fin INT(8) DEFAULT NULL,    -- YYYYMMDD
    filtro_id_broker INT(10) DEFAULT NULL,
    filtro_id_campaign INT(10) DEFAULT NULL,
    contactabilidad DECIMAL(5,2) DEFAULT 0,
    penetracion_bruta DECIMAL(5,2) DEFAULT 0,
    penetracion_neta DECIMAL(5,2) DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_fecha (fecha_creacion),
    KEY idx_broker (filtro_id_broker),
    KEY idx_campaign (filtro_id_campaign)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
## Ejemplo de inserción

```sql
INSERT INTO dashboard_snapshots (
    nombre, filtro_fecha_inicio, filtro_fecha_fin, filtro_id_broker, filtro_id_campaign,
    contactabilidad, penetracion_bruta, penetracion_neta
)
VALUES (
    'Snapshot 26-09-2025',
    20250901, 20250926, 5, 2,
    35.50, 10.25, 29.00
);
```
# Fórmulas de métricas
Contactabilidad (%) = (Contactos efectivos / Total de registros) * 100

Penetración Bruta (%) = (Total de ventas / Total de registros) * 100

Penetración Neta (%) = (Ventas efectivas / Contactos efectivos) * 100

# Consultas SQL principales
```sql
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
```
# Lo que aprendí
Cómo conectar JavaScript con PHP usando fetch y APIs.

Manejar errores y depurar consultas SQL.

Priorizar funcionalidades clave antes de agregar detalles: datos, métricas, filtros y snapshots.

Aprendí mucho PHP en menos de 24 horas gracias a la práctica y a la investigación activa.

Si querés probarlo, con solo tener XAMPP instalado, podés levantarlo en tu propia computadora y ver las métricas en vivo.
