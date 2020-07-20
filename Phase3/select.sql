/************** SELECTS **************/
-- NOTE: "SELECT * FROM USER" is just a dummy query
-- to get the script to run. You will need to replace that line 
-- with your solution.

-- Number: S1
-- Author: ty.zhang@
-- Name: hospital_transactions_report
DROP PROCEDURE IF EXISTS hospital_transactions_report;
DELIMITER //
CREATE PROCEDURE hospital_transactions_report(
    IN i_hospital VARCHAR(100),
    IN i_sortBy ENUM('', 'id', 'date'),
    IN i_sortDirection ENUM('', 'DESC', 'ASC')
)
BEGIN
    DROP TABLE IF EXISTS hospital_transactions_report_result;
    CREATE TABLE hospital_transactions_report_result(
        id CHAR(4),
        manufacturer VARCHAR(100),
        hospital VARCHAR(100),
        total_price FLOAT,
        date DATE);

    INSERT INTO hospital_transactions_report_result
-- Type solution below
	select id, TransactionItem.manufacturer, Transaction.hospital, sum(price * TransactionItem.count) as total_price , Transaction.date
	from Transaction, TransactionItem, CatalogItem
	where Transaction.hospital = i_hospital
	and Transaction.id = TransactionItem.transaction_id
	and TransactionItem.product_id = CatalogItem.product_id
	and CatalogItem.manufacturer = TransactionItem.manufacturer
	group by id, TransactionItem.manufacturer
	order by 
		case 
			when i_sortDirection = "DESC" and i_sortBy = "id" then id
		end DESC,
		case 
			when i_sortDirection = "DESC" and i_sortBy = "date" then Transaction.date
		end DESC,
		case 
			when i_sortDirection = "ASC" and i_sortBy = "id" then id
		end ASC,
		case 
			when i_sortDirection = "ASC" and i_sortBy = "date" then Transaction.date
		end ASC;

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
	select business as businessName, "Hospital" as businessType, count(*) as numOfAdmin
	from Administrator join Hospital on Administrator.business = Hospital.name 
	group by business
	union
	select business as businessName, "Manufacturer" as businessType, count(*) as numOfAdmin
	from Administrator join Manufacturer on Administrator.business = Manufacturer.name
	group by business; 
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
        product_id CHAR(5),
        product_color VARCHAR(30),
        product_type VARCHAR(30),
        num INT);

    INSERT INTO product_usage_list_result
-- Type solution below
	select Product.id as product_id, name_color as product_color, name_type as product_type, sum(UsageLogEntry.count) as num
	from Product, UsageLogEntry
	where Product.id = UsageLogEntry.product_id
	group by id
	order by num DESC;
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
	select Transaction.hospital as hospitalName, sum(T.totalExpenditure) as totalExpenditure, count(*) as transaction_count, sum(T.totalExpenditure)/count(*) as avg_cost
	from Transaction join
	(select Transaction.id as id, Transaction.hospital as hospitalName, sum(TransactionItem.count * CatalogItem.price) as totalExpenditure
	from Transaction, TransactionItem, CatalogItem
	where Transaction.id = TransactionItem.transaction_id
	and CatalogItem.product_id = TransactionItem.product_id
	and TransactionItem.manufacturer = CatalogItem.manufacturer
	group by Transaction.id, hospitalName) as T
	on Transaction.hospital = T.hospitalName and Transaction.id = T.id
	group by hospitalName;
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
	select Product.name_color, Product.name_type, CatalogItem.price, IFNULL(TransactionItem.count,0) as num_sold, CatalogItem.price * IFNULL(TransactionItem.count, 0) as revenue
	from CatalogItem
	left outer join TransactionItem on CatalogItem.manufacturer = TransactionItem.manufacturer and CatalogItem.product_id = TransactionItem.product_id
	join Product on Product.id = CatalogItem.product_id
	where CatalogItem.manufacturer = i_manufacturer 
	order by revenue DESC;
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
        product_id CHAR(5),
        count INT);

    INSERT INTO doctor_subordinate_usage_log_report_result
-- Type solution below
	select UsageLog.id as id, Doctor.username as doctor, UsageLog.timestamp as timestamp, UsageLogEntry.product_id, UsageLogEntry.count as count
	from Doctor, UsageLog, UsageLogEntry
	where (Doctor.manager = i_drUsername or Doctor.username = i_drUsername)
	and Doctor.username = UsageLog.doctor
	and UsageLog.id = UsageLogEntry.usage_log_id;
    -- End of solution
END //
DELIMITER ;

-- Number: S7
-- Author: klin83@
-- Name: explore_product
DROP PROCEDURE IF EXISTS explore_product;
DELIMITER //
CREATE PROCEDURE explore_product(
    IN i_product_id CHAR(5))
BEGIN
    DROP TABLE IF EXISTS explore_product_result;
    CREATE TABLE explore_product_result(
        manufacturer VARCHAR(100),
        count INT,
        price FLOAT(2));

    INSERT INTO explore_product_result
-- Type solution below
	select CatalogItem.manufacturer as manufacturer, InventoryHasProduct.count as count, CatalogItem.price as price
	from InventoryHasProduct 
	join CatalogItem on InventoryHasProduct.inventory_business = CatalogItem.manufacturer
	and InventoryHasProduct.product_id = CatalogItem.product_id
	where InventoryHasProduct.product_id = i_product_id;
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
        product_id CHAR(5),
        num_used INT,
        num_available INT,
        ratio FLOAT);

    INSERT INTO show_product_usage_result
