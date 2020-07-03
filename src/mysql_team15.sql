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

drop table if exists product;
create table product (
	p_id char(5) not null,
	name varchar(1) not null, 
	type varchar(1) not null, 
	color varchar(1) not null, 
	primary key (p_id)
) engine = InnoDB;

DROP TABLE IF EXISTS BUSINESS;
CREATE TABLE BUSINESS (
  business_name varchar(1) NOT NULL PRIMARY KEY,
  street varchar(1) NOT NULL,
  city varchar(1) NOT NULL,
  zip decimal(5, 0) NOT NULL,
  UNIQUE KEY (street, city, zip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS HOSPITAL;
CREATE TABLE HOSPITAL (
  hospital_name varchar(1) NOT NULL PRIMARY KEY,
  max_doctors decimal(2,0) NOT NULL,
  budget decimal(20,2) NOT NULL,
  CONSTRAINT hospital_ibfk_1 FOREIGN KEY (hospital_name) REFERENCES business (business_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS MANUFACTURER;
CREATE TABLE MANUFACTURER (
  manufacturer_name varchar(1) NOT NULL PRIMARY KEY,
  catalog_capacity decimal(5,0) NOT NULL,
  CONSTRAINT manufacturer_ibfk_1 FOREIGN KEY (manufacturer_name) REFERENCES business (business_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS user_account;
CREATE TABLE user_account (
  username varchar(1) NOT NULL,
  email varchar(1) NOT NULL,
  passphrase varchar(1) NOT NULL,
  fname varchar(1) NOT NULL,
  lname varchar(1) NOT NULL,
  PRIMARY KEY (username),
  UNIQUE KEY (email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS doctor;
CREATE TABLE doctor (
  username varchar(1) NOT NULL,
  hospital_name varchar(1) NOT NULL,
  manager varchar(1) NOT NULL,
  PRIMARY KEY (username),
  CONSTRAINT doctor_fk4 FOREIGN KEY (username) REFERENCES user_account (username),
  CONSTRAINT doctor_fk16 FOREIGN KEY (hospital_name) REFERENCES hospital (hospital_name),
  CONSTRAINT doctor_fk19 FOREIGN KEY (manager) REFERENCES doctor (username)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS administrator;
CREATE TABLE administrator (
  username varchar(1) NOT NULL,
  business_managed varchar(1) NOT NULL,
  PRIMARY KEY (username),
  CONSTRAINT administrator_fk5 FOREIGN KEY (username) REFERENCES user_account (username),
  CONSTRAINT administrator_fk18 FOREIGN KEY (business_managed) REFERENCES business (business_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
  T_id decimal(4,0) NOT NULL,
  hospital char(20) NOT NULL,
  tdate date NOT NULL,
  PRIMARY KEY (T_id),
  KEY hospital (hospital),
  CONSTRAINT transaction_ibfk_1 FOREIGN KEY (hospital) REFERENCES Hospital (hosital_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS usage_log;
CREATE TABLE usage_log (
  ul_id varchar(1) NOT NULL,
  time_stamp timestamp NOT NULL,
  doctor varchar(1) NOT NULL,
  PRIMARY KEY (ul_id),
  CONSTRAINT usage_log_fk16 FOREIGN KEY (doctor) REFERENCES doctor (username)
) ENGINE=InnoDB;

drop table if exists inventory;
create table inventory (
	business_name varchar(1) not null,
	street varchar(1) not null, 
	city varchar(1) not null, 
	state varchar(1) not null, 
	zip varchar(1) not null,
	primary key (business_name),
	constraint inventory_ibfk_1 foreign key (business_name) references business (business_name)
) engine = InnoDB;

drop table if exists has_item;
create table has_item (
	business_name varchar(1) not null,
	p_id char(5) not null, 
	count varchar(1) not null, 
	primary key (business_name,p_id),
	constraint has_item_ibfk_1 foreign key (business_name) references business (business_name),
	constraint has_item_ibfk_2 foreign key (p_id) references catalog_item (p_id)
) engine = InnoDB;

DROP TABLE IF EXISTS Catalog_Item;
CREATE TABLE Catalog_Item (
  P_id char(5) NOT NULL,
  business_name VARCHAR(0) NOT NULL,
  price decimal(10,2) NOT NULL,
  PRIMARY KEY (P_id, business_name),
  CONSTRAINT catalog_item_ibfk_1 FOREIGN KEY (P_id) REFERENCES product (p_id),
  CONSTRAINT catalog_item_ibfk_2 FOREIGN KEY (business_name) REFERENCES business (business_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Contain;
CREATE TABLE Contain (
  P_id char(5) NOT NULL,
  T_id decimal(4,0) NOT NULL,
  count decimal(10,2) NOT NULL,
  business_name VARCHAR(0) NOT NULL,
  PRIMARY KEY (P_id, T_id),
  CONSTRAINT contain_ibfk_1 FOREIGN KEY (P_id) REFERENCES product (p_id),
  CONSTRAINT contain_ibfk_2 FOREIGN KEY (business_name) REFERENCES business (business_name),
  CONSTRAINT contain_ibfk_3 FOREIGN KEY (T_id) REFERENCES transactions (t_id)
) ENGINE=InnoDB;

drop table if exists used_by;
create table used_by (
	p_id char(5) not null,
	ul_id char(5) not null, 
	count varchar(1) not null, 
	primary key (p_id, ul_id),
	constraint used_by_ibfk_1 foreign key (ul_id) references usage_log (ul_id),
	constraint used_by_ibfk_2 foreign key (p_id) references catalog_item (p_id)
)



-- INSERT STATEMENTS BELOW