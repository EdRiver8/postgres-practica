-- Sistema Bancario
-- Base de datos para un sistema bancario con las siguientes tablas:
-- Clientes: Informacion de los clientes del banco
-- CuentasBancarias: Informacion de las cuentas bancarias
-- Transacciones: Informacion de las transacciones realizadas
-- Empleados: Informacion de los empleados del banco
-- Sucursales: Informacion de las sucursales del banco
-- ProductosFinancieros: Informacion de los productos financieros
-- Prestamos: Informacion de los prestamos
-- TarjetasCredito: Informacion de las tarjetas de credito
-- ClientesProductos: Relacion entre clientes y productos financieros
-- ClientesTarjetas: Relacion entre clientes y tarjetas de credito
-- ClientesPrestamos: Relacion entre clientes y prestamos
-- ClientesCuentas: Relacion entre clientes y cuentas bancarias
-- ClientesTransacciones: Relacion entre clientes y transacciones

-- Borramos la base de datos si existe
-- drop database if exists sistema_bancario;

-- Creamos la base de datos
-- create database sistema_bancario;

-- Eliminar las vistas en cascada en caso que existan
drop view if exists PrestamosSuperanPromedio;
drop view if exists ClientesMultiplesCuentas;
drop view if exists SucursalesClientes;
drop view if exists ClientesRetirosAltos;
drop view if exists CuentasTransaccionesMes;
drop view if exists ClientesPrestamosView;
drop view if exists ClientesMultiplesSucursales;
drop view if exists SaldoTotalClientes;

-- Eliminacion de tablas en cascada
drop table if exists ClientesTransacciones;
drop table if exists ClientesCuentas;
drop table if exists ClientesPrestamos;
drop table if exists ClientesTarjetas;
drop table if exists ClientesProductos;
drop table if exists TarjetasCredito;
drop table if exists Prestamos;
drop table if exists ProductosFinancieros;
drop table if exists Empleados;
drop table if exists Departamentos;
drop table if exists Transacciones;
drop table if exists CuentasBancarias;
drop table if exists Sucursales;
drop table if exists Clientes;

create table Clientes(
    cliente_id serial primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    direccion varchar(100),
    telefono varchar(20),
    correo_electronico varchar(200) unique not null,
    fecha_nacimiento date not null,
    estado varchar(10) not null check (estado in ('activo', 'inactivo'))
);

create table Sucursales(
    sucursal_id serial primary key,
    nombre varchar(100) not null,
    direccion varchar(100) not null,
    telefono varchar(20) not null
);

create table CuentasBancarias(
    cuenta_id serial primary key,
    cliente_id int references Clientes(cliente_id) not null,
    numero_cuenta varchar(20) unique not null,
    tipo_cuenta varchar(10) not null check (tipo_cuenta in ('corriente', 'ahorro')),
    saldo numeric(10, 2) not null check (saldo >= 0),
    fecha_apertura date not null,
    estado varchar(10) not null check (estado in ('activa', 'cerrada')),
    sucursal_id int references Sucursales(sucursal_id) not null
);

create table Transacciones(
    transaccion_id serial primary key,
    cuenta_id int references CuentasBancarias(cuenta_id) not null,
    tipo_transaccion varchar(15) not null check (tipo_transaccion in ('deposito', 'retiro', 'transferencia')),
    monto numeric(10, 2) not null check (monto > 0),
    fecha_transaccion timestamp not null,
    descripcion varchar(200)
);

create table Departamentos(
    departamento_id serial primary key,
    nombre varchar(50) not null
);

create table Empleados(
    empleado_id serial primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    direccion varchar(100),
    telefono varchar(20),
    correo_electronico varchar(200) unique not null,
    fecha_contratacion timestamp not null,
    posicion varchar(50) not null,
    salario numeric(10, 2) not null,
    sucursal_id int references Sucursales(sucursal_id) not null,
    departamento_id int references Departamentos(departamento_id)
);

create table ProductosFinancieros(
    producto_id serial primary key,
    nombre_producto varchar(100) not null,
    tipo_producto varchar(50) not null check (tipo_producto in ('prestamo', 'tarjeta de credito', 'seguro')),
    descripcion varchar(200) not null,
    tasa_interes numeric(5, 2) not null check (tasa_interes > 0)
);

