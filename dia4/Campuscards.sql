

CREATE TYPE estado_vehiculo AS ENUM ('nuevo', 'usado', 'certificado');
CREATE TYPE estado_interes AS ENUM ('contactado', 'no contactado');
CREATE TYPE rol_empleado AS ENUM ('vendedor', 'tecnico', 'gerente');

CREATE TABLE vehiculo (
    id_vehiculo SERIAL PRIMARY KEY,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    año INT,
    precio DECIMAL(10, 2),
    estado estado_vehiculo -- Usando ENUM
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE empleado (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    correo_electronico VARCHAR(100),
    rol rol_empleado -- Usando ENUM
);
CREATE TABLE venta (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES cliente(id_cliente),
    id_vehiculo INT REFERENCES vehiculo(id_vehiculo),
    id_vendedor INT REFERENCES empleado(id_empleado),
    fecha_venta DATE,
    precio_venta DECIMAL(10, 2),
    comision DECIMAL(10, 2)
);

CREATE TABLE historial_servicio (
    id_servicio SERIAL PRIMARY KEY,
    id_vehiculo INT REFERENCES vehiculo(id_vehiculo),
    id_empleado INT REFERENCES empleado(id_empleado),
    fecha_servicio DATE,
    descripcion TEXT,
    costo DECIMAL(10, 2)
);

CREATE TABLE proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    correo_electronico VARCHAR(100)
);

CREATE TABLE pieza (
    id_pieza SERIAL PRIMARY KEY,
    id_proveedor INT REFERENCES proveedor(id_proveedor),
    nombre_pieza VARCHAR(100),
    numero_pieza VARCHAR(50),
    precio DECIMAL(10, 2),
    cantidad_en_stock INT
);

INSERT INTO vehiculo (marca, modelo, año, precio, estado) 
VALUES 
('Toyota', 'Corolla', 2022, 22000, 'nuevo'),
('Ford', 'Focus', 2021, 18000, 'usado'),
('Honda', 'Civic', 2020, 17000, 'usado'),
('Chevrolet', 'Spark', 2023, 15000, 'nuevo'),
('Nissan', 'Altima', 2019, 16000, 'certificado'),
('Hyundai', 'Elantra', 2022, 21000, 'nuevo'),
('Mazda', 'CX-5', 2020, 25000, 'usado'),
('Volkswagen', 'Jetta', 2021, 20000, 'nuevo'),
('Kia', 'Sorento', 2020, 28000, 'usado'),
('BMW', 'X5', 2023, 60000, 'nuevo');

INSERT INTO cliente (nombre, apellido, correo_electronico, telefono) 
VALUES 
('Juan', 'Pérez', 'juan.perez@example.com', '555-1234'),
('Ana', 'Torres', 'ana.torres@example.com', '555-5678'),
('Carlos', 'Gómez', 'carlos.gomez@example.com', '555-9101'),
('María', 'Rodríguez', 'maria.rodriguez@example.com', '555-1213'),
('Luis', 'López', 'luis.lopez@example.com', '555-1415'),
('Elena', 'Martínez', 'elena.martinez@example.com', '555-1617'),
('Pablo', 'Fernández', 'pablo.fernandez@example.com', '555-1819'),
('Laura', 'García', 'laura.garcia@example.com', '555-2021'),
('Pedro', 'Jiménez', 'pedro.jimenez@example.com', '555-2223'),
('Carolina', 'Sánchez', 'carolina.sanchez@example.com', '555-2425');

