use Prometeus_CRM;
CREATE TABLE dashboard_snapshots (
    id INT(10) NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(64) NOT NULL,             -- Nombre del snapshot
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    filtro_fecha_inicio INT(8) DEFAULT NULL, -- YYYYMMDD
    filtro_fecha_fin INT(8) DEFAULT NULL,    -- YYYYMMDD
    filtro_id_broker INT(10) DEFAULT NULL,   -- ID del agente
    filtro_id_campaign INT(10) DEFAULT NULL, -- ID de la campaña
    contactabilidad DECIMAL(5,2) DEFAULT 0,  -- Porcentaje
    penetracion_bruta DECIMAL(5,2) DEFAULT 0, -- Porcentaje
    penetracion_neta DECIMAL(5,2) DEFAULT 0,  -- Porcentaje
    PRIMARY KEY (id),
    KEY idx_fecha (fecha_creacion),
    KEY idx_broker (filtro_id_broker),
    KEY idx_campaign (filtro_id_campaign)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ASI SE INSERTAN LOS SNAPSHOTS
INSERT INTO dashboard_snapshots (nombre,filtro_fecha_inicio,filtro_fecha_fin,filtro_id_broker,filtro_id_campaign,contactabilidad,penetracion_bruta,penetracion_neta
)
VALUES (
    'Snapshot 26-09-2025',
    20250901,
    20250926,
    5,     -- ID del agente
    2,     -- ID de la campaña
    35.50, -- Contactabilidad %
    10.25, -- Penetración Bruta %
    29.00  -- Penetración Neta %
);