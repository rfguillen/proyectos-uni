
/* 
 S1.1. [F] Título, género y edad mínima recomendada de las series no españolas [observa que la
nacionalidad española se indica con el texto 'Espana'] cuya edad mínima recomendada es inferior
a 18 años. (titulo, genero, edad_minima).
*/
SELECT s.titulo, s.genero, s.edad_minima
FROM serie s
WHERE s.nacionalidad != 'Espana'
    AND s.edad_minima < 18;

/*
  S1.2. [F] Identificadores de las series y temporadas que los usuarios están viendo. Sin duplicados.
Ordenado por serie y temporada. (serie, temporada).
*/
SELECT DISTINCT e.serie, e.temporada
FROM estoy_viendo e
ORDER BY e.serie, e.temporada;

/*
 S1.3. [F] Capítulos de la temporada 3 o posterior de alguna serie, cuya duración sea inferior a 45
minutos, ordenado por serie y temporada. (serie, temporada, capitulo, titulo, duracion).
*/
SELECT *
FROM capitulo c
WHERE c.temporada >= 3
    AND c.duracion < 45
ORDER BY c.serie, c.temporada;

/*
 S1.4. [F] Usuarios cuya cuota está entre 50 y 100 euros y que se registraron después del
20/05/2020, ordenados por fecha de registro, de más reciente a más antigua (usuario_id,
nombre, f_registro).
*/
SELECT u.usuario_id, u.nombre, u.f_registro
FROM usuario u
WHERE u.cuota BETWEEN 50 AND 100
    AND u.f_registro > '20/05/2020'
ORDER BY u.f_registro DESC;

/*
S1.5. [F] Identificador de los usuarios que desde antes del 05/02/2025 tienen pendiente de
terminar algún capítulo del que visualizaron al menos 15 minutos. Sin duplicados y
ordenado por usuario. (usuario). 
*/
SELECT DISTINCT e.usuario
FROM estoy_viendo e
WHERE e.f_ultimo_acceso < '05/02/2025'
    AND e.minuto >= 15
ORDER BY e.usuario;

/*
 S1.6. [F] Intérpretes nacidos en la década de los 70 (del siglo XX, claro) de nacionalidad británica
('Reino Unido'), ordenado por año de nacimiento y por nombre. (interprete_id, nombre,
a_nacimiento).
*/
SELECT i.interprete_id, i.nombre, i.a_nacimiento
FROM interprete i
WHERE i.a_nacimiento BETWEEN 1970 AND 1979
    AND i.nacionalidad = 'Reino Unido'
ORDER BY i.a_nacimiento, i.nombre;

/*
 S1.7. [F] Para cada usuario cuyo nombre incluye el texto ‘ia’, mostrar el nombre, email y mes (no la
fecha, sino el mes en letras) en que se registró en la plataforma. (nombre, email,
mes_registro).
*/
SELECT u.nombre, u.email, TO_CHAR(u.f_registro, 'Month') as 
FROM usuario u
WHERE u.nombre LIKE '%ia%';

/*
 S1.8. [F] Para cada usuario registrado antes del 1 de enero de 2021 y que paga una cuota inferior a
80€, mostrar cómo quedaría su cuota si aumentara un 5% redondeada a dos decimales
[Puedes utilizar la función ROUND(valor, numero_decimales)]. Ordenado por identificador de
usuario. (usuario_id, nombre, nueva_cuota).
*/
SELECT u.usuario_id, u.nombre, ROUND(u.cuota * 1.05, 2) AS nueva_cuota
FROM usuario u
WHERE u.f_registro < '01/01/2021'
    AND u.cuota < 80
ORDER BY u.usuario_id;

/*
 S1.9. [F] Nombres de los usuarios registrados hace más de 5 años, incluyendo el nº de años que
hace que se registraron redondeado a 1 decimal. Ordenado por nombre. (nombre,
tiempo_registro). [Nota: la función SYSDATE devuelve la fecha actual del sistema y la resta entre dos
fechas obtiene el número de días transcurridos entre ellas].
*/
SELECT u.nombre, ROUND((SYSDATE - u.f_registro) / 365, 1) AS tiempo_registro
FROM usuario u
WHERE ROUND(((SYSDATE - u.f_registro) / 365),1) > 5
ORDER BY u.nombre;

/*
 S1.10. [F] Para los usuarios ‘U222’ y ‘U777’ mostrar cada serie que están viendo, la temporada,
capítulo, el minuto por el que se quedaron (siempre que hayan visto más de 20 minutos), y
los días que han pasado desde la última vez que accedieron a la serie, sin decimales.
Ordenado por usuario y serie. (usuario, serie, temporada, capitulo, minuto, dias).
*/
SELECT e.usuario, e.serie, e.temporada, e.capitulo, e.minuto, ROUND((SYSDATE - e.f_ultimo_acceso),0) AS dias
FROM estoy_viendo e
WHERE e.usuario IN ('U222','U777')
    AND e.minuto > 20
ORDER BY e.usuario, e.serie;

/*
 S1.11. [F] Nombre y nacionalidad de los intérpretes que participan en la serie con código ‘S001’,
incluyendo el rol con el que han participado. Ordenado por rol. (nombre, nacionalidad, rol)
*/
SELECT i.nombre, i.nacionalidad, r.rol
FROM interprete i, reparto r
WHERE i.interprete_id = r.interprete
    AND r.serie = 'S001'
ORDER BY r.rol;
    
/*
 S1.12. [F] Etiquetas asociadas a las series estadounidenses ('Estados Unidos') de género ‘Drama’,
ordenado por identificador de serie. (serie, titulo, etiqueta).
*/
SELECT q.serie, s.titulo, q.etiqueta
FROM etiquetado q, serie s
WHERE q.serie = s.serie_id
    AND s.nacionalidad = 'Estados Unidos'
    AND s.genero = 'Drama'
ORDER BY q.serie;

/*
 S1.13. [F] Intérpretes británicos ('Reino Unido') que han participado en alguna serie con un papel
protagonista o secundario, ordenados por nombre. (nombre, a_nacimiento, rol).
*/
SELECT DISTINCT i.nombre, i.a_nacimiento, r.rol
FROM interprete i, reparto r
WHERE i.interprete_id = r.interprete
    AND i.nacionalidad = 'Reino Unido'
    AND r.rol IN ('Protagonista', 'Secundario')
ORDER BY i.nombre;

/*
 S1.14. [F/M] Series de interés para el usuario llamado ‘Turiano’, ordenadas alfabéticamente por
título en orden descendente. (titulo, f_interes).
*/
SELECT DISTINCT s.titulo, n.f_interes
FROM serie s, interes n, usuario u
WHERE n.serie = s.serie_id
    AND n.usuario = u.usuario_id
    AND u.nombre = 'Turiano'
