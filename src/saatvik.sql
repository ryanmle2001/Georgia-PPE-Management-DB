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

DROP TABLE IF EXISTS product;
CREATE TABLE product (
	p_id char(5) not null,
	type varchar(100) not null, 
	color varchar(100) not null, 
	primary key (p_id)
) engine = InnoDB;

INSERT INTO product VALUES ('WHMSK','mask','white'),('BLMSK','mask','blue'),('RDMSK','mask','red'),('GRMSK','mask','green'),('WHRES','respirator','white'),('YLRES','respirator','yellow'),('ORRES','repirator','orange'),('CLSHD','shield','clear'),('GRGOG','goggles','green'),('ORGOG','goggles','orange'),('WHGOG','goggles','white'),('BKGOG','goggles','black'),('BLSHC','shoe cover','blue'),('BLHOD','hood','blue'),('BLGWN','gown','blue'),('GRSHC','shoe cover','green'),('GRHOD','hood','green'),('GRGWN','gown','green'),('GYSHC','shoe cover','grey'),('GYHOD','hood','grey'),('GYGWN','gown','grey'),('WHSHC','shoe cover','white'),('WHHOD','hood','white'),('WHGWN','gown','white'),('BKSTE','stethoscope','black'),('WHSTE','stethoscope','white'),('SISTE','stethoscope','silver'),('BKGLO','gloves','black'),('WHGLO','gloves','white'),('GRGLO','gloves','green');

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

INSERT INTO inventory VALUES ('Children\'s Heathcare of Atlanta','Storage St','Atlanta','Georgia',30309),('Piedmont Hospital','Warehouse Way','Atlanta','Georgia',30332),('Northside Hospital','Depot Dr','Dunwoody','Georgia',30338),('Emory Midtown','Inventory Ct','Atlanta','Georgia',30308),('Grady Hospital','Storehouse Pkwy','Atlanta','Georgia',30313),('PPE Empire','Cache Ct','Lawrenceville','Georgia',30043),('Buy Personal Protective Equipment, Inc','Stockpile St','Decatur','Georgia',30030),('Healthcare Supplies of Atlanta','Depository Dr','Atlanta','Georgia',30303),('Georgia Tech Protection Lab','Storehouse St','Atlanta','Georgia',30332),('Marietta Mask Production Company','Repository Way','Marietta','Georgia',30008),('S&J Corporation','Stash St','Suwanee','Suwanee',30024);

DROP TABLE IF EXISTS has_item;
CREATE TABLE has_item (
	business_name varchar(100) not null,
	p_id char(5) not null, 
	item_count varchar(100) not null, 
	primary key (business_name,p_id),
	constraint has_item_ibfk_1 foreign key (business_name) references business (business_name),
	constraint has_item_ibfk_2 foreign key (p_id) references catalog_item (p_id)
) engine = InnoDB;

