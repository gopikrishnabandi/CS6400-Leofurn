-- Scripts are as per MY SQl
CREATE USER IF NOT EXISTS 'gbandi3'@'localhost' IDENTIFIED BY 'gbandi3';
CREATE USER IF NOT EXISTS 'jswiderski'@'localhost' IDENTIFIED BY 'jswiderski';
CREATE USER IF NOT EXISTS 'malbertson3'@'localhost' IDENTIFIED BY 'malbertson3';
CREATE USER IF NOT EXISTS 'tomordonez'@'localhost' IDENTIFIED BY 'tomordonez';
CREATE USER IF NOT EXISTS 'mzhang486'@'localhost' IDENTIFIED BY 'mzhang486';
DROP DATABASE IF EXISTS cs6400_Sp21_team052; 
SET default_storage_engine=InnoDB;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS cs6400_Sp21_team052
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;
USE cs6400_Sp21_team052;
GRANT ALL PRIVILEGES ON cs6400_Sp21_team052.* TO 'gbandi3'@'localhost';
GRANT ALL PRIVILEGES ON cs6400_Sp21_team052.* TO 'jswiderski'@'localhost';
GRANT ALL PRIVILEGES ON cs6400_Sp21_team052.* TO 'malbertson3'@'localhost';
GRANT ALL PRIVILEGES ON cs6400_Sp21_team052.* TO 'tomordonez'@'localhost';
GRANT ALL PRIVILEGES ON cs6400_Sp21_team052.* TO 'mzhang486'@'localhost';
FLUSH PRIVILEGES;

-- Tables
CREATE TABLE Store(Store_Number varchar(50) NOT NULL,
Phone_Number varchar(20) NOT NULL,
Childcare_Flag boolean NOT NULL,
Restaurant_Flag boolean NOT NULL,
Snackbar_Flag boolean NOT NULL,
Street_Address varchar(100) NOT NULL,
City_Name varchar(30) NOT NULL,
State_Name VARCHAR(15) NOT NULL,
Limit_Mins int(3) DEFAULT NULL,
primary key (Store_Number)
);

 CREATE TABLE City(City_Name varchar(30) NOT NULL,
State_Name VARCHAR(15) NOT NULL,
Population int(16) NOT NULL,
primary key (City_Name,State_Name)
);

CREATE TABLE State(State_Name VARCHAR(15) NOT NULL,
primary key (State_Name)
);

CREATE TABLE `Limit`(Limit_Mins int(3) NOT NULL,
primary key (Limit_Mins)
);

CREATE TABLE Product(PID varchar(20) NOT NULL,
Product_Name varchar(50) NOT NULL,
Retail_Price float(10,2) NOT NULL,
primary key (PID)
);

CREATE TABLE Category(
Category_Name varchar(50) NOT NULL,
PID varchar(20) NOT NULL,
primary key (PID,Category_Name)
);

CREATE TABLE Discount(
Discount_Price float(10,2) NOT NULL,
PID varchar(20) NOT NULL,
Discount_Date date NOT NULl,
primary key (PID,Discount_Price,Discount_Date)
);

CREATE TABLE `Date`(
`Date` date NOT NULl,
primary key (`Date`)
);

CREATE TABLE Holiday(
Holiday_Name varchar(100) NOT NULL,
`Date` date NOT NULl,
primary key (Holiday_Name,`Date`)
);

CREATE TABLE Campaign(
`Date` date NOT NULl,
`Description` varchar(100) NOT NULL,
primary key (`Date`,`Description`)
);

CREATE TABLE Sale(
PID varchar(20) NOT NULL,
Store_Number varchar(50) NOT NULL,
`Date` date NOT NULl,
Quantity int(10) NOT NULL,
primary key (PID,Store_Number,`Date`)
);

ALTER TABLE Store ADD CONSTRAINT fk_Store_CityName_City_CityName FOREIGN KEY (City_Name) REFERENCES City(City_Name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_Store_StateName_State_StateName FOREIGN KEY (State_Name) REFERENCES State(State_Name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_Store_Limit_LimitMins_LimitMins FOREIGN KEY (Limit_Mins) REFERENCES `Limit`(Limit_mins) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE City ADD CONSTRAINT fk_City_StateName_State_StateName FOREIGN KEY (State_Name) REFERENCES State(State_Name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Category ADD CONSTRAINT fk_Category_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Discount ADD CONSTRAINT fk_Discount_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Holiday ADD CONSTRAINT fk_Holiday_Date_Date_Date FOREIGN KEY (`Date`) REFERENCES `Date`(`Date`);

ALTER TABLE Campaign ADD CONSTRAINT fk_Campaign_Date_Date_Date FOREIGN KEY (`Date`) REFERENCES `Date`(`Date`);

ALTER TABLE Sale ADD CONSTRAINT fk_Sale_Date_Date_Date FOREIGN KEY (`Date`) REFERENCES `Date`(`Date`),
ADD CONSTRAINT fk_Sale_StoreNumber_Store_StoreNumber FOREIGN KEY (Store_Number) REFERENCES Store(Store_Number) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_Sale_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE;