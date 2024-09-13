CREATE DATABASE dia3;

-- Tabla oficina
CREATE TABLE oficina (
    id_oficina VARCHAR(10) PRIMARY KEY NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    codigo_postal VARCHAR(10) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    linea_direccion1 VARCHAR(50) NOT NULL,
    linea_direccion2 VARCHAR(50)
);

-- Tabla gama_producto
CREATE TABLE gama_producto (
    id_gama VARCHAR(50) PRIMARY KEY NOT NULL,
    descripcion_texto TEXT,
    descripcion_html TEXT,
    image VARCHAR(256)
);

-- Tabla producto
CREATE TABLE producto (
    id_producto VARCHAR(15) PRIMARY KEY NOT NULL,
    nombre VARCHAR(70) NOT NULL,
    id_gama VARCHAR(50) NOT NULL,
    dimensiones VARCHAR(25),
    proveedor VARCHAR(50),
    descripcion TEXT,
    cantidad_en_stock SMALLINT NOT NULL,
    precio_venta DECIMAL(15, 2) NOT NULL,
    precio_proveedor DECIMAL(15, 2),
    FOREIGN KEY (id_gama) REFERENCES gama_producto(id_gama)
);

-- Tabla empleado
CREATE TABLE empleado (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    extension VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    id_oficina VARCHAR(10) NOT NULL,
    codigo_jefe INT,
    puesto VARCHAR(50),
    FOREIGN KEY (id_oficina) REFERENCES oficina(id_oficina),
    FOREIGN KEY (codigo_jefe) REFERENCES empleado(id_empleado)
);

-- Tabla cliente
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(50) NOT NULL,
    nombre_contacto VARCHAR(30),
    apellido_contacto VARCHAR(30),
    telefono VARCHAR(15) NOT NULL,
    fax VARCHAR(15),
    linea_direccion1 VARCHAR(50),
    linea_direccion2 VARCHAR(50),
    ciudad VARCHAR(50),
    region VARCHAR(50),
    pais VARCHAR(50),
    codigo_postal VARCHAR(10),
    id_empleado_rep_ventas INT,
    limite_credito DECIMAL(15,2),
    FOREIGN KEY (id_empleado_rep_ventas) REFERENCES empleado(id_empleado)
);

-- Tabla pago
CREATE TABLE pago (
    id_transaccion VARCHAR(50) PRIMARY KEY NOT NULL,
    forma_pago VARCHAR(40),
    fecha_pago DATE,
    total DECIMAL(10, 2),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Tabla pedido
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    fecha_pedido DATE NOT NULL,
    fecha_esperada DATE NOT NULL,
    fecha_entrega DATE,
    estado VARCHAR(15) NOT NULL,
    comentarios TEXT,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Tabla detalle_pedido
CREATE TABLE detalle_pedido (
    cantidad INT NOT NULL,
    precio_unidad DECIMAL(10, 2) NOT NULL,
    numero_linea SMALLINT,
    id_pedido INT,
    id_producto VARCHAR(15),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- --------------------------------------------------------
-- ---------------------Consultas--------------------------
-- --------------------------------------------------------

-- Listado con el código de oficina y la ciudad donde hay oficinas:

SELECT id_oficina, ciudad
FROM oficina;

-- Listado con la ciudad y el teléfono de las oficinas en España:

SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España';


.-- Listado con el nombre, apellidos y email de los empleados cuyo jefe 
-- tiene un código de jefe igual a 7:

SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe = 7;

-- Nombre del puesto, nombre, apellidos y email del jefe de la empresa:

SELECT puesto, nombre, apellido1, apellido2, email
FROM empleado
WHERE id_empleado = (SELECT codigo_jefe FROM empleado WHERE codigo_jefe IS NULL);

-- Listado con el nombre, apellidos y puesto de los empleados que no son 
-- representantes de ventas:

SELECT nombre, apellido1, apellido2, puesto
FROM empleado
WHERE puesto != 'Representante de Ventas';

-- Listado con el nombre de todos los clientes españoles:

SELECT nombre_cliente
FROM cliente
WHERE pais = 'España';


-- Listado con los distintos estados por los que puede pasar un pedido:

SELECT DISTINCT estado
FROM pedido;

-- Listado con el código de cliente de aquellos clientes que realizaron algún
-- pago en 2008:

SELECT DISTINCT id_cliente
FROM pago
WHERE EXTRACT(YEAR FROM fecha_pago) = 2008;

--  Listado con el código de pedido, código de cliente, fecha esperada y 
--  fecha de entrega de los pedidos que no han sido entregados a tiempo:    


SELECT id_pedido, id_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;

-- Devuelve un listado con el código de pedido, código de cliente, fecha
-- esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al
-- menos dos días antes de la fecha esperada.

--  A) Utilizando la función ADDDATE (equivalente en PostgreSQL es DATE + INTERVAL):

		SELECT id_pedido, id_cliente, fecha_esperada, fecha_entrega
		FROM pedido
		WHERE fecha_entrega <= (fecha_esperada - INTERVAL '2 days');
		
--  B) Utilizando la función DATEDIFF (en PostgreSQL puedes usar AGE o simplemente 
--     restar las fechas):		

	
		SELECT id_pedido, id_cliente, fecha_esperada, fecha_entrega
		FROM pedido
		WHERE fecha_esperada - fecha_entrega >= INTERVAL '2 days';


