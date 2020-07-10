-- CS4400: Introduction to Database Systems
-- Summer 2020
-- Phase II Create Table and Insert Statements Template

-- Team 15
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

DROP DATABASE IF EXISTS ryan;
CREATE DATABASE IF NOT EXISTS ryan;
USE ryan;

-- CREATE TABLE STATEMENTS BELOW

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

DROP TABLE IF EXISTS usage_log;
CREATE TABLE usage_log (
  ul_id varchar(1) NOT NULL,
  time_stamp timestamp NOT NULL,
  doctor varchar(1) NOT NULL,
  PRIMARY KEY (ul_id),
  CONSTRAINT usage_log_fk16 FOREIGN KEY (doctor) REFERENCES doctor (username)
) ENGINE=InnoDB;

-- INSERT STATEMENTS BELOW