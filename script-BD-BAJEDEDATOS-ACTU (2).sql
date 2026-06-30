DROP DATABASE IF EXISTS prog3BajeDatos;
CREATE DATABASE prog3BajeDatos;
USE prog3BajeDatos;

SET FOREIGN_KEY_CHECKS = 0; 

-- =========================================================================
--                          1. USUARIOS
-- =========================================================================

CREATE TABLE IF NOT EXISTS `Usuario` (
    `id_usuario` INTEGER AUTO_INCREMENT,
    `dni` VARCHAR(20) NOT NULL UNIQUE,
    `nombre` VARCHAR(100) NOT NULL,
    `apellido_completo` VARCHAR(150) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `correo` VARCHAR(150) NOT NULL UNIQUE,
    `contrasena_hash` VARCHAR(255) NOT NULL,
    `estado` ENUM('ACTIVA', 'INACTIVA', 'SUSPENDIDA') NOT NULL DEFAULT 'ACTIVA',
    PRIMARY KEY(`id_usuario`)
);

CREATE TABLE IF NOT EXISTS `Admin` (
    `id_usuario` INTEGER NOT NULL,
    `fecha_inicio_admin` DATE NOT NULL,
    `is_master` bool default false,
    PRIMARY KEY(`id_usuario`)
);

CREATE TABLE IF NOT EXISTS `Cliente` (
    `id_usuario` INTEGER NOT NULL,
    `telefono` VARCHAR(20) NOT NULL,
    `id_pedido_activo` INTEGER,
    `fecha_nacimiento` DATE NOT NULL,
    PRIMARY KEY(`id_usuario`)
);

CREATE TABLE IF NOT EXISTS `Cliente_Direccion` (
    `id_direccion` INTEGER NOT NULL AUTO_INCREMENT,
    `id_cliente` INTEGER NOT NULL,
    `direccion` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id_direccion`)
);

ALTER TABLE `Admin`
ADD FOREIGN KEY(`id_usuario`) REFERENCES `Usuario`(`id_usuario`) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE `Cliente`
ADD FOREIGN KEY(`id_usuario`) REFERENCES `Usuario`(`id_usuario`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_pedido_activo`) REFERENCES `Pedido`(`id_pedido`) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE `Cliente_Direccion`
ADD FOREIGN KEY(`id_cliente`) REFERENCES `Cliente`(`id_usuario`) ON UPDATE NO ACTION ON DELETE CASCADE;


-- =========================================================================
--                              2. PRODUCTO
-- =========================================================================

CREATE TABLE IF NOT EXISTS `Impuesto` (
    `id_impuesto` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL, 
    `porcentaje` DECIMAL(10,4) NOT NULL, 
    `tipo` ENUM('PORCENTAJE', 'MONTO_FIJO') NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    PRIMARY KEY(`id_impuesto`)
);

CREATE TABLE IF NOT EXISTS `Marca` (
    `id_marca` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id_marca`)
);

CREATE TABLE IF NOT EXISTS `AlcoholImpuesto` (
    `id_alcohol_impuesto` INTEGER NOT NULL AUTO_INCREMENT,
    `minimo` INTEGER NOT NULL,
    `maximo` INTEGER NOT NULL,
    `valor` DOUBLE NOT NULL,
    PRIMARY KEY(`id_alcohol_impuesto`)
);

CREATE TABLE IF NOT EXISTS `Imagen` (
    `id_imagen` INTEGER NOT NULL AUTO_INCREMENT,
    `url` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id_imagen`)
);

CREATE TABLE IF NOT EXISTS `Categoria` (
    `id_categoria` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id_categoria`)
);

CREATE TABLE IF NOT EXISTS `Producto` (
    `id_producto` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(150) NOT NULL,
    `precio` DECIMAL(10,2) NOT NULL, 
    `precio_final` DECIMAL(10,2) NOT NULL DEFAULT 0.00, 
    `stock` INTEGER NOT NULL,
    `descuento` DECIMAL(10,2) DEFAULT 0,
    `descripcion` TEXT, 
    `volumen_litros` DECIMAL(10,3) NOT NULL,
    `porcentaje_alcohol` DECIMAL(5,2) NOT NULL CHECK (`porcentaje_alcohol` BETWEEN 0.00 AND 100.00),
    `id_impuesto` INTEGER, 
    `id_impuesto_alcohol` INTEGER,  
    `id_marca` INTEGER NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id_producto`)
);

