create database testp1;

create table fabricante (
id_fabricante int primary key,
nombre varchar (100)not null
);

CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nombre varchar (100),
    precio DOUBLE PRECISION,
    id_fabricante INT,
    FOREIGN KEY (id_fabricante) REFERENCES fabricante (id_fabricante)
);




INSERT INTO fabricante (id_fabricante, nombre) VALUES
(1, 'Asus'),
(2, 'Lenovo'),
(3, 'Hewlett-Packard'),
(4, 'Samsung'),
(5, 'Seagate'),
(6, 'Crucial'),
(7, 'Gigabyte'),
(8, 'Huawei'),
(9, 'Xiaomi'); 

INSERT INTO producto (id_producto,nombre,precio, id_fabricante) VALUES
(1, 'Disco duro SATA3 1TB', 86.99, 5),
(2, 'Memoria RAM DDR4 8GB', 120, 6),
(3, 'Disco SSD 1 TB', 150.99, 4),
(4, 'GeForce GTX 1050Ti', 185, 7),
(5, 'GeForce GTX 1080 Xtreme', 755, 6),
(6, 'Monitor 24 LED Full HD', 202, 1),
(7, 'Monitor 27 LED Full HD', 245.99, 1),
(8, 'Portátil Yoga 520', 559, 2),
(9, 'Portátil Ideapad 320', 444, 2),
(10, 'Impresora HP Deskjet 3720', 59.99, 3),
(11, 'Impresora HP Laserjet Pro M26nw', 180, 3); 

-- Consultas sobre una tabla

--Lista el nombre de todos los productos que hay en la tabla producto.

select nombre from producto ;

-- Lista los nombres y los precios de todos los productos de la tabla producto.
select nombre, precio from producto ;

-- Lista todas las columnas de la tabla producto.
select * from producto;

-- Lista el nombre de los productos, el precio en euros y el precio en dólares
--estadounidenses (USD).


-- Lista los nombres y los precios de todos los productos de la tabla producto,
--convirtiendo los nombres a mayúscula.

select upper(nombre)  as  nombre_en_mayusculas, precio  from producto; 


--Lista los nombres y los precios de todos los productos de la tabla producto,
-- convirtiendo los nombres a minúscula.

SELECT LOWER(nombre) AS nombre_en_minusculas, precio FROM producto;

--Lista el nombre de todos los fabricantes en una columna, y en otra columna
--obtenga en mayúsculas los dos primeros caracteres del nombre del
--fabricante.

SELECT 
    nombre AS nombre_fabricante,
    UPPER(SUBSTRING(nombre FROM 1 FOR 2)) AS primeros_dos_caracteres_mayusculas
FROM fabricante;

--Lista los nombres y los precios de todos los productos de la tabla producto,
--redondeando el valor del precio.

SELECT 
    nombre,
    ROUND(precio) AS precio_redondeado
FROM producto;

--Lista los nombres y los precios de todos los productos de la tabla producto,
--truncando el valor del precio para mostrarlo sin ninguna cifra decimal.

select nombre, trunc(precio) as precio_truncado from producto; 

-- 11. Lista el identificador de los fabricantes que tienen productos en la tabla producto.

SELECT id_fabricante FROM producto;

-- 12. Lista el identificador de los fabricantes que tienen productos en la tabla producto, eliminando los identificadores que aparecen repetidos.

SELECT DISTINCT id_fabricante FROM producto;

-- 13. Lista los nombres de los fabricantes ordenados de forma ascendente.

SELECT nombre FROM fabricante ORDER BY nombre ASC;

-- 14. Lista los nombres de los fabricantes ordenados de forma descendente.

SELECT nombre FROM fabricante ORDER BY nombre DESC;

-- 15. Lista los nombres de los productos ordenados en primer lugar por el nombre de forma ascendente y en segundo lugar por el precio de forma descendente.

SELECT nombre, precio FROM producto ORDER BY nombre ASC, precio DESC;

-- 16. Devuelve una lista con las 5 primeras filas de la tabla fabricante.

SELECT * FROM fabricante LIMIT 5;

-- 17. Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante. La cuarta fila también se debe incluir en la respuesta.

SELECT * FROM fabricante OFFSET 3 LIMIT 2;

--18. Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas ORDER BY y LIMIT)

SELECT nombre, precio FROM producto ORDER BY precio desc LIMIT 1;

-- 19. Lista el nombre y el precio del producto más caro. (Utilice solamente las cláusulas ORDER BY y LIMIT)

SELECT nombre, precio FROM producto ORDER BY precio desc LIMIT 1;

-- 20. Lista el nombre de todos los productos del fabricante cuyo identificador de fabricante es igual a 2.

select ELECT nombre FROM producto WHERE id_fabricante = 2;

-- 21. Lista el nombre de los productos que tienen un precio menor o igual a 120€.

