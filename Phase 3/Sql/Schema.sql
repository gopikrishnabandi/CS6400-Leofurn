-- Scripts are as per MS SQl
use [master]
EXEC sp_configure 'CONTAINED DATABASE AUTHENTICATION', 1
GO
RECONFIGURE
GO

-- uncomment the below line if getting any error to drop database
 alter database [cs6400_Sp21_team052] set single_user with rollback immediate

go
drop database IF EXISTS [cs6400_Sp21_team052] ;




CREATE DATABASE cs6400_Sp21_team052;

USE [master]
GO
ALTER DATABASE [cs6400_Sp21_team052] SET CONTAINMENT = PARTIAL
GO

-- EXEC sp_configure 'CONTAINED DATABASE AUTHENTICATION'


/* Make sure User is created in the appropriate database. */
USE cs6400_Sp21_team052
GO
IF NOT EXISTS(SELECT principal_id FROM sys.server_principals WHERE name = 'gbandi3') BEGIN
    /* Syntax for SQL server login.  See BOL for domain logins, etc. */
    CREATE LOGIN gbandi3 
    WITH PASSWORD = 'gbandi3'
END

/* Create the user for the specified login. */
IF NOT EXISTS(SELECT principal_id FROM sys.database_principals WHERE name = 'gbandi3') BEGIN
    CREATE USER gbandi3 FOR LOGIN gbandi3
END


USE cs6400_Sp21_team052
GO
IF NOT EXISTS(SELECT principal_id FROM sys.server_principals WHERE name = 'jswiderski') BEGIN
    /* Syntax for SQL server login.  See BOL for domain logins, etc. */
    CREATE LOGIN jswiderski 
    WITH PASSWORD = 'jswiderski'
END

/* Create the user for the specified login. */
IF NOT EXISTS(SELECT principal_id FROM sys.database_principals WHERE name = 'jswiderski') BEGIN
    CREATE USER jswiderski FOR LOGIN jswiderski
END


USE cs6400_Sp21_team052
GO
IF NOT EXISTS(SELECT principal_id FROM sys.server_principals WHERE name = 'malbertson3') BEGIN
    /* Syntax for SQL server login.  See BOL for domain logins, etc. */
    CREATE LOGIN malbertson3 
    WITH PASSWORD = 'malbertson3'
END

/* Create the user for the specified login. */
IF NOT EXISTS(SELECT principal_id FROM sys.database_principals WHERE name = 'malbertson3') BEGIN
    CREATE USER malbertson3 FOR LOGIN malbertson3
END

USE cs6400_Sp21_team052
GO
IF NOT EXISTS(SELECT principal_id FROM sys.server_principals WHERE name = 'tomordonez') BEGIN
    /* Syntax for SQL server login.  See BOL for domain logins, etc. */
    CREATE LOGIN tomordonez 
    WITH PASSWORD = 'tomordonez'
END

/* Create the user for the specified login. */
IF NOT EXISTS(SELECT principal_id FROM sys.database_principals WHERE name = 'tomordonez') BEGIN
    CREATE USER tomordonez FOR LOGIN tomordonez
END

USE cs6400_Sp21_team052
GO
IF NOT EXISTS(SELECT principal_id FROM sys.server_principals WHERE name = 'mzhang486') BEGIN
    /* Syntax for SQL server login.  See BOL for domain logins, etc. */
    CREATE LOGIN mzhang486 
    WITH PASSWORD = 'mzhang486'
END

/* Create the user for the specified login. */
IF NOT EXISTS(SELECT principal_id FROM sys.database_principals WHERE name = 'mzhang486') BEGIN
    CREATE USER mzhang486 FOR LOGIN mzhang486
END



use cs6400_Sp21_team052
go
exec sp_addrolemember 'db_owner', 'gbandi3';
exec sp_addrolemember 'db_owner', 'jswiderski';
exec sp_addrolemember 'db_owner', 'malbertson3';
exec sp_addrolemember 'db_owner', 'tomordonez';
exec sp_addrolemember 'db_owner', 'mzhang486';
go