-- Type solution below
	select Inventory.product_id, sum(ifnull(UsageLog.count, 0)) as num_used, sum(ifnull(Inventory.count, 0)) as num_avaliable,  sum(ifnull(UsageLog.count, 0)) / sum(ifnull(Inventory.count, 0)) as ratio
	from 
	(select product_id, sum(count) as count 
	from InventoryHasProduct
	where inventory_business in (select distinct manufacturer from CatalogItem)
	group by product_id
	order by product_id) as Inventory
	left outer join 
	(select product_id, sum(count) as count 
	from UsageLogEntry
	group by product_id) as UsageLog
	on Inventory.product_id = UsageLog.product_id
	group by product_id; 
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
	select Doctor.hospital, sum(UsageLogEntry.count) as products_used
	from UsageLog 
	join Doctor on Doctor.username = UsageLog.doctor
	join UsageLogEntry on UsageLog.id = UsageLogEntry.usage_log_id
	group by Doctor.hospital
	order by Doctor.hospital asc; 
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
	select * from Business
	where (i_search_parameter = "name" and Business.name like concat("%",i_search_value,"%")) 
	or (i_search_parameter = "street" and Business.address_street like concat("%",i_search_value,"%"))
	or (i_search_parameter = "city" and Business.address_city like concat("%",i_search_value,"%"))
	or (i_search_parameter = "state" and Business.address_state like concat("%",i_search_value,"%"))
	or (i_search_parameter = "zip" and Business.address_zip like concat("%",i_search_value,"%"));
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
	select TransactionItem.transaction_id as id, Transaction.hospital as hospital, sum(CatalogItem.price * TransactionItem.count) as cost, sum(TransactionItem.count) as total_count
	from TransactionItem 
	join Transaction on TransactionItem.transaction_id = Transaction.id
	join CatalogItem on TransactionItem.product_id = CatalogItem.product_id and TransactionItem.manufacturer = CatalogItem.manufacturer
	where TransactionItem.manufacturer = i_manufacturer
	group by id;
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


-- S4
	select Hospital.name as hospitalName, ifnull(sum(T.totalExpenditure),0) as totalExpenditure, ifnull(count(distinct T.id),0) as transaction_count, round(ifnull(sum(T.totalExpenditure),0)/ ifnull(count(*),1),2) as avg_cost
	from Hospital 
    left outer join
	(select Transaction.id as id, Transaction.hospital as hospitalName, sum(ifnull(TransactionItem.count,0) * ifnull(CatalogItem.price,0)) as totalExpenditure
	from Transaction, TransactionItem, CatalogItem
	where Transaction.id = TransactionItem.transaction_id
	and CatalogItem.product_id = TransactionItem.product_id
	and TransactionItem.manufacturer = CatalogItem.manufacturer
	group by Transaction.id, hospitalName)  as T
	on Hospital.name = T.hospitalName -- and Transaction.id = T.id
	group by Hospital.name;

-- S9
	select Doctor.hospital, sum(ifnull(UsageLogEntry.count,0)) as products_used
	from UsageLog 
	join Doctor on Doctor.username = UsageLog.doctor
	join UsageLogEntry on UsageLog.id = UsageLogEntry.usage_log_id
	group by Doctor.hospital
	order by Doctor.hospital asc; 

	select Hospital.name as hospital, ifnull(H.products_used,0) as products_used
    from Hospital
    left outer join
	(select Doctor.hospital as hospital, sum(ifnull(UsageLogEntry.count,0)) as products_used
	from UsageLog 
	join Doctor on Doctor.username = UsageLog.doctor
	join UsageLogEntry on UsageLog.id = UsageLogEntry.usage_log_id
	group by Doctor.hospital) as H
    on Hospital.name = H.hospital
    order by hospital asc;
-- S8
	select I.product_id, sum(ifnull(U.count, 0)) as num_used, sum(ifnull(I.count, 0)) as num_avaliable,  round(sum(ifnull(U.count, 0)) / sum(ifnull(I.count, 0)), 2) as ratio
	from 
	(select product_id, sum(count) as count 
	from InventoryHasProduct
	where inventory_business in (select distinct name from Manufacturer)
	group by product_id) as I
	left outer join 
	(select product_id, sum(count) as count 
	from UsageLogEntry
	group by product_id) as U
	on I.product_id = U.product_id
	group by product_id
	union 
SELECT distinct InventoryHasProduct.product_id, IFNULL(UsageLogEntry.count, 0) as num_used, 0 as num_available, 0 as ratio 
FROM ga_ppe.InventoryHasProduct
left outer join UsageLogEntry
on InventoryHasProduct.product_id = UsageLogEntry.product_id
where inventory_business not in (select name from manufacturer)
and InventoryHasProduct.product_id not in
(select distinct product_id from InventoryHasProduct 
where inventory_business in 
(select name from manufacturer))
group by Product.id;


select Product.id, sum(ifnull(UsageLogEntry.count,0)) as num_used, sum(ifnull(InventoryHasProduct.count, 0)) as num_avaliable, round(sum(ifnull(UsageLogEntry.count, 0)) / sum(ifnull(InventoryHasProduct.count, 0)), 2) as ratio
from Product
left outer join UsageLogEntry 
on Product.id = UsageLogEntry.product_id
left join InventoryHasProduct
on Product.id = InventoryHasProduct.product_id
where InventoryHasProduct.inventory_business in 
(select name from manufacturer)
group by id; 