CREATE TABLE IF NOT EXISTS `ProductoImagen` (
    `id_producto` INTEGER NOT NULL,
    `id_imagen` INTEGER NOT NULL,
    `principal` BOOLEAN NOT NULL,
    PRIMARY KEY(`id_producto`, `id_imagen`)
);

CREATE TABLE IF NOT EXISTS `Producto_Categoria` (
    `id_producto` INTEGER NOT NULL,
    `id_categoria` INTEGER NOT NULL,
    PRIMARY KEY(`id_producto`, `id_categoria`)
);

CREATE TABLE IF NOT EXISTS `Receta` (
    `id_receta` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(150) NOT NULL,
    `descripcion` TEXT NOT NULL,
    `instrucciones` TEXT NOT NULL,
    `descuento` DECIMAL(10,2) DEFAULT 0,
    `precio` DECIMAL(10,2) NOT NULL DEFAULT 0.00, 
    `precio_final` DECIMAL(10,2) NOT NULL DEFAULT 0.00, 
    PRIMARY KEY(`id_receta`)
);

CREATE TABLE IF NOT EXISTS `RecetaImagen` (
    `id_receta` INTEGER NOT NULL,
    `id_imagen` INTEGER NOT NULL,
    `principal` BOOLEAN NOT NULL,
    PRIMARY KEY(`id_receta`, `id_imagen`)
);

CREATE TABLE IF NOT EXISTS `Elemento_Receta` (
    `id_elemento_receta` INTEGER NOT NULL AUTO_INCREMENT,
    `id_receta` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(`id_elemento_receta`)
);

CREATE TABLE IF NOT EXISTS `Receta_Categoria` (
    `id_receta` INTEGER NOT NULL,
    `id_categoria` INTEGER NOT NULL,
    PRIMARY KEY(`id_receta`, `id_categoria`)
);

ALTER TABLE `Receta_Categoria`
ADD FOREIGN KEY(`id_receta`) REFERENCES `Receta`(`id_receta`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_categoria`) REFERENCES `Categoria`(`id_categoria`) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE `Producto`
ADD FOREIGN KEY(`id_marca`) REFERENCES `Marca`(`id_marca`) ON UPDATE NO ACTION ON DELETE NO ACTION,
ADD FOREIGN KEY(`id_impuesto_alcohol`) REFERENCES `AlcoholImpuesto`(`id_alcohol_impuesto`) ON UPDATE NO ACTION ON DELETE NO ACTION,
ADD FOREIGN KEY(`id_impuesto`) REFERENCES `Impuesto`(`id_impuesto`) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE `Producto_Categoria`
ADD FOREIGN KEY(`id_producto`) REFERENCES `Producto`(`id_producto`) ON UPDATE NO ACTION ON DELETE NO ACTION,
ADD FOREIGN KEY(`id_categoria`) REFERENCES `Categoria`(`id_categoria`) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE `ProductoImagen`
ADD FOREIGN KEY(`id_producto`) REFERENCES `Producto`(`id_producto`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_imagen`) REFERENCES `Imagen`(`id_imagen`) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE `RecetaImagen`
ADD FOREIGN KEY(`id_receta`) REFERENCES `Receta`(`id_receta`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_imagen`) REFERENCES `Imagen`(`id_imagen`) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE `Elemento_Receta`
ADD FOREIGN KEY(`id_receta`) REFERENCES `Receta`(`id_receta`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_producto`) REFERENCES `Producto`(`id_producto`) ON UPDATE NO ACTION ON DELETE RESTRICT;


-- =========================================================================
--  PROCEDIMIENTO Y TRIGGER PARA ASIGNACIÓN AUTOMÁTICA DE IMPUESTOS
-- =========================================================================

DELIMITER $$

CREATE PROCEDURE AsignarImpuestoAlcohol(IN p_id_producto INT, IN p_porcentaje DECIMAL(5,2))
BEGIN
    DECLARE v_id_impuesto INT DEFAULT NULL;

    SELECT id_alcohol_impuesto INTO v_id_impuesto
    FROM AlcoholImpuesto
    WHERE p_porcentaje BETWEEN minimo AND maximo
    LIMIT 1;

    UPDATE Producto
    SET id_impuesto_alcohol = v_id_impuesto
    WHERE id_producto = p_id_producto;
