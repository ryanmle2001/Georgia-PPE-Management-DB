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
	ptype varchar(100) not null, 
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
  budget decimal(10,2) NOT NULL,
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
  manager varchar(100),
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  t_id decimal(4,0) NOT NULL,
  hospital varchar(100) NOT NULL,
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
);

-- INSERT STATEMENTS BELOW

INSERT INTO product VALUES ('WHMSK','mask','white'),('BLMSK','mask','blue'),('RDMSK','mask','red'),('GRMSK','mask','green'),('WHRES','respirator','white'),('YLRES','respirator','yellow'),('ORRES','repirator','orange'),('CLSHD','shield','clear'),('GRGOG','goggles','green'),('ORGOG','goggles','orange'),('WHGOG','goggles','white'),('BKGOG','goggles','black'),('BLSHC','shoe cover','blue'),('BLHOD','hood','blue'),('BLGWN','gown','blue'),('GRSHC','shoe cover','green'),('GRHOD','hood','green'),('GRGWN','gown','green'),('GYSHC','shoe cover','grey'),('GYHOD','hood','grey'),('GYGWN','gown','grey'),('WHSHC','shoe cover','white'),('WHHOD','hood','white'),('WHGWN','gown','white'),('BKSTE','stethoscope','black'),('WHSTE','stethoscope','white'),('SISTE','stethoscope','silver'),('BKGLO','gloves','black'),('WHGLO','gloves','white'),('GRGLO','gloves','green');

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

INSERT INTO MANUFACTURER VALUES 
("PPE Empire", 20),
("Buy Personal Protective Equipment, Inc", 25),
("Healthcare Supplies of Atlanta", 20),
("Georgia Tech Protection Lab", 27),
("Marietta Mask Production Company", 15),
("S&J Corporation", 22);

