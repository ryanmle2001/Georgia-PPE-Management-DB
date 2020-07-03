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

drop table if exists product;
create table product (
	p_id char(5,0) not null,
	name varchar(1) not null, 
	type varchar(1) not null, 
	color varchar(1) not null, 
	primary key (p_id)
) engine = InnoDB;

drop table if exists inventory;
create table inventory (
	business_name varchar(1) not null,
	street varchar(1) not null, 
	city varchar(1) not null, 
	state varchar(1) not null, 
	zip varchar(1) not null,
	primary key (business_name)
	constraint inventory_ibfk_1 foreign key (business_name) references business (business_name)
) engine = InnoDB;

drop table if exists has_item;
create table has_item (
	business_name varchar(1) not null,
	p_id char(5) not null, 
	count varchar(1) not null, 
	primary key (business_name,p_id)
	constraint has_item_ibfk_1 foreign key (business_name) references business (business_name)
	constraint has_item_ibfk_2 foreign key (p_id) references catalog_item (p_id)
)

drop table if exists used_by;
create table used_by (
	p_id char(5) not null,
	ul_id char(5) not null, 
	count varchar(1) not null, 
	primary key (p_id, ul_id)
	constraint used_by_ibfk_1 foreign key (ul_id) references usage_log (ul_id)
	constraint used_by_ibfk_2 foreign key (p_id) references catalog_item (p_id)
)


-- INSERT STATEMENTS BELOW