END$$

CREATE TRIGGER before_insert_producto
BEFORE INSERT ON Producto
FOR EACH ROW
BEGIN
    DECLARE v_id_impuesto INT DEFAULT NULL;

    SELECT id_alcohol_impuesto INTO v_id_impuesto
    FROM AlcoholImpuesto
    WHERE NEW.porcentaje_alcohol BETWEEN minimo AND maximo
    LIMIT 1;

    SET NEW.id_impuesto_alcohol = v_id_impuesto;
END$$

DELIMITER ;


-- =========================================================================
--                              3. PEDIDO
-- =========================================================================

CREATE TABLE IF NOT EXISTS `Pedido` (
    `id_pedido` INTEGER NOT NULL AUTO_INCREMENT,
    `id_cliente` INTEGER NOT NULL,
    `fecha_pedido` DATE NOT NULL,
    `hora_inicio` TIME NOT NULL,
    `hora_fin` TIME NOT NULL,
    `precio_total` DECIMAL(10,2) NOT NULL, 
    `total_impuestos` DECIMAL(10,2) NOT NULL DEFAULT 0.00, 
    `precio_delivery` DECIMAL(10,2) NOT NULL,
    `precio_final` DECIMAL(10,2) NOT NULL DEFAULT 0.00, 
    `estado` ENUM('PENDIENTE', 'EN_PREPARACION', 'EN_CAMINO', 'ENTREGADO', 'CANCELADO', 'RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
    `direccion_destino` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id_pedido`)
);

ALTER TABLE `Pedido`
ADD FOREIGN KEY(`id_cliente`) REFERENCES `Cliente`(`id_usuario`) ON UPDATE NO ACTION ON DELETE CASCADE;


-- =========================================================================
--                           4. CARRITO ACTIVO
-- =========================================================================

CREATE TABLE IF NOT EXISTS `Detalle_Producto` (
    `id_producto` INTEGER NOT NULL,
    `id_cliente_carrito` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `descuento_total` DECIMAL(10,2) NOT NULL,
    `monto_total` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(`id_producto`, `id_cliente_carrito`)
);

CREATE TABLE IF NOT EXISTS `Detalle_Receta` (
    `id_receta` INTEGER NOT NULL,
    `id_cliente_carrito` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `descuento_total` DECIMAL(10,2) NOT NULL,
    `monto_total` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(`id_receta`, `id_cliente_carrito`)
);

ALTER TABLE `Detalle_Producto`
ADD FOREIGN KEY(`id_cliente_carrito`) REFERENCES `Cliente`(`id_usuario`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_producto`) REFERENCES `Producto`(`id_producto`) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE `Detalle_Receta`
ADD FOREIGN KEY(`id_cliente_carrito`) REFERENCES `Cliente`(`id_usuario`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_receta`) REFERENCES `Receta`(`id_receta`) ON UPDATE NO ACTION ON DELETE CASCADE;


-- =========================================================================
--              5. EL ENTORNO SNAPSHOT (FOTOGRAFÍAS INMUTABLES)
-- =========================================================================

CREATE TABLE IF NOT EXISTS `Producto_Snapshot` (
    `id_producto_snapshot` INTEGER NOT NULL AUTO_INCREMENT,
    `id_producto_original` INTEGER, 
    `nombre` VARCHAR(150) NOT NULL,
    `precio_venta` DECIMAL(10,2) NOT NULL, 
    `precio_final_venta` DECIMAL(10,2) NOT NULL, 
    `descuento_applied` DECIMAL(10,2) DEFAULT 0.00,
    `volumen_litros` DECIMAL(10,3) NOT NULL,
    `porcentaje_alcohol` DECIMAL(5,2) NOT NULL,
    `nombre_marca` VARCHAR(255) NOT NULL,
    `nombre_impuesto` VARCHAR(100) NOT NULL,
    `porcentaje_impuesto` DECIMAL(10,4) NOT NULL,
    `tipo_impuesto` ENUM('PORCENTAJE', 'MONTO_FIJO') NOT NULL, 
    `porcentaje_precio_alcohol_historico` INTEGER DEFAULT 0,
    `valor_impuesto_alcohol_historico` DOUBLE DEFAULT 0.0,
    `id_imagen` INTEGER, -- Agregado para coincidir con el Java
    PRIMARY KEY(`id_producto_snapshot`)
);

CREATE TABLE IF NOT EXISTS `Producto_Snapshot_Categoria` (
    `id_producto_snapshot` INTEGER NOT NULL,
    `nombre_categoria` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id_producto_snapshot`, `nombre_categoria`)
);