ORDER BY s.titulo DESC;

/*
 S1.15. [F/M] Identificador y nombre de los intérpretes que participan como figurantes (‘Figuracion’)
en el reparto de alguna serie, indicando el identificador y título de la serie. (interprete,
nombre, serie, titulo).
*/
SELECT i.interprete_id, i.nombre, s.serie_id, s.titulo
FROM interprete i, serie s, reparto r
WHERE i.interprete_id = r.interprete
    AND s.serie_id = r.serie
    AND r.rol = 'Figuracion';

/* 
 S1.16. [F/M] Para cada serie cuyo género es ‘Ciencia Ficcion’ y que tiene alguna temporada con
algún capítulo cuya duración está entre 50 y 53 minutos, mostrar el título de la serie, el
número de la temporada, el año de estreno de la temporada, el número de capítulo y el título
del capítulo. Ordenado por título de serie y número de temporada. (titulo_serie, temporada,
a_estreno, capitulo, titulo_capitulo).
*/
SELECT s.titulo AS titulo_serie, t.temporada, t.a_estreno, c.capitulo, c.titulo AS titulo_capitulo
FROM serie s, temporada t, capitulo c
WHERE t.serie = s.serie_id
    AND c.serie = s.serie_id
    AND c.temporada = t.temporada
    AND s.genero = 'Ciencia Ficcion'
    AND c.duracion BETWEEN 50 AND 53
ORDER BY titulo_serie, t.temporada;

/*
 S1.17. [F/M] Nombre y email de los usuarios que están viendo alguna serie de género ‘Policiaca’,
incluyendo el título de la serie y el capítulo que tienen a medio. En orden descendente por
nombre. (nombre, email, titulo, temporada, capitulo).
*/
SELECT u.nombre, u. email, e.serie, e.temporada, e.capitulo
FROM usuario u, estoy_viendo e, serie s
WHERE u.usuario_id = e.usuario
    AND s.serie_id = e.serie
    AND s.genero = 'Policiaca'
ORDER BY u.nombre DESC;

/*
 S1.18. [F/M] Títulos de las series de interés para usuarios registrados antes del 2019. Ordenado por
título de serie. (titulo, nombre_usuario).
*/
SELECT s.titulo, u.nombre AS nombre_usuario
FROM serie s, usuario u, interes n
WHERE s.serie_id = n.serie
    AND u.usuario_id = n.usuario
    AND u.f_registro < '01/01/2019'
ORDER BY s.titulo;

/*
 S1.19. [F/M] Capítulo que están viendo los usuarios cuya fecha de último acceso es anterior a
01/02/2025, indicando el título de la serie y el título del capítulo y el nombre del usuario.
Ordenado por nombre de usuario. (nombre_usuario, titulo_serie, titulo_capitulo, minuto).
*/
SELECT u.nombre AS nombre_usuario, s.titulo AS titulo_serie, e.capitulo AS titulo_capitulo, e.minuto
FROM usuario u, serie s, estoy_viendo e
WHERE u.usuario_id = e.usuario
    AND s.serie_id = e.serie
    AND e.f_ultimo_acceso < '01/02/2025'
ORDER BY nombre_usuario;

/*
 S1.20. [F/M] Nombres y edad de los intérpretes de nacionalidad española, nacidos después de 1985
y que participan en series que algún usuario está viendo. (nombre, edad).
*/
SELECT DISTINCT i.nombre, (EXTRACT(YEAR FROM SYSDATE)- i.a_nacimiento) AS edad
FROM interprete i, estoy_viendo e, reparto r
WHERE r.serie = e.serie
    AND i.interprete_id = r.interprete
    AND i.nacionalidad = 'Espana'
    AND i.a_nacimiento > 1985;

/*
 S1.21. [F/M] Para cada serie de interés para algún usuario marcada como vista por tal usuario,
mostrar su título, su género y el año de estreno de su temporada 1. Ordenado por título de
serie. (titulo, genero, a_estreno).
*/
SELECT DISTINCT s.titulo, s.genero, t.a_estreno
FROM serie s, temporada t, interes n
WHERE s.serie_id = n.serie
    AND t.serie = n.serie
    AND t.temporada = 1
    AND n.vista = 'SI'
ORDER BY s.titulo;

/* 
 S1.22. [M] Listado de usuarios y las series de su interés. Deben aparecer también los usuarios que
no tengan lista de intereses, para los cuales se debe mostrar el texto ‘SIN INTERESES’ en la
columna ‘serie_id’. Ordenado descendentemente por nombre de usuario. (nombre, serie_id).
*/ 
-- NO SE HACERLO SIN LEFT JOIN
SELECT u.nombre, COALESCE(n.serie, '*SIN INTERESES*')
FROM usuario u
LEFT JOIN interes n ON n.usuario = u.usuario_id
ORDER BY u.nombre DESC;

/*
 S1.23. [M] Listado de series de género ‘Policiaca’ y sus etiquetas. Deben aparecer también las series
que no tienen etiquetas, y se debe mostrar el texto ‘*SIN ETIQUETAS*’ en la columna
‘etiqueta’. Ordenado por titulo de serie y etiqueta. (titulo_serie, etiqueta).
*/
SELECT s.titulo AS titulo_serie, COALESCE(q.etiqueta, '*SIN ETIQUETAS*')
FROM serie s
LEFT JOIN etiquetado q ON q.serie = s.serie_id
WHERE s.genero = 'Policiaca'
ORDER BY s.titulo, q.etiqueta;

/*
 S1.24. [M] Series y los usuarios que las están viendo. Deben aparecer también las series que no está
viendo nadie, para las cuales se debe mostrar el texto ‘*NADIE*’ en la columna
“nombre_usuario”. Ordenado por titulo de serie y nombre de usuario. (titulo_serie,
nombre_usuario).
*/
SELECT DISTINCT s.titulo AS titulo_serie, COALESCE(u.nombre, '*NADIE*') AS nombre_usuario
FROM serie s
LEFT JOIN estoy_viendo e ON s.serie_id = e.serie
LEFT JOIN usuario u ON e.usuario = u.usuario_id
ORDER BY titulo_serie, nombre_usuario;

/*
 S1.25. [M] Listado de usuarios y series que están viendo. Deben aparecer también los usuarios que
no están viendo ninguna serie, y se debe mostrar el texto ‘*NADA*’ en la columna
‘titulo_serie’. Ordenado por nombre de usuario y titulo de serie. (nombre_usuario,
titulo_serie).
*/