-- Tables
CREATE TABLE Store(Store_Number varchar(50) NOT NULL,
Phone_Number varchar(20) NOT NULL,
Street_Address varchar(100) NOT NULL,
City_Name varchar(300) NOT NULL,
State_Name VARCHAR(150) NOT NULL,
Restaurant_Flag bit NOT NULL,
Snackbar_Flag bit NOT NULL,
Childcare_Flag bit NOT NULL,
Limit_Mins int DEFAULT NULL,
primary key (Store_Number)
);

 CREATE TABLE City(City_Name varchar(300) NOT NULL,
State_Name VARCHAR(150) NOT NULL,
[Population] int NOT NULL,
primary key (City_Name,State_Name)
);

CREATE TABLE [State](State_Name VARCHAR(150) NOT NULL,
primary key (State_Name)
);

CREATE TABLE Limit(Limit_Mins int NOT NULL,
primary key (Limit_Mins)
);

CREATE TABLE Product(PID varchar(20) NOT NULL,
Product_Name varchar(50) NOT NULL,
Retail_Price float NOT NULL,
primary key (PID)
);

CREATE TABLE Category(
PID varchar(20) ,
Category_Name varchar(50) NOT NULL,
unique (Category_Name,PID)
);

create TABLE Discount(
PID varchar(20) NOT NULL,
Discount_Date date NOT NULl,
Discount_Price float NOT NULL,
primary key (PID,Discount_Date)
);


CREATE TABLE [Date](
[Date] date NOT NULl,
primary key ([Date])
);

CREATE TABLE Holiday(
[Date] date NOT NULl,
Holiday_Name varchar(100) NOT NULL,
primary key (Holiday_Name,[Date])
);

CREATE TABLE Campaign(
[Date] date NOT NULl,
[Description] varchar(100) NOT NULL,
primary key ([Date],[Description])
);

CREATE TABLE Sale(
PID varchar(20) NOT NULL,
Store_Number varchar(50) NOT NULL,
[Date] date NOT NULl,
Quantity int NOT NULL,
primary key (PID,Store_Number,[Date])
);

ALTER TABLE Store ADD CONSTRAINT fk_Store_CityName_City_CityName FOREIGN KEY (City_Name, State_name) REFERENCES City(City_Name, State_Name) ON DELETE CASCADE ON UPDATE CASCADE,
--CONSTRAINT fk_Store_StateName_State_StateName FOREIGN KEY (State_Name) REFERENCES State(State_Name) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Store_Limit_LimitMins_LimitMins FOREIGN KEY (Limit_Mins) REFERENCES Limit(Limit_mins) ON DELETE CASCADE ON UPDATE CASCADE;

alter table City add CONSTRAINT fk_City_StateName_State_StateName FOREIGN KEY (State_Name) REFERENCES State(State_Name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Category ADD CONSTRAINT fk_Category_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Discount ADD CONSTRAINT fk_Discount_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Discount_Date_Date_date FOREIGN KEY (Discount_Date) REFERENCES [Date]([Date]) ;

ALTER TABLE Holiday ADD CONSTRAINT fk_Holiday_Date_Date_Date FOREIGN KEY ([Date]) REFERENCES [Date]([Date]);

ALTER TABLE Campaign ADD CONSTRAINT fk_Campaign_Date_Date_Date FOREIGN KEY ([Date]) REFERENCES [Date]([Date]);

ALTER TABLE Sale ADD CONSTRAINT fk_Sale_Date_Date_Date FOREIGN KEY ([Date]) REFERENCES [Date]([Date]),
CONSTRAINT fk_Sale_StoreNumber_Store_StoreNumber FOREIGN KEY (Store_Number) REFERENCES Store(Store_Number) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Sale_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE;