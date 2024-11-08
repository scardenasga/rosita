
CREATE OR REPLACE FUNCTION auditoria_general() RETURNS trigger AS $$
DECLARE
	usuario_actual VARCHAR(50);
    registro VARCHAR(50);
BEGIN

	usuario_actual := current_setting('myapp.usuario_actual', true);
	
	IF NOT EXISTS (SELECT 1 FROM usuario WHERE username = usuario_actual) THEN
        RAISE EXCEPTION 'El usuario % no existe en la tabla usuario', usuario_actual;
	END IF;


	CASE TG_TABLE_NAME
        WHEN 'producto' THEN
            registro := NEW.id_producto;
        WHEN 'persona' THEN
            registro := new.identificacion;
		WHEN 'asiento_contable' THEN
            registro := NEW.id_asiento;
		WHEN 'venta' THEN
			registro := NEW.id_venta;
		WHEN 'compra' THEN
			registro := NEW.id_compra;
		WHEN 'categoria' THEN
			registro := NEW.id_categoria;
        ELSE
            RAISE EXCEPTION 'Tabla no soportada para auditoría: %', TG_TABLE_NAME;
	END CASE;

    INSERT INTO auditoria(id_usuario, registro_id, accion, fecha,tabla)
    VALUES (usuario_actual, registro ,TG_OP, NOW(), TG_TABLE_NAME);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers de auditoria

do $$
BEGIN

CREATE  OR REPLACE TRIGGER auditoria_producto
AFTER INSERT OR UPDATE OR DELETE
ON producto
FOR EACH ROW
EXECUTE FUNCTION auditoria_general();


CREATE  OR REPLACE TRIGGER auditoria_persona
AFTER INSERT OR UPDATE OR DELETE
ON persona
FOR EACH ROW
EXECUTE FUNCTION auditoria_general();


CREATE  OR REPLACE TRIGGER auditoria_cuenta
AFTER INSERT OR UPDATE OR DELETE
ON asiento_contable
FOR EACH ROW
EXECUTE FUNCTION auditoria_general();


CREATE  OR REPLACE TRIGGER auditoria_venta
AFTER INSERT OR UPDATE OR DELETE
ON venta
FOR EACH ROW
EXECUTE FUNCTION auditoria_general();


CREATE  OR REPLACE TRIGGER auditoria_compra
AFTER INSERT OR UPDATE OR DELETE
ON compra
FOR EACH ROW
EXECUTE FUNCTION auditoria_general();


end $$



DROP TRIGGER auditoria_persona ON persona;

-- establece la variable de sesion para todas las sesiones para siempre no temmporalmente.
ALTER SYSTEM SET myapp.usuario_actual = 'none';

-- recarga la configuracion del sistema
SELECT pg_reload_conf();


set myapp.usuario_actual = 'ADMIN';
SHOW myapp.usuario_actual;

show all;


DROP TRIGGER auditoria_compras ON producto;

INSERT INTO usuario (username,contrasena,estado,id_persona) 
VALUES (
    'ADMIN',
    'ADMIN',
    'ACTIVO',
    '1031644637'  -- Identificación de la persona registrada anteriormente
);


INSERT INTO usuario (username,contrasena,estado,id_persona) 
VALUES (
    'SEBAS',
    'OTROADMIN',
    'ACTIVO',
    '1031632637'  -- Identificación de la persona registrada anteriormente
);


insert into persona (identificacion,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,fecha_nacimiento,telefono,tipo_usuario) 
values
('1031644637','AMDIN','','','','2005-09-21','3105853773','ADMINISTRADOR');

insert into persona (identificacion,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,fecha_nacimiento,telefono,tipo_usuario) 
values
('1031632637','sebastian',null,'cardenas','garcia','2004-12-12','3224094609','ADMINISTRADOR');

insert into persona (identificacion,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,fecha_nacimiento,telefono,tipo_usuario) 
values
('1031632276','juan','jose','yañez','sarmiento','2003-09-07','1234567890','CLIENTE');

select * from USUARIO;

select * from PERSONA;

select * from AUDITORIA;

SELECT identificacion FROM persona ORDER BY identificacion asc LIMIT 1;

truncate table auditoria;

delete from persona where identificacion != '1031644637';