SELECT DISTINCT u.nombre AS nombre_usuario, COALESCE(s.titulo, '*NADA*') AS titulo_serie
FROM usuario u
LEFT JOIN estoy_viendo e ON u.usuario_id = e.usuario
LEFT JOIN serie s ON s.serie_id = e.serie
ORDER BY nombre_usuario, titulo_serie;

/*
 S1.26. [F] Identificadores de las series que no tienen ninguna etiqueta. Hay que usar operadores de
conjuntos (serie).
*/
(SELECT s.serie_id
FROM serie s)
MINUS
(SELECT q.serie
FROM etiquetado q);

/*
 S1.27. [F] Identificadores de las series cuyo género no sea ‘Policiaca’, tales que ningún usuario la
está viendo. Hay que usar operadores de conjuntos. (serie). 
*/
(SELECT s.serie_id
FROM serie s
WHERE s.genero != 'Policiaca')
MINUS
(SELECT e.serie
FROM estoy_viendo e);

/*
 S1.28. [F] Identificadores de las series que son de interés para algún usuario y que tengan la
etiqueta ‘Thriller’ pero que no están siendo vistas por ningún usuario. No usar JOIN, sino
sólo operadores de conjuntos. (serie).
*/
((SELECT n.serie
FROM interes n)
INTERSECT
(SELECT q.serie
FROM etiquetado q
WHERE q.etiqueta = 'Thriller'))
MINUS
(SELECT e.serie
FROM estoy_viendo e);

/*
 S1.29. [F] Identificadores de los intérpretes que participan en el reparto de alguna serie como
protagonistas y en alguna otra serie como actores/actrices de reparto. Hay que usar
operadores de conjuntos. (interprete).
*/
(SELECT r.interprete
FROM reparto r
WHERE r.rol = 'Protagonista')
INTERSECT
(SELECT r.interprete
FROM reparto r
WHERE r.rol = 'Reparto');

/*
 S1.30. [F] Usuarios que tienen lista de intereses pero no están viendo nada. Hay que usar
operadores de conjuntos. (usuario).
*/
(SELECT n.usuario
FROM interes n)
MINUS
(SELECT e.usuario
FROM estoy_viendo e);

/*
 S1.31. [M] Series de interés para algún usuario, cuya fecha de registro de dicho interés es posterior
al 15/01/2023, tales que ese mismo usuario no la está viendo. Ordenado por los
identificadores de serie y de usuario. Hay que usar operadores de conjuntos. (serie, usuario).
*/
(SELECT n.serie, n.usuario
FROM interes n
WHERE n.f_interes > '15/01/2023')
MINUS
(SELECT e.serie, e.usuario
FROM estoy_viendo e)
ORDER BY serie, usuario;

/*
 S1.32. [F/M] Identificadores de los usuarios que tienen a medio ver alguna serie a la que no
acceden desde hace más de 6 meses, o bien que pagan una cuota inferior a 70 euros y se
registraron en 2022 o después. Hay que usar operadores de conjuntos. (usuario).
*/
(SELECT e.usuario
FROM estoy_viendo e
WHERE ((SYSDATE - e.f_ultimo_acceso) / 30) > 6)
UNION
(SELECT u.usuario_id
FROM usuario u
WHERE u.cuota < 70
    AND u.f_registro >= '01/01/2022');
    
/*
 S1.33. [F/M] Series de género ‘Drama’ cuya edad mínima es 18, y con algún capítulo de su segunda
temporada cuya duración está entre 60 y 100 minutos. Hay que usar operadores de
conjuntos. (serie).
*/
(SELECT s.serie_id
FROM serie s
WHERE s.genero = 'Drama'
    AND s.edad_minima = 18)
INTERSECT
(SELECT c.serie
FROM capitulo c
WHERE c.temporada = 2
    AND c.duracion BETWEEN 60 AND 100);
    
/*
 S1.34. [F/M] Series de interés para los usuarios cuya cuota está entre 30 y 45 euros, o bien que
tengan una edad mínima inferior a 16, o bien que tengan algún capítulo en cuyo título
aparezca el número 4. Hay que usar operadores de conjuntos. (serie).
*/
(SELECT n.serie
FROM interes n
WHERE n.usuario IN 
    (SELECT u.usuario_id
    FROM usuario u
    WHERE u.cuota BETWEEN 30 AND 45))
UNION
(SELECT s.serie_id
FROM serie s
WHERE s.edad_minima < 16)
UNION
(SELECT c.serie
FROM capitulo c
WHERE c.titulo LIKE '%4%');

/*
 S1.35. [F/M] Identificador de los intérpretes que han participado con rol ‘Reparto’ en alguna serie y
que hayan nacido en la década de los 80 del siglo XX, pero que nunca hayan formado parte
de series estadounidenses. Hay que usar operadores de conjuntos. (interprete).
*/
(SELECT r.interprete
FROM reparto r
WHERE r.rol = 'Reparto'
    AND r.serie NOT IN 
        (SELECT s.serie_id
        FROM serie s
        WHERE s.nacionalidad = 'Estados Unidos'))
INTERSECT
(SELECT i.interprete_id
FROM interprete i
WHERE i.a_nacimiento BETWEEN 1980 AND 1989);

/*
 S2.1. [F] Título y género de las series que nadie está viendo. (titulo, genero).
*/
SELECT s.titulo, s.genero
FROM serie s
WHERE s.serie_id NOT IN
        (SELECT e.serie
        FROM estoy_viendo e);
    
/*
 S2.2. [F] Usuarios tales que la última vez que vieron alguna serie fue hace más de cuatro años.
(nombre, f_registro, cuota).
*/
SELECT u.nombre, u.f_registro, u.cuota
FROM usuario u
WHERE u.usuario_id IN
        (SELECT e.usuario
        FROM estoy_viendo e
        WHERE ((SYSDATE - e.f_ultimo_acceso) / 365) > 4);
    
/*
 S2.3. [F] Etiquetas empleadas en las series que son de interés para los usuarios que no están
viendo ninguna serie. (etiqueta).
*/
SELECT DISTINCT q.etiqueta
FROM etiquetado q
WHERE q.serie IN
        (SELECT n.serie
        FROM interes n
        WHERE n.usuario NOT IN 
                (SELECT e.usuario
                FROM estoy_viendo e));

/*
 S2.4. [F] Usuarios que no tienen interés en ninguna serie española, ordenado por nombre.
(nombre, f_registro, email).
*/
SELECT u.nombre, u.f_registro, u.email
FROM usuario u
WHERE u.usuario_id NOT IN (SELECT n.usuario
                            FROM interes n
                            WHERE n.serie IN (SELECT s.serie_id
                                                FROM serie s
                                                WHERE s.nacionalidad = 'Espana'))
ORDER BY u.nombre;

