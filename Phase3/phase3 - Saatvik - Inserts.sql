/*
CS4400: Introduction to Database Systems
Summer 2020
Phase III Template

Team ##
Team Member Name (GT username)
Team Member Name (GT username)
Team Member Name (GT username)
Team Member Name (GT username)

Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

/************** UTIL **************/
/* Feel free to add any utilty procedures you may need here */

-- Number:
-- Author: kachtani3@
-- Name: create_zero_inventory
-- Tested By: kachtani3@
DROP PROCEDURE IF EXISTS create_zero_inventory;
DELIMITER //
CREATE PROCEDURE create_zero_inventory(
    IN i_businessName VARCHAR(100),
    IN i_productId CHAR(5)
)
BEGIN
-- Type solution below
    IF (i_productId NOT IN (
        SELECT product_id FROM InventoryHasProduct WHERE inventory_business = i_businessName))
    THEN INSERT INTO InventoryHasProduct (inventory_business, product_id, count)
        VALUES (i_businessName, i_productId, 0);
    END IF;

-- End of solution
END //
DELIMITER ;


/************** INSERTS **************/

-- Number: I1
-- Author: kachtani3@
-- Name: add_usage_log
DROP PROCEDURE IF EXISTS add_usage_log;
DELIMITER //
CREATE PROCEDURE add_usage_log(
    IN i_usage_log_id CHAR(5),
    IN i_doctor_username VARCHAR(100),
    IN i_timestamp TIMESTAMP
)
BEGIN
-- Type solution below
    IF (i_usage_log_id NOT IN (
        SELECT id FROM usagelog )
        AND
        i_doctor_username IN (
        SELECT username FROM doctor))
    THEN INSERT INTO usagelog (id, doctor, timestamp)
        VALUES (i_usage_log_id, i_doctor_username, i_timestamp);
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: I2
-- Author: ty.zhang@
-- Name: add_usage_log_entry
DROP PROCEDURE IF EXISTS add_usage_log_entry;
DELIMITER //
CREATE PROCEDURE add_usage_log_entry(
    IN i_usage_log_id CHAR(5),
    IN i_product_id CHAR(5),
    IN i_count INT
)
BEGIN
-- Type solution below
    IF (i_usage_log_id IN ( -- checking if usagelog exists
        SELECT id FROM usagelog )
        AND
        concat(i_usage_log_id, i_product_id) NOT IN ( -- checking for duplicates
        SELECT concat(usage_log_id, product_id) FROM usagelogentry)
        AND
        i_count < (SELECT count FROM inventoryhasproduct WHERE inventory_business = (SELECT hospital FROM doctor WHERE username = (SELECT doctor FROM usagelog WHERE i_usage_log_id = id)) AND
            i_product_id = product_id)
        )
    THEN 
        INSERT INTO usagelogentry (usage_log_id, product_id, count)
        VALUES (i_usage_log_id, i_product_id, i_count);
        UPDATE inventoryhasproduct SET count = count - i_count WHERE 
            (SELECT hospital FROM doctor WHERE username = (SELECT doctor FROM usagelog WHERE i_usage_log_id = id)) = inventory_business
            AND i_product_id = product_id;
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: I3
-- Author: yxie@
-- Name: add_business
DROP PROCEDURE IF EXISTS add_business;
DELIMITER //
CREATE PROCEDURE add_business(
    IN i_name VARCHAR(100),
    IN i_BusinessStreet VARCHAR(100),
    IN i_BusinessCity VARCHAR(100),
    IN i_BusinessState VARCHAR(30),
    IN i_BusinessZip CHAR(5),
    IN i_businessType ENUM('Hospital', 'Manufacturer'),
    IN i_maxDoctors INT,
    IN i_budget FLOAT(2),
    IN i_catalog_capacity INT,
    IN i_InventoryStreet VARCHAR(100),
    IN i_InventoryCity VARCHAR(100),
    IN i_InventoryState VARCHAR(30),
    IN i_InventoryZip CHAR(5)
)
BEGIN
-- Type solution below
    IF (i_name NOT IN ( -- you may have to add not null statements here
        SELECT name FROM business )
        AND
        concat(i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip) NOT IN (
        SELECT concat(address_street, address_city, address_state, address_zip) FROM business)
        AND
        i_businessType = 'Hospital')
    THEN INSERT INTO business (name, address_street, address_city, address_state, address_zip)
        VALUES (i_name, i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip);
        INSERT INTO hospital (name, max_doctors, budget)
        VALUES (i_name, i_maxDoctors, i_budget); 
        INSERT INTO invetory (owner, address_street, address_city, address_state, address_zip) -- you may have to add not null statements here
        VALUES (i_name, i_InventoryStreet, i_InventoryCity, i_InventoryState, i_InventoryZip);
    END IF;
    
    IF (i_name NOT IN ( -- you may have to add not null statements here
        SELECT name FROM business )
        AND
        concat(i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip) NOT IN (
        SELECT concat(address_street, address_city, address_state, address_zip) FROM business)
        AND
        i_businessType = 'Manufacturer')
    THEN INSERT INTO business (name, address_street, address_city, address_state, address_zip)
        VALUES (i_name, i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip);
        INSERT INTO manufacturer (name, catalog_capacity)
        VALUES (i_name, i_catalog_capacity); 
        INSERT INTO invetory (owner, address_street, address_city, address_state, address_zip) -- you may have to add not null statements here
        VALUES (i_name, i_InventoryStreet, i_InventoryCity, i_InventoryState, i_InventoryZip);
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: I4
-- Author: kachtani3@
-- Name: add_transaction
DROP PROCEDURE IF EXISTS add_transaction;
DELIMITER //
CREATE PROCEDURE add_transaction(
    IN i_transaction_id CHAR(4),
    IN i_hospital VARCHAR(100),
    IN i_date DATE
)
BEGIN
-- Type solution below

