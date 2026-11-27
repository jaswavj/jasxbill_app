/* ============================================================
   JASXBILL cloud / existing shop DB
   Run once per client database.
   If a column already exists, skip that ALTER (duplicate-column error is OK).
   is_active is NOT overwritten on existing rows — hide flags stay.
   ============================================================ */

ALTER TABLE user_modules ADD COLUMN is_group int NOT NULL DEFAULT 1;
ALTER TABLE user_modules ADD COLUMN group_id int NOT NULL DEFAULT 0;
ALTER TABLE user_modules ADD COLUMN is_active int NOT NULL DEFAULT 1;

INSERT INTO user_modules (id, module_name, is_group, group_id, is_active) VALUES
(1,'Billing',1,0,1),
(2,'Master',1,0,1),
(3,'Stock Reports',1,0,1),
(4,'User management',1,0,1),
(5,'Inventory',1,0,1),
(6,'Account Report',1,0,1),
(7,'Admin',1,0,1),
(8,'Statistics',1,0,1),
(10,'Credit Management',1,0,1),
(11,'Order list',1,0,1),
(12,'Expense',1,0,1),
(101,'Category',0,2,1),
(102,'Brands',0,2,1),
(103,'Product',0,2,1),
(104,'Config Product Material',0,2,1),
(105,'Product Master',0,2,1),
(106,'Stock Management',0,2,1),
(107,'Customers',0,2,1),
(108,'Cafe Tables',0,2,1),
(109,'Units',0,2,1),
(110,'Bar Code',0,2,1),
(111,'Supplier',0,5,1),
(112,'Purchase Entry',0,5,1),
(113,'Purchase Return',0,5,1),
(114,'Purchase Report',0,5,1),
(115,'Purchase Return Report',0,5,1),
(116,'Supplier Payment Report',0,5,1),
(117,'Profit Analysis Report',0,8,1),
(118,'Dashboard',0,8,1),
(119,'Category Sales Statistics',0,8,1),
(120,'Product Analysis Report',0,8,1),
(121,'Current Stock',0,3,1),
(122,'Zero Stock Report',0,3,1),
(123,'Product Transaction',0,3,1),
(124,'Stock Adjustment',0,3,1),
(125,'Sales Report',0,6,1),
(126,'Sales by Category',0,6,1),
(127,'Sales by Department',0,6,1),
(128,'Sales by Product',0,6,1),
(129,'Sales by Customer',0,6,1),
(130,'Sales by Attender',0,6,1),
(131,'Day Book',0,6,1),
(132,'Commission Report',0,6,1),
(133,'GSTR-1',0,6,1),
(134,'Sales Summary',0,6,1),
(135,'Bill Wise Sales GST',0,6,1),
(136,'Item Wise Sales GST',0,6,1),
(137,'HSN Sales GST',0,6,1),
(138,'Purchase GST',0,6,1),
(139,'Purchase GST Summary',0,6,1),
(140,'Customers Balance',0,10,1),
(141,'Supplier Payment',0,10,1),
(142,'Create User',0,4,1),
(143,'Module Permission',0,4,1),
(144,'Special Permission',0,4,1),
(145,'Attender Management',0,4,1),
(146,'User Discount',0,4,1),
(147,'Company Details',0,7,1),
(148,'Edit Bill',0,7,1),
(149,'Edit Log',0,7,1),
(150,'Exchange',0,7,1),
(151,'Exchange & Return Report',0,7,1),
(152,'Expense Type',0,12,1),
(153,'Expense Entry',0,12,1),
(154,'Expense Report',0,12,1)
ON DUPLICATE KEY UPDATE
  module_name = VALUES(module_name),
  is_group = VALUES(is_group),
  group_id = VALUES(group_id);
  /* is_active is left as-is so client hide flags are kept */

/* ============================================================
   Hide menus for this client (examples — uncomment what you need)
   Group is_active=0 hides the whole main menu + all its screens.
   ============================================================ */

-- UPDATE user_modules SET is_active = 0 WHERE id = 1;   -- Billing (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 2;   -- Master (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 3;   -- Stock Reports (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 4;   -- User management (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 5;   -- Inventory (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 6;   -- Account Report (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 7;   -- Admin (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 8;   -- Statistics (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 10;  -- Credit Management (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 11;  -- Order list (whole)
-- UPDATE user_modules SET is_active = 0 WHERE id = 12;  -- Expense (whole)

-- Hide one screen only (parent stays):
-- UPDATE user_modules SET is_active = 0 WHERE id = 108; -- Cafe Tables
-- UPDATE user_modules SET is_active = 0 WHERE id = 11;  -- Order list

-- Turn a menu back on:
-- UPDATE user_modules SET is_active = 1 WHERE id = 11;