CREATE TABLE IF NOT EXISTS `Receta_Snapshot` (
    `id_receta_snapshot` INTEGER NOT NULL AUTO_INCREMENT,
    `id_receta_original` INTEGER, 
    `nombre` VARCHAR(150) NOT NULL,
    `precio_historico` DECIMAL(10,2) NOT NULL, 
    `precio_final_historico` DECIMAL(10,2) NOT NULL, 
    `id_imagen` INTEGER, -- Agregado para coincidir con el Java
    PRIMARY KEY(`id_receta_snapshot`)
);

CREATE TABLE IF NOT EXISTS `Receta_Snapshot_Elemento` (
    `id_receta_snapshot` INTEGER NOT NULL,
    `id_producto_snapshot` INTEGER NOT NULL,
    `cantidad` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(`id_receta_snapshot`, `id_producto_snapshot`)
);

ALTER TABLE `Producto_Snapshot`
ADD FOREIGN KEY(`id_producto_original`) REFERENCES `Producto`(`id_producto`) ON UPDATE NO ACTION ON DELETE SET NULL,
ADD FOREIGN KEY(`id_imagen`) REFERENCES `Imagen`(`id_imagen`) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE `Producto_Snapshot_Categoria`
ADD FOREIGN KEY(`id_producto_snapshot`) REFERENCES `Producto_Snapshot`(`id_producto_snapshot`) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE `Receta_Snapshot`
ADD FOREIGN KEY(`id_receta_original`) REFERENCES `Receta`(`id_receta`) ON UPDATE NO ACTION ON DELETE SET NULL,
ADD FOREIGN KEY(`id_imagen`) REFERENCES `Imagen`(`id_imagen`) ON UPDATE NO ACTION ON DELETE SET NULL;

ALTER TABLE `Receta_Snapshot_Elemento`
ADD FOREIGN KEY(`id_receta_snapshot`) REFERENCES `Receta_Snapshot`(`id_receta_snapshot`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_producto_snapshot`) REFERENCES `Producto_Snapshot`(`id_producto_snapshot`) ON UPDATE NO ACTION ON DELETE RESTRICT;


-- =========================================================================
--               6. HISTORIAL DE DETALLES DE PEDIDOS
-- =========================================================================

CREATE TABLE IF NOT EXISTS `Pedido_Detalle_Producto` (
    `id_pedido_detalle_prod` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pedido` INTEGER NOT NULL,
    `id_producto_snapshot` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    PRIMARY KEY(`id_pedido_detalle_prod`)
);

CREATE TABLE IF NOT EXISTS `Pedido_Detalle_Receta` (
    `id_pedido_detalle_receta` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pedido` INTEGER NOT NULL,
    `id_receta_snapshot` INTEGER NOT NULL, 
    `cantidad` INTEGER NOT NULL,
    `descuento_historico` DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY(`id_pedido_detalle_receta`)
);

ALTER TABLE `Pedido_Detalle_Producto`
ADD FOREIGN KEY(`id_pedido`) REFERENCES `Pedido`(`id_pedido`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_producto_snapshot`) REFERENCES `Producto_Snapshot`(`id_producto_snapshot`) ON UPDATE NO ACTION ON DELETE RESTRICT;

ALTER TABLE `Pedido_Detalle_Receta`
ADD FOREIGN KEY(`id_pedido`) REFERENCES `Pedido`(`id_pedido`) ON UPDATE NO ACTION ON DELETE CASCADE,
ADD FOREIGN KEY(`id_receta_snapshot`) REFERENCES `Receta_Snapshot`(`id_receta_snapshot`) ON UPDATE NO ACTION ON DELETE RESTRICT;

SET FOREIGN_KEY_CHECKS = 1;


