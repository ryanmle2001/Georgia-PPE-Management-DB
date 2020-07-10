-- CS4400: Introduction to Database Systems
-- Summer 2020
-- Phase II Create Table and Insert Statements Template

-- Team 15
-- Rajit Khanna (rkhanna38)
-- Ryan Le (rm331)
-- Saatvik Korisepati (skorisepati3)
-- Andrew Zhao (azhao63)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

DROP DATABASE IF EXISTS ppe_management;
CREATE DATABASE IF NOT EXISTS ppe_management;
USE ppe_management;

-- CREATE TABLE STATEMENTS BELOW

DROP TABLE IF EXISTS product;
CREATE TABLE product (
	p_id char(5) not null,
	name varchar(100) not null, 
	type varchar(100) not null, 
	color varchar(100) not null, 
	primary key (p_id)
) engine = InnoDB;

DROP TABLE IF EXISTS business;
CREATE TABLE business (
  business_name varchar(100) NOT NULL,
  street varchar(100) NOT NULL,
  city varchar(100) NOT NULL,
  state varchar(100) NOT NULL,
  zip decimal(5, 0) NOT NULL,
  PRIMARY KEY (business_name),
  UNIQUE KEY (street, city, zip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS hospital;
CREATE TABLE hospital (
  hospital_name varchar(100) NOT NULL PRIMARY KEY,
  max_doctors decimal(2,0) NOT NULL,
  budget decimal(20,2) NOT NULL,
  CONSTRAINT hospital_ibfk_1 FOREIGN KEY (hospital_name) REFERENCES business (business_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS manufacturer;
CREATE TABLE manufacturer (
  manufacturer_name varchar(100) NOT NULL PRIMARY KEY,
  catalog_capacity decimal(5,0) NOT NULL,
  CONSTRAINT manufacturer_ibfk_1 FOREIGN KEY (manufacturer_name) REFERENCES business (business_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS user_account;
CREATE TABLE user_account (
  username varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  passphrase varchar(100) NOT NULL,
  fname varchar(100) NOT NULL,
  lname varchar(100) NOT NULL,
  PRIMARY KEY (username),
  UNIQUE KEY (email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS doctor;
CREATE TABLE doctor (
  username varchar(100) NOT NULL,
  hospital_name varchar(100) NOT NULL,
  manager varchar(100) NOT NULL,
  PRIMARY KEY (username),
  CONSTRAINT doctor_ibfk_1 FOREIGN KEY (username) REFERENCES user_account (username),
  CONSTRAINT doctor_ibfk_2 FOREIGN KEY (hospital_name) REFERENCES hospital (hospital_name),
  CONSTRAINT doctor_ibfk_3 FOREIGN KEY (manager) REFERENCES doctor (username)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS administrator;
CREATE TABLE administrator (
  username varchar(100) NOT NULL,
  business_managed varchar(100) NOT NULL,
  PRIMARY KEY (username),
  CONSTRAINT administrator_ibfk_1 FOREIGN KEY (username) REFERENCES user_account (username),
  CONSTRAINT administrator_ibfk_2 FOREIGN KEY (business_managed) REFERENCES business (business_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  t_id decimal(4,0) NOT NULL,
  hospital char(20) NOT NULL,
  tdate date NOT NULL,
  PRIMARY KEY (T_id),
  KEY hospital (hospital),
  CONSTRAINT transaction_ibfk_1 FOREIGN KEY (hospital) REFERENCES hospital (hospital_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS usage_log;
CREATE TABLE usage_log (
  ul_id varchar(100) NOT NULL,
  time_stamp timestamp NOT NULL,
  doctor varchar(100) NOT NULL,
  PRIMARY KEY (ul_id),
  CONSTRAINT usage_log_ibfk_1 FOREIGN KEY (doctor) REFERENCES doctor (username)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
	business_name varchar(100) not null,
	street varchar(100) not null, 
	city varchar(100) not null, 
	state varchar(100) not null, 
	zip varchar(100) not null,
	primary key (business_name),
	constraint inventory_ibfk_1 foreign key (business_name) references business (business_name)
) engine = InnoDB;

DROP TABLE IF EXISTS catalog_item;
CREATE TABLE catalog_item (
  p_id char(5) NOT NULL,
  business_name varchar(100) NOT NULL,
  price decimal(10,2) NOT NULL,
  PRIMARY KEY (p_id, business_name),
  CONSTRAINT catalog_item_ibfk_1 FOREIGN KEY (p_id) REFERENCES product (p_id),
  CONSTRAINT catalog_item_ibfk_2 FOREIGN KEY (business_name) REFERENCES business (business_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS has_item;
CREATE TABLE has_item (
	business_name varchar(100) not null,
	p_id char(5) not null, 
	item_count varchar(100) not null, 
	primary key (business_name,p_id),
	constraint has_item_ibfk_1 foreign key (business_name) references business (business_name),
	constraint has_item_ibfk_2 foreign key (p_id) references catalog_item (p_id)
) engine = InnoDB;

DROP TABLE IF EXISTS contains_item;
CREATE TABLE contains_item (
  p_id char(5) NOT NULL,
  t_id decimal(4,0) NOT NULL,
  item_count decimal(10,2) NOT NULL,
  business_name varchar(100) NOT NULL,
  PRIMARY KEY (p_id, t_id),
  CONSTRAINT contains_item_ibfk_1 FOREIGN KEY (p_id) REFERENCES product (p_id),
  CONSTRAINT contains_item_ibfk_2 FOREIGN KEY (business_name) REFERENCES business (business_name),
  CONSTRAINT contains_item_ibfk_3 FOREIGN KEY (t_id) REFERENCES transactions (t_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS used_by;
CREATE TABLE used_by (
	p_id char(5) not null,
	ul_id char(5) not null, 
	item_count varchar(100) not null, 
	primary key (p_id, ul_id),
	constraint used_by_ibfk_1 foreign key (ul_id) references usage_log (ul_id),
	constraint used_by_ibfk_2 foreign key (p_id) references catalog_item (p_id)
) ENGINE=InnoDB;

-- INSERT STATEMENTS BELOW

INSERT INTO transactions VALUES (0001,'Children\'s Healthcare of Atlanta','03-10-2020'),(0002,'Children\'s Healthcare of Atlanta','03-10-2020'),(0003,'Emory Midtown','03-10-2020'),(0004,'Grady Hospital','03-10-2020'),(0005,'Northside Hospital','03-10-2020'),(0006,'Children\'s Healthcare of Atlanta','03-10-2020'),(0007,'Piedmont Hospital','03-10-2020'),(0008,'Northside Hospital','05-01-2020'),(0009,'Children\'s Healthcare of Atlanta','05-01-2020'),(0010,'Northside Hospital','05-01-2020'),(0011,'Northside Hospital','05-01-2020'),(0012,'Emory Midtown','05-25-2020'),(0013,'Children\'s Healthcare of Atlanta','05-25-2020'),(0014,'Emory Midtown','05-25-2020'),(0015,'Emory Midtown','05-25-2020'),(0016,'Northside Hospital','05-25-2020'),(0017,'Grady Hospital','06-03-2020'),(0018,'Grady Hospital','06-03-2020'),(0019,'Grady Hospital','06-03-2020'),(0020,'Piedmont Hospital','06-03-2020'),(0021,'Piedmont Hospital','06-04-2020');
INSERT INTO contains_item VALUES ('WHMSK',0001,500,'PPE Empire'),('BLMSK',0001,500,'PPE Empire'),('BLSHC',0002,300,'Buy Personal Protective Equipment, Inc'),('BLMSK',0003,500,'Healthcare Supplies of Atlanta'),('ORGOG',0004,150,'Healthcare Supplies of Atlanta'),('RDMSK',0004,150,'Healthcare Supplies of Atlanta'),('CLSHD',0004,200,'Healthcare Supplies of Atlanta'),('BLSHC',0004,100,'Healthcare Supplies of Atlanta'),('WHMSK',0005,300,'Healthcare Supplies of Atlanta'),('BLSHC',0006,400,'Buy Personal Protective Equipment, Inc'),('GRMSK',0007,100,'Marietta Mask Production Company'),('GRGOG',0007,300,'Marietta Mask Production Company'),('ORGOG',0008,200,'Georgia Tech Protection Lab'),('WHGOG',0008,200,'Georgia Tech Protection Lab'),('GRSHC',0009,500,'Marietta Mask Production Company'),('GRHOD',0009,500,'Marietta Mask Production Company'),('WHGLO',0010,500,'S&J Corporation'),('WHHOD',0011,200,'Buy Personal Protective Equipment, Inc'),('WHGWN',0011,200,'Buy Personal Protective Equipment, Inc'),('BLSHC',0012,50,'Buy Personal Protective Equipment, Inc'),('BLHOD',0013,100,'Healthcare Supplies of Atlanta'),('BLGWN',0013,100,'Healthcare Supplies of Atlanta'),('WHRES',0014,300,'PPE Empire'),('YLRES',0014,200,'PPE Empire'),('ORRES',0014,300,'PPE Empire'),('GYGWN',0015,50,'Buy Personal Protective Equipment, Inc'),('CLSHD',0016,20,'Healthcare Supplies of Atlanta'),('ORGOG',0016,300,'Healthcare Supplies of Atlanta'),('BLHOD',0016,100,'Healthcare Supplies of Atlanta'),('RDMSK',0017,200,'Healthcare Supplies of Atlanta'),('CLSHD',0017,180,'Healthcare Supplies of Atlanta'),('WHHOD',0018,500,'Buy Personal Protective Equipment, Inc'),('GYGWN',0019,300,'Buy Personal Protective Equipment, Inc'),('BKSTE',0020,50,'S&J Corporation'),('WHSTE',0020,50,'S&J Corporation'),('CLSHD',0021,100,'Georgia Tech Protection Lab'),('ORGOG',0021,200,'Georgia Tech Protection Lab');
INSERT INTO catalog_item VALUES ('WHMSK','PPE Empire',1.25),('BLMSK','PPE Empire',1.35),('RDMSK','PPE Empire',1.30),('GRMSK','PPE Empire',1.45),('WHRES','PPE Empire',4.80),('YLRES','PPE Empire',5.10),('ORRES','PPE Empire',4.50),('BLSHC','Buy Personal Protective Equipment, Inc',0.90),('BLHOD','Buy Personal Protective Equipment, Inc',2.10),('BLGWN','Buy Personal Protective Equipment, Inc',3.15),('GRSHC','Buy Personal Protective Equipment, Inc',0.90),('GRHOD','Buy Personal Protective Equipment, Inc',2.10),('GRGWN','Buy Personal Protective Equipment, Inc',3.15),('GYSHC','Buy Personal Protective Equipment, Inc',0.90),('GYHOD','Buy Personal Protective Equipment, Inc',2.10),('GYGWN','Buy Personal Protective Equipment, Inc',3.15),('WHSHC','Buy Personal Protective Equipment, Inc',0.90),('WHHOD','Buy Personal Protective Equipment, Inc',2.10),('WHGWN','Buy Personal Protective Equipment, Inc',3.15),('ORGOG','Healthcare Supplies of Atlanta',3.00),('RDMSK','Healthcare Supplies of Atlanta',1.45),('CLSHD','Healthcare Supplies of Atlanta',6.05),('BLSHC','Healthcare Supplies of Atlanta',1.00),('BLHOD','Healthcare Supplies of Atlanta',2.00),('BLGWN','Healthcare Supplies of Atlanta',3.00),('YLRES','Healthcare Supplies of Atlanta',5.50),('WHMSK','Healthcare Supplies of Atlanta',1.10),('BLMSK','Healthcare Supplies of Atlanta',1.05),('CLSHD','Georgia Tech Protection Lab',5.95),('ORGOG','Georgia Tech Protection Lab',3.20),('WHGOG','Georgia Tech Protection Lab',3.20),('BKGOG','Georgia Tech Protection Lab',3.20),('GYSHC','Georgia Tech Protection Lab',0.75),('GYHOD','Georgia Tech Protection Lab',1.80),('GYGWN','Georgia Tech Protection Lab',3.25),('GRSHC','Marietta Mask Production Company',0.80),('GRHOD','Marietta Mask Production Company',1.65),('GRGWN','Marietta Mask Production Company',2.95),('GRMSK','Marietta Mask Production Company',1.25),('GRGOG','Marietta Mask Production Company',3.25),('BKSTE','S&J Corporation',5.20),('WHSTE','S&J Corporation',5.00),('SISTE','S&J Corporation',5.10),('BKGLO','S&J Corporation',0.30),('WHGLO','S&J Corporation',0.30),('GRGLO','S&J Corporation',0.30);