INSERT INTO Transaction(id, hospital, date) VALUES (i_transaction_id, i_hospital, i_date);

-- End of solution
END //
DELIMITER ;

-- Number: I5
-- Author: kachtani3@
-- Name: add_transaction_item
DROP PROCEDURE IF EXISTS add_transaction_item;
DELIMITER //
CREATE PROCEDURE add_transaction_item(
    IN i_transactionId CHAR(4),
    IN i_productId CHAR(5),
    IN i_manufacturerName VARCHAR(100),
    IN i_purchaseCount INT)
BEGIN
-- Type solution below
    IF (
        (concat(i_manufacturerName, i_productId) IN (SELECT concat(inventory_business, product_id) FROM inventoryhasproduct))
        AND
        (concat(i_transactionId, i_productId, i_manufacturerName) NOT IN (
        SELECT concat(transaction_id, product_id, manufacturer) FROM transactionitem)) -- checking for duplicate entries
        AND
        (((i_transactionId IN (SELECT id FROM transaction)) -- checking if empty transaction exists
        AND
        (i_transactionId NOT IN (SELECT transaction_id FROM transactionitem)))
        OR
        (concat(i_transactionId, i_manufacturerName) IN (SELECT concat(transaction_id, manufacturer) FROM transactionitem))) -- checks if transaction exists in transactionitem
        AND
        ((SELECT budget FROM hospital WHERE (SELECT hospital FROM transaction WHERE id = i_transactionId) = name) > -- checking if hospital can afford
        ((SELECT price FROM catalogitem WHERE product_id = i_productId AND manufacturer = i_manufacturerName) * i_purchaseCount))
        AND
        (i_purchaseCount <= (SELECT count FROM inventoryhasproduct WHERE (product_id = i_productId AND inventory_business = i_manufacturerName))) -- checking if manufacturer has enough inventory
         )
    THEN 
        INSERT INTO transactionitem (product_id, transaction_id, count, manufacturer)
        VALUES (i_productId, i_transactionId, i_purchaseCount, i_manufacturerName);
        UPDATE inventoryhasproduct SET count = count - i_purchaseCount 
            WHERE i_manufacturerName = inventory_business AND i_productId = product_id;
        UPDATE inventoryhasproduct SET count = count + i_purchaseCount 
            WHERE (SELECT hospital FROM transaction WHERE id = i_transactionId) = inventory_business AND i_productId = product_id;
        UPDATE hospital SET budget = budget - ((SELECT price FROM catalogitem WHERE product_id = i_productId) * i_purchaseCount) 
            WHERE (SELECT hospital FROM transaction WHERE id = i_transactionId) = name;
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: I6
-- Author: yxie@
-- Name: add_user
DROP PROCEDURE IF EXISTS add_user;
DELIMITER //
CREATE PROCEDURE add_user(
    IN i_username VARCHAR(100),
    IN i_email VARCHAR(100),
    IN i_password VARCHAR(100),
    IN i_fname VARCHAR(50),
    IN i_lname VARCHAR(50),
    IN i_userType ENUM('Doctor', 'Admin', 'Doctor-Admin'),
    IN i_managingBusiness VARCHAR(100),
    IN i_workingHospital VARCHAR(100)
)
BEGIN
-- Type solution below
    IF (i_username NOT IN (
        SELECT username FROM user )
        AND
        i_email NOT IN (
        SELECT email FROM user)
        )
    THEN             
        IF ((i_userType = 1) AND (i_workingHospital IN (SELECT name FROM hospital)))
        THEN 
        INSERT INTO user (username, email, password, fname, lname)
        VALUES (i_username, i_email, SHA(i_password), i_fname, i_lname);
        INSERT INTO doctor (username, hospital, manager)
        VALUES (i_username, i_workingHospital, null); -- (SELECT username FROM administrator WHERE business = i_workingHospital)); -- this should auto null?, what about manager?
        END IF;
        
        IF ((i_userType = 2) AND (i_managingBusiness IN (SELECT name FROM business))) 
        THEN 
        INSERT INTO user (username, email, password, fname, lname)
        VALUES (i_username, i_email, SHA(i_password), i_fname, i_lname);
        INSERT INTO administrator (username, business)
            VALUES (i_username, i_managingBusiness);
        END IF;
        
        IF ((i_userType = 3) AND (i_managingBusiness IN (SELECT name FROM business)) AND (i_workingHospital IN (SELECT name FROM hospital)))
        THEN 
        INSERT INTO user (username, email, password, fname, lname)
        VALUES (i_username, i_email, SHA(i_password), i_fname, i_lname);
        INSERT INTO doctor (username, hospital, manager)
            VALUES (i_username, i_workingHospital, null); -- look at above comment
            INSERT INTO administrator (username, business)
            VALUES (i_username, i_managingBusiness);
        END IF;
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: I7
-- Author: klin83@
-- Name: add_catalogitem
DROP PROCEDURE IF EXISTS add_catalog_item;
DELIMITER //
CREATE PROCEDURE add_catalog_item(
    IN i_manufacturerName VARCHAR(100),
    IN i_product_id CHAR(5),
    IN i_price FLOAT(2)
)
BEGIN
-- Type solution below
    IF (i_manufacturerName IN (
        SELECT name FROM manufacturer)
        AND
        (SELECT catalog_capacity FROM manufacturer WHERE i_manufacturerName = name) > 
        (SELECT count(product_id) FROM inventoryhasproduct WHERE i_manufacturerName = inventory_business))
    THEN INSERT INTO catalogitem (manufacturer, product_id, price)
        VALUES (i_manufacturerName, i_product_id, i_price);
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: I8
-- Author: ftsang3@
-- Name: add_product
DROP PROCEDURE IF EXISTS add_product;
DELIMITER //
CREATE PROCEDURE add_product(
    IN i_prod_id CHAR(5),
    IN i_color VARCHAR(30),
    IN i_name VARCHAR(30)
)
BEGIN
-- Type solution below
    IF ((i_prod_id NOT IN (
        SELECT id FROM product )) 
        AND 
        (concat(i_color, i_name) NOT IN (
        SELECT concat(name_color, name_type) FROM product)))
    THEN INSERT INTO product (id, name_color, name_type)
        VALUES (i_prod_id, i_color, i_name);
    END IF;
