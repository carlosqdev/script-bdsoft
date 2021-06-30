/*
			****** Script Base de datos ********
	**** Análisis y diseño de sistemas orientado a objetos ****
*/

USE master
GO

--Comprobar si existe la base de datos.
IF EXISTS(SELECT * FROM sys.databases WHERE name='bdsoft')
BEGIN
	ALTER DATABASE bdsoft SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE bdsoft
END
GO

--Creamos la base de datos.
CREATE DATABASE bdsoft
GO

--Crear y asignar usuarios.
IF EXISTS(SELECT name FROM master.dbo.syslogins WHERE name='userbdsoft')
BEGIN
	DROP LOGIN userbdsoft
END
GO

--Crear login para el servidor.
CREATE LOGIN userbdsoft WITH PASSWORD = '$Udem2021*', DEFAULT_DATABASE = bdsoft
GO

USE bdsoft
GO

--Crear usuario para base de datos.
CREATE USER userbdsoft FOR LOGIN userbdsoft
GO

--Asignar rol de usuario.
EXEC sp_addrolemember 'db_owner', 'userbdsoft'
GO

/*
	Creación de tablas.
*/

-- Tabla LogTablas
CREATE TABLE LogTablas
(
	IdLog INT IDENTITY(1,1) NOT NULL,
	NombreTabla VARCHAR(255) NOT NULL,
	Accion VARCHAR(6) NOT NULL,
	Descripcion VARCHAR(255) NOT NULL,
	Usuario VARCHAR(20) NOT NULL,
	Fecha DATETIME NOT NULL
)
GO

-- Tabla Usuarios.
CREATE TABLE Usuarios (
	IdUsuario INT IDENTITY,
	Nombre VARCHAR(64),
	Apellido VARCHAR(64),
	Cargo VARCHAR(64),
	RolDeAcceso VARCHAR(20),
	UserName VARCHAR(64),
	Password VARCHAR(64),
	Observacion VARCHAR(100)
)
GO
-- Fin tabla Usuarios.

-- Tabla EquiposTecnologicos.
CREATE TABLE EquiposTecnologicos (
	IdEquipo INT IDENTITY,
	Descripcion VARCHAR(255),
	Modelo VARCHAR(64),
	Marca VARCHAR(64),
	NumeroDeSerie VARCHAR(64),
	CodigoInterno VARCHAR(64),
	Estado VARCHAR(20),
	CodEmpleado INT,
	ValorMonetario MONEY,
	CreadoPorUserName INT,
	Observacion VARCHAR(100)
)
GO
-- Fin tabla EquiposTecnologicos.

-- Tabla Areas.
CREATE TABLE Areas (
	IdArea INT IDENTITY,
	Nombre VARCHAR(64),
	Funcion VARCHAR(140),
	Observacion VARCHAR(100)
)
GO
-- Fin tabla areas.

-- Tabla Empleados.
CREATE TABLE Empleados (
	CodEmpleado INT IDENTITY,
	Nombre VARCHAR(64),
	Apellido VARCHAR(64),
	Identificacion VARCHAR(20),
	Cargo VARCHAR(20),
	IdArea INT,
	Observacion VARCHAR(100),
)
GO
-- Fin tabla Empleados.

-- Tabla Asistencias.
CREATE TABLE Asistencias (
	IdAsistencia INT IDENTITY,
	CodEmpleado INT
)
GO
-- Fin tabla Asistencias.

-- Tabla DetalleDeAsistencias.
CREATE TABLE DetalleDeAsistencias (
	IdDetalle INT IDENTITY,
	IdAsistencia INT,
	FechaHoraEntrada DATETIME,
	FechaHoraSalida DATETIME,
	Observacion VARCHAR(100)
)
GO
-- Fin tabla DetalleDeAsistencias.

/*
	Creación de restricciones.
*/

-- Clave primaria de tabla LogTablas
ALTER TABLE LogTablas ADD CONSTRAINT pk_logtablas_IdLog 
PRIMARY KEY NONCLUSTERED(IdLog)
GO

-- Creando restricción para campo Accion (Solo permite INSERT, DELETE, UPDATE)
ALTER TABLE LogTablas ADD CONSTRAINT ck_logtablas_Accion 
CHECK(Accion in ('INSERT', 'DELETE', 'UPDATE'))
GO

