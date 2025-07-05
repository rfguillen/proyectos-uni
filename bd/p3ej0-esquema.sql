/*
Asignatura: Bases de Datos
Curso: 2024/25 
Convocatoria: junio

Practica: P1. Diseno Logico
---------------------------
Cuenta Oracle:  <------ PON TU CUENTA
Estudiante(s): Rafael Guillen Garcia       <------ PON LOS NOMBRES COMPLETOS
---------------------------
*/
-- opcional:
-- Sentencias DROP para re-ejecucion del script
-- en el orden inverso al de creacion

-- Sentencias CREATE (y ALTER) para crear las tablas del esquema
-- en el orden que evite errores de integridad referencial

DROP TABLE PARTICIPACION CASCADE CONSTRAINTS;
DROP TABLE EMAIL_CONTACTO;
DROP TABLE MENSAJE CASCADE CONSTRAINTS;
DROP TABLE CHAT_GRUPO;
DROP TABLE CONTACTO CASCADE CONSTRAINTS;
DROP TABLE MIUSUARIO CASCADE CONSTRAINTS;

CREATE TABLE miusuario (
    telefono NUMBER(9) PRIMARY KEY, -- Clave principal
    fecha_registro DATE NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    idioma VARCHAR(15) NOT NULL,
    descripcion VARCHAR(30) NULL
    );
        
CREATE TABLE contacto( -- 6 Columnas
    telefono NUMBER(9) NOT NULL,
    usuario NUMBER(9) NOT NULL,
    nombre VARCHAR(25) NOT NULL, -- Quitado UNIQUE
    apellidos VARCHAR(25) NULL,
    dia NUMBER(2) CHECK(dia > 0 AND dia < 32) NULL,
    mes NUMBER(2) CHECK(mes > 0 AND mes < 13) NULL,
    PRIMARY KEY (usuario, telefono),
    CONSTRAINT fk_usuario FOREIGN KEY (usuario) REFERENCES miusuario(telefono) ON DELETE CASCADE, -- Clave ajena hacia usuario. Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle
    CONSTRAINT chk_dia CHECK ((dia IS NULL AND mes IS NULL) OR (dia IS NOT NULL AND mes IS NOT NULL)) -- Check para que dia_cumple y mes_cumple sean ambos nulos o ninguno nulo
    );
        
CREATE TABLE email_contacto (
    usuario NUMBER(9) NOT NULL,
    contacto NUMBER(9) NOT NULL,
    email VARCHAR(20) NOT NULL,
    PRIMARY KEY(usuario, contacto, email),
    CONSTRAINT fk_usuario_email FOREIGN KEY(usuario, contacto) REFERENCES contacto(usuario, telefono) ON DELETE CASCADE -- Indicado ON DELETE. Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle
    );

CREATE TABLE chat_grupo ( -- 6 columnas
    codigo CHAR(4) NOT NULL PRIMARY KEY, -- C?digo no nulo
    nombre VARCHAR(20) NOT NULL,
    fecha_creacion DATE NOT NULL, -- Fecha no nulo
    miembros NUMBER(3) DEFAULT 0 NOT NULL, -- Es un atributo calculado
    administrador NUMBER(9) NOT NULL,
    msj_anclado CHAR(8) UNIQUE NULL, -- Quitamos el NOT NULL para pode hacer inserciones
    descripcion VARCHAR2(50) NULL,
    CONSTRAINT fk_admin FOREIGN KEY(administrador) REFERENCES miusuario(telefono) ON DELETE CASCADE -- Indicado ON DELETE. Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle
    );
    
CREATE TABLE mensaje (
    mensaje_id CHAR(8) PRIMARY KEY,
    reenviado CHAR(2) CHECK(reenviado IN('SI','NO')),
    diahora DATE NOT NULL,
    usuario NUMBER(9) NOT NULL,
    chat_grupo CHAR(4) NOT NULL,
    msj_original CHAR(8) NULL,
    CONSTRAINT fk_usuario_mensaje FOREIGN KEY(usuario) REFERENCES miusuario(telefono) ON DELETE CASCADE, -- Indicado ON DELETE. Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle
    CONSTRAINT chat_grupo_pk FOREIGN KEY(chat_grupo) REFERENCES chat_grupo(codigo) ON DELETE CASCADE, -- Definida clave ajena hacia el chat. Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle
    CONSTRAINT msj_original_pk FOREIGN KEY(msj_original) REFERENCES mensaje(mensaje_id) ON DELETE SET NULL, -- Definida referencia a mensaje (autorreferencia). Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle
    CONSTRAINT no_respuesta_igual_original_pk CHECK (mensaje_id != msj_original) -- Un mensaje no se responde a s? mismo.
    );

ALTER TABLE chat_grupo ADD CONSTRAINT msj_anclado_pk FOREIGN KEY(msj_anclado) REFERENCES mensaje(mensaje_id) ON DELETE CASCADE; -- Indicado ON DELETE. Falta el ON UPDATE CASCADE porque no se puede implementar en Oracle

CREATE TABLE participacion (
   usuario      NUMBER(9) NOT NULL, 
   chat_grupo   CHAR(4)   NOT NULL,  
   fecha_inicio DATE      NOT NULL,
   CONSTRAINT participacion_pk PRIMARY KEY(usuario, chat_grupo),
   --
   CONSTRAINT participacion_fk_usuario
      FOREIGN KEY(usuario) REFERENCES miusuario(telefono),
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
   CONSTRAINT participacion_fk_chatgrupo
      FOREIGN KEY(chat_grupo) REFERENCES chat_grupo(codigo) 
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
);