-- End of solution
END //
DELIMITER ;


/************** DELETES **************/
-- NOTE: Do not circumvent referential ON DELETE triggers by manually deleting parent rows

-- Number: D1
-- Author: ty.zhang@
-- Name: delete_product
DROP PROCEDURE IF EXISTS delete_product;
DELIMITER //
CREATE PROCEDURE delete_product(
    IN i_product_id CHAR(5)
)
BEGIN
-- Type solution below

-- End of solution
END //
DELIMITER ;

-- Number: D2
-- Author: kachtani3@
-- Name: delete_zero_inventory
DROP PROCEDURE IF EXISTS delete_zero_inventory;
DELIMITER //
CREATE PROCEDURE delete_zero_inventory()
BEGIN
-- Type solution below

-- End of solution
END //
DELIMITER ;

-- Number: D3
-- Author: ftsang3@
-- Name: delete_business
DROP PROCEDURE IF EXISTS delete_business;
DELIMITER //
CREATE PROCEDURE delete_business(
    IN i_businessName VARCHAR(100)
)
BEGIN
-- Type solution below
    DELETE FROM Business where name = i_businessName;
-- End of solution
END //
DELIMITER ;

-- Number: D4
-- Author: ftsang3@
-- Name: delete_user
DROP PROCEDURE IF EXISTS delete_user;
DELIMITER //
CREATE PROCEDURE delete_user(
    IN i_username VARCHAR(100)
)
BEGIN
-- Type solution below