/*
 S2.5. [F/M] Intérpretes que participan como protagonistas en alguna serie 'Policiaca', ordenado
por nombre. (nombre, nacionalidad, a_nacimiento)
*/
SELECT i.nombre, i.nacionalidad, i.a_nacimiento
FROM interprete i
WHERE i.interprete_id IN (SELECT r.interprete
                            FROM reparto r
                            WHERE r.rol = 'Protagonista'
                            AND r.serie IN (SELECT s.serie_id
                                            FROM serie s
                                            WHERE s.genero = 'Policiaca'))
ORDER BY i.nombre;

/*
 S2.6. [F/M] Nombres y nacionalidades de los intérpretes no españoles, que han participado en
series de nacionalidad española. Ordenado por nombre de intérprete. (nombre,
nacionalidad).
*/
SELECT i.nombre, i.nacionalidad
FROM interprete i
WHERE i.nacionalidad != 'Espana'
    AND i.interprete_id IN (SELECT r.interprete
                    FROM reparto r
                    WHERE r.serie IN (SELECT s.serie_id
                                        FROM serie s
                                        WHERE s.nacionalidad = 'Espana'))
ORDER BY i.nombre;

/*
 S2.7. [M] Usuarios que actualmente están viendo alguna serie en cuyo reparto hay un intérprete
nacido entre 1990 y 2000. (usuario_id, nombre, email).
*/
SELECT u.usuario_id, u.nombre, u.email
FROM usuario u
WHERE u.usuario_id IN (SELECT e.usuario
                        FROM estoy_viendo e
                        WHERE e.serie IN (SELECT r.serie
                                            FROM reparto r
                                            WHERE r.interprete IN (SELECT i.interprete_id
                                                                    FROM interprete i
                                                                    WHERE i.a_nacimiento BETWEEN 1990 AND 2000)));
                                                                    
/*
 S2.8. [M] Usuarios que se han dejado a medio ver el primer capítulo de la primera temporada de
alguna serie que sólo tiene una temporada. Se asume que si un usuario ha visto un capítulo
completo, éste desaparece de su lista “Estoy viendo”. No se debe utilizar agrupamiento ni
funciones de agregados. (usuario_id, nombre, cuota).
*/
SELECT u.usuario_id, u.nombre, u.cuota
FROM usuario u
WHERE u.usuario_id IN (SELECT e.usuario
                        FROM estoy_viendo e
                        WHERE e.capitulo = 1
                            AND e.temporada = 1
                            AND NOT EXISTS (SELECT t.serie
                                            FROM temporada t
                                            WHERE t.temporada = 2
                                                AND e.serie = t.serie));

/*
 S2.9. [M] Series de género 'Drama' que tienen alguna etiqueta que también aparezca en alguna
serie de género 'Policiaca'. (titulo, nacionalidad, edad_minima).
*/
SELECT s.titulo, s.nacionalidad, s.edad_minima
FROM serie s
WHERE s.genero = 'Drama'
    AND s.serie_id IN (SELECT q1.serie
                        FROM etiquetado q1
                        WHERE q1.etiqueta IN (SELECT q2.etiqueta
                                                FROM etiquetado q2
                                                WHERE q2.serie IN (SELECT s2.serie_id
                                                                    FROM serie s2
                                                                    WHERE s2.genero = 'Policiaca')));

/*
 S2.10. [M/D] Usuarios que pagan una cuota inferior a 65 euros y anotaron que alguna serie era de
su interés después del 1 de enero de 2024, o bien que se registraron en 2022 y no están viendo
ninguna serie. Ordenado por identificador de usuario. (usuario_id, nombre, f_registro).
*/
(SELECT u.usuario_id, u.nombre, u.f_registro
FROM usuario u
WHERE u.cuota < 65
    AND u.usuario_id IN (SELECT n.usuario
                        FROM interes n
                        WHERE n.f_interes > '01/01/2024'))
UNION
(SELECT u.usuario_id, u.nombre, u.f_registro
FROM usuario u
WHERE u.f_registro BETWEEN '01/01/2022' AND '31/12/2022'
    AND u.usuario_id NOT IN (SELECT e.usuario
                            FROM estoy_viendo e))
ORDER BY usuario_id;

/*
 S2.11. [M] Series que tengan algún capítulo de la segunda temporada con una duración mayor que
todos los capítulos de la tercera temporada. (serie_id, titulo).
*/
SELECT s.serie_id, s.titulo
FROM serie s
WHERE s.serie_id IN (SELECT c.serie
                        FROM capitulo c
                        WHERE c.temporada = 2
                            AND c.serie = s.serie_id
                            AND c.duracion > ALL (SELECT c2.duracion
                                                    FROM capitulo c2
                                                    WHERE c2.temporada = 3
                                                        AND s.serie_id = c2.serie));

/*
 S2.12. [M] Series tales que han pasado 2 o más años entre el estreno de su primera y su segunda
temporada . (titulo, nacionalidad).
*/
SELECT s.titulo, s.nacionalidad
FROM serie s
WHERE s.serie_id IN (SELECT t.serie
                        FROM temporada t
                        WHERE t.temporada = 1
                            AND (SELECT t2.a_estreno
                                    FROM temporada t2
                                    WHERE t2.serie = s.serie_id
                                    AND t2.temporada = 2) - t.a_estreno >= 2);
                                    
/*
 S2.13. [M/D] Series que algún usuario está viendo para las que no indicó que eran de su interés.
(serie_id, titulo, genero).
*/
SELECT DISTINCT s.serie_id, s.titulo, s.genero
FROM serie s, estoy_viendo e
WHERE s.serie_id = e.serie
    AND NOT EXISTS (SELECT n.serie
                    FROM interes n
                    WHERE n.usuario = e.usuario
                        AND n.serie = e.serie);

/*
 S2.14. [F] Para cada etiqueta, mostrar en cuántas series aparece. Ordenado por número de series.
(etiqueta, n_series).
*/
SELECT q.etiqueta, COUNT(*) AS n_series
FROM etiquetado q
GROUP BY q.etiqueta
ORDER BY n_series;

/*
 S2.15. [F] Cuántas series hay de cada nacionalidad. Ordenado por número de series.
(nacionalidad, n_series).
*/
SELECT s.nacionalidad, COUNT(*) AS n_series
FROM serie s
GROUP BY s.nacionalidad
ORDER BY n_series;

/*
 S2.16. [F] Cuántas series cuya edad mínima recomendada es superior a 12 hay de cada género, en
orden descendente por género. (genero, n_series).
*/
SELECT s.genero, COUNT(*) AS n_series
FROM serie s
WHERE s.edad_minima > 12
GROUP BY s.genero
ORDER BY s.genero DESC;

/*
 S2.17. [F] Para cada usuario indicar cuántas series, de las que se interesó, ya ha visto de forma
completa. (usuario, n_series_vistas).
*/
SELECT n.usuario, COUNT(*) AS n_series_vistas
FROM interes n
WHERE n.vista = 'SI'
GROUP BY n.usuario

/*
 S2.18. [F] Cuántos usuarios están interesados en cada serie. Ordenado por serie. (serie,
n_usuarios).
*/
SELECT n.serie, COUNT(*)
FROM interes n
GROUP BY n.serie
ORDER BY n.serie;

/*
 S2.19. [F] Etiquetas utilizadas en más de 3 series. (etiqueta)
*/
SELECT q.etiqueta
FROM etiquetado q
HAVING COUNT(q.serie) > 3
GROUP BY q.etiqueta;

/*
 S2.20. [F/M] Cuántas series hay con algún capítulo que no tiene título. Trata de resolverlo sin
acceder a la tabla SERIE. (n_series).
*/
SELECT COUNT(DISTINCT c.serie) AS n_series
FROM capitulo c
WHERE c.titulo IS NULL;

/*
 S2.21. [F/M] ¿Cuáles son las nacionalidades para las que solo hay un intérprete en la base de
datos? Ordenadas alfabéticamente. (nacionalidad).
*/
SELECT i.nacionalidad
FROM interprete i
HAVING COUNT(i.interprete_id) = 1
GROUP BY i.nacionalidad
ORDER BY i.nacionalidad;

/*
 S2.22. [F/M] Mostrar el identificador de las series que tienen 4 o más temporadas junto con el
número de temporadas. Ordenado por serie. (serie, n_temporadas).
*/
SELECT t.serie, COUNT(*) AS n_temporadas
FROM temporada t
HAVING COUNT(t.temporada) >= 4
GROUP BY t.serie
ORDER BY t.serie;

/*
 S2.23. [F/M] Para cada serie en la que participa el actor 'David Tennant' indicar el número de veces
en total que aparece en la lista de intereses de los usuarios (serie, likes)
*/
SELECT n.serie, COUNT(*) AS likes
FROM interes n
WHERE n.serie IN (SELECT r.serie
                    FROM reparto r
                    WHERE r.interprete IN (SELECT i.interprete_id
                                            FROM interprete i
                                            WHERE i.nombre = 'David Tennant'))
GROUP BY n.serie;

/*
 S2.24. [F/M] Cuál es la media de las cuotas que pagan los usuarios que están interesados en más
de tres series. (cuota_media).
*/
SELECT AVG(u.cuota) AS cuota_media
FROM usuario u
WHERE u.usuario_id IN (SELECT n.usuario
                        FROM interes n
                        GROUP BY n.usuario
                        HAVING COUNT(*) > 3);
                        
/*
 S2.25. [F/M] Series con más de 3 temporadas, de nacionalidad no británica y cuya edad mínima
es inferior a 18 (titulo, nacionalidad, genero).
*/
SELECT s.titulo, s.nacionalidad, s.genero
FROM serie s
WHERE s.serie_id IN (SELECT t.serie
                    FROM temporada t
                    GROUP BY t.serie
                    HAVING COUNT(*) > 3)
    AND s.nacionalidad != 'Reino Unido'
    AND s.edad_minima < 18;
             
/* 
 S2.26. [M] Cuántos capítulos con duración inferior a 45 minutos tiene cada temporada de cada
serie con más de 2 temporadas. Ordenado por serie y temporada. (serie, temporada,
n_capitulos).
*/
SELECT c.serie, c.temporada, COUNT(*) AS n_capitulos
FROM capitulo c
WHERE c.duracion < 45
    AND c.serie IN (SELECT t.serie
                    FROM temporada t
                    GROUP BY t.serie
                    HAVING COUNT(*) > 2)
GROUP BY c.serie, c.temporada
ORDER BY c.serie, c.temporada;

/*
 S2.27. [M] Usuarios que están viendo alguna serie que solo tiene 2 temporadas. (nombre, cuota)
 */
SELECT u.nombre, u.cuota
FROM usuario u
WHERE u.usuario_id IN (SELECT e.usuario
                        FROM estoy_viendo e
                        WHERE e.serie IN (SELECT t.serie
                                            FROM temporada t
                                            GROUP BY t.serie
                                            HAVING COUNT(*) = 2));

/*
 S2.28. [M] Usuarios interesados en más de 5 series. (nombre, f_registro, cuota).
*/
SELECT u.nombre, u.f_registro, u.cuota
FROM usuario u
WHERE u.usuario_id IN (SELECT n.usuario
                        FROM interes n
                        GROUP BY n.usuario
                        HAVING COUNT(*) > 5);

/*
 S2.29. [M] Intérpretes que han participado en más de una serie, en orden alfabético. (nombre,
nacionalidad, a_nacimiento).
*/
SELECT i.nombre, i.nacionalidad, i.a_nacimiento
FROM interprete i
WHERE i.interprete_id IN (SELECT r.interprete
                            FROM reparto r
                            GROUP BY r.interprete
                            HAVING COUNT(*) > 1)
ORDER BY i.nombre;

/*
 S2.30. [M/D] Usuarios que están viendo más de un capítulo de la misma serie. (nombre).
*/
SELECT u.nombre
FROM usuario u
WHERE u.usuario_id IN (SELECT e.usuario
                        FROM estoy_viendo e
                        GROUP BY e.usuario, e.serie
                        HAVING COUNT(*) > 1);

/*
 S2.31. [M/D] En cuántas series británicas participa cada interprete de nacionalidad
estadounidense. (interprete, n_series_brit).
*/
SELECT r.interprete, COUNT(*) AS n_series_brit
FROM reparto r
WHERE r.serie IN (SELECT s.serie_id
                    FROM serie s
                    WHERE s.nacionalidad = 'Reino Unido')
    AND r.interprete IN (SELECT i.interprete_id
                            FROM interprete i
                            WHERE i.nacionalidad = 'Estados Unidos')
GROUP BY r.interprete;

/*
 S2.32. [M/D] Número de usuarios que están viendo cada serie. Si un usuario está viendo varios
capítulos de la misma serie, solo debe ser considerado una vez. Deben aparecer todas las series
y para las que no están siendo vistas por nadie debe aparecer el valor 0 en la columna
n_usuarios. Ordenado por identificador de serie. (serie_id, n_usuarios).
*/
SELECT s.serie_id, COUNT(DISTINCT e.usuario) AS n_usuarios
FROM serie s
LEFT JOIN estoy_viendo e ON e.serie = s.serie_id
GROUP BY s.serie_id
ORDER BY s.serie_id;