INSERT INTO has_item VALUES ('Children\'s Heathcare of Atlanta','WHMSK',5),('Children\'s Heathcare of Atlanta','BLMSK',220),('Children\'s Heathcare of Atlanta','WHRES',280),('Children\'s Heathcare of Atlanta','CLSHD',100),('Children\'s Heathcare of Atlanta','GRGOG',780),('Children\'s Heathcare of Atlanta','ORGOG',100),('Children\'s Heathcare of Atlanta','BLSHC',460),('Children\'s Heathcare of Atlanta','BLHOD',100),('Children\'s Heathcare of Atlanta','BLGWN',80),('Children\'s Heathcare of Atlanta','GRSHC',5),('Children\'s Heathcare of Atlanta','WHSTE',330),('Children\'s Heathcare of Atlanta','BKGLO',410),('Piedmont Hospital','BLSHC',3000),('Piedmont Hospital','BLHOD',3000),('Piedmont Hospital','BLGWN',420),('Piedmont Hospital','GRSHC',740),('Piedmont Hospital','GRHOD',560),('Piedmont Hospital','GRGWN',840),('Piedmont Hospital','SISTE',460),('Piedmont Hospital','BKGLO',4210),('Northside Hospital','WHRES',110),('Northside Hospital','YLRES',170),('Northside Hospital','ORRES',350),('Northside Hospital','CLSHD',410),('Northside Hospital','GRGOG',1),('Northside Hospital','ORGOG',100),('Emory Midtown','WHMSK',80),('Emory Midtown','BLMSK',210),('Emory Midtown','RDMSK',320),('Emory Midtown','GRMSK',40),('Emory Midtown','WHRES',760),('Emory Midtown','YLRES',140),('Emory Midtown','ORRES',20),('Emory Midtown','CLSHD',50),('Emory Midtown','GRGOG',70),('Emory Midtown','ORGOG',320),('Emory Midtown','WHGOG',140),('Emory Midtown','BKGOG',210),('Emory Midtown','BLSHC',630),('Grady Hospital','BLHOD',970),('Grady Hospital','BLGWN',310),('Grady Hospital','GRSHC',340),('Grady Hospital','GRHOD',570),('Grady Hospital','GRGWN',10),('Grady Hospital','GYSHC',20),('Grady Hospital','GYHOD',280),('Grady Hospital','GYGWN',240),('Grady Hospital','WHSHC',180),('Grady Hospital','WHHOD',140),('Grady Hospital','WHGWN',150),('Grady Hospital','BKSTE',210),('Grady Hospital','WHSTE',170),('Grady Hospital','SISTE',180),('Grady Hospital','BKGLO',70),('Grady Hospital','WHGLO',140),('Grady Hospital','GRGLO',80),('PPE Empire','WHMSK',850),('PPE Empire','BLMSK',1320),('PPE Empire','RDMSK',540),('PPE Empire','GRMSK',870),('PPE Empire','WHRES',500),('PPE Empire','ORRES',320),('Buy Personal Protective Equipment, Inc','BLSHC',900),('Buy Personal Protective Equipment, Inc','BLGWN',820),('Buy Personal Protective Equipment, Inc','GRSHC',700),('Buy Personal Protective Equipment, Inc','GRHOD',770),('Buy Personal Protective Equipment, Inc','GYSHC',250),('Buy Personal Protective Equipment, Inc','GYHOD',350),('Buy Personal Protective Equipment, Inc','GYGWN',850),('Buy Personal Protective Equipment, Inc','WHSHC',860),('Buy Personal Protective Equipment, Inc','WHHOD',700),('Buy Personal Protective Equipment, Inc','WHGWN',500),('Healthcare Supplies of Atlanta','ORGOG',860),('Healthcare Supplies of Atlanta','RDMSK',370),('Healthcare Supplies of Atlanta','CLSHD',990),('Healthcare Supplies of Atlanta','BLSHC',1370),('Healthcare Supplies of Atlanta','BLHOD',210),('Healthcare Supplies of Atlanta','BLGWN',680),('Healthcare Supplies of Atlanta','YLRES',890),('Healthcare Supplies of Atlanta','WHMSK',980),('Healthcare Supplies of Atlanta','BLMSK',5000),('Georgia Tech Protection Lab','CLSHD',620),('Georgia Tech Protection Lab','ORGOG',970),('Georgia Tech Protection Lab','WHGOG',940),('Georgia Tech Protection Lab','BKGOG',840),('Georgia Tech Protection Lab','GYSHC',610),('Georgia Tech Protection Lab','GYHOD',940),('Georgia Tech Protection Lab','GYGWN',700),('Marietta Mask Production Company','GRSHC',970),('Marietta Mask Production Company','GRHOD',750),('Marietta Mask Production Company','GRMSK',750),('Marietta Mask Production Company','GRGOG',320),('S&J Corporation','BKSTE',200),('S&J Corporation','WHSTE',860),('S&J Corporation','WHGLO',500),('S&J Corporation','GRGLO',420),('S&J Corporation','BKGLO',740);

DROP TABLE IF EXISTS used_by;
CREATE TABLE used_by (
	p_id char(5) not null,
	ul_id char(5) not null, 
	item_count varchar(100) not null, 
	primary key (p_id, ul_id),
	constraint used_by_ibfk_1 foreign key (ul_id) references usage_log (ul_id),
	constraint used_by_ibfk_2 foreign key (p_id) references catalog_item (p_id)
)

INSERT INTO used_by VALUES ('GRMSK',10000,3),('GRGOG',10000,3),('WHSTE',10000,1),('GRMSK',10001,5),('BKSTE',10001,1),('WHMSK',10002,4),('CLSHD',10003,2),('ORGOG',10003,1),('GRMSK',10003,2),('GRGOG',10003,1),('BKSTE',10003,1),('ORGOG',10004,2),('RDMSK',10004,4),('CLSHD',10004,2),('BLSHC',10004,4),('WHMSK',10005,4),('BLMSK',10005,4),('BLSHC',10005,8),('GRMSK',10006,2),('RDMSK',10007,3),('CLSHD',10007,3),('BLMSK',10008,5),('GRSHC',10009,4),('GRHOD',10009,4),('WHMSK',10009,4),('RDMSK',10010,3),('BLSHC',10010,3),('BLMSK',10011,8),('ORGOG',10012,1),('WHGOG',10012,1),('WHGLO',10012,2),('WHHOD',10013,2),('WHGOG',10014,2),('WHGWN',10014,2),('BLMSK',10015,4);
-- INSERT STATEMENTS BELOW