--  C)  Usando el operador de resta - directamente:
	
		SELECT id_pedido, id_cliente, fecha_esperada, fecha_entrega
		FROM pedido
		WHERE (fecha_esperada - fecha_entrega) >= 2;


--  Listado de todos los pedidos que fueron rechazados en 2009:

	SELECT id_pedido, fecha_pedido, estado
	FROM pedido
	WHERE estado = 'Rechazado' 
	AND EXTRACT(YEAR FROM fecha_pedido) = 2009;

-- Listado de todos los pedidos que han sido entregados en el mes de enero
--  de cualquier año:

	SELECT id_pedido, fecha_entrega
	FROM pedido
	WHERE EXTRACT(MONTH FROM fecha_entrega) = 1;

-- Listado de todos los pagos que se realizaron en el año 2008 mediante Paypal, ordenados
-- de mayor a menor:
	SELECT id_transaccion, forma_pago, fecha_pago, total
	FROM pago
	WHERE EXTRACT(YEAR FROM fecha_pago) = 2008
	AND forma_pago = 'Paypal'
	ORDER BY total DESC;



-- Listado con todas las formas de pago que aparecen en la tabla pago (sin repetidos):

	SELECT DISTINCT forma_pago
	FROM pago;

-- Listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más
-- de 100 unidades en stock, ordenados por precio de venta de mayor a menor:

	SELECT nombre, cantidad_en_stock, precio_venta
	FROM producto
	WHERE id_gama = (SELECT id_gama FROM gama_producto WHERE id_gama = 'Ornamentales')
	AND cantidad_en_stock > 100
	ORDER BY precio_venta DESC;
	
-- listado con todos los clientes de Madrid cuyo representante de ventas tenga el código
--  de empleado 11 o 30:

	SELECT nombre_cliente, ciudad, id_empleado_rep_ventas
	FROM cliente
	WHERE ciudad = 'Madrid'
	AND id_empleado_rep_ventas IN (11, 30);

-- ----------------------------------------------------------------------------------------
-- -------------------Consultas multitabla (Composición interna)---------------------------
-- ----------------------------------------------------------------------------------------

-- 1. Listado con el nombre de cada cliente y el nombre y apellido de su representante 
-- de ventas.

-- 1). SQL1 (estilo tradicional):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
	FROM cliente c, empleado e
	WHERE c.id_empleado_rep_ventas = e.id_empleado;

-- 2). SQL2 (INNER JOIN):
    SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
	FROM cliente c
	INNER JOIN empleado e ON c.id_empleado_rep_ventas = e.id_empleado;
	 
	
-- 3). SQL2 (NATURAL JOIN):

	SELECT nombre_cliente, nombre, apellido1, apellido2
	FROM cliente
	NATURAL JOIN empleado;

-- Nombre de los clientes que hayan realizado pagos junto con el nombre
-- de sus representantes de ventas.

-- 1). SQL1 (estilo tradicional):	

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
	FROM cliente c, empleado e, pago p
	WHERE c.id_cliente = p.id_cliente
	AND c.id_empleado_rep_ventas = e.id_empleado;

-- 2). SQL2 (INNER JOIN):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
	FROM cliente c
	INNER JOIN pago p ON c.id_cliente = p.id_cliente
	INNER JOIN empleado e ON c.id_empleado_rep_ventas = e.id_empleado;

-- 3). SELECT nombre_cliente, nombre, apellido1, apellido2

	FROM cliente
	NATURAL JOIN pago
	NATURAL JOIN empleado;

-- Nombre de los clientes que no hayan realizado pagos junto con el
-- nombre de sus representantes de ventas.

-- 1). SQL1 (estilo tradicional):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
	FROM cliente c, empleado e
	WHERE c.id_empleado_rep_ventas = e.id_empleado
	AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);

-- 2). SQL2 (INNER JOIN):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
	FROM cliente c
	INNER JOIN empleado e ON c.id_empleado_rep_ventas = e.id_empleado
	LEFT JOIN pago p ON c.id_cliente = p.id_cliente
	WHERE p.id_cliente IS NULL;

-- 3). SQL2 (NATURAL JOIN):

	SELECT nombre_cliente, nombre, apellido1, apellido2
	FROM cliente
	NATURAL JOIN empleado
	LEFT JOIN pago USING (id_cliente)
	WHERE pago.id_cliente IS NULL;

-- Nombre de los clientes que han hecho pagos, el nombre de sus representantes y 
-- la ciudad de la oficina a la que pertenece el representante.

-- 1). SQL1 (estilo tradicional):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
	FROM cliente c, empleado e, pago p, oficina o
	WHERE c.id_cliente = p.id_cliente
	AND c.id_empleado_rep_ventas = e.id_empleado
	AND e.id_oficina = o.id_oficina;

-- 2). SQL2 (INNER JOIN):
	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
	FROM cliente c
	INNER JOIN pago p ON c.id_cliente = p.id_cliente
	INNER JOIN empleado e ON c.id_empleado_rep_ventas = e.id_empleado
	INNER JOIN oficina o ON e.id_oficina = o.id_oficina;


-- 3). SQL2 (NATURAL JOIN):

	SELECT nombre_cliente, nombre, apellido1, apellido2, ciudad
	FROM cliente
	NATURAL JOIN pago
	NATURAL JOIN empleado
	NATURAL JOIN oficina;

-- Nombre de los clientes que no hayan hecho pagos, el nombre de sus representantes y 
-- la ciudad de la oficina a la que pertenece el representante.

-- 1). SQL1 (estilo tradicional):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
	FROM cliente c, empleado e, oficina o
	WHERE c.id_empleado_rep_ventas = e.id_empleado
	AND e.id_oficina = o.id_oficina
	AND c.id_cliente NOT IN (SELECT id_cliente FROM pago);

-- 2). SQL2 (INNER JOIN):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
	FROM cliente c
	INNER JOIN empleado e ON c.id_empleado_rep_ventas = e.id_empleado
	INNER JOIN oficina o ON e.id_oficina = o.id_oficina
	LEFT JOIN pago p ON c.id_cliente = p.id_cliente
	WHERE p.id_cliente IS NULL;

	
-- 3). SQL2 (NATURAL JOIN):

	
	SELECT nombre_cliente, nombre, apellido1, apellido2, ciudad
	FROM cliente
	NATURAL JOIN empleado
	NATURAL JOIN oficina
	LEFT JOIN pago USING (id_cliente)
	WHERE pago.id_cliente IS NULL;

