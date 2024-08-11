-- Description: Script to create the table to store the bills
CREATE TABLE IF NOT EXISTS facturas (
    id_unique SERIAL PRIMARY KEY,
    nombre_xml VARCHAR(255),
    nombre_pdf VARCHAR(255),
    nombre_email_xml VARCHAR(255),
    nombre_email_pdf VARCHAR(255),
    negocio VARCHAR(10),
    numero_factura VARCHAR(20),
    nit VARCHAR(15),
    orden_compra INT,
    fecha_descarga TIMESTAMP,
    fecha_correo TIMESTAMP,
    cufe VARCHAR(200),
    tipo_emision VARCHAR(200),
    fk_tipo_rechazo INT,
    validacion_fiscal BOOLEAN,
    validacion_comercial BOOLEAN,
    transmitida_delfin BOOLEAN,
    almacenada_oracle BOOLEAN,
    procesado_api_edn BOOLEAN
);

CREATE TABLE IF NOT EXISTS validacion_edn (
    id_unique SERIAL PRIMARY KEY,
    fk_factura INT,
    estado_carga VARCHAR(200),
    estado_flujo VARCHAR(200),
    tipo_documento VARCHAR(200),
    codigo_rechazo VARCHAR(200),
    razon_rechazo VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS acuses (
    id_unique SERIAL PRIMARY KEY,
    fk_factura INT,
    fecha TIMESTAMP,
    acuse VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS logs (
    id_unique SERIAL PRIMARY KEY,
    fk_factura INT,
    microservicio VARCHAR(200),
    accion_realizada VARCHAR(200),
    fecha TIMESTAMP,
    mensaje VARCHAR(200)
);

-- Para las inserciones en la tabla 'facturas'
INSERT INTO facturas (id_unique, nombre_xml, nombre_pdf, negocio, numero_factura, nit, orden_compra, fecha_descarga, fecha_correo, cufe, tipo_emision, fk_tipo_rechazo, validacion_fiscal, procesado_api_edn) VALUES
(200001,'factura1.xml', 'factura1.pdf', 'Leasing', '12345', 'NIT123', 1001, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE123', 'Emision 1', 1, false, false),
(200002,'factura2.xml', 'factura2.pdf', 'Leasing', '67890', 'NIT456', 1002, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE456', 'Emision 2', 1, false, false),
(200003,'factura3.xml', 'factura3.pdf', 'Leasing', '123', 'NIT789', 1003, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE789', 'Emision 1', 1, false, false),
(200004,'factura4.xml', 'factura4.pdf', 'Leasing', '456', 'NIT012', 1004, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE012', 'Emision 2', 1, false, null),
(200005,'factura5.xml', 'factura5.pdf', 'Leasing', '789', 'NIT123', 1005, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE345', 'Emision 2', 1, null, null),
(200006,'factura6.xml', 'factura6.pdf', 'Leasing', '012', 'NIT456', 1006, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE678', 'Emision 1', 1, null, null),
(200007,'factura7.xml', 'factura7.pdf', 'Leasing', '345', 'NIT567', 1007, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE901', 'Emision 1', 1, false, null),
(200008,'factura8.xml', 'factura8.pdf', 'Leasing', '678', 'NIT789', 1008, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE456', 'Emision 2', 1, true, false),
(200009,'factura9.xml', 'factura9.pdf', 'Leasing', '901', 'NIT012', 1009, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE456', 'Emision 2', 1, true, false), -- caso donde quedo el pdf del ciclo anterior y tiene acuse 30
(200010,'factura10.xml', 'factura10.pdf', 'Leasing', '234', 'NIT789', 1010, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE123', 'Emision 2', 1, true, false), -- caso donde quedo el pdf del ciclo anterior fue validad pero no tiene acuse 30
(200011,'factura11.xml', 'factura11.pdf', 'Leasing', '567', 'NIT012', 1011, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE456', 'Emision 2', 1, false, true), -- caso donde esta siendo procesada por otra instancia del microservicio
(200012,'LEA20240809152014001.xml', 'LEA2024080915201400.pdf', 'Leasing', '567', 'NIT012', 1011, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'CUFE456', 'Emision 2', 1, true, false); -- caso donde esta siendo procesada por otra instancia del microservicio

-- ahora se debe realizar la eliminacion de los datos insertados en la tabla de facturas, logs, validacion_edn y acuses
DELETE FROM schflred.logs WHERE fk_factura IN (SELECT id_unique FROM schflred.facturas WHERE nombre_xml
IN ('factura1.xml', 'factura2.xml', 'factura3.xml', 'factura4.xml', 'factura5.xml', 'factura6.xml', 'factura7.xml', 'factura8.xml', 'factura9.xml', 'factura10.xml', 'factura11.xml'));
	
DELETE FROM schflred.validacion_edn WHERE fk_factura IN (SELECT id_unique FROM schflred.facturas WHERE nombre_xml
IN ('factura1.xml', 'factura2.xml', 'factura3.xml', 'factura4.xml', 'factura5.xml', 'factura6.xml', 'factura7.xml', 'factura8.xml', 'factura9.xml', 'factura10.xml', 'factura11.xml'));
	
DELETE FROM schflred.acuses WHERE fk_factura IN (SELECT id_unique FROM schflred.facturas WHERE nombre_xml
IN ('factura1.xml', 'factura2.xml', 'factura3.xml', 'factura4.xml', 'factura5.xml', 'factura6.xml', 'factura7.xml', 'factura8.xml', 'factura9.xml', 'factura10.xml', 'factura11.xml'));
												 
DELETE FROM schflred.facturas WHERE nombre_xml
IN ('factura1.xml', 'factura2.xml', 'factura3.xml', 'factura4.xml', 'factura5.xml', 'factura6.xml', 'factura7.xml', 'factura8.xml', 'factura9.xml', 'factura10.xml', 'factura11.xml');
	
SELECT * FROM schflred.facturas WHERE nombre_xml
IN ('factura1.xml', 'factura2.xml', 'factura3.xml', 'factura4.xml', 'factura5.xml', 'factura6.xml', 'factura7.xml', 'factura8.xml', 'factura9.xml', 'factura10.xml', 'factura11.xml');

-- actualizar la factura 11 poniendo todo el false
UPDATE schflred.facturas SET validacion_fiscal = false, validacion_comercial = false, transmitida_delfin = false, almacenada_oracle = false, procesado_api_edn = false WHERE nombre_xml = 'factura11.xml';

-- realizar una actualizacion para setear el campo de procesado_api_edn para algunas facturas
UPDATE schflred.facturas SET procesado_api_edn = true WHERE nombre_xml IN ('LEA20240808143002001.xml', 'LEA20240808143003001.xml', 'LEA20240808143003002.xml', 'LEA20240808143004001.xml', 'LEA20240808143004002.xml', 'LEA20240808143005001.xml',
	'LEA20240808143005002.xml', 'LEA20240808143006002.xml', 'LEA20240808143007001.xml', 'LEA20240808143008001.xml');

-- crear acuse para la factura factura9.xml y asi poder probar el caso donde se tiene un pdf del ciclo anterior y tiene acuse 30
INSERT INTO acuses (fk_factura, fecha, acuse) VALUES (200009, CURRENT_TIMESTAMP, 'Acuse 30');
INSERT INTO acuses (fk_factura, fecha, acuse) VALUES (200012, CURRENT_TIMESTAMP, 'Acuse 30');

-- insertar valores para la tabla de validacion_edn
INSERT INTO validacion_edn (fk_factura, estado_carga, estado_flujo, tipo_documento, codigo_rechazo, razon_rechazo) VALUES (200008, 'Cargado', 'Flujo 1', 'Factura', 'Codigo 1', 'Razon 1');
INSERT INTO validacion_edn (fk_factura, estado_carga, estado_flujo, tipo_documento, codigo_rechazo, razon_rechazo) VALUES (200009, 'Cargado', 'Flujo 1', 'Factura', 'Codigo 1', 'Razon 1');
INSERT INTO validacion_edn (fk_factura, estado_carga, estado_flujo, tipo_documento, codigo_rechazo, razon_rechazo) VALUES (200010, 'Cargado', 'Flujo 1', 'Factura', 'Codigo 1', 'Razon 1');
INSERT INTO validacion_edn (fk_factura, estado_carga, estado_flujo, tipo_documento, codigo_rechazo, razon_rechazo) VALUES (200011, 'Cargado', 'Flujo 1', 'Factura', 'Codigo 1', 'Razon 1');
INSERT INTO validacion_edn (fk_factura, estado_carga, estado_flujo, tipo_documento, codigo_rechazo, razon_rechazo) VALUES (200012, 'Cargado', 'Flujo 1', 'Factura', 'Codigo 1', 'Razon 1');

-- insertar valores para la tabla de logs
INSERT INTO logs (fk_factura, microservicio, accion_realizada, fecha, mensaje) VALUES (200008, 'Microservicio 1', 'Accion 1', CURRENT_TIMESTAMP, 'Mensaje 1');
INSERT INTO logs (fk_factura, microservicio, accion_realizada, fecha, mensaje) VALUES (200009, 'Microservicio 1', 'Accion 1', CURRENT_TIMESTAMP, 'Mensaje 1');

-- insertar en logs pero con una fecha anterior a la actual por lo menos con 6 horas de diferencia, para la factura 200011 que esta siendo procesada por otra instancia del microservicio
INSERT INTO logs (fk_factura, microservicio, accion_realizada, fecha, mensaje) VALUES (200011, 'Microservicio 1', 'Accion 1', CURRENT_TIMESTAMP - interval '7 hours', 'Mensaje 1');
-- insertar otro log con la fecha actual para la factura 200011 con informacion diferente
INSERT INTO logs (fk_factura, microservicio, accion_realizada, fecha, mensaje) VALUES (200011, 'Microservicio 2', 'Accion 2', CURRENT_TIMESTAMP, 'Mensaje 2');

-- seleccionar todos los logs donde la factura 200011 este siendo procesada por otra instancia del microservicio
SELECT * FROM schflred.logs WHERE fk_factura = 200011;