INSERT INTO empleado (nombre, apellido, correo_electronico, rol) 
VALUES 
('Carlos', 'Gómez', 'carlos.gomez@example.com', 'vendedor'),
('Ana', 'Torres', 'ana.torres@example.com', 'vendedor'),
('Pablo', 'Fernández', 'pablo.fernandez@example.com', 'tecnico'),
('Laura', 'García', 'laura.garcia@example.com', 'gerente'),
('Juan', 'Pérez', 'juan.perez@example.com', 'vendedor'),
('Pedro', 'Jiménez', 'pedro.jimenez@example.com', 'tecnico'),
('Carolina', 'Sánchez', 'carolina.sanchez@example.com', 'vendedor'),
('María', 'Rodríguez', 'maria.rodriguez@example.com', 'gerente'),
('Luis', 'López', 'luis.lopez@example.com', 'tecnico'),
('Elena', 'Martínez', 'elena.martinez@example.com', 'vendedor');

INSERT INTO venta (id_cliente, id_vehiculo, id_vendedor, fecha_venta, precio_venta, comision)
VALUES 
(1, 1, 1, '2024-01-15', 22000, 1500),
(2, 2, 2, '2024-02-10', 18000, 1200),
(3, 3, 1, '2024-03-22', 17000, 1100),
(4, 4, 3, '2024-04-05', 15000, 1000),
(5, 5, 2, '2024-05-18', 16000, 1100),
(6, 6, 1, '2024-06-11', 21000, 1400),
(7, 7, 3, '2024-07-29', 25000, 1700),
(8, 8, 1, '2024-08-12', 20000, 1300),
(9, 9, 2, '2024-09-21', 28000, 1900),
(10, 10, 3, '2024-10-03', 60000, 4000);

INSERT INTO historial_servicio (id_vehiculo, id_empleado, fecha_servicio, descripcion, costo)
VALUES 
(1, 3, '2024-02-15', 'Mantenimiento de frenos', 500),
(2, 4, '2024-03-01', 'Cambio de aceite', 100),
(3, 5, '2024-03-20', 'Reparación de motor', 1500),
(4, 6, '2024-04-05', 'Revisión general', 300),
(5, 7, '2024-04-22', 'Alineación y balanceo', 200),
(6, 8, '2024-05-10', 'Cambio de batería', 250),
(7, 9, '2024-06-01', 'Reparación de suspensión', 1200),
(8, 3, '2024-06-25', 'Cambio de neumáticos', 600),
(9, 4, '2024-07-12', 'Revisión de frenos', 500),
(10, 5, '2024-08-01', 'Cambio de aceite y filtro', 150);

INSERT INTO proveedor (nombre, contacto, telefono, correo_electronico)
VALUES 
('Proveedor A', 'Contacto A', '555-1010', 'contactoA@example.com'),
('Proveedor B', 'Contacto B', '555-1111', 'contactoB@example.com'),
('Proveedor C', 'Contacto C', '555-1212', 'contactoC@example.com'),
('Proveedor D', 'Contacto D', '555-1313', 'contactoD@example.com'),
('Proveedor E', 'Contacto E', '555-1414', 'contactoE@example.com'),
('Proveedor F', 'Contacto F', '555-1515', 'contactoF@example.com'),
('Proveedor G', 'Contacto G', '555-1616', 'contactoG@example.com'),
('Proveedor H', 'Contacto H', '555-1717', 'contactoH@example.com'),
('Proveedor I', 'Contacto I', '555-1818', 'contactoI@example.com'),
('Proveedor J', 'Contacto J', '555-1919', 'contactoJ@example.com');

INSERT INTO pieza (id_proveedor, nombre_pieza, numero_pieza, precio, cantidad_en_stock)
VALUES 
(1, 'Filtro de aceite', 'FO123', 15.00, 100),
(2, 'Pastillas de freno', 'PB456', 35.00, 200),
(3, 'Batería', 'BT789', 120.00, 50),
(4, 'Neumático', 'NT111', 80.00, 150),
(5, 'Amortiguador', 'AM222', 60.00, 75),
(6, 'Filtro de aire', 'FA333', 25.00, 100),
(7, 'Bomba de agua', 'BA444', 95.00, 40),
(8, 'Correa de distribución', 'CD555', 45.00, 30),
(9, 'Aceite de motor', 'AE666', 50.00, 300),
(10, 'Radiador', 'RA777', 150.00, 20);


