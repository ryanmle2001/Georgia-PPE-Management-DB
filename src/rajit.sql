-- CS4400: Introduction to Database Systems
-- Summer 2020
-- Phase II Create Table and Insert Statements Template

-- Team XX
-- Rajit Khanna (rkhanna38)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

-- CREATE TABLE STATEMENTS BELOW
DROP TABLE IF EXISTS BUSINESS;
CREATE TABLE BUSINESS (
  business_name varchar(1) NOT NULL PRIMARY KEY,
  street varchar(1) NOT NULL,
  city varchar(1) NOT NULL,
  state varchar(1) NOT NULL,
  zip decimal(5, 0) NOT NULL,
  UNIQUE KEY (street, city, zip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS HOSPITAL;
CREATE TABLE HOSPITAL (
  hospital_name varchar(1) NOT NULL PRIMARY KEY,
  max_doctors decimal(2,0) NOT NULL,
  budget decimal(10,2) NOT NULL,
  CONSTRAINT hospital_ibfk_1 FOREIGN KEY (hospital_name) REFERENCES business (business_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS MANUFACTURER;
CREATE TABLE MANUFACTURER (
  manufacturer_name varchar(1) NOT NULL PRIMARY KEY,
  catalog_capacity decimal(5,0) NOT NULL,
  CONSTRAINT manufacturer_ibfk_1 FOREIGN KEY (manufacturer_name) REFERENCES business (business_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- INSERT STATEMENTS BELOW

INSERT INTO BUSINESS VALUES 
("Children's Healthcare of Atlanta", "Clifton Rd NE", "Atlanta", "Georgia", 30332),
("Piedmont Hospital", "Peachtree Rd NW", "Atlanta", "Georgia", 30309),
("Northside Hospital", "Johnson Ferry Road NE", "Atlanta", "Georgia", 30342),
("Emory Midtown", "Peachtree St NE", "Atlanta", "Georgia", 30308),
("Grady Hospital", "Jesse Hill Jr Dr SE", "Atlanta", "Georgia", 30303),
("PPE Empire", "Ponce De Leon Ave", "Atlanta", "Georgia", 30308),
("Buy Personal Protective Equipment, Inc", "Spring St","Atlanta", "Georgia", 30313),
("Healthcare Supplies of Atlanta", "Peachstree St", "Atlanta", "Georgia", 30308),
("Georgia Tech Protection Lab", "North Ave NW", "Atlanta", "Georgia", 30332),
("Marietta Mask Production Company", "Appletree Way", "Atlanta", "Georgia", 30061),
("S&J Corporation", "Juniper St", "Atlanta", "Georgia", 30339);

INSERT INTO HOSPITAL VALUES 
("Children's Healthcare of Atlanta", 6, 80000),
("Piedmont Hospital", 7, 95000),
("Northside Hospital", 9, 72000),
("Emory Midtown", 13, 120000),
("Grady Hospital", 10, 81000);

INSERT INTO BUSINESS VALUES 
("PPE Empire", 20),
("Buy Personal Protective Equipment, Inc", 25),
("Healthcare Supplies of Atlanta", 20),
("Georgia Tech Protection Lab", 27),
("Marietta Mask Production Company", 15),
("S&J Corporation", 22);