INSERT INTO user_account VALUES ('drCS4400','cs4400@gatech.edu',30003000,'Computer','Science'),('doctor_moss','mmoss7@gatech.edu',12341234,'Mark','Moss'),('drmcdaniel','mcdaniel@cc.gatech.edu',12345678,'Melinda','McDaniel'),('musaev_doc','aibek.musaev@gatech.edu',87654321,'Aibek','Musaev'),('doctor1','doctor1@gatech.edu',10001000,'Doctor','One'),('doctor2','doctor2@gatech.edu',20002000,'Doctor','Two'),('fantastic','ninth_doctor@gatech.edu',99999999,'Chris','Eccleston'),('allons_y','tenth_doctor@gatech.edu',10101010,'David','Tennant'),('bow_ties _are_cool','eleventh_doctor@gatech.edu',11111111,'Matt','Smith'),('sonic_shades','twelfth_doctor@gatech.edu',12121212,'Peter','Capaldi'),('mcdreamy','dr_shepard@gatech.edu',13311332,'Derek','Shepard'),('grey_jr','dr_grey@gatech.edu',87878787,'Meredith','Shepard'),('young_doc','howser@gatech.edu',80088008,'Doogie','Howser'),('dr_dolittle','dog_doc@gatech.edu',37377373,'John','Dolittle'),('bones','doctor_mccoy@gatech.edu',11223344,'Leonard','McCoy'),('doc_in_da_house','tv_doctor@gatech.edu',30854124,'Gregory','House'),('jekyll_not_hyde','jekyll1886@gatech.edu',56775213,'Henry','Jekyll'),('drake_remoray ','f_r_i_e_n_d_s@gatech.edu',24598543,'Joey','Tribbiani'),('Jones01','jones01@gatech.edu',52935481,'Johnes','Boys'),('hannah_hills','managerEHH@gatech.edu',13485102,'Hannah','Hills'),('henryjk','HenryJK@gatech.edu',54238912,'Henry','Kims'),('aziz_01','ehh01@gatech.edu',90821348,'Amit','Aziz'),('dr_mory','JackMM@gatech.edu',12093015,'Jack','Mory'),('ppee_admin','ppee_admin@gatech.edu',27536292,'Admin','One'),('bppe_admin','bppe_admin@gatech.edu',35045790,'Admin','Two'),('hsa_admin','hsa_admin@gatech.edu',75733271,'Jennifer','Tree'),('gtpl_admin','gtpl_admin@gatech.edu',14506524,'Shaundra','Apple'),('mmpc_admin','mmpc_admin@gatech.edu',22193897,'Nicholas','Cage'),('sjc_admin','sjc_admin@gatech.edu',74454118,'Trey','Germs'),('choa_admin','choa_admin@gatech.edu',62469488,'Addison','Ambulance'),('piedmont_admin','piedmont_admin@gatech.edu',36846830,'Rohan','Right'),('northside_admin','northside_admin@gatech.edu',38613312,'Johnathan','Smith'),('emory_admin','emory_admin@gatech.edu',33202257,'Elizabeth','Tucker'),('grady_admin','grady_admin@gatech.edu',67181125,'Taylor','Booker'),('Burdell','GeorgeBurdell@gatech.edu',12345678,'George','Burdell'),('Buzz','THWG@gatech.edu',98765432,'Buzz','Tech');
INSERT INTO catalog_item VALUES ('WHMSK','PPE Empire',1.25),('BLMSK','PPE Empire',1.35),('RDMSK','PPE Empire',1.30),('GRMSK','PPE Empire',1.45),('WHRES','PPE Empire',4.80),('YLRES','PPE Empire',5.10),('ORRES','PPE Empire',4.50),('BLSHC','Buy Personal Protective Equipment, Inc',0.90),('BLHOD','Buy Personal Protective Equipment, Inc',2.10),('BLGWN','Buy Personal Protective Equipment, Inc',3.15),('GRSHC','Buy Personal Protective Equipment, Inc',0.90),('GRHOD','Buy Personal Protective Equipment, Inc',2.10),('GRGWN','Buy Personal Protective Equipment, Inc',3.15),('GYSHC','Buy Personal Protective Equipment, Inc',0.90),('GYHOD','Buy Personal Protective Equipment, Inc',2.10),('GYGWN','Buy Personal Protective Equipment, Inc',3.15),('WHSHC','Buy Personal Protective Equipment, Inc',0.90),('WHHOD','Buy Personal Protective Equipment, Inc',2.10),('WHGWN','Buy Personal Protective Equipment, Inc',3.15),('ORGOG','Healthcare Supplies of Atlanta',3.00),('RDMSK','Healthcare Supplies of Atlanta',1.45),('CLSHD','Healthcare Supplies of Atlanta',6.05),('BLSHC','Healthcare Supplies of Atlanta',1.00),('BLHOD','Healthcare Supplies of Atlanta',2.00),('BLGWN','Healthcare Supplies of Atlanta',3.00),('YLRES','Healthcare Supplies of Atlanta',5.50),('WHMSK','Healthcare Supplies of Atlanta',1.10),('BLMSK','Healthcare Supplies of Atlanta',1.05),('CLSHD','Georgia Tech Protection Lab',5.95),('ORGOG','Georgia Tech Protection Lab',3.20),('WHGOG','Georgia Tech Protection Lab',3.20),('BKGOG','Georgia Tech Protection Lab',3.20),('GYSHC','Georgia Tech Protection Lab',0.75),('GYHOD','Georgia Tech Protection Lab',1.80),('GYGWN','Georgia Tech Protection Lab',3.25),('GRSHC','Marietta Mask Production Company',0.80),('GRHOD','Marietta Mask Production Company',1.65),('GRGWN','Marietta Mask Production Company',2.95),('GRMSK','Marietta Mask Production Company',1.25),('GRGOG','Marietta Mask Production Company',3.25),('BKSTE','S&J Corporation',5.20),('WHSTE','S&J Corporation',5.00),('SISTE','S&J Corporation',5.10),('BKGLO','S&J Corporation',0.30),('WHGLO','S&J Corporation',0.30),('GRGLO','S&J Corporation',0.30);
INSERT INTO doctor VALUES ('drCS4400','Children\'s Healthcare of Atlanta', null),('doctor_moss','Piedmont Hospital', null),('drmcdaniel','Northside Hospital', null),('musaev_doc','Emory Midtown', null),('doctor1','Grady Hospital', null),('doctor2','Children\'s Healthcare of Atlanta','drCS4400'),('fantastic','Piedmont Hospital','doctor_moss'),('allons_y','Northside Hospital','drmcdaniel'),('bow_ties _are_cool','Emory Midtown','musaev_doc'),('sonic_shades','Grady Hospital','doctor1'),('mcdreamy','Children\'s Healthcare of Atlanta','drCS4400'),('grey_jr','Piedmont Hospital','doctor_moss'),('young_doc','Northside Hospital','drmcdaniel'),('dr_dolittle','Emory Midtown','musaev_doc'),('bones','Grady Hospital','doctor1'),('doc_in_da_house','Children\'s Healthcare of Atlanta','drCS4400'),('jekyll_not_hyde','Piedmont Hospital','doctor_moss'),('drake_remoray ','Northside Hospital','drmcdaniel'),('Jones01','Emory Midtown','musaev_doc'),('hannah_hills','Grady Hospital','doctor1'),('henryjk','Children\'s Healthcare of Atlanta','drCS4400'),('aziz_01','Piedmont Hospital','doctor_moss'),('dr_mory','Northside Hospital','drmcdaniel'),('Burdell','Northside Hospital','drmcdaniel'),('Buzz','Piedmont Hospital','doctor_moss');
INSERT INTO administrator VALUES ('ppee_admin','PPE Empire'),('bppe_admin','Buy Personal Protective Equipment, Inc'),('hsa_admin','Healthcare Supplies of Atlanta'),('gtpl_admin','Georgia Tech Protection Lab'),('mmpc_admin','Marietta Mask Production Company'),('sjc_admin','S&J Corporation'),('choa_admin','Children\'s Healthcare of Atlanta'),('piedmont_admin','Piedmont Hospital'),('northside_admin','Northside Hospital'),('emory_admin','Emory Midtown'),('grady_admin','Grady Hospital'),('Burdell','Northside Hospital'),('Buzz','Piedmont Hospital');
-- INSERT INTO inventory VALUES ('Children\'s Heathcare of Atlanta','Storage St','Atlanta','Georgia','30309'),('Piedmont Hospital','Warehouse Way','Atlanta','Georgia','30332'),('Northside Hospital','Depot Dr','Dunwoody','Georgia','30338'),('Emory Midtown','Inventory Ct','Atlanta','Georgia','30308'),('Grady Hospital','Storehouse Pkwy','Atlanta','Georgia','30313'),('PPE Empire','Cache Ct','Lawrenceville','Georgia','30043'),('Buy Personal Protective Equipment, Inc','Stockpile St','Decatur','Georgia','30030'),('Healthcare Supplies of Atlanta','Depository Dr','Atlanta','Georgia','30303'),('Georgia Tech Protection Lab','Storehouse St','Atlanta','Georgia','30332'),('Marietta Mask Production Company','Repository Way','Marietta','Georgia','30008'),('S&J Corporation','Stash St','Suwanee','Suwanee','30024');
INSERT INTO transactions VALUES (0001,'Children\'s Healthcare of Atlanta','2020-03-10'),(0002,'Children\'s Healthcare of Atlanta','2020-03-10'),(0003,'Emory Midtown','2020-03-10'),(0004,'Grady Hospital','2020-03-10'),(0005,'Northside Hospital','2020-03-10'),(0006,'Children\'s Healthcare of Atlanta','2020-03-10'),(0007,'Piedmont Hospital','2020-03-10'),(0008,'Northside Hospital','2020-05-01'),(0009,'Children\'s Healthcare of Atlanta','2020-05-01'),(0010,'Northside Hospital','2020-05-01'),(0011,'Northside Hospital','2020-05-01'),(0012,'Emory Midtown','2020-05-25'),(0013,'Children\'s Healthcare of Atlanta','2020-05-25'),(0014,'Emory Midtown','2020-05-25'),(0015,'Emory Midtown','2020-05-25'),(0016,'Northside Hospital','2020-05-25'),(0017,'Grady Hospital','2020-06-03'),(0018,'Grady Hospital','2020-06-03'),(0019,'Grady Hospital','2020-06-03'),(0020,'Piedmont Hospital','2020-06-03'),(0021,'Piedmont Hospital','2020-06-04');
INSERT INTO usage_log VALUES ('10000','2020-11-06 16:30:00','fantastic'),('10001','2020-06-11 17:00:00','jekyll_not_hyde'),('10002','2020-06-11 17:03:00','young_doc'),('10003','2020-06-12 8:23:00','fantastic'),('10004','2020-06-12 8:42:00','hannah_hills'),('10005','2020-06-12 9:00:00','mcdreamy'),('10006','2020-06-12 9:43:00','fantastic'),('10007','2020-06-12 10:11:00','doctor1'),('10008','2020-06-12 10:12:00','Jones01'),('10009','2020-06-12 10:23:00','henryjk'),('10010','2020-06-12 10:32:00','bones'),('10011','2020-06-12 11:00:00','dr_dolittle'),('10012','2020-06-12 11:14:00','drake_remoray '),('10013','2020-06-12 12:11:00','allons_y'),('10014','2020-06-12 13:23:00','dr_mory'),('10015','2020-06-12 13:52:00','Jones01');
-- INSERT INTO has_item VALUES ('Children\'s Heathcare of Atlanta','WHMSK',5),('Children\'s Heathcare of Atlanta','BLMSK',220),('Children\'s Heathcare of Atlanta','WHRES',280),('Children\'s Heathcare of Atlanta','CLSHD',100),('Children\'s Heathcare of Atlanta','GRGOG',780),('Children\'s Heathcare of Atlanta','ORGOG',100),('Children\'s Heathcare of Atlanta','BLSHC',460),('Children\'s Heathcare of Atlanta','BLHOD',100),('Children\'s Heathcare of Atlanta','BLGWN',80),('Children\'s Heathcare of Atlanta','GRSHC',5),('Children\'s Heathcare of Atlanta','WHSTE',330),('Children\'s Heathcare of Atlanta','BKGLO',410),('Piedmont Hospital','BLSHC',3000),('Piedmont Hospital','BLHOD',3000),('Piedmont Hospital','BLGWN',420),('Piedmont Hospital','GRSHC',740),('Piedmont Hospital','GRHOD',560),('Piedmont Hospital','GRGWN',840),('Piedmont Hospital','SISTE',460),('Piedmont Hospital','BKGLO',4210),('Northside Hospital','WHRES',110),('Northside Hospital','YLRES',170),('Northside Hospital','ORRES',350),('Northside Hospital','CLSHD',410),('Northside Hospital','GRGOG',1),('Northside Hospital','ORGOG',100),('Emory Midtown','WHMSK',80),('Emory Midtown','BLMSK',210),('Emory Midtown','RDMSK',320),('Emory Midtown','GRMSK',40),('Emory Midtown','WHRES',760),('Emory Midtown','YLRES',140),('Emory Midtown','ORRES',20),('Emory Midtown','CLSHD',50),('Emory Midtown','GRGOG',70),('Emory Midtown','ORGOG',320),('Emory Midtown','WHGOG',140),('Emory Midtown','BKGOG',210),('Emory Midtown','BLSHC',630),('Grady Hospital','BLHOD',970),('Grady Hospital','BLGWN',310),('Grady Hospital','GRSHC',340),('Grady Hospital','GRHOD',570),('Grady Hospital','GRGWN',10),('Grady Hospital','GYSHC',20),('Grady Hospital','GYHOD',280),('Grady Hospital','GYGWN',240),('Grady Hospital','WHSHC',180),('Grady Hospital','WHHOD',140),('Grady Hospital','WHGWN',150),('Grady Hospital','BKSTE',210),('Grady Hospital','WHSTE',170),('Grady Hospital','SISTE',180),('Grady Hospital','BKGLO',70),('Grady Hospital','WHGLO',140),('Grady Hospital','GRGLO',80),('PPE Empire','WHMSK',850),('PPE Empire','BLMSK',1320),('PPE Empire','RDMSK',540),('PPE Empire','GRMSK',870),('PPE Empire','WHRES',500),('PPE Empire','ORRES',320),('Buy Personal Protective Equipment, Inc','BLSHC',900),('Buy Personal Protective Equipment, Inc','BLGWN',820),('Buy Personal Protective Equipment, Inc','GRSHC',700),('Buy Personal Protective Equipment, Inc','GRHOD',770),('Buy Personal Protective Equipment, Inc','GYSHC',250),('Buy Personal Protective Equipment, Inc','GYHOD',350),('Buy Personal Protective Equipment, Inc','GYGWN',850),('Buy Personal Protective Equipment, Inc','WHSHC',860),('Buy Personal Protective Equipment, Inc','WHHOD',700),('Buy Personal Protective Equipment, Inc','WHGWN',500),('Healthcare Supplies of Atlanta','ORGOG',860),('Healthcare Supplies of Atlanta','RDMSK',370),('Healthcare Supplies of Atlanta','CLSHD',990),('Healthcare Supplies of Atlanta','BLSHC',1370),('Healthcare Supplies of Atlanta','BLHOD',210),('Healthcare Supplies of Atlanta','BLGWN',680),('Healthcare Supplies of Atlanta','YLRES',890),('Healthcare Supplies of Atlanta','WHMSK',980),('Healthcare Supplies of Atlanta','BLMSK',5000),('Georgia Tech Protection Lab','CLSHD',620),('Georgia Tech Protection Lab','ORGOG',970),('Georgia Tech Protection Lab','WHGOG',940),('Georgia Tech Protection Lab','BKGOG',840),('Georgia Tech Protection Lab','GYSHC',610),('Georgia Tech Protection Lab','GYHOD',940),('Georgia Tech Protection Lab','GYGWN',700),('Marietta Mask Production Company','GRSHC',970),('Marietta Mask Production Company','GRHOD',750),('Marietta Mask Production Company','GRMSK',750),('Marietta Mask Production Company','GRGOG',320),('S&J Corporation','BKSTE',200),('S&J Corporation','WHSTE',860),('S&J Corporation','WHGLO',500),('S&J Corporation','GRGLO',420),('S&J Corporation','BKGLO',740);
INSERT INTO contains_item VALUES ('WHMSK',0001,500,'PPE Empire'),('BLMSK',0001,500,'PPE Empire'),('BLSHC',0002,300,'Buy Personal Protective Equipment, Inc'),('BLMSK',0003,500,'Healthcare Supplies of Atlanta'),('ORGOG',0004,150,'Healthcare Supplies of Atlanta'),('RDMSK',0004,150,'Healthcare Supplies of Atlanta'),('CLSHD',0004,200,'Healthcare Supplies of Atlanta'),('BLSHC',0004,100,'Healthcare Supplies of Atlanta'),('WHMSK',0005,300,'Healthcare Supplies of Atlanta'),('BLSHC',0006,400,'Buy Personal Protective Equipment, Inc'),('GRMSK',0007,100,'Marietta Mask Production Company'),('GRGOG',0007,300,'Marietta Mask Production Company'),('ORGOG',0008,200,'Georgia Tech Protection Lab'),('WHGOG',0008,200,'Georgia Tech Protection Lab'),('GRSHC',0009,500,'Marietta Mask Production Company'),('GRHOD',0009,500,'Marietta Mask Production Company'),('WHGLO',0010,500,'S&J Corporation'),('WHHOD',0011,200,'Buy Personal Protective Equipment, Inc'),('WHGWN',0011,200,'Buy Personal Protective Equipment, Inc'),('BLSHC',0012,50,'Buy Personal Protective Equipment, Inc'),('BLHOD',0013,100,'Healthcare Supplies of Atlanta'),('BLGWN',0013,100,'Healthcare Supplies of Atlanta'),('WHRES',0014,300,'PPE Empire'),('YLRES',0014,200,'PPE Empire'),('ORRES',0014,300,'PPE Empire'),('GYGWN',0015,50,'Buy Personal Protective Equipment, Inc'),('CLSHD',0016,20,'Healthcare Supplies of Atlanta'),('ORGOG',0016,300,'Healthcare Supplies of Atlanta'),('BLHOD',0016,100,'Healthcare Supplies of Atlanta'),('RDMSK',0017,200,'Healthcare Supplies of Atlanta'),('CLSHD',0017,180,'Healthcare Supplies of Atlanta'),('WHHOD',0018,500,'Buy Personal Protective Equipment, Inc'),('GYGWN',0019,300,'Buy Personal Protective Equipment, Inc'),('BKSTE',0020,50,'S&J Corporation'),('WHSTE',0020,50,'S&J Corporation'),('CLSHD',0021,100,'Georgia Tech Protection Lab'),('ORGOG',0021,200,'Georgia Tech Protection Lab');
-- INSERT INTO used_by VALUES ('GRMSK',10000,3),('GRGOG',10000,3),('WHSTE',10000,1),('GRMSK',10001,5),('BKSTE',10001,1),('WHMSK',10002,4),('CLSHD',10003,2),('ORGOG',10003,1),('GRMSK',10003,2),('GRGOG',10003,1),('BKSTE',10003,1),('ORGOG',10004,2),('RDMSK',10004,4),('CLSHD',10004,2),('BLSHC',10004,4),('WHMSK',10005,4),('BLMSK',10005,4),('BLSHC',10005,8),('GRMSK',10006,2),('RDMSK',10007,3),('CLSHD',10007,3),('BLMSK',10008,5),('GRSHC',10009,4),('GRHOD',10009,4),('WHMSK',10009,4),('RDMSK',10010,3),('BLSHC',10010,3),('BLMSK',10011,8),('ORGOG',10012,1),('WHGOG',10012,1),('WHGLO',10012,2),('WHHOD',10013,2),('WHGOG',10014,2),('WHGWN',10014,2),('BLMSK',10015,4);