/*
 S2.33. [M/D] Número de series que está viendo cada usuario, en orden descendente por el
número de series. Si un usuario está viendo diferentes capítulos de la misma serie, solo debe
ser considerada una vez. Deben mostrarse todos los usuarios; para los que no están viendo
ninguna serie debe aparecer un 0 en la columna series_en_curso. (usuario_id, series_en_curso).
*/
SELECT u.usuario_id, COUNT(DISTINCT e.serie) AS series_en_curso
FROM usuario u
LEFT JOIN estoy_viendo e ON e.usuario = u.usuario_id
GROUP BY u.usuario_id
ORDER BY series_en_curso DESC;

/*
 S2.34. [M/D] Número de series en las que se ha interesado cada usuario pero que todavía no ha
empezado a ver, es decir, no aparecen anotadas como ya vistas ni el usuario las tiene a medio
ver (usuario, series_pendientes).
*/
SELECT n.usuario, COUNT(*) AS series_pendientes
FROM interes n
WHERE n.vista = 'NO'
    AND NOT EXISTS (SELECT 1
                    FROM estoy_viendo e
                    WHERE e.usuario = n.usuario
                        AND e.serie = n.serie)
GROUP BY n.usuario;

/*
 S2.35. [M/D] Mostrar cuántas temporadas y cuántos capítulos en total tiene cada serie en la que
participa algún intérprete con nacionalidad 'Estados Unidos'. Ordenado por identificador de
serie. (serie, n_temporadas, n_capitulos).
*/
SELECT c.serie, COUNT(DISTINCT c.temporada) AS n_temporadas, COUNT(c.capitulo) AS n_capitulos
FROM capitulo c
WHERE c.serie IN (SELECT r.serie
                    FROM reparto r
                    WHERE r.interprete IN (SELECT i.interprete_id
                                            FROM interprete i
                                            WHERE i.nacionalidad = 'Estados Unidos'))
GROUP BY c.serie
ORDER BY c.serie;

/*
 S3.1. [M] Etiqueta más utilizada para describir series. (etiqueta)
*/
SELECT q.etiqueta
FROM etiquetado q
GROUP BY q.etiqueta
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM etiquetado q2
                    GROUP BY q2.etiqueta);

/*
 S3.2. [M] Serie que, entre los intereses de los usuarios, es la que más veces aparece como vista de
forma completa (el sistema lo ha anotado así en la columna vista de la tabla de intereses),
indicando también cuántas veces ha sido vista. (serie, veces_vista).
*/
SELECT n.serie, COUNT(n.vista) AS veces_vista
FROM interes n
WHERE n.vista = 'SI'
GROUP BY n.serie
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM interes n2
                    WHERE n2.vista = 'SI'
                    GROUP BY n2.serie);

/*
 S3.3. [M]Nacionalidad de la que hay menos series, indicando cuántas series hay de esa
nacionalidad. (nacionalidad, n_series).
*/
SELECT s.nacionalidad, COUNT(s.serie_id) AS n_series
FROM serie s
GROUP BY s.nacionalidad
HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                    FROM serie s2
                    GROUP BY s2.nacionalidad);

/*
 S3.4. [M] Usuario que está interesado en más series que ningún otro, incluyendo el número de
series. (usuario_id, n_series).
*/
SELECT u.usuario_id, COUNT(n.serie)
FROM usuario u, interes n
WHERE n.usuario = u.usuario_id
GROUP BY u.usuario_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM interes n2
                    GROUP BY n2.usuario);

/*
 S3.5. [M] Serie en la que más usuarios están interesados, indicando cuántos. (serie, n_usuarios).
*/
SELECT n.serie, COUNT(n.usuario) AS n_usuarios
FROM interes n
GROUP BY n.serie
HAVING COUNT(n.usuario) = (SELECT MAX(COUNT(*))
                            FROM interes n2
                            GROUP BY n2.serie);
                            
/*
 S3.6. [M] Serie que más temporadas tiene, mostrando cuántas temporadas (serie, n_temporadas).
*/
SELECT t.serie, COUNT(t.temporada) AS n_temporadas
FROM temporada t
GROUP BY t.serie
HAVING COUNT(t.temporada) = (SELECT MAX(COUNT(*))
                                FROM temporada t2
                                GROUP BY t2.serie);
                                
/*
 S3.7. [M] Serie que más veces está siendo vista por los usuarios, es decir, que tenga más capítulos
a medio ver por los usuarios. Como siempre, se asume que todos los capítulos que aparecen en
la lista “Estoy viendo” de un usuario son los que tiene a medio ver, pues cuando se ve un
capítulo completo, éste desaparece de su lista “Estoy viendo”. (serie, n_capitulos_a_medio)
*/
SELECT e.serie, COUNT(e.capitulo) AS n_capitulos_a_medio
FROM estoy_viendo e
GROUP BY e.serie
HAVING COUNT(e.capitulo) = (SELECT MAX(COUNT(*))
                            FROM estoy_viendo e2
                            GROUP BY e2.serie);

/*
 S3.8. [M/D] Serie que más veces está siendo vista por un mismo usuario, es decir, que tenga más
capítulos a medio ver por el mismo usuario, indicando quién es. Como siempre, se asume que
todos los capítulos que aparecen en la lista “Estoy viendo” de un usuario son los que tiene a
medio ver, pues cuando se ve un capítulo completo, éste desaparece de su lista “Estoy viendo”.
(serie, usuario, n_capitulos_a_medio).
*/
SELECT e.serie, e.usuario, COUNT(e.capitulo) AS n_capitulos_a_medio
FROM estoy_viendo e
GROUP BY e.serie, e.usuario
HAVING COUNT(e.capitulo) = (SELECT MAX(COUNT(*))
                                FROM estoy_viendo e2
                                GROUP BY e2.serie, e2.usuario);
                                
/*
 S3.9. [M] Nacionalidad de la que se tiene más intérpretes en la base de datos, indicando cuántos
son. (nacionalidad, n_interpretes).
*/
SELECT i.nacionalidad, COUNT(*) AS n_interpretes
FROM interprete i
GROUP BY i.nacionalidad
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                FROM interprete i2
                                GROUP BY i2.nacionalidad);
                                
/*
 S3.10. [M] Intérprete que más veces participa en series, indicando cuántas (interprete, num_veces).
*/
SELECT r.interprete, COUNT(*) AS num_veces
FROM reparto r
GROUP BY r.interprete
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM reparto r2
                    GROUP BY r2.interprete);

/*
 S3.11. [M/D] Etiquetas asociadas a la serie que tiene más usuarios interesados. En orden alfabético.
(etiqueta).
*/
SELECT q.etiqueta
FROM etiquetado q
WHERE q.serie IN (SELECT n.serie
                    FROM interes n
                    GROUP BY n.serie
                    HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                        FROM interes n2
                                        GROUP BY n2.serie))
