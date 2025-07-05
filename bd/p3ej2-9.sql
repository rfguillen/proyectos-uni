/*
Asignatura: Bases de Datos
Curso: 2024/25

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas:
 Integrante 1: RAFAEL GUILLÉN GARCÍA
*/

--------------------------------------------------------------------------------------
-- EJERCICIO 2. Annadir / Eliminar columnas

--a) Añade una columna llamada texto en la tabla MENSAJE, de tipo cadena de caracteres de longitud
--variable con tamaño máximo 35, y que admita nulos.

ALTER TABLE MENSAJE
    ADD (texto VARCHAR(35) NULL);

--b) Añade una columna llamada numero_mensajes en la tabla MIUSUARIO, de tipo numérico con 3
--dígitos, valor por defecto 0 y que no admita nulos.

ALTER TABLE MIUSUARIO
    ADD (numero_mensajes NUMBER(3) DEFAULT 0 NOT NULL);

--c) Elimina la columna de tabla MIUSUARIO que contiene la descripción.
  
ALTER TABLE MIUSUARIO
    DROP COLUMN descripcion;

--------------------------------------------------------------------------------------
-- EJERCICIO 3. Modificar valores de una columna 

--a) Redacta una sola sentencia UPDATE que, para todo usuario, calcule el número de mensajes que ha
--redactado cada uno, y lo introduzca en la columna numero_mensajes de MIUSUARIO.

UPDATE MIUSUARIO u
SET numero_mensajes = (SELECT COUNT(*)
                      FROM MENSAJE m
                      WHERE m.usuario = u.telefono);
                       
COMMIT;

--b) Modifica el mensaje anclado en los chats de grupo cuyo último mensaje ha sido publicado antes del
--03/04/2024, de forma que el texto del mensaje contenga esto:
--'CHAT ANTIGUO: VALORA SU BORRADO'.

UPDATE MENSAJE m
SET texto = 'CHAT ANTIGUO: VALORA SU BORRADO'
WHERE EXISTS (SELECT 1 
             FROM CHAT_GRUPO c
             WHERE m.mensaje_id = c.msj_anclado
             AND EXISTS (SELECT 1
                        FROM MENSAJE m1
                        WHERE m1.chat_grupo = c.codigo
                        AND m1.diahora < TO_DATE('03/04/2024', 'DD/MM/YYYY')));

--c) Muestra mediante una SELECT los mensajes anclados de los chats indicados en b)

SELECT m.texto
FROM MENSAJE m
WHERE m.mensaje_id IN (SELECT msj_anclado
                      FROM CHAT_GRUPO);

SELECT m.texto
FROM MENSAJE m
WHERE m.mensaje_id IN (SELECT msj_anclado
                      FROM CHAT_GRUPO c
                      WHERE EXISTS (SELECT 1
                                  FROM MENSAJE m1
                                  WHERE m1.diahora < TO_DATE('03/04/2024', 'DD/MM/YYYY')
                                  AND m1.chat_grupo = c.codigo));

--d) Deshaz la modificación realizada en el paso b)

ROLLBACK;

SELECT m.texto
FROM MENSAJE m
WHERE m.mensaje_id IN (SELECT msj_anclado
                      FROM CHAT_GRUPO);

--------------------------------------------------------------------------------------
-- EJERCICIO 4. Modificar el valor de una clave primaria 

-- Desactivar restricciones de integridad referencial
ALTER TABLE CONTACTO DISABLE CONSTRAINT fk_usuario;
ALTER TABLE EMAIL_CONTACTO DISABLE CONSTRAINT fk_usuario_email;
ALTER TABLE MENSAJE DISABLE CONSTRAINT fk_usuario_mensaje;
ALTER TABLE CHAT_GRUPO DISABLE CONSTRAINT fk_admin;
ALTER TABLE PARTICIPACION DISABLE CONSTRAINT participacion_fk_usuario;

-- Actualizar todas las referencias
UPDATE CONTACTO
SET usuario = 610000004
WHERE usuario = 600000004;

UPDATE CONTACTO
SET telefono = 610000004
WHERE telefono = 600000004;

UPDATE EMAIL_CONTACTO
SET usuario = 610000004
WHERE usuario = 600000004;

UPDATE EMAIL_CONTACTO
SET contacto = 610000004
WHERE contacto = 600000004;

UPDATE MENSAJE
SET usuario = 610000004
WHERE usuario = 600000004;

UPDATE CHAT_GRUPO
SET administrador = 610000004
WHERE administrador = 600000004;

UPDATE PARTICIPACION
SET usuario = 610000004
WHERE usuario = 600000004;

UPDATE MIUSUARIO
SET telefono = 610000004
WHERE telefono = 600000004;

COMMIT;