create table Prestamos(
    prestamo_id serial primary key,
    cuenta_id int references CuentasBancarias(cuenta_id) not null,
    monto numeric(10, 2) not null check (monto > 0),
    tasa_interes numeric(5, 2) not null check (tasa_interes > 0),
    fecha_inicio date not null,
    fecha_fin date not null,
    estado varchar(10) not null check (estado in ('activo', 'pagado'))
);

create table TarjetasCredito(
    tarjeta_id serial primary key,
    cuenta_id int references CuentasBancarias(cuenta_id) not null,
    numero_tarjeta varchar(20) unique not null,
    limite_credito numeric(10, 2) not null check (limite_credito > 0),
    saldo_actual numeric(10, 2) not null check (saldo_actual >= 0),
    fecha_emision date not null,
    fecha_vencimiento date not null,
    estado varchar(10) not null check (estado in ('activa', 'bloqueada'))
);

create table ClientesProductos(
    cliente_id int references Clientes(cliente_id) not null,
    producto_id int references ProductosFinancieros(producto_id) not null,
    fecha_adquisicion date not null,
    primary key (cliente_id, producto_id)
);

create table ClientesTarjetas(
    cliente_id int references Clientes(cliente_id) not null,
    tarjeta_id int references TarjetasCredito(tarjeta_id) not null,
    fecha_adquisicion date not null,
    primary key (cliente_id, tarjeta_id)
);

create table ClientesPrestamos(
    cliente_id int references Clientes(cliente_id) not null,
    prestamo_id int references Prestamos(prestamo_id) not null,
    fecha_adquisicion date not null,
    primary key (cliente_id, prestamo_id)
);

create table ClientesCuentas(
    cliente_id int references Clientes(cliente_id) not null,
    cuenta_id int references CuentasBancarias(cuenta_id) not null,
    fecha_adquisicion date not null,
    primary key (cliente_id, cuenta_id)
);

create table ClientesTransacciones(
    cliente_id int references Clientes(cliente_id) not null,
    transaccion_id int references Transacciones(transaccion_id) not null,
    fecha_adquisicion date not null,
    primary key (cliente_id, transaccion_id)
);

-- insertar datos de prueba pero tener en cuenta para la informacion de personas, los personajes de Dragon Ball Z
insert into Clientes(nombre, apellido, direccion, telefono, correo_electronico, fecha_nacimiento, estado) values
('Goku', 'Son', 'Kame House', '123456789', 'elverdaderosupersayain@dgbz.com' , '1984-04-16', 'activo'),
('Vegeta', 'Prince', 'Planeta Vegeta', '987654321', 'todossonbichos@dgbz.com', '1984-12-03', 'activo'),
('Gohan', 'Son', 'Kame House', '123456789', 'amorypaz@dgbz.com', '1990-05-18', 'activo'),
('Trunks', 'Brief', 'Capsule Corp', '987654321', 'solocalle@dgbz.com', '1993-05-12', 'activo'),
('Goten', 'Son', 'Kame House', '123456789', 'memiman@dgbz.com', '1994-03-12', 'activo'),
('Piccolo', '', 'Namek', '987654321', 'sabiduria@dgbz.com', '1984-04-16', 'activo'),
('Krillin', '', 'Kame House', '123456789', 'nomedejenmorir@dgbz.com', '1984-04-16', 'activo'),
('Yamcha', '', 'Desierto', '987654321', 'dejadodelado@dgbz.com', '1984-04-16', 'activo'),
('Tenshinhan', '', 'Kame House', '123456789', 'venciagoku@dgbz.com', '1984-04-16', 'activo'),
('Chaoz', '', 'Kame House', '987654321', 'littlebaby@dgbz.com', '1984-04-16', 'activo'),
('Bulma', 'Brief', 'Capsule Corp', '123456789', 'todosquierenconmigo@dgbz.com', '1984-04-16', 'activo');

insert into Sucursales(nombre, direccion, telefono) values
('Kame House', 'Isla Tortuga', '123456789'),
('Planeta Kaio', 'Planeta Kaio', '123456789');

