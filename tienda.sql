--------------------------------CREACION DE TABLAS PRIMARIAS--------------------------------
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

--------------------------------CREACION DE TABLAS SECUNDARIAS--------------------------------
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT REFERENCES categorias(id_categoria),
    CHECK (precio > 0),
    CHECK (stock >= 0)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'Procesando',
    total DECIMAL(10, 2) NOT NULL,
    CHECK (estado IN ('Procesando', 'Enviado', 'Entregado', 'Cancelado')),
    CHECK (total >= 0)
);

CREATE TABLE detalles_pedido (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT REFERENCES pedidos(id_pedido),
    id_producto INT REFERENCES productos(id_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    CHECK (cantidad > 0),
    CHECK (precio_unitario >= 0)
);

CREATE TABLE resenas (
    id_resena SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    id_producto INT REFERENCES productos(id_producto),
    calificacion INT NOT NULL,
    comentario TEXT,
    fecha_resena TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (calificacion BETWEEN 1 AND 5)
);

CREATE TABLE lista_deseos (
    id_lista SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    id_producto INT REFERENCES productos(id_producto),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------INSERCION DE DATOS--------------------------------
INSERT INTO clientes (nombre, apellido, direccion, telefono, email) VALUES
('Freddie', 'Mercury', 'Zanzibar 123', '555-BOHEMIAN', 'freddie@bohemian.com'),
('Axl', 'Rose', 'Paradise City 456', '555-GNROCKS', 'axl@gunsnroses.com'),
('David', 'Bowie', 'Space Oddity 789', '555-STARDUST', 'ziggy@stardust.com'),
('Janis', 'Joplin', 'Piece of My Heart 101', '555-PEARL', 'janis@bigbrother.com'),
('Jim', 'Morrison', 'The Doors 202', '555-LIZARD', 'jim@thedoors.com');

INSERT INTO categorias (nombre) VALUES
('Guitarras'), ('Baterías'), ('Teclados'), ('Micrófonos'), ('Amplificadores');

INSERT INTO productos (nombre, descripcion, precio, stock, id_categoria) VALUES
('Guitarra Eléctrica Slash Signature', 'Perfecta para tocar Sweet Child O Mine', 1999.99, 10, 1),
('Batería Ludwig Bonham', 'Ideal para hacer temblar estadios', 2499.99, 5, 2),
('Sintetizador Bowie Space Oddity', 'Para sonidos fuera de este mundo', 1499.99, 8, 3),
('Micrófono Freddie Mercury', 'Con extra de bigote incluido', 299.99, 20, 4),
('Amplificador Marshall Stack', 'Porque el volumen importa', 999.99, 15, 5);

INSERT INTO pedidos (id_cliente, estado, total) VALUES
(1, 'Entregado', 2299.98),
(2, 'Procesando', 999.99),
(3, 'Enviado', 1799.98),
(4, 'Entregado', 299.99),
(5, 'Cancelado', 4999.97);

INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 1999.99),  -- Freddie compró una guitarra Slash
(1, 4, 1, 299.99),   -- Y su propio micrófono
(2, 5, 1, 999.99),   -- Axl compró un amplificador
(3, 3, 1, 1499.99),  -- Bowie compró su propio sintetizador
(3, 4, 1, 299.99),   -- Y un micrófono de Freddie (por si acaso)
(4, 4, 1, 299.99),   -- Janis solo quería el micrófono de Freddie
(5, 2, 2, 2499.99);  -- Jim intentó comprar dos baterías, pero canceló

INSERT INTO resenas (id_cliente, id_producto, calificacion, comentario) VALUES
(1, 4, 5, '¡Darling, este micrófono es una delicia! Perfecto para mis falsetes.'),
(2, 5, 4, 'Buen amplificador, pero no tan ruidoso como esperaba. ¿Dónde está el 11?'),
(3, 3, 5, 'Este sintetizador es de otro planeta. ¡Literalmente!'),
(4, 4, 3, 'El micrófono está bien, pero me hace sonar demasiado sobria.'),
(5, 2, 1, 'Demasiado ruidosa. Prefiero el sonido de las puertas cerrándose.');

INSERT INTO lista_deseos (id_cliente, id_producto) VALUES
(1, 2),  -- Freddie quiere una batería
(2, 1),  -- Axl desea la guitarra de Slash (ironía)
(3, 5),  -- Bowie está interesado en el amplificador
(4, 3),  -- Janis considera el sintetizador
(5, 4);  -- Jim piensa en el micrófono de Freddie

--------------------------------CONSULTAS--------------------------------
-- 1. Top 5 productos más vendidos
SELECT p.nombre, SUM(dp.cantidad) as total_vendido
FROM productos p
JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_vendido DESC
LIMIT 5;

-- 2. Clientes que han gastado más de $1000 en total
SELECT c.nombre, c.apellido, SUM(p.total) as total_gastado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido
HAVING SUM(p.total) > 1000
ORDER BY total_gastado DESC;

-- 3. Productos con stock bajo (menos de 5 unidades)
SELECT nombre, stock
FROM productos
WHERE stock < 5
ORDER BY stock;

-- 4. Promedio de calificaciones por producto
SELECT p.nombre, AVG(r.calificacion) as promedio_calificacion
FROM productos p
LEFT JOIN resenas r ON p.id_producto = r.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY promedio_calificacion DESC;

-- 5. Productos más deseados (en listas de deseos)
SELECT p.nombre, COUNT(*) as veces_deseado
FROM productos p
JOIN lista_deseos ld ON p.id_producto = ld.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY veces_deseado DESC
LIMIT 5;

--------------------------------PROCEDIMIENTOS--------------------------------
-- 1. Procedimiento para actualizar el stock después de una venta
CREATE OR REPLACE PROCEDURE actualizar_stock_venta(
    IN p_id_pedido INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos p
    SET stock = p.stock - dp.cantidad
    FROM detalles_pedido dp
    WHERE dp.id_pedido = p_id_pedido AND p.id_producto = dp.id_producto;
END;
$$;

-- 2. Procedimiento para calcular el total de un pedido
CREATE OR REPLACE PROCEDURE calcular_total_pedido(
    IN p_id_pedido INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total DECIMAL(10, 2);
BEGIN
    SELECT SUM(cantidad * precio_unitario) INTO v_total
    FROM detalles_pedido
    WHERE id_pedido = p_id_pedido;

    UPDATE pedidos
    SET total = v_total
    WHERE id_pedido = p_id_pedido;
END;
$$;

-- 3. Procedimiento para agregar un producto a la lista de deseos
CREATE OR REPLACE PROCEDURE agregar_a_lista_deseos(
    IN p_id_cliente INT,
    IN p_id_producto INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lista_deseos (id_cliente, id_producto)
    VALUES (p_id_cliente, p_id_producto)
    ON CONFLICT (id_cliente, id_producto) DO NOTHING;
END;
$$;

-- 4. Procedimiento para actualizar el estado de un pedido
CREATE OR REPLACE PROCEDURE actualizar_estado_pedido(
    IN p_id_pedido INT,
    IN p_nuevo_estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE pedidos
    SET estado = p_nuevo_estado
    WHERE id_pedido = p_id_pedido;
END;
$$;

-- 5. Procedimiento para eliminar productos sin stock
CREATE OR REPLACE PROCEDURE eliminar_productos_sin_stock()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM productos
    WHERE stock = 0;
END;
$$;

--------------------------------FUNCIONES--------------------------------

-- 1. Función para obtener el total de ventas en un período
CREATE OR REPLACE FUNCTION total_ventas_periodo(
    fecha_inicio DATE,
    fecha_fin DATE
)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT COALESCE(SUM(total), 0) INTO total
    FROM pedidos
    WHERE fecha_pedido BETWEEN fecha_inicio AND fecha_fin;
    RETURN total;
END;
$$;

-- 2. Función para calcular el promedio de calificaciones de un producto
CREATE OR REPLACE FUNCTION promedio_calificaciones_producto(
    p_id_producto INT
)
RETURNS DECIMAL(3, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    promedio DECIMAL(3, 2);
BEGIN
    SELECT COALESCE(AVG(calificacion), 0) INTO promedio
    FROM resenas
    WHERE id_producto = p_id_producto;
    RETURN promedio;
END;
$$;

-- 3. Función para obtener el producto más vendido
CREATE OR REPLACE FUNCTION producto_mas_vendido()
RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS $$
DECLARE
    nombre_producto VARCHAR(100);
BEGIN
    SELECT p.nombre INTO nombre_producto
    FROM productos p
    JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
    GROUP BY p.id_producto, p.nombre
    ORDER BY SUM(dp.cantidad) DESC
    LIMIT 1;
    RETURN nombre_producto;
END;
$$;

-- 4. Función para calcular el valor total del inventario
CREATE OR REPLACE FUNCTION valor_total_inventario()
RETURNS DECIMAL(12, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    valor_total DECIMAL(12, 2);
BEGIN
    SELECT COALESCE(SUM(precio * stock), 0) INTO valor_total
    FROM productos;
    RETURN valor_total;
END;
$$;

-- 5. Función para obtener el cliente con más compras
CREATE OR REPLACE FUNCTION cliente_mas_compras()
RETURNS TABLE (
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    total_compras BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.nombre, c.apellido, COUNT(p.id_pedido) as total_compras
    FROM clientes c
    JOIN pedidos p ON c.id_cliente = p.id_cliente
    GROUP BY c.id_cliente, c.nombre, c.apellido
    ORDER BY total_compras DESC
    LIMIT 1;
END;
$$;