ORDER BY q.etiqueta;

/*
 S3.12. [M/D] Series en las que actúan como protagonistas los intérpretes que más veces participan
en series. (serie_id, titulo)
*/
SELECT s.serie_id, s.titulo
FROM serie s
WHERE s.serie_id IN (SELECT r.serie
                        FROM reparto r
                        WHERE r.rol = 'Protagonista'
                            AND r.interprete IN (SELECT r2.interprete
                                                    FROM reparto r2
                                                    GROUP BY r2.interprete
                                                    HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                                                        FROM reparto r3
                                                                        GROUP BY r3.interprete)));
                                                                        
/*
 S3.13. [DD] Para cada usuario indicar la nacionalidad más común entre las series en las que está
interesado. Es decir, si un usuario está interesado en más series españolas que de cualquier otra
nacionalidad, debe aparecer su identificador junto con la nacionalidad 'Espana' en el resultado.
Ordenado por usuario. (usuario, nacionalidad).
*/
SELECT n.usuario, s.nacionalidad
FROM interes n, serie s
WHERE n.serie = s.serie_id
GROUP BY n.usuario, s.nacionalidad
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                    FROM interes n2, serie s2
                    WHERE s2.serie_id = n2.serie
                    AND n2.usuario = n.usuario
                    GROUP BY s2.nacionalidad)
ORDER BY n.usuario;

/*
 S3.14. [D] Título y edad mínima recomendada de la serie que más temporadas tiene, indicando
cuántas. (titulo, edad_minima, n_temporadas).
*/
SELECT s.titulo, s.edad_minima, COUNT(t.temporada) AS n_temporadas
FROM serie s
JOIN temporada t 
    ON t.serie = s.serie_id
GROUP BY s.titulo, s.edad_minima, s.serie_id
HAVING COUNT(t.temporada) = (SELECT MAX(COUNT(*))
                                FROM temporada t2
                                GROUP BY t2.serie);

/*
 S3.15. [D] Título y género de la serie que más veces aparece en la lista de intereses de los usuarios,
indicando cuántos son los usuarios interesados en ella. (titulo, genero, n_interesados)
*/
SELECT s.titulo, s.genero, COUNT(n.usuario) AS n_interesados
FROM serie s
JOIN interes n
    ON n.serie = s.serie_id
GROUP BY s.titulo, s.genero, s.serie_id
HAVING COUNT(n.usuario) = (SELECT MAX(COUNT(*))
                            FROM interes n2
                            GROUP BY n2.serie);

/*
 S3.16. [D] Serie en las que participan más intérpretes, indicando cuántos son (serie_id, titulo,
n_interpretes).
*/
SELECT s.serie_id, s.titulo, COUNT(r.interprete) AS n_interpretes
FROM serie s
JOIN reparto r
    ON r.serie = s.serie_id
GROUP BY s.serie_id, s.titulo
HAVING COUNT(r.interprete) = (SELECT MAX(COUNT(*))
                                FROM reparto r2
                                GROUP BY r2.serie);

/*
 S3.17. [D] Nombre y año de nacimiento del intérprete que más veces participa en series, indicando
en cuántas (nombre, a_nacimiento, n_series).
*/
SELECT i.nombre, i.a_nacimiento, COUNT(r.serie) AS n_series
FROM interprete i
JOIN reparto r
    ON r.interprete = i.interprete_id
GROUP BY i.nombre, i.a_nacimiento, i.interprete_id
HAVING COUNT(r.serie) = (SELECT MAX(COUNT(*))
                            FROM reparto r2
                            GROUP BY r2.interprete);

/*
 S3.18. [M/D] Para cada intérprete, mostrar en cuántas series ha participado, cuántas de ellas son de
genero 'Policiaca' y cuántas de ellas tienen una etiqueta 'Thriller'. (nombre, n_series,
n_policiacas, n_thrillers).
*/
SELECT i.nombre, COUNT(r.serie) AS n_series, f.n_policiacas, f1.n_thriller
FROM interprete i
JOIN reparto r
    ON r.interprete = i.interprete_id
JOIN (SELECT r2.interprete, COUNT(r2.serie) AS n_policiacas
        FROM reparto r2
        WHERE r2.serie IN (SELECT s.serie_id
                            FROM serie s
                            WHERE s.genero = 'Policiaca')
        GROUP BY r2.interprete) f 
    ON f.interprete = r.interprete

JOIN (SELECT r3.interprete, COUNT(r3.serie) AS n_thriller
        FROM reparto r3
        WHERE r3.serie IN (SELECT q.serie
                            FROM etiquetado q
                            WHERE q.etiqueta = 'Thriller')
        GROUP BY r3.interprete) f1
    ON f1.interprete = r.interprete
GROUP BY i.nombre, i.interprete_id, f.n_policiacas, f1.n_thriller
ORDER BY i.nombre;

/*
 S3.19. [D] Para cada usuario, mostrar los identificadores de las series de nacionalidad británica que
está viendo, y cuántos capítulos está viendo de cada una de esas series. Ordenado por usuario
y serie. (nombre, serie, n_capitulos).
Parte 2: Deben aparecer todos los usuarios, de modo que para aquellos que no están viendo
ninguna serie británica, la columna serie debe mostrar tres guiones: '---' y la columna
n_capitulos debe contener un 0.
*/
SELECT u.nombre, e.serie, COUNT(e.capitulo) AS n_capitulo
FROM usuario u
JOIN estoy_viendo e
    ON e.usuario = u.usuario_id
WHERE e.serie IN (SELECT s.serie_id
                    FROM serie s
                    WHERE s.nacionalidad = 'Reino Unido')
GROUP BY u.nombre, e.serie
ORDER BY u.nombre, e.serie;

--- PARTE 2:
SELECT u.nombre, COALESCE(e.serie, '---') AS serie, COUNT(e.capitulo) AS n_capitulo
FROM usuario u
LEFT JOIN estoy_viendo e
    ON e.usuario = u.usuario_id
    AND e.serie IN (SELECT s.serie_id
                    FROM serie s
                    WHERE s.nacionalidad = 'Reino Unido')
GROUP BY u.nombre, e.serie
ORDER BY u.nombre, e.serie;

