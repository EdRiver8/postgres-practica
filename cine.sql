-- usar la base de datos cine si existe, sino crearla en postgres
-- create database if not exists cine; -- solo sirve de postgres 9 en adelante
-- -- seleccionar la base de datos cine
-- \c cine;

-- Eliminado en cascada, primero las dependientes y luego las masters
drop table if exists Favoritos;
drop table if exists Reservas;
drop table if exists Empleados;
drop table if exists Asientos;
drop table if exists Funciones;
drop table if exists Peliculas;
drop table if exists Generos;
drop table if exists Clientes;

-- Creacion tablas Maestras(Fuertes)
create table Clientes(
	cliente_id serial primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    direccion varchar(100),
	telefono varchar(20),
    correo_electronico varchar(200) unique not null,
    fecha_registro timestamp default current_timestamp -- valor por defecto de la fecha actual
);

insert into Clientes(nombre, apellido, correo_electronico)
values ('Ron', 'Damon', '14meses@paguemelarenta.com'),
('la chilindrina', 'Gomez', 'chillona@vecindad.com'),
('el chavo', 'Gomez', 'pipipi@vecindad.com'),
('el chapulin', 'Colorado', 'elchipote@vecindad.com'),
('el señor', 'Barriga', 'paguemelarenta@vecindad.com'),
('la bruja', 'del 71', 'zatanas@vecindad.com'),
('el profesor', 'Jirafales', 'tatata@vecindad.com'),
('la popis', 'Gomez', 'nomesimpatisas@vecidad.com');

select * from Clientes;

create table Generos(
	genero_id serial primary key,
	nombre varchar(100) not null
);

insert into Generos(nombre)
values ('Accion'), ('Comedia'), ('Drama'), ('Terror'), ('Ciencia Ficcion'), ('Musical'), ('Romance'), ('Documental'), ('Animacion'), ('Accion');

select * from Generos;

-- creacion de tablas dependientes
create table Peliculas(
	pelicula_id serial primary key,
    titulo varchar(100) not null,
    genero_id integer references Generos(genero_id) not null, -- references busca que el id si exista en la otra tabla (integridad de tablas), pero si podria admitir nulos
    duracion smallint not null check (duracion > 0),
    descripcion varchar(2000) not null,
    fecha_estreno date not null
);

insert into Peliculas(titulo, genero_id, duracion, descripcion, fecha_estreno)
values ('El Padrino', 3, 175, 'La historia de la familia Corleone', '1972-03-24'),
('El Padrino II', 3, 202, 'La historia de la familia Corleone', '1974-12-20'),
('El Padrino III', 3, 162, 'La historia de la familia Corleone', '1990-12-25'),
('Star Wars: Episodio IV', 5, 121, 'La historia de la familia Skywalker', '1977-05-25'), 
('Predator', 1, 107, 'Un alienigena cazador', '1987-06-12'),
('Alien', 1, 117, 'Un alienigena asesino', '1979-05-25'),
('El Chavo del 8', 2, 30, 'La vecindad', '1972-01-01'),
('El Chapulin Colorado', 2, 30, 'El superheroe', '1972-01-01'),
('El Chanfle', 2, 90, 'El futbolista', '1979-05-25'),
('El Chanfle II', 2, 90, 'El futbolista', '1982-05-25'),
('Viaje a Marte', 5, 120, 'La historia de un astronauta', '2022-12-25');

select * from Peliculas;
-- contar cuantas peliculas hay de drama
select * count(*) from Peliculas WHERE genero_id = 3; 
-- contar cuantas peliculas hay de comedia
select * count(*) from Peliculas WHERE genero_id = 2;
-- mostrar las peliculas ordenadas de forma descendente por duracion
select * from Peliculas order by duracion desc;
-- mostrar las peliculas ordenadas de forma ascendente por fecha de estreno
select * from Peliculas order by fecha_estreno asc;
-- ultimo empleado contratado
select * from Empleados order by fecha_contratacion desc limit 1;
-- mostrar todos los empleados que hallan ingresado entre 1972 y 1974
select * from Empleados where fecha_contratacion between '1972-01-01' and '1974-12-31'
ORDER BY fecha_contratacion;
-- ordenar todas las peliculas cuyos generos sean accion, comedia y drama
select * from Peliculas where genero_id in (1, 2, 3) order by genero_id;



create table Funciones(
	funcion_id serial primary key,
    pelicula_id int references Peliculas(pelicula_id) not null,
    fecha_funcion timestamp not null,
    sala varchar(15)
);

