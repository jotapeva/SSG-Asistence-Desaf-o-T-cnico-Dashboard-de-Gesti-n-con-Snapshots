drop database Prometeus_CRM;
create database Prometeus_CRM;
use Prometeus_CRM;

-- Todo brindado por Gonzalo --

CREATE TABLE `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(4) NOT NULL,                    -- FK hacia users_tipos.id
  `id_estado` int(2) NOT NULL,                  -- FK hacia users_estados.id  
  `id_grupo` int(4) NOT NULL,                   -- FK hacia users_grupos.id
  `id_categoria` int(8) NOT NULL,               -- FK hacia users_categorias.id
  `ci` int(8) NOT NULL,                         -- Cédula de identidad del usuario
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `apellido` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `usuario` char(32) COLLATE utf8_spanish_ci NOT NULL,  -- Login único
  `password` text COLLATE utf8_spanish_ci NOT NULL,     -- Hash de la contraseña
  `id_tipo_escala` int(2) NOT NULL,             -- Relacionado con esquema de comisiones
  PRIMARY KEY (`id`),
  KEY `id_tipo` (`id_tipo`,`id_estado`,`id_grupo`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_estado` (`id_estado`),
  KEY `id_grupo` (`id_grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `users_tipos` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `users_estados` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `users_grupos` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `users_categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `contactos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_estado` int(4) NOT NULL,                  -- FK hacia contactos_estado.id
  `id_domicilio` int(10) UNSIGNED NOT NULL,     -- FK hacia domicilios.id
  `id_ocupacion` int(4) NOT NULL,               -- FK hacia ocupaciones.id
  `id_estado_civil` int(2) NOT NULL,            -- FK hacia estados_civiles.id
  `ci` bigint(11) NOT NULL,                     -- Cédula de identidad
  `nombre1` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `nombre2` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `apellido1` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `apellido2` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `fc_nacimiento` int(8) NOT NULL,              -- Fecha en formato YYYYMMDD
  `sexo` char(1) COLLATE utf8_spanish_ci NOT NULL,  -- 'M' o 'F'
  `zurdo` char(1) COLLATE utf8_spanish_ci NOT NULL, -- Para seguros laborales,
  `id_tel_fijo1` int(10) NOT NULL,              -- FK hacia telefonos.id
  `id_tel_fijo2` int(10) NOT NULL,              -- FK hacia telefonos.id
  `id_tel_movil1` int(10) NOT NULL,             -- FK hacia telefonos.id
  `id_tel_movil2` int(10) NOT NULL,             -- FK hacia telefonos.id
  `email` text COLLATE utf8_spanish_ci NOT NULL,
  `id_userinsert` int(10) NOT NULL,             -- FK hacia users.id (quien creó el registro)
  `id_fuente_dato` int(10) NOT NULL,            -- FK hacia contactos_fuentes_datos.id
  `se_queda` int(1) NOT NULL,                   -- Flag para campañas de retención
  `timestamp` bigint(14) NOT NULL,              -- Fecha/hora de creación YYYYMMDDhhiiss
  `lastupdate` timestamp,
  `mascota` int(1) DEFAULT '0',                 -- Si tiene mascotas (para productos específicos)
  PRIMARY KEY (`id`),
  KEY `id_tel_fijo1` (`id_tel_fijo1`),
  KEY `id_estado` (`id_estado`),
  KEY `id_domicilio` (`id_domicilio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `contactos_estado` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;


CREATE TABLE `telefonos` (
  `id` bigint(16) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` int(2) NOT NULL,                       -- 1=Fijo, 2=Móvil
  `numero` bigint(15) UNSIGNED NOT NULL,        -- Número sin prefijos ni formatos
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero` (`numero`),
  KEY `tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `campaigns` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `id_estado` int(4) NOT NULL,                  -- FK hacia campaigns_estados.id
  `codigo` char(16) COLLATE utf8_spanish_ci NOT NULL,   -- Código único de campaña
  `nombre` char(64) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  `brokers` text COLLATE utf8_spanish_ci NOT NULL,      -- Lista de usuarios asignados (formato legacy)
  `fc_inicio` int(8) NOT NULL,                  -- Fecha inicio YYYYMMDD
  `fc_final` int(8) NOT NULL,                   -- Fecha fin YYYYMMDD
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `id_estado` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `campaigns_estados` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `gestiones` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(4) NOT NULL,                    -- FK hacia gestiones_tipo.id
  `id_campaign` int(6) NOT NULL,                -- FK hacia campaigns.id
  `id_broker` int(4) NOT NULL,                  -- FK hacia users.id (operador asignado)
  `id_contacto` int(10) NOT NULL,               -- FK hacia contactos.id
  `id_resultado` int(4) NOT NULL,               -- FK hacia gestiones_resultado.id -> 0 significa sin resultado
  `notas` text COLLATE utf8_spanish_ci NOT NULL,    -- Observaciones del operador
  `timestamp` char(14) COLLATE utf8_spanish_ci NOT NULL,  -- Fecha/hora YYYYMMDDhhiiss
  `id_tel_fijo1` int(11) NOT NULL,              -- Teléfono usado en esta gestión
  `lastupdate` timestamp,
  PRIMARY KEY (`id`),
  KEY `id_contacto` (`id_contacto`),
  KEY `id_tipo` (`id_tipo`),
  KEY `id_campaign` (`id_campaign`),
  KEY `id_broker` (`id_broker`),
  KEY `id_resultado` (`id_resultado`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE `gestiones_tipo` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;


CREATE TABLE `gestiones_resultado` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `nombre` char(32) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