-- End of solution
END //
DELIMITER ;

-- Number: D5
-- Author: klin83@
-- Name: delete_catalogitem
DROP PROCEDURE IF EXISTS delete_catalogitem;
DELIMITER //
CREATE PROCEDURE delete_catalogitem(
    IN i_manufacturer_name VARCHAR(100),
    IN i_productransaction_id CHAR(5)
)
BEGIN
-- Type solution below

-- End of solution
END //
DELIMITER ;


/************** UPDATES **************/

-- Number: U1
-- Author: kachtani3@
-- Name: add_subtract_inventory
DROP PROCEDURE IF EXISTS add_subtract_inventory;
DELIMITER //
CREATE PROCEDURE add_subtract_inventory(
    IN i_prod_id CHAR(5),
    IN i_businessName VARCHAR(100),
    IN i_delta INT
)
BEGIN
-- Type solution below
if abs(i_delta) <= (select count from inventoryhasproduct where inventory_business = i_businessName and product_id = i_prod_id) then
	if i_delta > 0 then
			update inventoryhasproduct
			set count = count + i_delta
			where inventory_business = i_businessName
			and product_id = i_prod_id;
	end if;

	if i_delta < 0 then
			update inventoryhasproduct
			set count = count - i_delta
			where inventory_business = i_businessName
			and product_id = i_prod_id;
	end if;
end if;

call delete_zero_inventory();

-- End of solution
END //
DELIMITER ;

-- Number: U2
-- Author: kachtani3@
-- Name: move_inventory
DROP PROCEDURE IF EXISTS move_inventory;
DELIMITER //
CREATE PROCEDURE move_inventory(
    IN i_supplierName VARCHAR(100),
    IN i_consumerName VARCHAR(100),
    IN i_productId CHAR(5),
    IN i_count INT)
BEGIN
-- Type solution below
if (select count from inventoryhasproduct where inventory_business = i_supplierName and product_id = i_productId) >= i_count then
	## subtract product from supplier 
    update inventoryhasproduct
    set count = count - i_count
    where inventory_business = i_supplierName and product_id = i_productId;
    
    ## add product to the consumer
    update inventoryhasproduct
    set count = count + i_count
    where inventory_business = i_consumerName and product_id = i_productId;
end if;
call delete_zero_inventory();
-- End of solution
END //
DELIMITER ;

-- Number: U3
-- Author: ty.zhang@
-- Name: rename_productransaction_id
DROP PROCEDURE IF EXISTS rename_productransaction_id;
DELIMITER //
CREATE PROCEDURE rename_productransaction_id(
    IN i_productransaction_id CHAR(5),
    IN i_new_productransaction_id CHAR(5)
)
BEGIN
-- Type solution below
update product
set id = i_new_product_id
where id = i_product_id;
-- End of solution
END //
DELIMITER ;

-- Number: U4
-- Author: ty.zhang@
-- Name: update_business_address
DROP PROCEDURE IF EXISTS update_business_address;
DELIMITER //
CREATE PROCEDURE update_business_address(
    IN i_name VARCHAR(100),
    IN i_address_street VARCHAR(100),
    IN i_address_city VARCHAR(100),
    IN i_address_state VARCHAR(30),
    IN i_address_zip CHAR(5)
)
BEGIN
-- Type solution below
update business
set address_street = i_address_street and address_city = i_address_city and address_zip = i_address_zip
where name = i_name;
-- End of solution
END //
DELIMITER ;

-- Number: U5
-- Author: kachtani3@
-- Name: charge_hospital
DROP PROCEDURE IF EXISTS charge_hospital;
DELIMITER //
CREATE PROCEDURE charge_hospital(
    IN i_name VARCHAR(100),
    IN i_amount FLOAT(2))
BEGIN
-- Type solution below
if i_amount <= (select budget from hospital where name = i_hospital_name) then
	update hospital
    set budget = budget - i_amount
    where name = i_hospital_name;
end if;
-- End of solution
END //
DELIMITER ;

-- Number: U6
-- Author: yxie@
-- Name: update_business_admin
DROP PROCEDURE IF EXISTS update_business_admin;
DELIMITER //
CREATE PROCEDURE update_business_admin(
    IN i_admin_username VARCHAR(100),
    IN i_name VARCHAR(100)
)
BEGIN
-- Type solution below
if (select count(username) from administrator where business = i_business_name group by business) > 1 then
	update administator
	set business = i_business_name
	where username = i_admin_username;