insert into Funciones(pelicula_id, fecha_funcion, sala)
values (1, '2022-12-25 15:00', 'Sala 1'),
(2, '2022-12-25 18:00', 'Sala 2'),
(3, '2022-12-25 21:00', 'Sala 3'),
(4, '2022-12-25 21:00', 'Sala 4');

select * from Funciones;

create table Asientos(
	asiento_id serial primary key,
    funcion_id int references Funciones(funcion_id) not null,
    numero_asiento varchar(10) not null,
    tipo_asiento varchar(15) not null check (tipo_asiento in ('GENERAL', 'PREFERENCIAL'))
);

insert into Asientos(funcion_id, numero_asiento, tipo_asiento)
values (1, 'A1', 'PREFERENCIAL'),
(1, 'A2', 'PREFERENCIAL'),
(1, 'A3', 'GENERAL'),
(1, 'A4', 'GENERAL'),
(2, 'A1', 'PREFERENCIAL'),
(2, 'A2', 'PREFERENCIAL'),
(2, 'A3', 'GENERAL'),
(2, 'A4', 'GENERAL'),
(3, 'A1', 'PREFERENCIAL'),
(3, 'A2', 'PREFERENCIAL'),
(3, 'A3', 'GENERAL'),
(3, 'A4', 'GENERAL'),
(4, 'A1', 'PREFERENCIAL'),
(4, 'A2', 'PREFERENCIAL'),
(4, 'A3', 'GENERAL'),
(4, 'A4', 'GENERAL');

select * from Asientos;

create table Empleados(
	empleado_id serial primary key,
	nombre varchar(50) not null,
    apellido varchar(50) not null,
    direccion varchar(100),
	telefono varchar(20),
    correo_electronico varchar(200) unique not null,
    fecha_contratacion timestamp not null,
    cargo varchar(50) not null
);

-- insertar personajes del chavo del 8
insert into Empleados(nombre, apellido, correo_electronico, fecha_contratacion, cargo)
values ('Roberto', 'Gomez', 'roberto@chespirito', '1968-01-01', 'Actor'),
('Carlos', 'Villagran', 'carlos@chespirito', '1972-01-01', 'Actor'),
('Maria', 'Antonieta', 'maria@chespirito', '1972-01-01', 'Actriz'),
('Florinda', 'Meza', 'florinda@chespirito', '1972-01-01', 'Actriz'),
('Ruben', 'Aguirre', 'ruben@chespirito', '1972-01-01', 'Actor'),
('Edgar', 'Vivar', 'edgar@chespirito', '1972-01-01', 'Actor'),
('Ramon', 'Valdes', 'ramon@chespirito', '1972-01-01', 'Actor');

select * from Empleados;

create table Reservas(
	reserva_id serial primary key,
    cliente_id int references Clientes(cliente_id) not null,
    funcion_id int references Funciones(funcion_id) not null,
    asiento_id int references Asientos(asiento_id) not null,
    fecha_reserva timestamp not null
);

insert into Reservas(cliente_id, funcion_id, asiento_id, fecha_reserva)
values (1, 1, 1, '2022-12-25 14:00'),
(1, 2, 2, '2022-12-25 17:00'),
(1, 3, 3, '2022-12-25 20:00'),
(1, 4, 4, '2022-12-25 20:00');

select * from Reservas;

-- Intermedias
create table Favoritos(
	cliente_id int references Clientes(cliente_id),
    pelicula_id int references Peliculas(pelicula_id),
    fecha_agregado timestamp not null,
    primary key (cliente_id, pelicula_id) -- clave compuesta, cuando se hacen primary key, no requiere especificar el not null
);

insert into Favoritos(cliente_id, pelicula_id, fecha_agregado)
values (1, 1, '2022-12-25 14:00'),
(1, 2, '2022-12-25 14:00'),
(1, 3, '2022-12-25 14:00'),
(1, 4, '2022-12-25 14:00');

select * from Favoritos;



update Clientes set direccion = 'La vecindad #72', telefono = '12345678888';

select * from Clientes;


-- Traer todos los generos sin duplicados 
select distinct nombre from Generos; -- distinct elimina los duplicados de la consulta

-- Actualizar datos
update Clientes set direccion = 'La vecindad #72', telefono = '12345678888' where cliente_id = 1;

select * from Clientes;

update Peliculas set genero_id = 1 where genero_id = 3;

