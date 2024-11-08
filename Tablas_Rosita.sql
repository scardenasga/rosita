create database ROSITA;

do $$

BEGIN

create type user_type as enum ('ADMINISTRADOR', 'EMPLEADO', 'CLIENTE','PROVEEDOR');


create table persona(
	identificacion VARCHAR(10) primary key not null,
	primer_nombre VARCHAR(20) not null,
	segundo_nombre VARCHAR(20),
	primer_apellido VARCHAR(20) not null,
	segundo_apellido VARCHAR(20) not null,
	fecha_nacimiento DATE not null,
	telefono VARCHAR(10),
	tipo_usuario user_type not null
);

create type tipo_estado as enum ('ACTIVO', 'INACTIVO','BLOQUEADO');

create table usuario(
	username VARCHAR(50) PRIMARY key not null,
	contrasena VARCHAR(50) not null,
	estado tipo_estado not null,
	id_persona VARCHAR(10) references persona(identificacion) not null
);

CREATE TABLE auditoria (
    id_auditoria BIGSERIAL PRIMARY key not null,
    id_usuario VARCHAR(50) references usuario(username) not null,
	registro_id VARCHAR(50),
    accion VARCHAR(10) not null,
    fecha TIMESTAMP not null,
    tabla VARCHAR(50) not null 
);



create table producto(
	id_producto VARCHAR(10) primary key not null,
	nombre VARCHAR(20) not null,
	precio numeric(10,2),
	inventario integer not null
);

create type nombre_cuenta as enum (
    'CAJA',
    'CUENTAS POR COBRAR',
    'INVENTARIOS',
    'CUENTAS POR PAGAR',
    'APORTES DE SOCIOS',
    'UTILIDADES REVENIDAS',
    'INGRESO POR VENTAS',
    'OTROS INGRESOS',
    'GASTOS DE ADMINISTRACION',
    'GASTOS DE VENTAS',
    'IMPUESTOS'
 );

create type tipo_cuenta as enum (
   	'ACTIVO',
    'PASIVO',
    'PATRIMONIO',
    'INGRESO',
    'GASTO'
);

create table cuenta_contable(
	id_cuenta SMALLSERIAL primary key not NULL,
	nombre nombre_cuenta not null, 
	tipo tipo_cuenta not null
);

create table asiento_contable(
	id_asiento BIGSERIAL primary key not null,
	fecha_asiento TIMESTAMP not null,
	total NUMERIC(10,2) not null
);

create table detalle_contable(
	id_detalle BIGSERIAL primary key not null,
	id_cuenta smallint references cuenta_contable(id_cuenta) not null,
	id_asiento BIGINT references asiento_contable(id_asiento) not null,
	debe NUMERIC(10,2) not null,
	haber NUMERIC(10,2) not null
);


create table venta(
	id_venta BIGSERIAL primary key not null,
	id_persona VARCHAR(10) references persona(identificacion) not null,
	total_venta numeric(10,2) not null,
	fecha_venta TIMESTAMP not null,
	id_asiento BIGINT references asiento_contable(id_asiento) not null
);

create table compra(
	id_compra BIGSERIAL primary key not null,
	id_persona VARCHAR(10) references persona(identificacion) not null,
	total_compra NUMERIC(10,2) not null,
	fecha_compra TIMESTAMP not null,
	id_asiento BIGINT references asiento_contable(id_asiento) not null
);

create table detalle_venta(
	id_detalle BIGSERIAL primary key not null,
	id_venta BIGINT references venta(id_venta) not null,
	id_producto VARCHAR(10) references producto(id_producto) not null,
	cantidad INTEGER not null,
	subtotal NUMERIC(8,2) not NULL
);

end $$;

CREATE CAST (varchar AS user_type) WITH INOUT AS IMPLICIT;

CREATE CAST (varchar AS tipo_estado) WITH INOUT AS IMPLICIT;

CREATE CAST (varchar AS nombre_cuenta) WITH INOUT AS IMPLICIT;

CREATE CAST (varchar AS tipo_cuenta) WITH INOUT AS IMPLICIT;

