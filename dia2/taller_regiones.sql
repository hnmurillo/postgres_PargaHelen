


create table Persona(
	id SERIAL primary key not null,
	nombre VARCHAR(250),
	apellido VARCHAR(250),
	municipio_nacimiento VARCHAR(250),
	municipio_domicilio VARCHAR(250)
);

create table Region(
	id SERIAL primary key not null,
	region VARCHAR(250),
	departamento VARCHAR(250),
	codigo_departamento VARCHAR(250),
	municipio VARCHAR(250),
	codigo_municipio VARCHAR(250)
);


select * from pg_catalog.pg_tables;

select * from Region;



-- 1.Crear una vista que muestre las regiones con sus departamentos.Generar una columna que muestre
--   la cantidad de municipios por cada departamento. 

create or replace view vista_regiones_departamentos as
select region, departamento, COUNT(municipio) as cantidad_municipios 
from Region 
group by region, departamento;

select * from vista_regiones_departamentos;

-- 2.Crear una vista que muestre los departamentos con sus respectivos municipios.Generar la columna
--   de código de departamento concatenado con el código de municipio.

create or replace view vista_departamentos_municipios as 
select departamento, municipio, CONCAT(codigo_departamento, codigo_municipio) as codigo_completo
from Region;

select * from vista_departamentos_municipios;

-- 3.Agregar dos columnas que permitan llevar el conteo de personas que viven y trabajan en cada municipio,
-- implementar un disparador que actualice esos conteos cada que se agregue, modifique o elimine un dato de 
-- municipio de nacimiento y/o de domicilio.

ALTER TABLE Region
ADD COLUMN personas_viven INT DEFAULT 0,
ADD COLUMN personas_trabajan INT DEFAULT 0;

CREATE OR REPLACE FUNCTION actualizar_conteos()
RETURNS TRIGGER AS $$
BEGIN
    -- Si se inserta o actualiza una persona
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        -- Actualizar el conteo de trabajadores en el municipio de nacimiento
        IF (NEW.municipio_nacimiento IS DISTINCT FROM OLD.municipio_nacimiento) THEN
            -- Decrementar conteo en el municipio anterior
            IF TG_OP = 'UPDATE' AND OLD.municipio_nacimiento IS NOT NULL THEN
                UPDATE Region
                SET personas_trabajan = personas_trabajan - 1
                WHERE municipio = OLD.municipio_nacimiento;
            END IF;
            -- Incrementar conteo en el nuevo municipio
            UPDATE Region
            SET personas_trabajan = personas_trabajan + 1
            WHERE municipio = NEW.municipio_nacimiento;
        END IF;

        -- Actualizar el conteo de residentes en el municipio de domicilio
        IF (NEW.municipio_domicilio IS DISTINCT FROM OLD.municipio_domicilio) THEN
            -- Decrementar conteo en el municipio anterior
            IF TG_OP = 'UPDATE' AND OLD.municipio_domicilio IS NOT NULL THEN
                UPDATE Region
                SET personas_viven = personas_viven - 1
                WHERE municipio = OLD.municipio_domicilio;
            END IF;
            -- Incrementar conteo en el nuevo municipio
            UPDATE Region
            SET personas_viven = personas_viven + 1
            WHERE municipio = NEW.municipio_domicilio;
        END IF;
    END IF;

    -- Si se elimina una persona
    IF TG_OP = 'DELETE' THEN
        -- Decrementar ambos contadores en el municipio correspondiente
        IF OLD.municipio_nacimiento IS NOT NULL THEN
            UPDATE Region
            SET personas_trabajan = personas_trabajan - 1
            WHERE municipio = OLD.municipio_nacimiento;
        END IF;
        
        IF OLD.municipio_domicilio IS NOT NULL THEN
            UPDATE Region
            SET personas_viven = personas_viven - 1
            WHERE municipio = OLD.municipio_domicilio;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_actualizar_conteos
AFTER INSERT OR UPDATE OR DELETE ON Persona
FOR EACH ROW
EXECUTE FUNCTION actualizar_conteos();

-- 4.Agregar las columnas de conteos a la vista que muestra la lista de departamentos y municipios.

create or replace view vista_departamentos_municipios as
select departamento, municipio, CONCAT(codigo_departamento, codigo_municipio) as codigo_completo,
    personas_viven, personas_trabajan
from Region;

select * from vista_departamentos_municipios;

-- Insertar una nueva persona para test
INSERT INTO Persona (nombre, apellido, municipio_nacimiento, municipio_domicilio)
VALUES ('Laura', 'Diaz', 'Bogota', 'floridablanca');



--