select * from Peliculas;

update Funciones set sala = 'Sala 5' where sala = 'Sala 4';

select * from Funciones;

update Asientos set tipo_asiento = 'PREFERENCIAL' where tipo_asiento = 'GENERAL';

select * from Asientos;

update Empleados set cargo = 'Actor comico' where cargo = 'Actor';

select * from Empleados;

update Reservas set asiento_id = 1 where asiento_id = 4;

select * from Reservas;

update Favoritos set pelicula_id = 1 where pelicula_id = 4;

select * from Favoritos;

-- Eliminar datos
delete from Favoritos where cliente_id = 1 and pelicula_id = 1;

select * from Favoritos;

delete from Reservas where cliente_id = 1;

select * from Reservas;

delete from Empleados where empleado_id = 1;

select * from Empleados;

delete from Asientos where asiento_id = 1;

select * from Asientos;

delete from Funciones where funcion_id = 1;

select * from Funciones;

delete from Peliculas where pelicula_id = 1;

select * from Peliculas;

delete from Generos where genero_id = 1;

select * from Generos;

delete from Clientes where cliente_id = 1;

select * from Clientes;

-- consultar las funciones y salas
SELECT P.titulo, F.fecha_funcion, F.sala FROM Peliculas AS P 
INNER JOIN Funciones AS F ON P.pelicula_id = F.pelicula_id;

-- Selecciona todas las funciones y las salas donde se proyectan incluyendo las funciones que aun no tienen salas asignadas
SELECT P.titulo, F.fecha_funcion, F.sala FROM Peliculas AS P
LEFT JOIN Funciones AS F ON P.pelicula_id = F.pelicula_id;






------------------------------------------VISTAS------------------------------------------
-- las vistas son consultas que se guardan en la base de datos y se pueden consultar como si fueran tablas reales 
-- se pueden hacer consultas mas complejas y se pueden reutilizar en otras consultas 
-- se pueden hacer consultas a varias tablas y guardarlas en una vista
-- las vistas permiten almacenar consultas complejas y reutilizarlas llamandolas como si fueran tablas

-- ahora realicemos una vista para clientes
create or replace view vista_clientes as
select cliente_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_registro from Clientes;

-- ahora insertamos un nuevo cliente con la vista
insert or replace into vista_clientes(nombre, apellido, correo_electronico)
values ('Doña Florinda', 'Gomez', 'doniafodonga@lachusma.com');

-- vista para las peliculas mas vistas por clientes
create or replace view vista_peliculas_mas_vistas as
select C.cliente_id, C.nombre, C.apellido, P.titulo from Reservas as R 
INNER JOIN Clientes as C ON R.cliente_id = C.cliente_id
JOIN funcioes as F ON R.funcion_id = F.funcion_id
JOIN Peliculas as P ON F.pelicula_id = P.pelicula_id
GROUP BY C.cliente_id, C.nombre, C.apellido, P.titulo
ORDER BY C.cliente_id;

-- vista que muestre los detalles de las funciones organizadas por sala
create or replace view detalle_por_funcion as 
select P.titulo, F.fecha_funcion, F.sala, A.numero_asiento, A.tipo_asiento from Peliculas as P
JOIN Funciones as F ON P.pelicula_id = F.pelicula_id
JOIN Asientos as A ON F.funcion_id = A.funcion_id
ORDER BY F.fecha_funcion, F.sala, A.numero_asiento;

-- vista que muestre los clientes con sus peliculas favoritas
create or replace view clientes_favoritos as
select C.cliente_id, C.nombre, C.apellido, P.titulo from Clientes as C
JOIN Favoritos as F ON C.cliente_id = F.cliente_id
JOIN Peliculas as P ON F.pelicula_id = P.pelicula_id
ORDER BY C.cliente_id;

-- vista que muestre las reservas realizadas por los clientes en los ultimos 30 dias
create or replace view reservas_ultimos_30_dias as
select C.cliente_id, C.nombre, C.apellido, P.titulo, R.fecha_reserva from Clientes as C
JOIN Reservas as R ON C.cliente_id = R.cliente_id
JOIN Funciones as F ON R.funcion_id = F.funcion_id
JOIN Peliculas as P ON F.pelicula_id = P.pelicula_id
WHERE R.fecha_reserva >= current_date - interval '30 days'
ORDER BY C.cliente_id;

------------------------------PROCEDIMIENTOS ALMACENADOS--------------------------------