-- Clave primaria de tabla Usuarios.
ALTER TABLE Usuarios ADD CONSTRAINT pk_usuarios_IdUsuario
PRIMARY KEY NONCLUSTERED(IdUsuario)
GO

-- Clave primaria de tabla EquiposTecnologicos.
ALTER TABLE EquiposTecnologicos ADD CONSTRAINT pk_EquiposTecnologicos_IdEquipo
PRIMARY KEY NONCLUSTERED(IdEquipo)
GO

-- Clave primaria de tabla Areas.
ALTER TABLE Areas ADD CONSTRAINT pk_Areas_IdArea
PRIMARY KEY NONCLUSTERED(IdArea)
GO

-- Clave primaria de tabla Empleados.
ALTER TABLE Empleados ADD CONSTRAINT pk_Empleados_CodEmpleado
PRIMARY KEY NONCLUSTERED(CodEmpleado)
GO

-- Clave primaria de tabla Asistencias.
ALTER TABLE Asistencias ADD CONSTRAINT pk_Asistencias_IdAsistencia
PRIMARY KEY NONCLUSTERED(IdAsistencia)
GO

-- Clave primaria de tabla DetalleDeAsistencias.
ALTER TABLE DetalleDeAsistencias ADD CONSTRAINT pk_DetalleDeAsistencias_IdDetalle
PRIMARY KEY NONCLUSTERED(IdDetalle)
GO

-- Claves foraneas en tabla EquiposTecnologicos.
ALTER TABLE EquiposTecnologicos ADD CONSTRAINT fk_EquiposTecnologicos_CodEmpleado
FOREIGN KEY(CodEmpleado) REFERENCES Empleados(CodEmpleado) ON UPDATE CASCADE ON DELETE CASCADE
GO
ALTER TABLE EquiposTecnologicos ADD CONSTRAINT fk_EquiposTecnologicos_CreadoPorUserName
FOREIGN KEY(CreadoPorUserName) REFERENCES Usuarios(IdUsuario) ON UPDATE CASCADE ON DELETE CASCADE
GO

-- Clave foranea en tabla Empleados.
ALTER TABLE Empleados ADD CONSTRAINT fk_Empleados_IdArea
FOREIGN KEY(IdArea) REFERENCES Areas(IdArea) ON UPDATE CASCADE ON DELETE CASCADE
GO

-- Clave foranea en tabla Asistencias.
ALTER TABLE Asistencias ADD CONSTRAINT fk_Asistencias_CodEmpleado
FOREIGN KEY(CodEmpleado) REFERENCES Empleados(CodEmpleado) ON UPDATE CASCADE ON DELETE CASCADE
GO

-- Clave foranea en tabla DetalleDeAsistencias.
ALTER TABLE DetalleDeAsistencias ADD CONSTRAINT fk_DetalleDeAsistencias_IdAsistencia
FOREIGN KEY(IdAsistencia) REFERENCES Asistencias(IdAsistencia) ON UPDATE CASCADE ON DELETE CASCADE
GO

/*
	Creación de procedimientos almacenados.
*/