end if;
-- End of solution
END //
DELIMITER ;

-- Number: U7
-- Author: ftsang3@
-- Name: update_doctor_manager
DROP PROCEDURE IF EXISTS update_doctor_manager;
DELIMITER //
CREATE PROCEDURE update_doctor_manager(
    IN i_doctor_username VARCHAR(100),
    IN i_manager_username VARCHAR(100)
)
BEGIN
-- Type solution below
IF i_doctor_username <> i_manager_username
    THEN
        UPDATE Doctor SET manager = i_manager_username WHERE username = i_doctor_username;
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: U8
-- Author: ftsang3@
-- Name: update_user_password
DROP PROCEDURE IF EXISTS update_user_password;
DELIMITER //
CREATE PROCEDURE update_user_password(
    IN i_username VARCHAR(100),
    IN i_new_password VARCHAR(100)
)
BEGIN
-- Type solution below
update user
set password = SHA(i_new_password)
where username = i_username;
-- End of solution
END //
DELIMITER ;

-- Number: U9
-- Author: klin83@
-- Name: batch_update_catalogitem
DROP PROCEDURE IF EXISTS batch_update_catalogitem;
DELIMITER //
CREATE PROCEDURE batch_update_catalogitem(
    IN i_manufacturer_name VARCHAR(100),
    IN i_factor FLOAT(2))
BEGIN
-- Type solution below
update catalogitem
set price = price * i_factor
where manufacturer = i_manufacturer_name;
-- End of solution
END //
DELIMITER ;

/************** SELECTS **************/
-- NOTE: "SELECT * FROM USER" is just a dummy query
-- to get the script to run. You will need to replace that line
-- with your solution.

-- Number: S1
-- Author: ty.zhang@
-- Name: hospital_transaction_report
DROP PROCEDURE IF EXISTS hospital_transaction_report;
DELIMITER //
CREATE PROCEDURE hospital_transaction_report(
    IN i_hospital VARCHAR(100),
    IN i_sortBy ENUM('', 'id', 'date'),
    IN i_sortDirection ENUM('', 'DESC', 'ASC')
)
BEGIN
    DROP TABLE IF EXISTS hospital_transaction_report_result;
    CREATE TABLE hospital_transaction_report_result(
        id CHAR(4),
        manufacturer VARCHAR(100),
        hospital VARCHAR(100),
        total_price FLOAT,
        date DATE);

    INSERT INTO hospital_transaction_report_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S2
-- Author: ty.zhang@
-- Name: num_of_admin_list
DROP PROCEDURE IF EXISTS num_of_admin_list;
DELIMITER //
CREATE PROCEDURE num_of_admin_list()
BEGIN
    DROP TABLE IF EXISTS num_of_admin_list_result;
    CREATE TABLE num_of_admin_list_result(
        businessName VARCHAR(100),
        businessType VARCHAR(100),
        numOfAdmin INT);

    INSERT INTO num_of_admin_list_result
-- Type solution below
    SELECT H.name, 'Hospital', count(*)
    FROM Hospital AS H, Administrator AS A
    WHERE name = business
    GROUP BY H.name
    UNION
    SELECT M.name, 'Manufacturer', count(*)
    FROM Manufacturer AS M, Administrator AS A
    WHERE name = business
    GROUP BY M.name;
-- End of solution
END //
DELIMITER ;

-- Number: S3
-- Author: ty.zhang@
-- Name: product_usage_list
DROP PROCEDURE IF EXISTS product_usage_list;
DELIMITER //
CREATE PROCEDURE product_usage_list()

BEGIN
    DROP TABLE IF EXISTS product_usage_list_result;
    CREATE TABLE product_usage_list_result(
        productransaction_id CHAR(5),
        product_color VARCHAR(30),
        product_type VARCHAR(30),
        num INT);

    INSERT INTO product_usage_list_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S4
-- Author: ty.zhang@
-- Name: hospital_total_expenditure
DROP PROCEDURE IF EXISTS hospital_total_expenditure;
DELIMITER //
CREATE PROCEDURE hospital_total_expenditure()

BEGIN
    DROP TABLE IF EXISTS hospital_total_expenditure_result;
    CREATE TABLE hospital_total_expenditure_result(
        hospitalName VARCHAR(100),
        totalExpenditure FLOAT,
        transaction_count INT,
        avg_cost FLOAT);

    INSERT INTO hospital_total_expenditure_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S5
