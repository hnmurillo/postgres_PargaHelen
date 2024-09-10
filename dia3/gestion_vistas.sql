create database  dia3;

create table gama_producto (
id_gama varchar (50) primary key not null,
descripcion_texto text,
descripcion_html text,
image varchar (256)
);

create table producto(
id_producto varchar (15) not null,
nombre varchar(70) not null,
dimenciones varchar (25), 
provedor varchar (50),
descripcion text,
cantidad_en_stock smallint (6) not null,
precio_venta decimal (15.2) not null,
precio_provedor decimal (10.2),
id_gama varchar (50),
foreign key (id_gama) refereneces gama_producto (id_gama)
);

create table cliente (
id_cliente int primary key not null,
nombre_cliente varchar (50) not null,
nombre_contacto varchar (30),
apellido_contact varchar (30),
telefono varchar (15) not null,
fax varchar (15)not null,
linea_direccio1 varchar (50),
linea_direccion2 varchar (50),
ciudad varchar (50),
region varchar(50),
pais varchar (50),
codigo_postal varchar (10),
id_empleado_rep_ventas int references empleado(codigo_empleado),
limite_credito decimal(15,2)
);

create table pedido(
codigo_pedido int primary key not null,
fecha_pedido date not null,
fecha_esperada date not null,
fecha_entrega date,
estado varchar (15)not null,
comentarios text,
codigo_cliente int,
foreign key (id_cliente) references cliente (id_clinete )

);

create table pago (
forma_pago varchar (40),
id_transasaccion varchar (50) primary key not null,
fecha_pago date,
total decimal (10.2),

);


create table detalle_pedido(
id_pedido int (11),
codigo_producto varchar (15),
cantidad int (11) not null,
precio-unoidad decimal (10.2) not null,
numero_linea smallint (6)
);


create table oficina(
id_oficina varchar (10) primary key not null,
ciudad varchar (30) not null,
pais varchar (50) not null,
region varchar (50),
codigo_postal varchar (10) not null,
telefono varchar (20) not null,
linea_direccion1 varchar (50) not null,
linea_direccion2 varchar (50)
);

create  table empleado(
id_empleado primary key not null,
nombre varchar (50) not null,
apellido1 varchar (50) not null,
apellido2 varchar (50),
extension varchar (100) not null,
email varchar(100) not null,
id_oficina varchar (50) not null,
foreign key (id_odicina) references oficina (id_oficina)
codigo_jefe int references empleado (id_empleado),
puesto  varchar (50)
);