-- 1). SQL1 (estilo tradicional):

	SELECT o.linea_direccion1, o.linea_direccion2, o.ciudad, o.pais, o.codigo_postal
	FROM oficina o, cliente c
	WHERE c.ciudad = 'Fuenlabrada'
	AND c.id_empleado_rep_ventas = (SELECT e.id_empleado FROM empleado e WHERE e.id_oficina = o.id_oficina);


-- 2). SQL2 (INNER JOIN):

	SELECT o.linea_direccion1, o.linea_direccion2, o.ciudad, o.pais, o.codigo_postal
	FROM oficina o
	INNER JOIN empleado e ON o.id_oficina = e.id_oficina
	INNER JOIN cliente c ON c.id_empleado_rep_ventas = e.id_empleado
	WHERE c.ciudad = 'Fuenlabrada';


-- Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la
--  que pertenece el representante.


-- 1). SQL1 (estilo tradicional):
	SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
	FROM cliente c, empleado e, oficina o
	WHERE c.id_empleado_rep_ventas = e.id_empleado
	AND e.id_oficina = o.id_oficina;

-- 2). SQL2 (INNER JOIN):

	SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
	FROM cliente c
	INNER JOIN empleado e ON c.id_empleado_rep_ventas = e.id_empleado
	INNER JOIN oficina o ON e.id_oficina = o.id_oficina;

-- Listado con el nombre de los empleados junto con el nombre de sus jefes.

-- 1). SQL1 (estilo tradicional):

	SELECT e1.nombre AS empleado, e2.nombre AS jefe
	FROM empleado e1, empleado e2
	WHERE e1.codigo_jefe = e2.id_empleado;


-- 2). SQL2 (INNER JOIN):

	SELECT e1.nombre AS empleado, e2.nombre AS jefe
	FROM empleado e1
	INNER JOIN empleado e2 ON e1.codigo_jefe = e2.id_empleado;

-- Listado que muestre el nombre de cada empleado, el nombre de su jefe 
-- y el nombre del jefe de su jefe.

-- 1). SQL1 (estilo tradicional):

	SELECT e1.nombre AS empleado, e2.nombre AS jefe, e3.nombre AS jefe_del_jefe
	FROM empleado e1, empleado e2, empleado e3
	WHERE e1.codigo_jefe = e2.id_empleado
	AND e2.codigo_jefe = e3.id_empleado;

-- 2). SQL2 (INNER JOIN):

	SELECT e1.nombre AS empleado, e2.nombre AS jefe, e3.nombre AS jefe_del_jefe
	FROM empleado e1
	INNER JOIN empleado e2 ON e1.codigo_jefe = e2.id_empleado
	INNER JOIN empleado e3 ON e2.codigo_jefe = e3.id_empleado;


-- Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.

-- 1). SQL1 (estilo tradicional):
	SELECT c.nombre_cliente
	FROM cliente c, pedido p
	WHERE c.id_cliente = p.codigo_cliente
	AND p.fecha_entrega > p.fecha_esperada;

-- 2). SQL2 (INNER JOIN):

	SELECT c.nombre_cliente
	FROM cliente c
	INNER JOIN pedido p ON c.id_cliente = p.codigo_cliente
	WHERE p.fecha_entrega > p.fecha_esperada;

-- 11. Listado de las diferentes gamas de producto que ha comprado cada cliente.

-- 1). SQL1 (estilo tradicional):

	SELECT c.nombre_cliente, gp.id_gama
	FROM cliente c, pedido p, detalle_pedido dp, producto pr, gama_producto gp
	WHERE c.id_cliente = p.codigo_cliente
	AND p.id_pedido = dp.id_pedido
	AND dp.id_producto = pr.id_producto
	AND pr.id_gama = gp.id_gama;

-- 2). SQL2 (INNER JOIN):

	SELECT c.nombre_cliente, gp.id_gama
	FROM cliente c
	INNER JOIN pedido p ON c.id_cliente = p.codigo_cliente
	INNER JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
	INNER JOIN producto pr ON dp.id_producto = pr.id_producto
	INNER JOIN gama_producto gp ON pr.id_gama = gp.id_gama;


