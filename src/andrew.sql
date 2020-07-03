-- CS4400: Introduction to Database Systems
-- Summer 2020
-- Phase II Create Table and Insert Statements Template

-- Team XX
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

-- CREATE TABLE STATEMENTS BELOW

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
  T_id decimal(4,0) NOT NULL,
  hospital char(20) NOT NULL,
  tdate date NOT NULL,
  PRIMARY KEY (T_id),
  KEY hospital (hospital),
  CONSTRAINT transaction_ibfk_1 FOREIGN KEY (hospital) REFERENCES Hospital (hosital_name)
) ENGINE=InnoDB;

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

-- INSERT STATEMENTS BELOW