-- =========================================================================
--                        INSERCIÓN DE DATOS
-- =========================================================================

INSERT INTO `Impuesto` (`id_impuesto`, `nombre`, `porcentaje`, `tipo`, `activo`) 
VALUES (1, 'IGV 18%', 0.1800, 'PORCENTAJE', true);

INSERT INTO `AlcoholImpuesto` (`id_alcohol_impuesto`, `minimo`, `maximo`, `porcentaje_precio`, `valor`) VALUES
(1, 0, 10, 0, 0.00),   
(2, 11, 20, 20, 1.50), 
(3, 21, 50, 40, 3.50); 

INSERT INTO `Marca` (`id_marca`, `nombre`) VALUES
(1, 'Beefeater'),(2, 'Bombay'),(3, 'Tanqueray'),(4, 'Hendrick\'s'),(5, 'Jägermeister'),
(6, 'Baileys'),(7, 'Kahlúa'),(8, 'Disaronno'),(9, 'Portón'),(10, 'Cuatro Gallos'),
(11, 'Vargas'),(12, 'Tabernero'),(13, 'Bacardí'),(14, 'Cartavio'),(15, 'Havana Club'),
(16, 'Zacapa'),(17, 'Concha y Toro'),(18, 'Navarro Correas'),(19, 'Trapiche'),
(20, 'Marqués de Riscal'),(21, 'Absolut'),(22, 'Smirnoff'),(23, 'Grey Goose'),
(24, 'Stolichnaya'),(25, 'Johnnie Walker'),(26, 'Jack Daniel\'s'),(27, 'Chivas Regal');

INSERT INTO `Categoria` (`id_categoria`, `nombre`) VALUES
(1, 'Gin'),(2, 'Licor'),(3, 'Pisco'),(4, 'Ron'),(5, 'Vino'),(6, 'Vodka'),(7, 'Whisky');