-- Reactivar restricciones de integridad referencial
ALTER TABLE CONTACTO ENABLE CONSTRAINT fk_usuario;
ALTER TABLE EMAIL_CONTACTO ENABLE CONSTRAINT fk_usuario_email;
ALTER TABLE MENSAJE ENABLE CONSTRAINT fk_usuario_mensaje;
ALTER TABLE CHAT_GRUPO ENABLE CONSTRAINT fk_admin;
ALTER TABLE PARTICIPACION ENABLE CONSTRAINT participacion_fk_usuario;

-- Comprobaciones
SELECT * FROM MIUSUARIO WHERE telefono IN ('600000004', '610000004');
SELECT * FROM CONTACTO WHERE usuario IN ('600000004', '610000004') OR telefono IN ('600000004', '610000004');
SELECT * FROM EMAIL_CONTACTO WHERE usuario IN ('600000004', '610000004') OR contacto IN ('600000004', '610000004');
SELECT * FROM MENSAJE WHERE usuario IN ('600000004', '610000004');
SELECT * FROM CHAT_GRUPO WHERE administrador IN ('600000004', '610000004');
SELECT * FROM PARTICIPACION WHERE usuario IN ('600000004', '610000004');

COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 5. Borrar algunas filas de una tabla.

--a) Elimina mensajes cuya fecha es anterior al 10/02/2025, que no están anclados en ningún chat,
--que sean la respuesta a algún otro, que están publicados en chats de grupo con más de 3 miembros,
--y que han sido escritos por un usuario que pertenece a menos de 4 chats.

-- Consulta previa para identificar las filas a eliminar.
SELECT m.mensaje_id
FROM MENSAJE m
WHERE m.diahora < TO_DATE('10/02/2025', 'DD/MM/YYYY')
  AND m.mensaje_id NOT IN (SELECT msj_anclado FROM CHAT_GRUPO)
  AND m.msj_original IS NOT NULL
  AND m.chat_grupo IN (SELECT c.codigo
                       FROM CHAT_GRUPO c
                       WHERE c.miembros > 3)
  AND m.usuario IN (SELECT u.telefono
                    FROM MIUSUARIO u
                    JOIN MENSAJE m2 ON u.telefono = m2.usuario
                    GROUP BY u.telefono
                    HAVING COUNT(DISTINCT m2.chat_grupo) < 4);

-- Eliminación de las filas identificadas.
DELETE FROM MENSAJE
WHERE mensaje_id IN ('MSJ00104', 'MSJ00506', 'MSJ01005', 'MSJ00504', 'MSJ01008');

-- Comprobación tras la eliminación.
SELECT m.mensaje_id
FROM MENSAJE m
WHERE m.diahora < TO_DATE('10/02/2025', 'DD/MM/YYYY')
  AND m.mensaje_id NOT IN (SELECT msj_anclado FROM CHAT_GRUPO)
  AND m.msj_original IS NOT NULL
  AND m.chat_grupo IN (SELECT c.codigo
                       FROM CHAT_GRUPO c
                       WHERE c.miembros > 3)
  AND m.usuario IN (SELECT u.telefono
                    FROM MIUSUARIO u
                    JOIN MENSAJE m2 ON u.telefono = m2.usuario
                    GROUP BY u.telefono
                    HAVING COUNT(DISTINCT m2.chat_grupo) < 4);

-- Confirmación de los cambios realizados.
COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 6. Borrar algunas filas de varias tablas.

--a) Elimina todos los datos referentes al chat de grupo con código ‘C004’.

-- Eliminación de las participaciones relacionadas.
DELETE FROM PARTICIPACION
WHERE chat_grupo = 'C004';

-- Eliminación de los mensajes relacionados.
DELETE FROM MENSAJE
WHERE chat_grupo = 'C004';

-- Eliminación del chat de grupo.
DELETE FROM CHAT_GRUPO
WHERE codigo = 'C004';

-- Comprobaciones tras la eliminación.
SELECT * FROM PARTICIPACION WHERE chat_grupo = 'C004';
SELECT * FROM MENSAJE WHERE chat_grupo = 'C004';
SELECT * FROM CHAT_GRUPO WHERE codigo = 'C004';

-- Confirmación de los cambios realizados.
COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 7. Crear y manipular una vista.

--a) Define una vista llamada INTERACCION_ADMIN.
CREATE VIEW INTERACCION_ADMIN (tel_admin, nom_admin, f_registro, nom_chat, n_mensajes)
AS
SELECT u.telefono, u.nombre, u.fecha_registro, c.nombre, f.n_mensajes
FROM MIUSUARIO u
JOIN CHAT_GRUPO c ON u.telefono = c.administrador
JOIN (SELECT m.usuario, m.chat_grupo, COUNT(*) AS n_mensajes
      FROM MENSAJE m
      GROUP BY m.usuario, m.chat_grupo) f
ON u.telefono = f.usuario AND c.codigo = f.chat_grupo;

--b) Muestra el contenido completo de la vista, ordenado por nom_admin y nom_chat.
SELECT *
FROM INTERACCION_ADMIN
ORDER BY nom_admin, nom_chat;

