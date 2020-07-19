/* select id, TransactionItem.manufacturer, Transaction.hospital, sum(price * TransactionItem.count) as total_price , Transaction.date
from Transaction, TransactionItem, CatalogItem
where Transaction.hospital = "Children's Healthcare of Atlanta" 
and Transaction.id = TransactionItem.transaction_id
and TransactionItem.product_id = CatalogItem.product_id
and CatalogItem.manufacturer = TransactionItem.manufacturer
group by id, TransactionItem.manufacturer
order by 
	case 
		when "DESC" = "DESC" then id
	end DESC,
	case
		when "ASC" = "ASC" then id
	end ASC;
*/
/*
select business as businessName, "Hospital" as businessType, count(*) as numOfAdmin
from Administrator join Hospital on Administrator.business = Hospital.name 
group by business
union
select business as businessName, "Manufacturer" as businessType, count(*) as numOfAdmin
from Administrator join Manufacturer on Administrator.business = Manufacturer.name
group by business; 
*/
/*
select Product.id as product_id, name_color as product_color, name_type as product_type, sum(UsageLogEntry.count) as num
from Product, UsageLogEntry
where Product.id = UsageLogEntry.product_id
group by id
order by num DESC;
*/
/*
select Transaction.hospital as hospitalName, sum(TransactionItem.count * CatalogItem.price) as totalExpenditure, count(*) as transaction_count, avg(TransactionItem.count * CatalogItem.price)
from Transaction, TransactionItem, CatalogItem
where Transaction.id = TransactionItem.transaction_id
and CatalogItem.product_id = TransactionItem.product_id
and TransactionItem.manufacturer = CatalogItem.manufacturer
group by hospitalName;
*/
/*
select Product.name_color, Product.name_type, CatalogItem.price, IFNULL(TransactionItem.count,0) as num_sold, CatalogItem.price * IFNULL(TransactionItem.count, 0) as revenue
from CatalogItem
left outer join TransactionItem on CatalogItem.manufacturer = TransactionItem.manufacturer and CatalogItem.product_id = TransactionItem.product_id
join Product on Product.id = CatalogItem.product_id
where CatalogItem.manufacturer = 'Marietta Mask Production Company'
order by revenue DESC;
*/
/*
select UsageLog.id as id, Doctor.username as doctor, UsageLog.timestamp as timestamp, UsageLogEntry.product_id, UsageLogEntry.count as count
from Doctor, UsageLog, UsageLogEntry
where (Doctor.manager = "drmcdaniel" or Doctor.username = "drmcdaniel")
and Doctor.username = UsageLog.doctor
and UsageLog.id = UsageLogEntry.usage_log_id;
*/
/*
select CatalogItem.manufacturer as manufacturer, InventoryHasProduct.count as count, CatalogItem.price as price
from InventoryHasProduct 
join CatalogItem on InventoryHasProduct.inventory_business = CatalogItem.manufacturer
and InventoryHasProduct.product_id = CatalogItem.product_id
where InventoryHasProduct.product_id = "";
*/
/*
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
*/
/*
select Doctor.hospital, sum(UsageLogEntry.count) as products_used
from UsageLog 
join Doctor on Doctor.username = UsageLog.doctor
join UsageLogEntry on UsageLog.id = UsageLogEntry.usage_log_id
group by Doctor.hospital
order by Doctor.hospital asc; 
*/
/*
select * from Business
where (i_search_parameter = "name" and Business.name like concat("%",i_search_value,"%")) 
or (i_search_parameter = "street" and Business.address_street like concat("%",i_search_value,"%"))
or (i_search_parameter = "city" and Business.address_city like concat("%",i_search_value,"%"))
or (i_search_parameter = "state" and Business.address_state like concat("%",i_search_value,"%"))
or (i_search_parameter = "zip" and Business.address_zip like concat("%",i_search_value,"%"));
*/
/*
select TransactionItem.transaction_id as id, Transaction.hospital as hospital, sum(CatalogItem.price * TransactionItem.count) as cost, sum(TransactionItem.count) as total_count
from TransactionItem 
join Transaction on TransactionItem.transaction_id = Transaction.id
join CatalogItem on TransactionItem.product_id = CatalogItem.product_id and TransactionItem.manufacturer = CatalogItem.manufacturer
where TransactionItem.manufacturer = "PPE Empire"
group by id;
*/

select distinct username, UserType 
from 
(select distinct DoctorManager.username, "Doctor-Admin-Manager" as UserType
from (select distinct username, "Doctor-Manager" as UserType
from Doctor join (select manager, hospital from Doctor) as Manager
on Doctor.username = Manager.manager and Doctor.hospital = Manager.hospital) as DoctorManager
join Administrator on DoctorManager.username = Administrator.username
union
select distinct username, "Doctor-Manager" as UserType
from Doctor join (select manager, hospital from Doctor) as Manager
on Doctor.username = Manager.manager and Doctor.hospital = Manager.hospital
union
select distinct Doctor.username, "Doctor-Admin" as UserType
from Doctor join Administrator on Doctor.username = Administrator.username 
union
select distinct username, "Admin" as UserType
from Administrator
union
select distinct username, "Doctor" as UserType
from Doctor) as roles;