-- los procedimientos almacenados son un conjunto de instrucciones SQL que se guardan en la base de datos y se pueden ejecutar cuando se necesite
-- se pueden hacer consultas, actualizaciones, eliminaciones, inserciones, etc
-- se pueden hacer consultas mas complejas y se pueden reutilizar en otras consultas 
-- se pueden hacer consultas a varias tablas y guardarlas en una vista
-- los procedimientos almacenados permiten almacenar consultas complejas y reutilizarlas llamandolas como si fueran tablas

-- crear un procedimiento almacenado para insertar un nuevo cliente
create or replace procedure insertar_cliente(
    nombre_cliente varchar(50),
    apellido_cliente varchar(50),
    direccion_cliente varchar(100),
    telefono_cliente varchar(20),
    correo_cliente varchar(200)
)
language plpgsql
as $$
begin
    insert into Clientes(nombre, apellido, direccion, telefono, correo_electronico)
    values (nombre_cliente, apellido_cliente, direccion_cliente, telefono_cliente, correo_cliente);
end;

--------------------------------FUNCIONES--------------------------------
-- las funciones son un conjunto de instrucciones SQL que se guardan en la base de datos y se pueden ejecutar cuando se necesite
-- se pueden hacer consultas, actualizaciones, eliminaciones, inserciones, etc
-- se pueden hacer consultas mas complejas y se pueden reutilizar en otras consultas
-- se pueden hacer consultas a varias tablas y guardarlas en una vista
-- las funciones permiten almacenar consultas complejas y reutilizarlas llamandolas como si fueran tablas

-- funcion para crear un cliente
create or replace function crear_cliente(
    nombre_cliente varchar(50),
    apellido_cliente varchar(50),
    direccion_cliente varchar(100),
    telefono_cliente varchar(20),
    correo_cliente varchar(200)
) returns void as $$
begin
    insert into Clientes(nombre, apellido, direccion, telefono, correo_electronico)
    values (nombre_cliente, apellido_cliente, direccion_cliente, telefono_cliente, correo_cliente);
end;

-- llamar la funcion
select crear_cliente('Don', 'Ramon', 'La vecindad #72', '12345678888', 'ronDamon@nolepago.com');

SELECT * FROM clientes;

SELECT pg_get_serial_sequence('Clientes', 'cliente_id'); -- esto es para saber el nombre de la secuencia

SELECT setval('Clientes_cliente_id_seq', (SELECT MAX(cliente_id) FROM Clientes)); -- esto es para actualizar la secuencia de manera manual en caso de que se haya eliminado un cliente


-- Crear el procedimiento almacenado para iniciar la reserva con un precio de 0

alter table Reservas add column precio MONEY;

SELECT * FROM Reservas;

CREATE OR REPLACE procedure iniciar_reserva()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Reservas SET precio = 0;
END;

call iniciar_reserva();

SELECT * FROM Asientos;

-- General: tendra un precio de 16000
-- Preferencial: tendra un precio de 20000

CREATE OR REPLACE procedure calcular_precio()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Reservas SET precio = 16000 WHERE asiento_id IN (SELECT asiento_id FROM Asientos WHERE tipo_asiento = 'GENERAL'); -- actualiza el precio de los asientos generales
    UPDATE Reservas SET precio = 20000 WHERE asiento_id IN (SELECT asiento_id FROM Asientos WHERE tipo_asiento = 'PREFERENCIAL');
END;

call calcular_precio();

-- si Duracion <=  90 minutos, el precio incrementa el 2%
-- si Duracion <= 120 minutos, el precio incrementa el 5%
-- si Duracion > 120 minutos, el precio incrementa el 7%

SELECT * FROM Peliculas;

CREATE OR REPLACE procedure incrementar_precio()
LANGUAGE plpgsql
AS $$
DECLARE
    duracion_pelicula INTEGER; -- variable para almacenar la duracion de la pelicula
BEGIN
    SELECT duracion INTO duracion_pelicula FROM Peliculas WHERE pelicula_id = (SELECT pelicula_id FROM Funciones WHERE funcion_id = (SELECT funcion_id FROM Reservas));
    IF duracion_pelicula <= 90 THEN
        UPDATE Reservas SET precio = precio + (precio * 0.02);
    ELSIF duracion_pelicula <= 120 THEN
        UPDATE Reservas SET precio = precio + (precio * 0.05);
    ELSE
        UPDATE Reservas SET precio = precio + (precio * 0.07);
    END IF;
END;