INSERT INTO CuentasBancarias(cliente_id, numero_cuenta, tipo_cuenta, saldo, fecha_apertura, estado, sucursal_id) VALUES
(1, '1234567890', 'corriente', 1000.00, '2020-01-01', 'activa', 1),
(2, '2345678901', 'ahorro', 500.00, '2020-01-01', 'activa', 2),
(3, '3456789012', 'corriente', 2000.00, '2020-01-01', 'activa', 1),
(4, '4567890123', 'ahorro', 1500.00, '2020-01-01', 'activa', 2),
(5, '5678901234', 'corriente', 3000.00, '2020-01-01', 'activa', 1),
(6, '6789012345', 'ahorro', 2500.00, '2020-01-01', 'activa', 2),
(7, '7890123456', 'corriente', 4000.00, '2020-01-01', 'activa', 1),
(8, '8901234567', 'ahorro', 3500.00, '2020-01-01', 'activa', 2),
(9, '9012345678', 'corriente', 5000.00, '2020-01-01', 'activa', 1),
(10, '0123456789', 'ahorro', 4500.00, '2020-01-01', 'activa', 2);

insert into Transacciones(cuenta_id, tipo_transaccion, monto, fecha_transaccion, descripcion) values
(1, 'deposito', 1000.00, '2020-01-01 12:00', 'pago inicial'),
(2, 'deposito', 500.00, '2020-01-01 12:00', 'Deposito inicial'),
(3, 'deposito', 2000.00, '2020-01-01 12:00', 'Deposito inicial'),
(4, 'deposito', 1500.00, '2020-01-01 12:00', 'pago inicial'),
(5, 'deposito', 3000.00, '2020-01-01 12:00', 'Deposito inicial'),
(6, 'deposito', 2500.00, '2020-01-01 12:00', 'Deposito inicial'),
(7, 'deposito', 4000.00, '2020-01-01 12:00', 'Deposito inicial'),
(8, 'deposito', 3500.00, '2020-01-01 12:00', 'Deposito inicial'),
(9, 'deposito', 5000.00, '2020-01-01 12:00', 'Deposito inicial'),
(10, 'deposito', 4500.00, '2020-01-01 12:00', 'Deposito inicial');

-- insertando datos para los departamentos de los empleados basado en dragon ball z
insert into Departamentos(nombre) values
('Cuidadores'),
('Cocina'),
('Asistentes'),
('Entrenadores');

-- Insertamos datos para los departamentos de los empleados basado en dragon ball z
insert into Empleados(nombre, apellido, direccion, telefono, correo_electronico, fecha_contratacion, posicion, salario, sucursal_id, departamento_id) values
('Mr', 'Popo', 'Kame House', '123456789', 'empleado1@secundario.com' , '1984-04-16', 'Cuidador', 1000.00, 1, 1),
('Oolong', '', 'Kame House', '123456789', 'empleado2@secundario.com' , '1984-04-16', 'Cocinero', 1000.00, 1, 2),
('Puar', '', 'Kame House', '123456789', 'empleado3@secundario.com' , '1984-04-16', 'Asistente', 1000.00, 1, 3),
('Yajirobe', '', 'Kame House', '123456789', 'empleado4@secundario.com' , '1984-04-16', 'Cuidador', 1000.00, 1, 1),
('Korin', '', 'Kame House', '123456789', 'empleado5@secundario.com' , '1984-04-16', 'Cuidador', 1000.00, 1, 1),
('Rey', 'Kai', 'Planeta Kaio', '123456789', 'empleado6@secundario.com' , '1984-04-16', 'Entrenador', 1000.00, 2, 4),
('Kaiosama', '', 'Planeta Kaio', '123456789', 'empleado7@secundario.com' , '1984-04-16', 'Entrenador', 1000.00, 2, 4);

insert into ProductosFinancieros(nombre_producto, tipo_producto, descripcion, tasa_interes) values
('Prestamo Personal', 'prestamo', 'Prestamo personal para cualquier necesidad', 10.00),
('Tarjeta de Credito', 'tarjeta de credito', 'Tarjeta de credito para compras', 15.00),
('Seguro de Vida', 'seguro', 'Seguro de vida para proteccion', 5.00);