--Procedimiento almacenado de Usuarios
CREATE PROCEDURE SpUsuarios
(
	@IdUsuario INT,
	@Nombre VARCHAR(64),
	@Apellido VARCHAR(64),
	@Cargo VARCHAR(64),
	@RolDeAcceso VARCHAR(20),
	@UserName VARCHAR(64),
	@Password VARCHAR(64),
	@Observacion VARCHAR(100),
	-- Variable de trabajo Work.
	@W_Operacion VARCHAR(10),
	-- Variable de salida OUTPUT.
	@O_Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
	BEGIN TRY
	--Validar tipo de operación "I" es INSERT
	IF (@W_Operacion = 'I')
	BEGIN
		INSERT INTO Usuarios
		(
			Nombre,
			Apellido,
			Cargo,
			RolDeAcceso,
			UserName,
			Password,
			Observacion
		)
		VALUES
		(
			@Nombre,
			@Apellido,
			@Cargo,
			@RolDeAcceso,
			@UserName,
			@Password,
			@Observacion
		)
		SELECT @O_Mensaje = 'SE HA INSERTADO CORRECTAMENTE EN LA TABLA USUARIOS.'
	END
	--fin de isertado.
	--Validar tipo de operación "U" es UPDATE
	IF (@W_Operacion = 'U')
	BEGIN
		UPDATE Usuarios
			SET
				Nombre = @Nombre,
				Apellido = @Apellido,
				Cargo = @Cargo,
				RolDeAcceso = @RolDeAcceso,
				Password = @Password,
				Observacion = @Observacion
				WHERE IdUsuario = @IdUsuario
			SELECT @O_Mensaje = 'SE HA ACTUALIZADO CORRECTAMENTE UN REGISTRO DE LA TABLA USUARIOS.'
	END
	--fin de actualizado.
	--Validar tipo de operación "S" es SELECT.
	IF (@W_Operacion = 'S')
	BEGIN
		SELECT Nombre, Apellido, Cargo, RolDeAcceso, UserName, Observacion
			FROM Usuarios
		SELECT @O_Mensaje = 'SE REALIZO UN SELECT CORRECTAMENTE A LA TABLA USUARIOS.'
	END
	--fin de select.
	--Validar tipo de operación "D" es DELETE.
	IF (@W_Operacion = 'D')
	BEGIN
		DELETE Usuarios WHERE IdUsuario = @IdUsuario
		SELECT @O_Mensaje = 'SE HA ELIMINADO UN REGISTRO DE LA TABLA USUARIOS.'
	END
	--fin de delete.
	END TRY
	BEGIN CATCH
		-- Si ocurrio un error lo notificamos.
		SELECT @O_Mensaje = 'ERROR: ' + ERROR_MESSAGE() + 'EN LINEA: ' + CONVERT(VARCHAR, ERROR_LINE() )
	END CATCH
END
GO
-- Fin procedimiento almacenado Usuarios.

--Procedimiento almacenado de EquiposTecnologicos
CREATE PROCEDURE SpEquipoTecnologicos
(
	@IdEquipo INT,
	@Descripcion VARCHAR(255),
	@Modelo VARCHAR(64),
	@Marca VARCHAR(64),
	@NumeroDeSerie VARCHAR(64),
	@CodigoInterno VARCHAR(64),
	@Estado VARCHAR(20),
	@CodEmpleado INT,
	@ValorMonetario MONEY,
	@CreadoPorUserName INT,
	@Observacion VARCHAR(100),
	-- Variable de trabajo Work.
	@W_Operacion VARCHAR(10),
	-- Variable de salida OUTPUT.
	@O_Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
	BEGIN TRY
	--Validar tipo de operación "I" es INSERT
	IF (@W_Operacion = 'I')
	BEGIN
		INSERT INTO EquiposTecnologicos
		(
			Descripcion,
			Modelo,
			Marca,
			NumeroDeSerie,
			CodigoInterno,
			Estado,
			CodEmpleado,
			ValorMonetario,
			CreadoPorUserName,
			Observacion
		)
		VALUES
		(
			@Descripcion,
			@Modelo,
			@Marca,
			@NumeroDeSerie,
			@CodigoInterno,
			@Estado,
			@CodEmpleado,
			@ValorMonetario,
			@CreadoPorUserName,
			@Observacion
		)
		SELECT @O_Mensaje = 'SE HA INSERTADO CORRECTAMENTE EN LA TABLA EQUIPOSTECNOLOGICOS.'
	END
	--fin de isertado.
	--Validar tipo de operación "U" es UPDATE
	IF (@W_Operacion = 'U')
	BEGIN
		UPDATE EquiposTecnologicos
			SET
				Descripcion = @Descripcion,
				Modelo = @Modelo,
				Marca = @Marca,
				NumeroDeSerie = @NumeroDeSerie,
				CodigoInterno = @CodigoInterno,
				Estado = @Estado,
				CodEmpleado = @CodEmpleado,
				ValorMonetario = @ValorMonetario,
				CreadoPorUserName = @CreadoPorUserName,
				Observacion = @Observacion
				WHERE IdEquipo = @IdEquipo
			SELECT @O_Mensaje = 'SE HA ACTUALIZADO CORRECTAMENTE UN REGISTRO DE LA TABLA EQUIPOSTECNOLOGICOS.'
	END
	--fin de actualizado.
	--Validar tipo de operación "S" es SELECT.
	IF (@W_Operacion = 'S')
	BEGIN
		SELECT IdEquipo, Descripcion, Modelo, Marca, NumeroDeSerie, CodigoInterno, Estado, CodEmpleado, ValorMonetario, CreadoPorUserName, Observacion
			FROM EquiposTecnologicos
		SELECT @O_Mensaje = 'SE REALIZO UN SELECT CORRECTAMENTE A LA TABLA EQUIPOSTECNOLOGICOS.'
	END
	--fin de select.
	--Validar tipo de operación "D" es DELETE.
	IF (@W_Operacion = 'D')
	BEGIN
		DELETE EquiposTecnologicos WHERE IdEquipo = @IdEquipo
		SELECT @O_Mensaje = 'SE HA ELIMINADO UN REGISTRO DE LA TABLA EQUIPOSTECNOLOGICOS.'
	END
	--fin de delete.
	END TRY
	BEGIN CATCH
		-- Si ocurrio un error lo notificamos.
		SELECT @O_Mensaje = 'ERROR: ' + ERROR_MESSAGE() + 'EN LINEA: ' + CONVERT(VARCHAR, ERROR_LINE() )
	END CATCH
END
GO
-- Fin procedimiento almacenado EquiposTecnologicos.

--Procedimiento almacenado de Areas
CREATE PROCEDURE SpAreas
(
	@idArea INT,
	@Nombre VARCHAR(64),
	@Funcion VARCHAR(140),
	@Observacion VARCHAR(100),
	-- Variable de trabajo Work.
	@W_Operacion VARCHAR(10),
	-- Variable de salida OUTPUT.
	@O_Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
	BEGIN TRY
	--Validar tipo de operación "I" es INSERT
	IF (@W_Operacion = 'I')
	BEGIN
		INSERT INTO Areas
		(
			Nombre,
			Funcion,
			Observacion
		)
		VALUES
		(
			@Nombre,
			@Funcion,
			@Observacion
		)
		SELECT @O_Mensaje = 'SE HA INSERTADO CORRECTAMENTE EN LA TABLA AREAS.'
	END
	--fin de isertado.
	--Validar tipo de operación "U" es UPDATE
	IF (@W_Operacion = 'U')
	BEGIN
		UPDATE Areas
			SET
				Nombre = @Nombre,
				Funcion = @Funcion,
				Observacion = @Observacion
				WHERE IdArea = @idArea
			SELECT @O_Mensaje = 'SE HA ACTUALIZADO CORRECTAMENTE UN REGISTRO DE LA TABLA AREAS.'
	END
	--fin de actualizado.
	--Validar tipo de operación "S" es SELECT.
	IF (@W_Operacion = 'S')
	BEGIN
		SELECT Nombre, Funcion, Observacion
			FROM Areas
		SELECT @O_Mensaje = 'SE REALIZO UN SELECT CORRECTAMENTE A LA TABLA AREAS.'
	END
	--fin de select.
	--Validar tipo de operación "D" es DELETE.
	IF (@W_Operacion = 'D')
	BEGIN
		DELETE Areas WHERE IdArea = @idArea
		SELECT @O_Mensaje = 'SE HA ELIMINADO UN REGISTRO DE LA TABLA AREAS.'
	END
	--fin de delete.
	END TRY
	BEGIN CATCH
		-- Si ocurrio un error lo notificamos.
		SELECT @O_Mensaje = 'ERROR: ' + ERROR_MESSAGE() + 'EN LINEA: ' + CONVERT(VARCHAR, ERROR_LINE() )
	END CATCH
END
GO
-- Fin procedimiento almacenado Areas.

--Procedimiento almacenado de Empleados
CREATE PROCEDURE SpEmpleados
(
	@CodEmpleado INT,
	@Nombre VARCHAR(64),
	@Apellido VARCHAR(64),
	@Identificacion VARCHAR(20),
	@Cargo VARCHAR(20),
	@IdArea INT,
	@Observacion VARCHAR(100),
	-- Variable de trabajo Work.
	@W_Operacion VARCHAR(10),
	-- Variable de salida OUTPUT.
	@O_Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
	BEGIN TRY
	--Validar tipo de operación "I" es INSERT
	IF (@W_Operacion = 'I')
	BEGIN
		INSERT INTO Empleados
		(
			Nombre,
			Apellido,
			Identificacion,
			Cargo,
			IdArea,
			Observacion
		)
		VALUES
		(
			@Nombre,
			@Apellido,
			@Identificacion,
			@Cargo,
			@IdArea,
			@Observacion
		)
		SELECT @O_Mensaje = 'SE HA INSERTADO CORRECTAMENTE EN LA TABLA EMPLEADOS.'
	END
	--fin de isertado.
	--Validar tipo de operación "U" es UPDATE
	IF (@W_Operacion = 'U')
	BEGIN
		UPDATE Empleados
			SET
				Nombre = @Nombre,
				Apellido = @Apellido,
				Identificacion = @Identificacion,
				Cargo = @Cargo,
				IdArea = @IdArea,
				Observacion = @Observacion
				WHERE CodEmpleado = @CodEmpleado
			SELECT @O_Mensaje = 'SE HA ACTUALIZADO CORRECTAMENTE UN REGISTRO DE LA TABLA EMPLEADOS.'
	END
	--fin de actualizado.
	--Validar tipo de operación "S" es SELECT.
	IF (@W_Operacion = 'S')
	BEGIN
		SELECT Nombre, Apellido, Identificacion, Cargo, IdArea, Observacion
			FROM Empleados
		SELECT @O_Mensaje = 'SE REALIZO UN SELECT CORRECTAMENTE A LA TABLA EMPLEADOS.'
	END
	--fin de select.
	--Validar tipo de operación "D" es DELETE.
	IF (@W_Operacion = 'D')
	BEGIN
		DELETE Empleados WHERE CodEmpleado = @CodEmpleado
		SELECT @O_Mensaje = 'SE HA ELIMINADO UN REGISTRO DE LA TABLA EMPLEADOS.'
	END
	--fin de delete.
	END TRY
	BEGIN CATCH
		-- Si ocurrio un error lo notificamos.
		SELECT @O_Mensaje = 'ERROR: ' + ERROR_MESSAGE() + 'EN LINEA: ' + CONVERT(VARCHAR, ERROR_LINE() )
	END CATCH
END
GO
-- Fin procedimiento almacenado Empleados.

--Procedimiento almacenado de Asistencias
CREATE PROCEDURE SpAsistencias
(
	@IdAsistencia INT,
	@CodEmpleado INT,
	-- Variable de trabajo Work.
	@W_Operacion VARCHAR(10),
	-- Variable de salida OUTPUT.
	@O_Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
	BEGIN TRY
	--Validar tipo de operación "I" es INSERT
	IF (@W_Operacion = 'I')
	BEGIN
		INSERT INTO Asistencias
		(
			CodEmpleado
		)
		VALUES
		(
			@CodEmpleado
		)
		SELECT @O_Mensaje = 'SE HA INSERTADO CORRECTAMENTE EN LA TABLA ASISTENCIAS.'
	END
	--fin de isertado.
	--Validar tipo de operación "U" es UPDATE
	IF (@W_Operacion = 'U')
	BEGIN
		UPDATE Asistencias
			SET
				CodEmpleado = @CodEmpleado
				WHERE IdAsistencia = @IdAsistencia
			SELECT @O_Mensaje = 'SE HA ACTUALIZADO CORRECTAMENTE UN REGISTRO DE LA TABLA ASISTENCIAS.'
	END
	--fin de actualizado.
	--Validar tipo de operación "S" es SELECT.
	IF (@W_Operacion = 'S')
	BEGIN
		SELECT IdAsistencia, CodEmpleado
			FROM Asistencias
		SELECT @O_Mensaje = 'SE REALIZO UN SELECT CORRECTAMENTE A LA TABLA ASISTENCIAS.'
	END
	--fin de select.
	--Validar tipo de operación "D" es DELETE.
	IF (@W_Operacion = 'D')
	BEGIN
		DELETE Asistencias WHERE IdAsistencia = @IdAsistencia
		SELECT @O_Mensaje = 'SE HA ELIMINADO UN REGISTRO DE LA TABLA ASISTENCIAS.'
	END
	--fin de delete.
	END TRY
	BEGIN CATCH
		-- Si ocurrio un error lo notificamos.
		SELECT @O_Mensaje = 'ERROR: ' + ERROR_MESSAGE() + 'EN LINEA: ' + CONVERT(VARCHAR, ERROR_LINE() )
	END CATCH
END
GO
-- Fin procedimiento almacenado Asistencias.

--Procedimiento almacenado de DetalleDeAsistencias
CREATE PROCEDURE SpDetalleDeAsistencias
(
	@IdDetalle INT,
	@IdAsistencia INT,
	@FechaHoraEntrada DATETIME,
	@FechaHoraSalida DATETIME,
	@Obervacion VARCHAR(100),
	-- Variable de trabajo Work.
	@W_Operacion VARCHAR(10),
	-- Variable de salida OUTPUT.
	@O_Mensaje VARCHAR(255) OUTPUT
)
AS
BEGIN
	BEGIN TRY
	--Validar tipo de operación "I" es INSERT
	IF (@W_Operacion = 'I')
	BEGIN
		INSERT INTO DetalleDeAsistencias
		(
			IdAsistencia,
			FechaHoraEntrada,
			FechaHoraSalida,
			Observacion
		)
		VALUES
		(
			@IdAsistencia,
			@FechaHoraEntrada,
			@FechaHoraSalida,
			@Obervacion
		)
		SELECT @O_Mensaje = 'SE HA INSERTADO CORRECTAMENTE EN LA TABLA DETALLEDEASISTENCIAS.'
	END
	--fin de isertado.
	--Validar tipo de operación "U" es UPDATE
	IF (@W_Operacion = 'U')
	BEGIN
		UPDATE DetalleDeAsistencias
			SET
				IdAsistencia = @IdAsistencia,
				FechaHoraEntrada = @FechaHoraEntrada,
				FechaHoraSalida = @FechaHoraSalida,
				Observacion = @Obervacion
				WHERE IdDetalle = @IdDetalle
			SELECT @O_Mensaje = 'SE HA ACTUALIZADO CORRECTAMENTE UN REGISTRO DE LA TABLA DETALLEDEASISTENCIAS.'
	END
	--fin de actualizado.
	--Validar tipo de operación "S" es SELECT.
	IF (@W_Operacion = 'S')
	BEGIN
		SELECT IdDetalle, IdAsistencia, FechaHoraEntrada, FechaHoraSalida, Observacion
			FROM DetalleDeAsistencias
		SELECT @O_Mensaje = 'SE REALIZO UN SELECT CORRECTAMENTE A LA TABLA DETALLEDEASISTENCIAS.'
	END
	--fin de select.
	--Validar tipo de operación "D" es DELETE.
	IF (@W_Operacion = 'D')
	BEGIN
		DELETE DetalleDeAsistencias WHERE IdDetalle = @IdDetalle
		SELECT @O_Mensaje = 'SE HA ELIMINADO UN REGISTRO DE LA TABLA DETALLEDEASISTENCIAS.'
	END
	--fin de delete.
	END TRY
	BEGIN CATCH
		-- Si ocurrio un error lo notificamos.
		SELECT @O_Mensaje = 'ERROR: ' + ERROR_MESSAGE() + 'EN LINEA: ' + CONVERT(VARCHAR, ERROR_LINE() )
	END CATCH
END
GO
-- Fin procedimiento almacenado DetalleDeAsistencias.

/*
	Creación de disparadores de eventos.
*/
--	Creando triggers para log de la tabla Usuarios.
--	Trigger insert
CREATE TRIGGER tr_UsuariosInsertar ON Usuarios FOR INSERT
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'Usuarios'
DECLARE @Accion VARCHAR(6) = 'INSERT'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Nombre + ' ' + Apellido + ' Cargo: ' + Cargo + ' RolDeAcceso: ' + RolDeAcceso + ' UserName: ' + UserName FROM inserted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Se le ha otorgado acceso al sistema a: ' + @Descripcion, USER, GETDATE())
GO
--	Trigger Update
CREATE TRIGGER tr_UsuariosUpdate ON Usuarios FOR UPDATE
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'Usuarios'
DECLARE @Accion VARCHAR(6) = 'UPDATE'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Nombre + ' ' + Apellido + ' Cargo: ' + Cargo + ' RolDeAcceso: ' + RolDeAcceso + ' UserName: ' + UserName FROM deleted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Se realizo un cambio en el usuario: ' + @Descripcion, USER, GETDATE())
GO
--	Trigger Delete
CREATE TRIGGER tr_UsuariosDelete ON Usuarios FOR DELETE
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'Usuarios'
DECLARE @Accion VARCHAR(6) = 'DELETE'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Nombre + ' ' + Apellido + ' Cargo: ' + Cargo + ' RolDeAcceso: ' + RolDeAcceso + ' UserName: ' + UserName FROM deleted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Fue eliminado el usuario: ' + @Descripcion, USER, GETDATE())
GO

--	Creando triggers para log de la tabla EquiposTecnologicos.
--	Trigger insert
CREATE TRIGGER tr_EquiposTecnologicosInsertar ON EquiposTecnologicos FOR INSERT
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'EquiposTecnologicos'
DECLARE @Accion VARCHAR(6) = 'INSERT'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Descripcion + ' Modelo: ' + Modelo + ' Estado: ' + Estado FROM inserted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Se agrego el equipo: ' + @Descripcion, USER, GETDATE())
GO
--	Trigger Update
CREATE TRIGGER tr_EquiposTecnologicosUpdate ON EquiposTecnologicos FOR UPDATE
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'EquiposTecnologicos'
DECLARE @Accion VARCHAR(6) = 'UPDATE'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Descripcion + ' Modelo: ' + Modelo + ' Estado: ' + Estado FROM deleted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Se realizo un cambio en el equipo: ' + @Descripcion, USER, GETDATE())
GO
--	Trigger Delete
CREATE TRIGGER tr_EquiposTecnologicosDelete ON EquiposTecnologicos FOR DELETE
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'EquiposTecnologicos'
DECLARE @Accion VARCHAR(6) = 'DELETE'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Descripcion + ' Modelo: ' + Modelo + ' Estado: ' + Estado FROM deleted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Fue eliminado el equipo: ' + @Descripcion, USER, GETDATE())
GO

--	Creando triggers para log de la tabla Empleados.
--	Trigger insert
CREATE TRIGGER tr_EmpleadosInsertar ON Empleados FOR INSERT
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'Empleados'
DECLARE @Accion VARCHAR(6) = 'INSERT'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Nombre + ' ' + Apellido + ' Identificación: ' + Identificacion + ' Cargo: ' + Cargo FROM inserted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Se agrego el empleado: ' + @Descripcion, USER, GETDATE())
GO
--	Trigger Update
CREATE TRIGGER tr_EmpleadosUpdate ON Empleados FOR UPDATE
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'Empleados'
DECLARE @Accion VARCHAR(6) = 'UPDATE'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Nombre + ' ' + Apellido + ' Identificación: ' + Identificacion + ' Cargo: ' + Cargo FROM deleted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Se realizo un cambio en el empleado: ' + @Descripcion, USER, GETDATE())
GO
--	Trigger Delete
CREATE TRIGGER tr_EmpleadosDelete ON Empleados FOR DELETE
AS
SET NOCOUNT ON ---- Desactivamos registro por fila
DECLARE @Tabla VARCHAR(255) = 'Empleados'
DECLARE @Accion VARCHAR(6) = 'DELETE'
DECLARE @Descripcion VARCHAR(255)
SELECT @Descripcion = Nombre + ' ' + Apellido + ' Identificación: ' + Identificacion + ' Cargo: ' + Cargo FROM deleted 
INSERT INTO bdsoft..LogTablas VALUES(@Tabla, @Accion,'Fue eliminado el empleado: ' + @Descripcion, USER, GETDATE())
GO

/*
	Creación de consultas.
*/
-- Mostrar todas las áreas y organizarlas en orden a - z.
SELECT IdArea, Nombre, Funcion, Observacion FROM Areas ORDER BY Nombre
GO
-- Mostrar lista de empleados y organizarlas por áreas en orden a - z
SELECT t1.CodEmpleado, t1.Nombre, t1.Apellido, t1.Identificacion, t1.Cargo, t2.Nombre as Area, t1.Observacion
FROM Empleados as t1
INNER JOIN Areas as t2
ON t1.IdArea = t2.IdArea
ORDER BY t2.Nombre
GO
-- Mostrar lista de todos los equipos que estan registrados.
SELECT t1.IdEquipo, t1.Descripcion, t1.Modelo, t1.Marca, t1.NumeroDeSerie, t1.CodigoInterno, t1.Estado, t2.Nombre + ' ' + t2.Apellido AS Empleado, t1.ValorMonetario, t3.UserName AS Usuario, t1.Observacion 
FROM EquiposTecnologicos AS t1
INNER JOIN Empleados AS t2
ON t1.CodEmpleado = t2.CodEmpleado
INNER JOIN Usuarios AS t3
ON t1.CreadoPorUserName = t3.IdUsuario
ORDER BY t1.Descripcion
GO
-- Mostrar lista de todos los equipos que estan registrados en un area específico.
DECLARE @area int = 1
SELECT t1.IdEquipo, t4.Nombre AS Area ,t1.Descripcion, t1.Modelo, t1.Marca, t1.NumeroDeSerie, t1.CodigoInterno, t1.Estado, t2.Nombre + ' ' + t2.Apellido AS Empleado, t1.ValorMonetario, t3.UserName AS Usuario, t1.Observacion 
FROM EquiposTecnologicos AS t1
INNER JOIN Empleados AS t2
ON t1.CodEmpleado = t2.CodEmpleado
INNER JOIN Usuarios AS t3
ON t1.CreadoPorUserName = t3.IdUsuario
INNER JOIN Areas AS T4
ON t2.IdArea = t4.IdArea
WHERE t4.IdArea = @area
ORDER BY t1.Descripcion
GO
-- Mostrar lista de todos los equipos que estan registrados ordenarlos por valor monetario de mayor a menor.
SELECT t1.IdEquipo, t1.Descripcion, t1.Modelo, t1.Marca, t1.NumeroDeSerie, t1.CodigoInterno, t1.Estado, t2.Nombre + ' ' + t2.Apellido AS Empleado, t1.ValorMonetario, t3.UserName AS Usuario, t1.Observacion 
FROM EquiposTecnologicos AS t1
INNER JOIN Empleados AS t2
ON t1.CodEmpleado = t2.CodEmpleado
INNER JOIN Usuarios AS t3
ON t1.CreadoPorUserName = t3.IdUsuario
ORDER BY t1.ValorMonetario DESC
GO
-- Mostrar lista general de entrada y salida del personal, filtrar por rango de fechas.
DECLARE @FechaInicial Datetime = '2021/06/28'
DECLARE @FechaFinal Datetime = '2021/06/29'
SELECT t1.IdAsistencia, t3.Nombre + ' ' + t3.Apellido as Empleado ,t2.FechaHoraEntrada, t2.FechaHoraSalida, t2.Observacion
FROM Asistencias AS t1
INNER JOIN DetalleDeAsistencias AS t2
ON t1.IdAsistencia = t2.IdAsistencia
INNER JOIN Empleados AS t3
ON T1.CodEmpleado = t3.CodEmpleado
WHERE t2.FechaHoraEntrada BETWEEN @FechaInicial AND @FechaFinal
GO
--Mostrar lista general de entrada y salida del personal, filtrar por rango de fechas y areas.
DECLARE @FechaInicialDos Datetime = '2021/06/28'
DECLARE @FechaFinalDos Datetime = '2021/07/01'
DECLARE @AreaDos Int = 1;
SELECT t1.IdAsistencia, t4.Nombre as Area ,t3.Nombre + ' ' + t3.Apellido as Empleado ,t2.FechaHoraEntrada, t2.FechaHoraSalida, t2.Observacion
FROM Asistencias AS t1
INNER JOIN DetalleDeAsistencias AS t2
ON t1.IdAsistencia = t2.IdAsistencia
INNER JOIN Empleados AS t3
ON T1.CodEmpleado = t3.CodEmpleado
INNER JOIN Areas AS t4
ON t3.IdArea = t4.IdArea
WHERE t2.FechaHoraEntrada BETWEEN @FechaInicialDos AND @FechaFinalDos AND t3.IdArea = @AreaDos
GO