# SSG-Asistence-Desaf-o-T-cnico-Dashboard-de-Gesti-n-con-Snapshots
Dashboard de Supervisión – Proyecto Personal

Este proyecto es un Dashboard web que permite visualizar métricas de contacto y ventas, aplicar filtros por fechas, agentes y campañas, y guardar snapshots de los resultados.
Lo desarrollé como un desafío personal para aprender nuevas tecnologías y mejorar mi manera de presentar información.

Mi experiencia al desarrollarlo

Cuando empecé, no sabía nada de PHP. Siempre había trabajado con bases de datos y algo de HTML/CSS, pero nunca había creado una API.
Para resolverlo, investigué bastante, leí tutoriales y también me apoyé en inteligencia artificial (IA) para entender cómo estructurar el código, manejar las consultas a MySQL y conectar todo desde cero.

Fue un proceso de prueba y error: desde crear las tablas hasta depurar errores de sintaxis en SQL, aprendí a usar fetch en JavaScript para traer datos dinámicos y a pensar cómo estructurar una API en PHP, algo que al principio me parecía imposible.

# Instalación y ejecución

Para correr este proyecto, usé XAMPP porque es una herramienta que ya viene con Apache y MySQL, y me simplificó mucho no tener que instalar todo por separado.

Instalar XAMPP

Descargá XAMPP desde su página oficial.

Durante la instalación, asegurate de que Apache y MySQL estén seleccionados.

Clonar o copiar el proyecto

Colocá los archivos del proyecto dentro de la carpeta htdocs que viene en XAMPP (por ejemplo: C:\xampp\htdocs\dashboard).

# Iniciar servicios

Abrí el Panel de Control de XAMPP.

Iniciá Apache y MySQL.

Base de datos

Entrá a http://localhost/phpmyadmin y creá una base de datos (por ejemplo, prometeus_crm).

Importá el archivo SQL con las tablas y datos de ejemplo (lo incluí en la carpeta /sql).

# Abrir el Dashboard

En tu navegador, entrá a: http://localhost/dashboard/index.html.

¡Listo! Con eso ya podés empezar a usarlo.


# Base de Datos

Creé la base Prometeus_CRM y le puse la estructura brindada por SSg con sus tablas principales y datos de prueba.

Solo tuve que crear una tabla extra para los snapshots.

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

Ejemplo de inserción real que probé:
INSERT INTO dashboard_snapshots (
    nombre,
    filtro_fecha_inicio,
    filtro_fecha_fin,
    filtro_id_broker,
    filtro_id_campaign,
    contactabilidad,
    penetracion_bruta,
    penetracion_neta
)
VALUES (
    'Snapshot 26-09-2025',
    20250901,
    20250926,
    5,
    2,
    35.50,
    10.25,
    29.00
);

# Fórmulas de las métricas

Estas son las fórmulas que usé para calcular las métricas principales:

Contactabilidad (%)
(Contactos efectivos / Total de registros) * 100

Penetración Bruta (%)
(Total de ventas / Total de registros) * 100

Penetración Neta (%)
(Ventas efectivas / Contactos efectivos) * 100

Son cálculos simples pero fundamentales para supervisar el rendimiento de las campañas.

# Ejemplos de consultas SQL

Algunas de las consultas que usa la API para traer datos:

-- Listar agentes
SELECT id_broker, nombre FROM brokers;

-- Listar campañas
SELECT id_campaign, nombre FROM campaigns;

-- Calcular métricas filtradas
SELECT 
    (SUM(contactos_efectivos) / COUNT(*)) * 100 AS contactabilidad,
    (SUM(ventas) / COUNT(*)) * 100 AS penetracion_bruta,
    (SUM(ventas_efectivas) / SUM(contactos_efectivos)) * 100 AS penetracion_neta
FROM registros
WHERE fecha BETWEEN '2024-01-01' AND '2024-01-31';

# Lo que aprendí

Cómo conectar JavaScript con PHP a través de fetch y APIs.

A manejar errores de SQL (varios :( ).

Que no es necesario saberlo todo antes de empezar: investigar y pedir ayuda a la IA me permitió avanzar mucho más rápido.

Aprendi muchisimo PHP en menos de 24hs, era un inexperto total, pero buen autodiracta.

¿Querés probarlo?
Con solo tener XAMPP instalado, podés levantarlo en tu propia computadora y ver las métricas en vivo.