insert into Prestamos(cuenta_id, monto, tasa_interes, fecha_inicio, fecha_fin, estado) values
(1, 1000.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(2, 500.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(3, 2000.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(4, 1500.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(5, 3000.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(6, 2500.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(7, 4000.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(8, 3500.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(9, 5000.00, 10.00, '2020-01-01', '2021-01-01', 'activo'),
(10, 4500.00, 10.00, '2020-01-01', '2021-01-01', 'activo');

insert into TarjetasCredito(cuenta_id, numero_tarjeta, limite_credito, saldo_actual, fecha_emision, fecha_vencimiento, estado) values
(1, '1234567890123456', 1000.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(2, '2345678901234567', 500.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(3, '3456789012345678', 2000.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(4, '4567890123456789', 1500.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(5, '5678901234567890', 3000.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(6, '6789012345678901', 2500.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(7, '7890123456789012', 4000.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(8, '8901234567890123', 3500.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(9, '9012345678901234', 5000.00, 0.00, '2020-01-01', '2021-01-01', 'activa'),
(10, '0123456789012345', 4500.00, 0.00, '2020-01-01', '2021-01-01', 'activa');

insert into ClientesProductos(cliente_id, producto_id, fecha_adquisicion) values
(1, 1, '2020-01-01'),
(2, 2, '2020-01-01'),
(3, 1, '2020-01-01'),
(4, 2, '2020-01-01'),
(5, 1, '2020-01-01'),
(6, 2, '2020-01-01'),
(7, 1, '2020-01-01'),
(8, 2, '2020-01-01'),
(9, 1, '2020-01-01'),
(10, 2, '2020-01-01');

insert into ClientesTarjetas(cliente_id, tarjeta_id, fecha_adquisicion) values
(1, 1, '2020-01-01'),
(2, 2, '2020-01-01'),
(3, 3, '2020-01-01'),
(4, 4, '2020-01-01'),
(5, 5, '2020-01-01'),
(6, 6, '2020-01-01'),
(7, 7, '2020-01-01'),
(8, 8, '2020-01-01'),
(9, 9, '2020-01-01'),
(10, 10, '2020-01-01');

insert into ClientesPrestamos(cliente_id, prestamo_id, fecha_adquisicion) values
(1, 1, '2020-01-01'),
(2, 2, '2020-01-01'),
(3, 3, '2020-01-01'),
(4, 4, '2020-01-01'),
(5, 5, '2020-01-01'),
(6, 6, '2020-01-01'),
(7, 7, '2020-01-01'),
(8, 8, '2020-01-01'),
(9, 9, '2020-01-01'),
(10, 10, '2020-01-01');

insert into ClientesCuentas(cliente_id, cuenta_id, fecha_adquisicion) values
(1, 1, '2020-01-01'),
(2, 2, '2020-01-01'),
(3, 3, '2020-01-01'),
(4, 4, '2020-01-01'),
(5, 5, '2020-01-01'),
(6, 6, '2020-01-01'),
(7, 7, '2020-01-01'),
(8, 8, '2020-01-01'),
(9, 9, '2020-01-01'),
(10, 10, '2020-01-01');

insert into ClientesTransacciones(cliente_id, transaccion_id, fecha_adquisicion) values
(1, 1, '2020-01-01'),
(2, 2, '2020-01-01'),
(3, 3, '2020-01-01'),
(4, 4, '2020-01-01'),
(5, 5, '2020-01-01'),
(6, 6, '2020-01-01'),
(7, 7, '2020-01-01'),
(8, 8, '2020-01-01'),
(9, 9, '2020-01-01'),
(10, 10, '2020-01-01');

--------------------CONSULTAS TALLER #2: CONSULTAS BASICAS--------------------

-- Selecciona todos los registros de la tabla "Clientes".
select * from Clientes;

-- Obtén una lista de todos los tipos de cuentas sin duplicados.
select distinct tipo_cuenta from CuentasBancarias;

--  Cuenta cuántos clientes hay en la tabla "Clientes".
select count(*) from Clientes;

-- Selecciona todas las transacciones que tienen un monto mayor a 1000.
select * from Transacciones where monto > 1000.00;

-- Ordena la lista de cuentas por su saldo en orden ascendente.
select * from CuentasBancarias order by saldo asc;

-- Selecciona los primeros 5 empleados ordenados por su fecha de contratación en orden descendente.
select * from Empleados order by fecha_contratacion desc limit 5;

-- Selecciona todas las transacciones realizadas entre el 1 de enero de 2023 y el 31 de diciembre de 2023.
select * from Transacciones where fecha_transaccion between '2023-01-01' and '2023-12-31';

-- Selecciona todas las cuentas cuyo tipo sea "Ahorro", "Corriente" o "Inversión".
select * from CuentasBancarias where tipo_cuenta in ('ahorro', 'corriente', 'inversion');

-- Selecciona todos los clientes cuyo nombre contiene la letra "a".
select * from Clientes where nombre like '%a%';

-- Selecciona todos los empleados cuyos apellidos empiezan con la letra "S".
select * from Empleados where apellido like 'P%';

-- Selecciona todos los clientes que viven en direcciones que terminan con "House".
select * from Clientes where direccion like '%House';

-- Selecciona todos los empleados cuyo correo electrónico contiene "bank".
select * from Empleados where correo_electronico like '%@secundario%';

-- Selecciona todas las sucursales cuyo nombre comienza con "Central".
select * from Sucursales where nombre like 'Central%';

--  Selecciona todas las transacciones que son de tipo "Depósito".
select * from Transacciones where tipo_transaccion = 'deposito';

-- Selecciona todas las transacciones que ocurren en el año 2023.
select * from Transacciones where extract(year from fecha_transaccion) = 2023;

-- Selecciona todas las transacciones cuya descripción contiene la palabra "pago".
select * from Transacciones where descripcion like '%pago%';

-- Selecciona todos los clientes cuyo número de teléfono comienza con "555".
select * from Clientes where telefono like '987%';

-- Selecciona todos los empleados cuyo cargo contiene la palabra "Manager".
select * from Empleados where posicion like '%Entrenador%';


--------------------CONSULTAS TALLER #3: CONSULTAS ENTRE TABLAS --------------------

-- Selecciona todos los clientes junto con los detalles de sus cuentas.
select c.*, cb.* from Clientes c
inner join CuentasBancarias cb on c.cliente_id = cb.cliente_id;

-- Selecciona todos los empleados y las sucursales donde trabajan, incluyendo aquellos empleados que no están asignados a ninguna sucursal.
select e.*, s.* from Empleados e
left join Sucursales s on e.sucursal_id = s.sucursal_id;

-- Selecciona todos los clientes y sus transacciones, incluyendo aquellas transacciones que no tienen clientes asignados.
select c.*, t.* from Clientes c
right join ClientesTransacciones ct on c.cliente_id = ct.cliente_id
right join Transacciones t on ct.transaccion_id = t.transaccion_id;

-- Selecciona todos los empleados y los departamentos, incluyendo aquellos empleados que no están asignados a un departamento y aquellos departamentos sin empleados.
select e.*, d.* from Empleados e
left join Departamentos d on e.departamento_id = d.departamento_id;

--Selecciona los clientes que tienen cuentas con un saldo mayor a 5000.
select c.* from Clientes c
inner join CuentasBancarias cb on c.cliente_id = cb.cliente_id
where cb.saldo > 1500;

-- Selecciona todos los empleados y las sucursales donde trabajan, incluyendo aquellos empleados que no están asignados a ninguna sucursal, pero solo si la sucursal está en "Kame House".
select e.*, s.* from Empleados e
left join Sucursales s on e.sucursal_id = s.sucursal_id
where s.nombre = 'Kame House';

-- Selecciona todas las transacciones y los clientes asociados, incluyendo aquellas transacciones sin clientes, pero solo si el monto de la transacción es menor a 100.
select t.*, c.* from Transacciones t
left join ClientesTransacciones ct on t.transaccion_id = ct.transaccion_id
left join Clientes c on ct.cliente_id = c.cliente_id
where t.monto < 1000;

-- Selecciona todos los empleados y los departamentos, incluyendo aquellos empleados que no están asignados a un departamento y aquellos departamentos sin empleados, pero solo si el departamento está en "HR".
select e.*, d.* from Empleados e
left join Departamentos d on e.departamento_id = d.departamento_id
where d.nombre = 'Asistentes';

-- Selecciona las cuentas, los clientes y las transacciones asociadas a cada cuenta.
select cb.*, c.*, t.* from CuentasBancarias cb
inner join Clientes c on cb.cliente_id = c.cliente_id
inner join ClientesTransacciones ct on c.cliente_id = ct.cliente_id
inner join Transacciones t on ct.transaccion_id = t.transaccion_id;

-- Selecciona todas las transacciones, los clientes y las cuentas, incluyendo aquellas transacciones que no están asignadas a ningún cliente o cuenta.
select t.*, c.*, cb.* from Transacciones t
left join ClientesTransacciones ct on t.transaccion_id = ct.transaccion_id
left join Clientes c on ct.cliente_id = c.cliente_id
left join ClientesCuentas cc on c.cliente_id = cc.cliente_id
left join CuentasBancarias cb on cc.cuenta_id = cb.cuenta_id;



--------------------CONSULTAS TALLER #4: VISTAS--------------------

-- Crear una vista que muestre el saldo total de cada cliente en todas sus cuentas.
create view SaldoTotalClientes as
select c.cliente_id, c.nombre, sum(cb.saldo) as saldo_total
from Clientes c
inner join CuentasBancarias cb on c.cliente_id = cb.cliente_id
group by c.cliente_id, c.nombre;

--  Crear una vista que muestre los clientes que tienen cuentas en más de una sucursal.
create view ClientesMultiplesSucursales as
select c.cliente_id, c.nombre, count(distinct cb.sucursal_id) as sucursales
from Clientes c
inner join CuentasBancarias cb on c.cliente_id = cb.cliente_id
group by c.cliente_id, c.nombre
having count(distinct cb.sucursal_id) > 1;

-- Crear una vista que muestre los clientes con préstamos y el total adeudado.
create view ClientesPrestamosView as
select c.cliente_id, c.nombre, sum(p.monto) as total_prestamos
from Clientes c
inner join ClientesPrestamos cp on c.cliente_id = cp.cliente_id
inner join Prestamos p on cp.prestamo_id = p.prestamo_id
group by c.cliente_id, c.nombre;

-- Crear una vista que muestre las cuentas que han realizado más de 3 transacciones en el último mes.
create view CuentasTransaccionesMes as
select cb.cuenta_id, count(t.transaccion_id) as transacciones
from CuentasBancarias cb
inner join Transacciones t on cb.cuenta_id = t.cuenta_id
where t.fecha_transaccion >= current_date - interval '1 month'
group by cb.cuenta_id
having count(t.transaccion_id) > 3;

-- Crear una vista que muestre los clientes que han realizado retiros mayores a 1000.
create view ClientesRetirosAltos as
select c.cliente_id, c.nombre, sum(t.monto) as total_retiros
from Clientes c
inner join ClientesTransacciones ct on c.cliente_id = ct.cliente_id
inner join Transacciones t on ct.transaccion_id = t.transaccion_id
where t.tipo_transaccion = 'retiro' and t.monto > 1000
group by c.cliente_id, c.nombre;

-- Crear una vista que muestre las sucursales y el número de clientes asociados a cada una.
create view SucursalesClientes as
select s.sucursal_id, s.nombre, count(distinct c.cliente_id) as clientes
from Sucursales s
left join Empleados e on s.sucursal_id = e.sucursal_id
left join Clientes c on e.empleado_id = c.cliente_id
group by s.sucursal_id, s.nombre;

-- Crear una vista que muestre los clientes que tienen más de un tipo de cuenta.
create view ClientesMultiplesCuentas as
select c.cliente_id, c.nombre, count(distinct cb.tipo_cuenta) as cuentas
from Clientes c
inner join CuentasBancarias cb on c.cliente_id = cb.cliente_id
group by c.cliente_id, c.nombre
having count(distinct cb.tipo_cuenta) > 1;

-- Crear una vista que muestre los préstamos que superan el promedio de todos los préstamos.
create view PrestamosSuperanPromedio as
select p.prestamo_id, p.monto, p.tasa_interes
from Prestamos p
where p.monto > (select avg(monto) from Prestamos);



--------------------CONSULTAS TALLER #5: PROCEDIMIENTOS ALMACENADOS--------------------
-- 1. Crear una nueva cuenta bancaria: Crea una nueva cuenta bancaria para un cliente, asignando un número de cuenta único y estableciendo un saldo inicial.
create or replace function crear_cuenta_bancaria(p_cliente_id int, p_tipo_cuenta varchar, p_saldo numeric) returns void as $$
declare
    v_numero_cuenta varchar;
begin
    v_numero_cuenta := (select lpad(nextval('cuenta_id')::text, 10, '0'));
    insert into CuentasBancarias(cliente_id, numero_cuenta, tipo_cuenta, saldo, fecha_apertura, estado, sucursal_id)
    values (p_cliente_id, v_numero_cuenta, p_tipo_cuenta, p_saldo, current_date, 'activa', 1);
end;
$$ language plpgsql;

-- 2. Actualizar la información del cliente: Actualiza la información personal de un cliente, como dirección, teléfono y correo electrónico, basado en el ID del cliente.
create or replace function actualizar_cliente(p_cliente_id int, p_direccion varchar, p_telefono varchar, p_correo varchar) returns void as $$
begin
    update Clientes
    set direccion = p_direccion, telefono = p_telefono, correo_electronico = p_correo
    where cliente_id = p_cliente_id;
end;
$$ language plpgsql;

-- 3. Eliminar una cuenta bancaria: Elimina una cuenta bancaria específica del sistema, incluyendo la eliminación de todas las transacciones asociadas.
create or replace function eliminar_cuenta_bancaria(p_cuenta_id int) returns void as $$
begin
    delete from Transacciones
    where cuenta_id = p_cuenta_id;
    delete from CuentasBancarias
    where cuenta_id = p_cuenta_id;
end;
$$ language plpgsql;

-- 4. Transferir fondos entre cuentas: Realiza una transferencia de fondos desde una cuenta a otra, asegurando que ambas cuentas se actualicen correctamente y se registre la transacción.
create or replace function transferir_fondos(p_cuenta_origen int, p_cuenta_destino int, p_monto numeric) returns void as $$
begin
    update CuentasBancarias
    set saldo = saldo - p_monto
    where cuenta_id = p_cuenta_origen;
    update CuentasBancarias
    set saldo = saldo + p_monto
    where cuenta_id = p_cuenta_destino;
    insert into Transacciones
    (cuenta_id, tipo_transaccion, monto, fecha_transaccion, descripcion)
    values (p_cuenta_origen, 'transferencia', p_monto, current_timestamp, 'Transferencia a cuenta ' || p_cuenta_destino);
    insert into Transacciones
    (cuenta_id, tipo_transaccion, monto, fecha_transaccion, descripcion)
    values (p_cuenta_destino, 'transferencia', p_monto, current_timestamp, 'Transferencia de cuenta ' || p_cuenta_origen);
end;
$$ language plpgsql;

-- 5. Agregar una nueva transacción: Registra una nueva transacción (depósito, retiro) en el sistema, actualizando el saldo de la cuenta asociada.
create or replace function agregar_transaccion(p_cuenta_id int, p_tipo_transaccion varchar, p_monto numeric, p_descripcion varchar) returns void as $$
begin
    if p_tipo_transaccion = 'deposito' then
        update CuentasBancarias
        set saldo = saldo + p_monto
        where cuenta_id = p_cuenta_id;
    elsif p_tipo_transaccion = 'retiro' then
        update CuentasBancarias
        set saldo = saldo - p_monto
        where cuenta_id = p_cuenta_id;
    end if;
    insert into Transacciones
    (cuenta_id, tipo_transaccion, monto, fecha_transaccion, descripcion)
    values
    (p_cuenta_id, p_tipo_transaccion, p_monto, current_timestamp, p_descripcion);
end;
$$ language plpgsql;

-- 6. Calcular el saldo total de todas las cuentas de un cliente: Calcula el saldo total combinado de todas las cuentas bancarias pertenecientes a un cliente específico.
create or replace function saldo_total_cliente(p_cliente_id int) returns numeric as $$
declare
    v_saldo_total numeric;
begin
    select sum(saldo) into v_saldo_total
    from CuentasBancarias
    where cliente_id = p_cliente_id;
    return v_saldo_total;
end;
$$ language plpgsql;

-- 7. Generar un reporte de transacciones para un rango de fechas: Genera un reporte detallado de todas las transacciones realizadas en un rango de fechas específico.
create or replace function reporte_transacciones(p_fecha_inicio date, p_fecha_fin date) 
returns table (
    id_transaccion int,
    monto numeric,
    fecha_transaccion date,
    descripcion text
) as $$
begin
    return query
    select id_transaccion, monto, fecha_transaccion, descripcion
    from Transacciones
    where fecha_transaccion between p_fecha_inicio and p_fecha_fin;
end;
$$ language plpgsql;




