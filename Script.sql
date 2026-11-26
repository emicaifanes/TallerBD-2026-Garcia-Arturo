CREATE DATABASE SistemaPrestamoEquipos;
use SistemaPrestamoEquipos;


CREATE TABLE categorias(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(50) UNIQUE NOT NULL,
	descripcion VARCHAR(100)


);


CREATE TABLE equipos(
	id_equipo INT PRIMARY KEY AUTO_INCREMENT,
	codigo_inventario  VARCHAR(50) UNIQUE NOT NULL,
	id_categoria int NOT NULL,
	descripcion VARCHAR(255) NOT NULL,
	marca VARCHAR(50) NOT NULL,
	modelo VARCHAR(50) NOT NULL,
	condicion VARCHAR(30) NOT NULL DEFAULT 'Buen estado',
	estado VARCHAR(50) DEFAULT 'Disponible',
	activo BOOL DEFAULT TRUE,
	
	
	CONSTRAINT chk_estado 
	CHECK(estado IN ('Disponible','Prestado','Mantenimiento')),
	CONSTRAINT fk_id_categoria 
	FOREIGN KEY(id_categoria) REFERENCES categorias(id_categoria) 
	ON UPDATE CASCADE ON DELETE RESTRICT

);

CREATE TABLE solicitantes(
	
id_solicitante INT PRIMARY KEY AUTO_INCREMENT,
numero_empleado VARCHAR(50) UNIQUE NOT NULL,
nombre VARCHAR(150) NOT NULL,
departamento VARCHAR(100) NOT NULL,
activo BOOL DEFAULT TRUE


);


CREATE TABLE usuario_sistema(
	id_usuario INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
	usuario VARCHAR(50) UNIQUE NOT NULL,
	contrasena VARCHAR(255) NOT NULL,
	nombre VARCHAR(150) NOT NULL,
	rol VARCHAR(50) NOT NULL,
	activo BOOL DEFAULT TRUE,
	
	
	CONSTRAINT chk_rol 
	CHECK(rol IN ('admin','consulta'))
);

CREATE TABLE prestamos(
	id_prestamo INT PRIMARY KEY AUTO_INCREMENT,
	id_equipo INT NOT NULL,
	id_solicitante INT NOT NULL,
	id_usuario_entrega INT NOT NULL,
	fecha_prestamo DATETIME DEFAULT CURRENT_TIMESTAMP,
	fecha_devolucion_prevista DATETIME NOT NULL,
	estado VARCHAR(30) DEFAULT 'Activo',
	
	
	CONSTRAINT fk_id_equipo
	FOREIGN KEY(id_equipo) REFERENCES equipos(id_equipo) 
	ON UPDATE CASCADE ON DELETE RESTRICT,
	
	CONSTRAINT fk_id_solicitante
	FOREIGN KEY(id_solicitante) REFERENCES solicitantes(id_solicitante) 
	ON UPDATE CASCADE ON DELETE RESTRICT,
	
	CONSTRAINT fk_usuario_entrega
	FOREIGN KEY(id_usuario_entrega) REFERENCES usuario_sistema(id_usuario) 
	ON UPDATE CASCADE ON DELETE RESTRICT,
	
	CONSTRAINT chk_estado_prestamo
	CHECK(estado IN('Activo','Devuelto'))
	

);


CREATE TABLE devoluciones(
	id_devolucion INT PRIMARY KEY AUTO_INCREMENT,
	id_prestamo INT UNIQUE NOT NULL,
	id_usuario_recibe INT NOT NULL,
	fecha_devolucion DATETIME DEFAULT CURRENT_TIMESTAMP,
	condicion_entrega VARCHAR(30) NOT NULL,
	observaciones VARCHAR(100),
	
	
	CONSTRAINT fk_id_prestamo
	FOREIGN KEY(id_prestamo) REFERENCES prestamos(id_prestamo)
	ON UPDATE CASCADE ON DELETE RESTRICT,
	
	CONSTRAINT fk_usuario_recibe 
	FOREIGN KEY(id_usuario_recibe) REFERENCES usuario_sistema(id_usuario) 
	ON UPDATE CASCADE ON DELETE RESTRICT,
	
	CONSTRAINT chk_condicion_entrega
	CHECK(condicion_entrega IN('Adecuada','Con falla'))

);



