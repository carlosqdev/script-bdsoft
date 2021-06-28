/*
	****** Encabezado ********
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