/*
	Creación de disparadores de eventos.
*/
USE bdsoft
GO

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