--c.1) Modifica la vista para eliminar la columna f_registro.
CREATE OR REPLACE VIEW INTERACCION_ADMIN (tel_admin, nom_admin, nom_chat, n_mensajes)
AS
SELECT u.telefono, u.nombre, c.nombre, f.n_mensajes
FROM MIUSUARIO u
JOIN CHAT_GRUPO c ON u.telefono = c.administrador
JOIN (SELECT m.usuario, m.chat_grupo, COUNT(*) AS n_mensajes
      FROM MENSAJE m
      GROUP BY m.usuario, m.chat_grupo) f
ON u.telefono = f.usuario AND c.codigo = f.chat_grupo;

--c.2) Modifica la vista para añadir la columna total_mensajes.
CREATE OR REPLACE VIEW INTERACCION_ADMIN (tel_admin, nom_admin, nom_chat, n_mensajes, total_mensajes)
AS
SELECT u.telefono, u.nombre, c.nombre, f.n_mensajes, f1.total_mensajes
FROM MIUSUARIO u
JOIN CHAT_GRUPO c ON u.telefono = c.administrador
JOIN (SELECT m.usuario, m.chat_grupo, COUNT(*) AS n_mensajes
      FROM MENSAJE m
      GROUP BY m.usuario, m.chat_grupo) f
ON u.telefono = f.usuario AND c.codigo = f.chat_grupo
JOIN (SELECT m.chat_grupo, COUNT(*) AS total_mensajes
      FROM MENSAJE m
      GROUP BY m.chat_grupo) f1
ON f1.chat_grupo = c.codigo;

-- Visualización de la vista tras la modificación.
SELECT *
FROM INTERACCION_ADMIN
ORDER BY nom_admin, nom_chat;

--d.1) Inserta un nuevo mensaje redactado por el usuario ‘600000008‘.
INSERT INTO MENSAJE (mensaje_id, diahora, reenviado, usuario, chat_grupo, msj_original, texto)
VALUES ('MSJ00701', SYSDATE, 'NO', 600000008, 'C007', NULL, 'Q deberes puso la de mates?');

--d.2) Inserta un nuevo mensaje redactado por el usuario ‘600000011‘.
INSERT INTO MENSAJE (mensaje_id, diahora, reenviado, usuario, chat_grupo, msj_original, texto)
VALUES ('MSJ00702', SYSDATE, 'NO', 600000011, 'C007', 'MSJ00701', 'Toda la pagina 36 del libro');

--e) Visualiza el contenido de la vista tras las inserciones.
SELECT *
FROM INTERACCION_ADMIN
ORDER BY nom_admin, nom_chat;

-- Confirmación de los datos insertados.
COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 8. Restricciones de Integridad: Asertos.

--a) Aserto 1: Todos los chats deben tener al menos un mensaje.
CREATE ASSERTION chat_con_mensaje
CHECK (NOT EXISTS (
       SELECT *
       FROM CHAT_GRUPO c
       WHERE NOT EXISTS (
            SELECT 1
            FROM MENSAJE m
            WHERE m.chat_grupo = c.codigo
       )
));

--b) Aserto 2: Los mensajes anclados deben pertenecer al chat correspondiente.
CREATE ASSERTION msj_anclado_correcto
CHECK (NOT EXISTS (
       SELECT *
       FROM CHAT_GRUPO c
       WHERE c.msj_anclado IS NOT NULL
       AND c.msj_anclado NOT IN (
            SELECT m.mensaje_id
            FROM MENSAJE m
            WHERE m.chat_grupo = c.codigo
       )
));

-- Confirmación de los cambios realizados.
COMMIT;

--------------------------------------------------------------------------------------
-- EJERCICIO 9. Creación y uso de índices.

--a) Plan de ejecución inicial.
SELECT DISTINCT m.mensaje_id
FROM MENSAJE m
JOIN CHAT_GRUPO c ON m.chat_grupo = c.codigo
JOIN PARTICIPACION p ON p.chat_grupo = c.codigo
WHERE m.msj_original IS NOT NULL
  AND EXISTS (SELECT *
              FROM MIUSUARIO u
              WHERE u.telefono = p.usuario
                AND u.telefono IN (SELECT usuario
                                   FROM CONTACTO
                                   GROUP BY usuario
                                   HAVING COUNT(*) > 5));

--b) Creación de un índice para optimizar la consulta.
CREATE INDEX indice_contacto_usuario ON CONTACTO(usuario);

--c) Plan de ejecución tras la creación del índice.
SELECT DISTINCT m.mensaje_id
FROM MENSAJE m
JOIN CHAT_GRUPO c ON m.chat_grupo = c.codigo
JOIN PARTICIPACION p ON p.chat_grupo = c.codigo
WHERE m.msj_original IS NOT NULL
  AND EXISTS (SELECT *
              FROM MIUSUARIO u
              WHERE u.telefono = p.usuario
                AND u.telefono IN (SELECT usuario
                                   FROM CONTACTO
                                   GROUP BY usuario
                                   HAVING COUNT(*) > 5));

-- Confirmación de los cambios realizados.
COMMIT;