-- Author: kachtani3@
-- Name: manufacturer_catalog_report
DROP PROCEDURE IF EXISTS manufacturer_catalog_report;
DELIMITER //
CREATE PROCEDURE manufacturer_catalog_report(
    IN i_manufacturer VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS manufacturer_catalog_report_result;
    CREATE TABLE manufacturer_catalog_report_result(
        name_color VARCHAR(30),
        name_type VARCHAR(30),
        price FLOAT(2),
        num_sold INT,
        revenue FLOAT(2));

    INSERT INTO manufacturer_catalog_report_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S6
-- Author: kachtani3@
-- Name: doctor_subordinate_usage_log_report
DROP PROCEDURE IF EXISTS doctor_subordinate_usage_log_report;
DELIMITER //
CREATE PROCEDURE doctor_subordinate_usage_log_report(
    IN i_drUsername VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS doctor_subordinate_usage_log_report_result;
    CREATE TABLE doctor_subordinate_usage_log_report_result(
        id CHAR(5),
        doctor VARCHAR(100),
        timestamp TIMESTAMP,
        productransaction_id CHAR(5),
        count INT);

    INSERT INTO doctor_subordinate_usage_log_report_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S7
-- Author: klin83@
-- Name: explore_product
DROP PROCEDURE IF EXISTS explore_product;
DELIMITER //
CREATE PROCEDURE explore_product(
    IN i_productransaction_id CHAR(5))
BEGIN
    DROP TABLE IF EXISTS explore_product_result;
    CREATE TABLE explore_product_result(
        manufacturer VARCHAR(100),
        count INT,
        price FLOAT(2));

    INSERT INTO explore_product_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S8
-- Author: klin83@
-- Name: show_product_usage
DROP PROCEDURE IF EXISTS show_product_usage;
DELIMITER //
CREATE PROCEDURE show_product_usage()
BEGIN
    DROP TABLE IF EXISTS show_product_usage_result;
    CREATE TABLE show_product_usage_result(
        productransaction_id CHAR(5),
        num_used INT,
        num_available INT,
        ratio FLOAT);

    INSERT INTO show_product_usage_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S9
-- Author: klin83@
-- Name: show_hospital_aggregate_usage
DROP PROCEDURE IF EXISTS show_hospital_aggregate_usage;
DELIMITER //
CREATE PROCEDURE show_hospital_aggregate_usage()
BEGIN
    DROP TABLE IF EXISTS show_hospital_aggregate_usage_result;
    CREATE TABLE show_hospital_aggregate_usage_result(
        hospital VARCHAR(100),
        items_used INT);

    INSERT INTO show_hospital_aggregate_usage_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S10
-- Author: ftsang3
-- Name: business_search
DROP PROCEDURE IF EXISTS business_search;
DELIMITER //
CREATE PROCEDURE business_search (
    IN i_search_parameter ENUM("name","street", "city", "state", "zip"),
    IN i_search_value VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS business_search_result;
    CREATE TABLE business_search_result(
        name VARCHAR(100),
        address_street VARCHAR(100),
        address_city VARCHAR(100),
        address_state VARCHAR(30),
        address_zip CHAR(5));

    INSERT INTO business_search_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S11
-- Author: ftsang3@
-- Name: manufacturer_transaction_report
DROP PROCEDURE IF EXISTS manufacturer_transaction_report;
DELIMITER //
CREATE PROCEDURE manufacturer_transaction_report(
    IN i_manufacturer VARCHAR(100))

BEGIN
    DROP TABLE IF EXISTS manufacturer_transaction_report_result;
    CREATE TABLE manufacturer_transaction_report_result(
        id CHAR(4),
        hospital VARCHAR(100),
        `date` DATE,
        cost FLOAT(2),
        total_count INT);

    INSERT INTO manufacturer_transaction_report_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;

-- Number: S12
-- Author: yxie@
-- Name: get_user_types
-- Tested By: yxie@
DROP PROCEDURE IF EXISTS get_user_types;
DELIMITER //
CREATE PROCEDURE get_user_types()
BEGIN
DROP TABLE IF EXISTS get_user_types_result;
    CREATE TABLE get_user_types_result(
        username VARCHAR(100),
        UserType VARCHAR(50));
    INSERT INTO get_user_types_result
-- Type solution below
    SELECT * FROM User;
-- End of solution
END //
DELIMITER ;