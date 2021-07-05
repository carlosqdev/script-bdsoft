/*
	Creación de procedimientos almacenados.
*/

USE bdsoft
GO

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