-- -------------------------------------------------------------------------------
-- ---------------Consultas multitabla (Composición externa)----------------------
-- -------------------------------------------------------------------------------


-- 1). LEFT JOIN:

	SELECT c.nombre_cliente
	FROM cliente c
	LEFT JOIN pago p ON c.id_cliente = p.id_cliente
	WHERE p.id_cliente IS NULL;


-- 2). NATURAL LEFT JOIN:
	SELECT nombre_cliente
	FROM cliente
	NATURAL LEFT JOIN pago
	WHERE id_cliente IS NULL;

--  Listado de clientes que no han realizado ningún pedido.

-- 1). LEFT JOIN:
	
	SELECT c.nombre_cliente
	FROM cliente c
	LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente
	WHERE p.codigo_cliente IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT nombre_cliente
	FROM cliente
	NATURAL LEFT JOIN pedido
	WHERE id_cliente IS NULL;

-- Listado de clientes que no han realizado ningún pago y los que no han realizado ningún pedido.

-- 1). LEFT JOIN:

	SELECT c.nombre_cliente
	FROM cliente c
	LEFT JOIN pago p ON c.id_cliente = p.id_cliente
	LEFT JOIN pedido o ON c.id_cliente = o.codigo_cliente
	WHERE p.id_cliente IS NULL OR o.codigo_cliente IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT nombre_cliente
	FROM cliente
	NATURAL LEFT JOIN pago
	NATURAL LEFT JOIN pedido
	WHERE id_cliente IS NULL OR codigo_cliente IS NULL;

--  Listado de empleados que no tienen una oficina asociada.

-- 1). LEFT JOIN:
	SELECT e.nombre, e.apellido1
	FROM empleado e
	LEFT JOIN oficina o ON e.id_oficina = o.id_oficina
	WHERE o.id_oficina IS NULL;


-- 2). NATURAL LEFT JOIN:

	SELECT nombre, apellido1
	FROM empleado
	NATURAL LEFT JOIN oficina
	WHERE id_oficina IS NULL;

--  Listado de empleados que no tienen un cliente asociado.

-- 1). LEFT JOIN:

	SELECT e.nombre, e.apellido1
	FROM empleado e
	LEFT JOIN cliente c ON e.id_empleado = c.id_empleado_rep_ventas
	WHERE c.id_empleado_rep_ventas IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT nombre, apellido1
	FROM empleado
	NATURAL LEFT JOIN cliente
	WHERE id_empleado_rep_ventas IS NULL;

-- Listado de empleados que no tienen un cliente asociado junto con los datos 
-- de la oficina donde trabajan.

-- 1). LEFT JOIN:

	SELECT e.nombre, e.apellido1, o.linea_direccion1, o.linea_direccion2, o.ciudad, o.pais
	FROM empleado e
	LEFT JOIN cliente c ON e.id_empleado = c.id_empleado_rep_ventas
	LEFT JOIN oficina o ON e.id_oficina = o.id_oficina
	WHERE c.id_empleado_rep_ventas IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT nombre, apellido1, linea_direccion1, linea_direccion2, ciudad, pais
	FROM empleado
	NATURAL LEFT JOIN cliente
	NATURAL LEFT JOIN oficina
	WHERE id_empleado_rep_ventas IS NULL;

--  Listado que muestre los empleados que no tienen una oficina asociada y los que no tienen
--  un cliente asociado.

-- 1). LEFT JOIN:
	SELECT e.nombre, e.apellido1, 'No Oficina' AS motivo
	FROM empleado e
	LEFT JOIN oficina o ON e.id_oficina = o.id_oficina
	WHERE o.id_oficina IS NULL
	
	UNION
	
	SELECT e.nombre, e.apellido1, 'No Cliente' AS motivo
	FROM empleado e
	LEFT JOIN cliente c ON e.id_empleado = c.id_empleado_rep_ventas
	WHERE c.id_empleado_rep_ventas IS NULL;

