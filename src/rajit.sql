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

CREATE TABLE `business` (
  `name` char(20) NOT NULL PRIMARY KEY,
  `street` char(20) NOT NULL,
  `city` char(20) NOT NULL,
  `zip` decimal(6,0) NOT NULL,
  UNIQUE KEY (`street`, `city`, `zip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `hospital` (
  `name` char(20) NOT NULL PRIMARY KEY,
  `max_doctors` decimal(2,0) NOT NULL,
  `budget` decimal(6,0) NOT NULL,
  CONSTRAINT hospital_ibfk_1 FOREIGN KEY (name) REFERENCES business (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `manufacturer` (
  `name` char(20) NOT NULL PRIMARY KEY,
  `catalog_capacity` decimal(20) NOT NULL,
  CONSTRAINT manufacturer_ibfk_1 FOREIGN KEY (name) REFERENCES business (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




-- INSERT STATEMENTS BELOW