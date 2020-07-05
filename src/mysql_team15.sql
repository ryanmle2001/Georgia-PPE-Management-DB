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
	zip decimal(5,0) not null,
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
)

-- INSERT STATEMENTS BELOW