/*
 S3.20. [D] Para cada serie, indicar cuántas temporadas tiene, cuántos usuarios están interesados en
ella, y cuántos usuarios la están viendo. Ordenado por título de serie. (titulo, n_temporadas,
n_interesados, n_visores).
 Parte 2. Deben aparecer todas las series. Si no tienen usuarios interesados, o ninguno la está
viendo, debe mostrarse un 0 en la(s) columna(s) correspondiente(s).
*/
SELECT s.titulo, COUNT(t.temporada) AS n_temporadas, f.n_interesados, f2.n_visores
FROM serie s
JOIN temporada t
    ON t.serie = s.serie_id
    
JOIN (SELECT n.serie, COUNT(n.usuario) AS n_interesados
        FROM interes n
        GROUP BY n.serie) f 
    ON f.serie = s.serie_id    
    
JOIN (SELECT e.serie, COUNT(DISTINCT e.usuario) AS n_visores
        FROM estoy_viendo e
        GROUP BY e.serie) f2 
    ON f2.serie = s.serie_id
    
GROUP BY s.titulo, s.serie_id, n_interesados, n_visores
ORDER BY s.titulo;
                        
--- PARTE 2
SELECT s.titulo, COUNT(t.temporada) AS n_temporadas, f.n_interesados, COALESCE(f2.n_visores,0)
FROM serie s
JOIN temporada t
    ON t.serie = s.serie_id
    
LEFT JOIN (SELECT n.serie, COUNT(n.usuario) AS n_interesados
        FROM interes n
        GROUP BY n.serie) f 
    ON f.serie = s.serie_id    
    
LEFT JOIN (SELECT e.serie, COUNT(DISTINCT e.usuario) AS n_visores
        FROM estoy_viendo e
        GROUP BY e.serie) f2 
    ON f2.serie = s.serie_id
    
GROUP BY s.titulo, s.serie_id, n_interesados, n_visores
ORDER BY s.titulo;

/*
 S3.21. [D] Para cada serie, mostrar cuántas etiquetas tiene, cuántas temporadas, y cuántos capítulos
de duración inferior a 50 minutos. (titulo, n_etiquetas, n_temporadas, n_capitulos).
Parte 2. Deben aparecer todas las series. Si no tienen etiquetas o no tienen capítulos de
duración inferior a 50 minutos, debe mostrarse un 0 en la(s) columna(s) correspondiente(s).
*/
SELECT s.titulo, COUNT(q.etiqueta) AS n_etiquetas, f.n_temporadas, f1.n_capitulos
FROM serie s
LEFT JOIN etiquetado q
    ON q.serie = s.serie_id

JOIN (SELECT t.serie, COUNT(t.temporada) AS n_temporadas
        FROM temporada t
        GROUP BY t.serie) f
    ON f.serie = s.serie_id

JOIN (SELECT c.serie, COUNT(c.capitulo) AS n_capitulos
        FROM capitulo c
        WHERE c.duracion < 50
        GROUP BY c.serie) f1
    ON f1.serie = s.serie_id

GROUP BY s.titulo, f.n_temporadas, f1.n_capitulos
ORDER BY s.titulo;

--- PARTE 2:
SELECT s.titulo, COALESCE(COUNT(q.etiqueta),0) AS n_etiquetas, COALESCE(f.n_temporadas,0), COALESCE(f1.n_capitulos,0)
FROM serie s
LEFT JOIN etiquetado q
    ON q.serie = s.serie_id

LEFT JOIN (SELECT t.serie, COUNT(t.temporada) AS n_temporadas
        FROM temporada t
        GROUP BY t.serie) f
    ON f.serie = s.serie_id

LEFT JOIN (SELECT c.serie, COUNT(c.capitulo) AS n_capitulos
        FROM capitulo c
        WHERE c.duracion < 50
        GROUP BY c.serie) f1
    ON f1.serie = s.serie_id

GROUP BY s.titulo, f.n_temporadas, f1.n_capitulos
ORDER BY s.titulo;


/*
 S4.1.[D] Usuarios que están interesados en todas las series. (usuario_id, nombre)
 USUARIOS TALES QUE NO EXISTE UNA SERIE EN LA QUE NO ESTÉN INTERESADOS
*/
SELECT u.usuario_id, u.nombre
FROM usuario u
WHERE NOT EXISTS (SELECT *
                    FROM serie s
                    WHERE s.serie_id NOT IN (SELECT n.serie
                                                FROM interes n
                                                WHERE n.usuario = u.usuario_id));

/*
 S4.2.[D] Series en las que están interesados todos los usuarios (serie_id, titulo).
 SERIES TALES QUE NO EXISTE UN USUARIO QUE NO ESTÉ INTERESADO EN ELLAS
*/
SELECT s.serie_id, s.titulo
FROM serie s
WHERE NOT EXISTS (SELECT *
                    FROM usuario u
                    WHERE u.usuario_id NOT IN (SELECT n.usuario
                                                FROM interes n
                                                WHERE n.serie = s.serie_id));

/*
 S4.3.[D] Series que están viendo todos los usuarios cuya cuota es inferior a 36 euros. (serie_id,
titulo).
SERIES TALES QUE NO EXISTE UN USUARIO CUYA CUOTA SEA INFERIOR A 36 QUE NO LA ESTÉ VIENDO 
*/
SELECT s.serie_id, s.titulo
FROM serie s
WHERE NOT EXISTS (SELECT *
                    FROM usuario u
                    WHERE u.cuota < 36
                        AND u.usuario_id NOT IN (SELECT e.usuario
                                                    FROM estoy_viendo e
                                                    WHERE e.serie = s.serie_id));

/*
 S4.4.[D] Intérpretes que participan en todas las series que tienen la etiqueta ‘Aventura’.
(interprete_id, nombre).
INTERPRETES TALES QUE NO EXISTE UNA SERIE CON LA ETIQUETA AVENTURA EN LA QUE NO PARTICIPEN
*/
SELECT i.interprete_id, i.nombre
FROM interprete i
WHERE NOT EXISTS (SELECT *
                    FROM etiquetado q
                    WHERE q.etiqueta = 'Aventura'
                        AND q.serie NOT IN (SELECT r.serie
                                            FROM reparto r
                                            WHERE r.interprete = i.interprete_id));

/*
 S4.5.[D] Usuarios que están interesados en todas las series del intérprete 'Matt Smith'. (usuario_id,
nombre)
 USUARIOS TALES QUE NO EXISTE UNA SERIE DEL INTERPRETE 'Matt Smith' EN LA QUE NO ESTÉN INTERESADOS
*/
SELECT u.usuario_id, u.nombre
FROM usuario u
WHERE NOT EXISTS (SELECT *
                  FROM reparto r
                  WHERE r.interprete = (SELECT i.interprete_id
                                        FROM interprete i
                                        WHERE i.nombre = 'Matt Smith')
                  AND r.serie NOT IN (SELECT n.serie
                                      FROM interes n
                                      WHERE n.usuario = u.usuario_id));