-- Galería principal
INSERT INTO `Imagen` (`id_imagen`, `url`) VALUES
(1, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/gin-beefeater.webp'),
(2, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/gin-bombay.webp'),
(3, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/gin-tanqueray.webp'),
(4, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/gin-hendricks.webp'),
(5, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/licor-jagermeister.webp'),
(6, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/licor-baileys.webp'),
(7, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/licor-kahlua.webp'),
(8, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/licor-amaretto.webp'),
(9, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/pisco-porton.webp'),
(10, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/pisco-quebranta.webp'),
(11, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/pisco-acholado.webp'),
(12, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/pisco-tabernero.webp'),
(13, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/ron-bacardi.webp'),
(14, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/ron-cartavio.webp'),
(15, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/ron-havana-club.webp'),
(16, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/ron-zacapa.webp'),
(17, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vino-casillero.webp'),
(18, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vino-navarro-correas.webp'),
(19, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vino-trapiche.webp'),
(20, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vino-marques.webp'),
(21, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vodka-absolut.webp'),
(22, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vodka-smirnoff.webp'),
(23, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vodka-grey-goose.webp'),
(24, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/vodka-stolichnaya.webp'),
(25, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/whisky-johnnie-walker.webp'),
(26, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/whisky-jack-daniels.webp'),
(27, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/whisky-chivas-regal.webp'),
(28, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/whisky-black-label.webp');


INSERT INTO Producto (id_producto, nombre, precio, precio_final, stock, descuento, descripcion, volumen_litros, porcentaje_alcohol, id_impuesto, id_marca) VALUES
(1, 'Beefeater London Dry Gin', 58.47, 69.00, 50, 0.00, 'Gin premium de origen inglés.', 0.750, 40.00, 1, 1),
(2, 'Bombay Sapphire', 72.03, 85.00, 40, 0.00, 'Gin premium infusión al vapor.', 0.750, 47.00, 1, 2),
(3, 'Tanqueray London Dry', 75.42, 89.00, 35, 0.00, 'Gin clásico de cuatro botánicos.', 0.750, 43.10, 1, 3),
(4, 'Hendrick''s Gin', 126.27, 149.00, 20, 0.00, 'Gin premium escocés.', 0.750, 44.00, 1, 4),
(5, 'Jägermeister', 66.95, 79.00, 60, 0.00, 'Licor alemán de hierbas.', 0.700, 35.00, 1, 5),
(6, 'Baileys Original', 58.47, 69.00, 80, 0.00, 'Licor cremoso irlandés.', 0.750, 17.00, 1, 6),
(7, 'Kahlúa', 55.08, 65.00, 45, 0.00, 'Licor de café.', 0.700, 20.00, 1, 7),
(8, 'Amaretto Disaronno', 75.42, 89.00, 30, 0.00, 'Licor italiano de almendra.', 0.700, 28.00, 1, 8),
(9, 'Pisco Portón Mosto Verde', 75.42, 89.00, 25, 0.00, 'Pisco premium peruano.', 0.750, 43.00, 1, 9),
(10, 'Pisco Quebranta', 41.53, 49.00, 100, 0.00, 'Pisco quebranta puro.', 0.750, 41.00, 1, 10),
(11, 'Pisco Acholado', 50.00, 59.00, 90, 0.00, 'Pisco de mezcla armoniosa.', 0.750, 40.00, 1, 11),
(12, 'Pisco Tabernero Italia', 44.07, 52.00, 85, 0.00, 'Pisco aromático.', 0.750, 40.00, 1, 12),
(13, 'Bacardí Carta Blanca', 41.53, 49.00, 120, 0.00, 'Ron blanco ligero.', 0.750, 40.00, 1, 13),
(14, 'Cartavio Selecto', 35.59, 42.00, 150, 0.00, 'Ron peruano suave.', 0.750, 40.00, 1, 14),
(15, 'Havana Club Añejo', 49.15, 58.00, 70, 0.00, 'Ron cubano añejado.', 0.750, 40.00, 1, 15),
(16, 'Ron Zacapa 23', 160.17, 189.00, 15, 0.00, 'Ron premium añejo.', 0.750, 40.00, 1, 16),
(17, 'Casillero del Diablo', 41.53, 49.00, 200, 0.00, 'Vino tinto chileno.', 0.750, 13.50, 1, 17),
(18, 'Navarro Correas', 50.00, 59.00, 65, 0.00, 'Vino argentino.', 0.750, 14.00, 1, 18),
(19, 'Trapiche Malbec', 38.14, 45.00, 110, 0.00, 'Malbec argentino.', 0.750, 13.50, 1, 19),
(20, 'Marqués de Riscal', 75.42, 89.00, 40, 0.00, 'Vino español de calidad.', 0.750, 14.00, 1, 20),
(21, 'Absolut Vodka', 55.08, 65.00, 100, 0.00, 'Vodka sueco.', 0.750, 40.00, 1, 21),
(22, 'Smirnoff Red', 46.61, 55.00, 140, 0.00, 'Vodka tradicional.', 0.750, 37.50, 1, 22),
(23, 'Grey Goose', 100.85, 119.00, 30, 0.00, 'Vodka premium francés.', 0.750, 40.00, 1, 23),
(24, 'Stolichnaya', 50.00, 59.00, 85, 0.00, 'Vodka balanceado.', 0.750, 40.00, 1, 24),
(25, 'Johnnie Walker Red Label', 58.47, 69.00, 95, 0.00, 'Whisky blended clásico.', 0.750, 40.00, 1, 25),
(26, 'Jack Daniel''s', 75.42, 89.00, 60, 0.00, 'Whiskey Tennessee.', 0.750, 40.00, 1, 26),
(27, 'Chivas Regal 12 años', 109.32, 129.00, 40, 0.00, 'Whisky escocés 12 años.', 0.750, 40.00, 1, 27),
(28, 'Johnnie Walker Black Label', 126.27, 149.00, 55, 0.00, 'Whisky blended ahumado.', 0.750, 40.00, 1, 25);

INSERT INTO `ProductoImagen` (`id_producto`, `id_imagen`, `principal`) VALUES
(1, 1, true), (2, 2, true), (3, 3, true), (4, 4, true),
(5, 5, true), (6, 6, true), (7, 7, true), (8, 8, true),
(9, 9, true), (10, 10, true), (11, 11, true), (12, 12, true),
(13, 13, true), (14, 14, true), (15, 15, true), (16, 16, true),
(17, 17, true), (18, 18, true), (19, 19, true), (20, 20, true),
(21, 21, true), (22, 22, true), (23, 23, true), (24, 24, true),
(25, 25, true), (26, 26, true), (27, 27, true), (28, 28, true);

INSERT INTO `Producto_Categoria` (`id_producto`, `id_categoria`) VALUES
(1, 1), (2, 1), (3, 1), (4, 1),   
(5, 2), (6, 2), (7, 2), (8, 2),   
(9, 3), (10, 3), (11, 3), (12, 3),
(13, 4), (14, 4), (15, 4), (16, 4), 
(17, 5), (18, 5), (19, 5), (20, 5), 
(21, 6), (22, 6), (23, 6), (24, 6), 
(25, 7), (26, 7), (27, 7), (28, 7); 


INSERT INTO `Receta` (`id_receta`, `nombre`, `descripcion`, `instrucciones`, `descuento`, `precio`, `precio_final`) VALUES
(1, 'Pisco Sour Clásico', 'El cóctel bandera del Perú, equilibrado, cítrico y con su clásica espuma.', 'Agregar a la coctelera pisco...', 0.00, 25.42, 30.00),
(2, 'Whisky Sour', 'Un clásico internacional adaptado al paladar exigente de las barras peruanas.', 'Colocar en la coctelera whisky...', 0.00, 33.90, 40.00),
(3, 'Mojito Clásico', 'Bebida cubana refrescante con el toque de hierbabuena.', 'Macerar suavemente las hojas...', 2.00, 21.19, 25.00),
(4, 'Gin Tonic Premium', 'Elegante, botánico y muy refrescante.', 'Enfriar una copa balón...', 0.00, 38.14, 45.00);


INSERT INTO Elemento_Receta (id_elemento_receta, id_receta, id_producto, cantidad) VALUES
-- 1. Pisco Sour Clásico (Receta ID: 1)
(1, 1, 9, 0.09),  -- Pisco Portón
(2, 1, 12, 0.03), -- Pisco Tabernero
(3, 1, 6, 0.01),  -- Dash de Baileys
-- 2. Whisky Sour (Receta ID: 2)
(4, 2, 26, 0.06), -- Jack Daniels
-- 3. Mojito Clásico (Receta ID: 3)
(5, 3, 13, 0.06), -- Bacardí Carta Blanca
-- 4. Gin Tonic Premium (Receta ID: 4)
(6, 4, 2, 0.06),  -- Gin Bombay
(7, 4, 8, 0.01);  -- Dash de Amaretto

INSERT INTO Imagen (id_imagen, url) VALUES
(29, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/receta-pisco-sour.webp'),
(30, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/cuba_libre.webp'),
(31, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/margarita.webp'),
(32, 'https://zrrvsajbasvpbtannzyc.supabase.co/storage/v1/object/public/imagenes/gin_tonic.webp');


INSERT INTO RecetaImagen (id_receta, id_imagen, principal) VALUES
(1, 29, TRUE), -- Pisco Sour
(2, 30, TRUE), -- Whisky Sour
(3, 31, TRUE), -- Mojito
(4, 32, TRUE); -- Gin Tonic

-- Usuarios
INSERT INTO `Usuario` (`dni`, `nombre`, `apellido_completo`, `correo`, `contrasena_hash`, `estado`) VALUES 
('11111111', 'Carlos', 'Mendoza Torres', 'admin.carlos@licoreria.com', 'hash_seguro_admin_123', 'ACTIVA'),
('22222222', 'Ana Maria', 'Gomez Pardo', 'ana.gomez@gmail.com', 'hash_cliente_ana', 'ACTIVA'),
('33333333', 'Juan Diego', 'Quispe Vega', 'juan.quispe@outlook.com', 'hash_cliente_juan', 'ACTIVA'),
('44444444', 'Lucia', 'Fernandez Rios', 'lucia.fer@yahoo.com', 'hash_cliente_lucia', 'ACTIVA');

INSERT INTO `Admin` (`id_usuario`, `fecha_inicio_admin`,`is_master`) VALUES (1, CURDATE(), true);

INSERT INTO `Cliente` (`id_usuario`, `telefono`, `id_pedido_activo`, `fecha_nacimiento`) VALUES 
(2, '999888777', NULL, '1995-04-12'),
(3, '955444333', NULL, '1990-11-23'),
(4, '911222333', NULL, '2001-07-08');