-- 2). NATURAL LEFT JOIN:
}	SELECT nombre, apellido1, 'No Oficina' AS motivo
	FROM empleado
	NATURAL LEFT JOIN oficina
	WHERE id_oficina IS NULL
	
	UNION
	
	SELECT nombre, apellido1, 'No Cliente' AS motivo
	FROM empleado
	NATURAL LEFT JOIN cliente
	WHERE id_empleado_rep_ventas IS NULL;

-- Listado de los productos que nunca han aparecido en un pedido.

-- 1). LEFT JOIN:

	SELECT p.id_producto, p.nombre
	FROM producto p
	LEFT JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
	WHERE dp.id_producto IS NULL;


-- 2). NATURAL LEFT JOIN:

	SELECT id_producto, nombre
	FROM producto
	NATURAL LEFT JOIN detalle_pedido
	WHERE id_producto IS NULL;

-- Listado de los productos que nunca han aparecido en un pedido, mostrando nombre, 
-- descripción e imagen del producto.

-- 1). LEFT JOIN:

	SELECT p.id_producto, p.nombre, p.descripcion, p.image
	FROM producto p
	LEFT JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
	WHERE dp.id_producto IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT id_producto, nombre, descripcion, image
	FROM producto
	NATURAL LEFT JOIN detalle_pedido
	WHERE id_producto IS NULL;

--  Oficinas donde no trabajan empleados que hayan sido representantes de ventas de algún cliente que haya
--  comprado productos de la gama Frutales.

-- 1). LEFT JOIN:

	SELECT o.id_oficina, o.linea_direccion1, o.linea_direccion2, o.ciudad
	FROM oficina o
	LEFT JOIN empleado e ON o.id_oficina = e.id_oficina
	LEFT JOIN cliente c ON e.id_empleado = c.id_empleado_rep_ventas
	LEFT JOIN pedido p ON c.id_cliente = p.codigo_cliente
	LEFT JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
	LEFT JOIN producto pr ON dp.id_producto = pr.id_producto
	WHERE pr.id_gama = 'Frutales'
	AND e.id_oficina IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT o.id_oficina, o.linea_direccion1, o.linea_direccion2, o.ciudad
	FROM oficina o
	NATURAL LEFT JOIN empleado
	NATURAL LEFT JOIN cliente
	NATURAL LEFT JOIN pedido
	NATURAL LEFT JOIN detalle_pedido
	NATURAL LEFT JOIN producto
	WHERE id_gama = 'Frutales'
	AND id_oficina IS NULL;

-- Listado de clientes que han realizado algún pedido pero no han realizado ningún pago.

-- 1). LEFT JOIN:
	
	SELECT c.nombre_cliente
	FROM cliente c
	INNER JOIN pedido p ON c.id_cliente = p.codigo_cliente
	LEFT JOIN pago pa ON c.id_cliente = pa.id_cliente
	WHERE pa.id_cliente IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT nombre_cliente
	FROM cliente
	NATURAL INNER JOIN pedido
	NATURAL LEFT JOIN pago
	WHERE id_cliente IS NULL;

--  Listado con los datos de los empleados que no tienen clientes asociados y el nombre
--  de su jefe asociado.

-- 1). LEFT JOIN:

	SELECT e1.nombre AS empleado, e1.apellido1, e2.nombre AS jefe, e2.apellido1 AS apellido_jefe
	FROM empleado e1
	LEFT JOIN cliente c ON e1.id_empleado = c.id_empleado_rep_ventas
	LEFT JOIN empleado e2 ON e1.codigo_jefe = e2.id_empleado
	WHERE c.id_empleado_rep_ventas IS NULL;

-- 2). NATURAL LEFT JOIN:

	SELECT e1.nombre AS empleado, e1.apellido1, e2.nombre AS jefe, e2.apellido1 AS apellido_jefe
	FROM empleado e1
	NATURAL LEFT JOIN cliente
	NATURAL LEFT JOIN empleado e2
	WHERE id_empleado_rep_ventas IS NULL;