select nombre,precio from producto where precio <=120;

-- 22. Lista el nombre de los productos que tienen un precio mayor o igual a 400€.

select nombre, precio from producto where precio >=400;

-- 23. Lista el nombre de los productos que no tienen un precio mayor o igual a 400€.

select nombre, precio from producto where precio < 400;

-- 24. Lista todos los productos que tengan un precio entre 80€ y 300€. Sin utilizar el operador BETWEEN.

select nombre, precio from producto where precio >= 80 and precio <=300;

-- 25. Lista todos los productos que tengan un precio entre 60€ y 200€. Utilizando el operador BETWEEN.

select nombre, precio from producto where precio between 60 and 200;

-- 26. Lista todos los productos que tengan un precio mayor que 200€ y que el identificador de fabricante sea igual a 6.

select nombre, precio, codigo_fabricante from producto where precio > 200 and codigo_fabricante = 6;

-- 27. Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. Sin utilizar el operador IN.

select * from producto where codigo_fabricante = 1 or codigo_fabricante = 3 or codigo_fabricante = 5;

-- 28. Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. Utilizando el operador IN.

select * from producto where codigo_fabricante in (1 , 3 , 5 );

-- 29. Lista el nombre y el precio de los productos en céntimos (Habrá que multiplicar por 100 el valor del precio). Cree un alias para la columna que contiene el precio que se llame céntimos.

select nombre, precio * 100 as céntimos from producto;

-- 30. Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.

select * from fabricante where nombre like 'S%';

-- 31. Lista los nombres de los fabricantes cuyo nombre termine por la vocal e.

SELECT nombre FROM fabricante WHERE nombre LIKE '%e';

-- 32. Lista los nombres de los fabricantes cuyo nombre contenga el carácter w.

SELECT nombre FROM fabricante WHERE nombre LIKE '%w%';

-- 33. Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres.

SELECT nombre FROM fabricante WHERE LENGTH(nombre) = 4;

-- 34. Devuelve una lista con el nombre de todos los productos que contienen la cadena Portátil en el nombre.

SELECT nombre FROM producto WHERE nombre LIKE '%Portátil%';

-- 35. Devuelve una lista con el nombre de todos los productos que contienen la cadena Monitor en el nombre y tienen un precio inferior a 215 €.

SELECT nombre FROM producto WHERE nombre LIKE '%Monitor%' AND precio < 215;

-- 36. Lista el nombre y el precio de todos los productos que tengan un precio mayor o igual a 180€. Ordene el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en orden ascendente).

SELECT nombre, precio FROM producto WHERE precio >= 180 ORDER BY precio DESC, nombre ASC;

-- Consultas multitabla (Composición interna)
-- Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2.
-- 1. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante;

-- 2. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos. Ordene el resultado por el nombre del fabricante, por orden alfabético.
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
ORDER BY f.nombre ASC;

-- 3. Devuelve una lista con el identificador del producto, nombre del producto, identificador del fabricante y nombre del fabricante, de todos los productos de la base de datos.
SELECT p.id_producto, p.nombre AS "nombre del producto", f.id_fabricante, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante;

-- 4. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
ORDER BY p.precio ASC
LIMIT 1;

-- 5. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
ORDER BY p.precio DESC
LIMIT 1;

-- 6. Devuelve una lista de todos los productos del fabricante Lenovo.
SELECT p.nombre AS "nombre del producto", p.precio
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE f.nombre = 'Lenovo';

-- 7. Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que 200€.
SELECT p.nombre AS "nombre del producto", p.precio
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE f.nombre = 'Crucial' AND p.precio > 200;

-- 8. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Sin utilizar el operador IN.
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE f.nombre = 'Asus' OR f.nombre = 'Hewlett-Packard' OR f.nombre = 'Seagate';

-- 9. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Utilizando el operador IN.
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE f.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

-- 10. Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine por la vocal e.
SELECT p.nombre AS "nombre del producto", p.precio
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE f.nombre LIKE '%e';

-- 11. Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga el carácter w en su nombre.
SELECT p.nombre AS "nombre del producto", p.precio
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE f.nombre LIKE '%w%';

-- 12. Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos que tengan un precio mayor o igual a 180€. 
-- Ordene el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en orden ascendente).
SELECT p.nombre AS "nombre del producto", p.precio, f.nombre AS "nombre del fabricante"
FROM producto p
JOIN fabricante f ON p.id_fabricante = f.id_fabricante
WHERE p.precio >= 180
ORDER BY p.precio DESC, p.nombre ASC;

-- 13. Devuelve un listado con el identificador y el nombre de fabricante, solamente de aquellos fabricantes que tienen productos asociados en la base de datos.
SELECT DISTINCT f.id_fabricante, f.nombre AS "nombre del fabricante"
FROM fabricante f
JOIN producto p ON f.id_fabricante = p.id_fabricante;
