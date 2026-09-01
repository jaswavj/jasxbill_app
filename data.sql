/*
SQLyog Community v13.3.1 (64 bit)
MySQL - 8.4.7 : Database - jasxbill
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`jasxbill` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `jasxbill`;

/*Table structure for table `attender` */

DROP TABLE IF EXISTS `attender`;

CREATE TABLE `attender` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `attender` */

/*Table structure for table `bill_type` */

DROP TABLE IF EXISTS `bill_type`;

CREATE TABLE `bill_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `table` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `bill_type` */

insert  into `bill_type`(`id`,`type`,`table`) values 
(1,'customer bill','prod_bill'),
(2,'customer balance collection','prod_bill_due'),
(3,'customer add advance','prod_bill_due'),
(4,'Customer old Balance add','prod_bill_due'),
(5,'purchase entry','prod_purchase'),
(6,'supplier balance collection','prod_supplier_due'),
(7,'supplier add advance','prod_supplier_due'),
(8,'Purchase Return','prod_purchase_return'),
(9,'Expense Entry','expense_entry'),
(11,'opening balance',NULL),
(12,'supplier old balance add','prod_supplier_due');

/*Table structure for table `company_details` */

DROP TABLE IF EXISTS `company_details`;

CREATE TABLE `company_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` text,
  `gstin` varchar(255) DEFAULT NULL,
  `print_type` int NOT NULL DEFAULT '0',
  `printer_name` varchar(255) DEFAULT NULL,
  `bank_details` varchar(255) DEFAULT NULL,
  `barcode_printer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `company_details` */

insert  into `company_details`(`id`,`shop_name`,`address`,`gstin`,`print_type`,`printer_name`,`bank_details`,`barcode_printer`) values 
(2,'JASXBILL','Address','ASDFFD223SDDDDF',2,'','Bank Details','AP4909');

/*Table structure for table `configure_bank_details` */

DROP TABLE IF EXISTS `configure_bank_details`;

CREATE TABLE `configure_bank_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_blocked` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `configure_bank_details` */

insert  into `configure_bank_details`(`id`,`name`,`is_blocked`) values 
(1,'SBI BANK',0),
(2,'CANARA BANK',0),
(3,'AXIS BANK',0),
(4,'IOB BANK',0);

/*Table structure for table `configure_payment_type` */

DROP TABLE IF EXISTS `configure_payment_type`;

CREATE TABLE `configure_payment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_blocked` int unsigned NOT NULL DEFAULT '0',
  `type_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `configure_payment_type` */

insert  into `configure_payment_type`(`id`,`name`,`is_blocked`,`type_id`) values 
(1,'Cash',0,1),
(2,'BANK',0,2);

/*Table structure for table `credit_days` */

DROP TABLE IF EXISTS `credit_days`;

CREATE TABLE `credit_days` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `credit_days` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `credit_days` */

insert  into `credit_days`(`id`,`credit_days`) values 
(1,10);

/*Table structure for table `customer_account` */

DROP TABLE IF EXISTS `customer_account`;

CREATE TABLE `customer_account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `advance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `customer_account` */

insert  into `customer_account`(`id`,`customer_id`,`advance`,`balance`) values 
(1,1,200.00,50.00),
(2,2,0.00,0.00),
(3,3,0.00,0.00);

/*Table structure for table `customers` */

DROP TABLE IF EXISTS `customers`;

CREATE TABLE `customers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_eligible_for_commission` tinyint DEFAULT '1',
  `is_active` int DEFAULT '1',
  `gstin` varchar(255) DEFAULT NULL,
  `is_gst` int DEFAULT '0',
  `salesman` int DEFAULT NULL,
  `area` int DEFAULT NULL,
  `credit_limit` double(10,2) NOT NULL DEFAULT '0.00',
  `local` int DEFAULT '1',
  `exchange_point` double(10,3) DEFAULT '0.000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `customers` */

insert  into `customers`(`id`,`name`,`phone_number`,`address`,`date`,`time`,`is_eligible_for_commission`,`is_active`,`gstin`,`is_gst`,`salesman`,`area`,`credit_limit`,`local`,`exchange_point`) values 
(1,'jaswa','9597451419','','2026-07-29','23:06:11',0,1,'',0,NULL,NULL,0.00,1,0.000),
(2,'New','9595959595','','2026-08-04','22:33:50',0,1,'',0,NULL,NULL,0.00,1,0.000),
(3,'jeb','8667214152','','2026-09-01','14:38:59',0,1,'',0,NULL,NULL,0.00,1,0.000);

/*Table structure for table `customers_exchange_point` */

DROP TABLE IF EXISTS `customers_exchange_point`;

CREATE TABLE `customers_exchange_point` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `bill_id` int NOT NULL,
  `old_point` double(10,3) DEFAULT '0.000',
  `exchange_point` double(10,3) DEFAULT '0.000',
  `total_point` double(10,3) DEFAULT '0.000',
  `uid` int DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `customers_exchange_point` */

insert  into `customers_exchange_point`(`id`,`customer_id`,`bill_id`,`old_point`,`exchange_point`,`total_point`,`uid`,`date_time`,`notes`) values 
(1,3,8,0.000,45.000,45.000,1,'2026-09-01 14:39:50','Points earned on product return (Bill: 26-8, Qty: 1.000)'),
(2,3,9,45.000,-45.000,0.000,1,'2026-09-01 14:40:35','Points used as bill discount (Bill ID: 9, Used: 45.00)');

/*Table structure for table `daybook_opening_balance` */

DROP TABLE IF EXISTS `daybook_opening_balance`;

CREATE TABLE `daybook_opening_balance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `balance_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `notes` varchar(255) DEFAULT NULL,
  `uid` int DEFAULT NULL,
  `entry_date` date NOT NULL,
  `entry_time` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_balance_date` (`balance_date`),
  KEY `idx_active_date` (`is_active`,`balance_date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `daybook_opening_balance` */

insert  into `daybook_opening_balance`(`id`,`balance_date`,`amount`,`notes`,`uid`,`entry_date`,`entry_time`,`is_active`) values 
(1,'2026-07-30',10000.00,'',1,'2026-07-30','11:33:49',1),
(2,'2026-07-30',10001.00,'',1,'2026-07-30','11:34:00',1);

/*Table structure for table `expense_entry` */

DROP TABLE IF EXISTS `expense_entry`;

CREATE TABLE `expense_entry` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `exp_type` int NOT NULL,
  `content` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text,
  `exc_date_time` datetime DEFAULT NULL,
  `entry_date_time` datetime DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`exp_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `expense_entry` */

insert  into `expense_entry`(`id`,`exp_type`,`content`,`amount`,`description`,`exc_date_time`,`entry_date_time`,`is_active`,`uid`) values 
(1,1,'Tea',150.00,'x','2026-07-30 11:09:00','2026-07-30 11:10:20',1,1),
(2,1,'s',10.00,'மஞ்சள்','2026-08-15 22:36:00','2026-08-15 22:36:17',1,1);

/*Table structure for table `expense_type` */

DROP TABLE IF EXISTS `expense_type`;

CREATE TABLE `expense_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `expense_type` */

insert  into `expense_type`(`id`,`type`,`is_active`) values 
(1,'Tea',1);

/*Table structure for table `gstin` */

DROP TABLE IF EXISTS `gstin`;

CREATE TABLE `gstin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gstin` varchar(255) NOT NULL,
  `shop_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `gstin` */

/*Table structure for table `heading` */

DROP TABLE IF EXISTS `heading`;

CREATE TABLE `heading` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `head1` varchar(255) DEFAULT NULL,
  `head2` varchar(255) DEFAULT NULL,
  `head3` varchar(255) DEFAULT NULL,
  `active` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `heading` */

insert  into `heading`(`id`,`head1`,`head2`,`head3`,`active`) values 
(1,'Category','Brand','Product',200);

/*Table structure for table `order_tables` */

DROP TABLE IF EXISTS `order_tables`;

CREATE TABLE `order_tables` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_occupied` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `order_tables` */

/*Table structure for table `pro_bill_exchange` */

DROP TABLE IF EXISTS `pro_bill_exchange`;

CREATE TABLE `pro_bill_exchange` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `old_prod_id` int NOT NULL,
  `new_prod_id` int NOT NULL,
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `pro_bill_exchange` */

insert  into `pro_bill_exchange`(`id`,`bill_id`,`customer_id`,`old_prod_id`,`new_prod_id`,`uid`,`date_time`) values 
(1,8,3,2,2,1,'2026-09-01 14:39:49');

/*Table structure for table `prod_batch` */

DROP TABLE IF EXISTS `prod_batch`;

CREATE TABLE `prod_batch` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `cost` double(10,3) DEFAULT '0.000',
  `mrp` double(10,3) DEFAULT '0.000',
  `commission` double(10,3) DEFAULT '0.000',
  `stock` decimal(10,2) NOT NULL,
  `disc_type` int DEFAULT '0' COMMENT '1=rs 2=%',
  `discount` double(10,3) DEFAULT '0.000',
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `added_stock` decimal(10,2) NOT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `disc` (`disc_type`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `prod_batch` */

insert  into `prod_batch`(`id`,`name`,`product_id`,`cost`,`mrp`,`commission`,`stock`,`disc_type`,`discount`,`date`,`time`,`added_stock`,`uid`) values 
(1,'ZSP001',1,50.000,100.000,0.000,16.00,1,0.000,'2026-07-29','23:05:46',10.00,1),
(2,'Z102',2,10.000,20.000,0.000,16.00,0,0.000,'2026-07-29','23:05:46',0.00,1),
(3,'Z101',3,200.000,400.000,0.000,98.00,0,0.000,'2026-08-29','19:27:22',0.00,1),
(4,'Z103',4,200.000,300.000,0.000,0.00,0,0.000,'2026-09-01','15:20:45',0.00,1),
(5,'Z104',5,20.000,25.000,0.000,9.00,0,0.000,'2026-09-01','15:21:57',0.00,1);

/*Table structure for table `prod_batch_updated` */

DROP TABLE IF EXISTS `prod_batch_updated`;

CREATE TABLE `prod_batch_updated` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `cost` double(10,3) NOT NULL DEFAULT '0.000',
  `mrp` double(10,3) NOT NULL DEFAULT '0.000',
  `stock` decimal(10,2) NOT NULL,
  `disc_type` int DEFAULT '0' COMMENT '1=rs 2=%',
  `discount` double(10,3) DEFAULT '0.000',
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `added_stock` decimal(10,2) NOT NULL,
  `uid` int NOT NULL DEFAULT '0',
  `updatedDate` date DEFAULT NULL,
  `updatedTime` time DEFAULT '00:00:00',
  `updatedUid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `disc` (`disc_type`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `prod_batch_updated` */

insert  into `prod_batch_updated`(`id`,`name`,`product_id`,`cost`,`mrp`,`stock`,`disc_type`,`discount`,`date`,`time`,`added_stock`,`uid`,`updatedDate`,`updatedTime`,`updatedUid`) values 
(1,'ZSP002',2,25.000,45.000,9.00,2,5.000,NULL,'00:00:00',0.00,0,'2026-09-01','14:32:57',1),
(2,'Z102',2,30.000,45.000,16.00,2,5.000,NULL,'00:00:00',0.00,0,'2026-09-01','15:19:49',1);

/*Table structure for table `prod_batch_zero_stock_bill` */

DROP TABLE IF EXISTS `prod_batch_zero_stock_bill`;

CREATE TABLE `prod_batch_zero_stock_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `batch` (`batch_id`),
  KEY `prod` (`product_id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_batch_zero_stock_bill` */

/*Table structure for table `prod_bill` */

DROP TABLE IF EXISTS `prod_bill`;

CREATE TABLE `prod_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_display` varchar(255) NOT NULL,
  `is_tax_bill` tinyint(1) DEFAULT '1',
  `is_receipt` int DEFAULT '1',
  `total` double(10,3) DEFAULT '0.000',
  `prodDisc` double(10,3) DEFAULT '0.000',
  `extraDisc` double(10,3) DEFAULT '0.000',
  `payable` double(10,3) DEFAULT '0.000',
  `paid` double(10,3) DEFAULT '0.000',
  `balance` double(10,3) DEFAULT '0.000',
  `currentBalance` double(10,3) DEFAULT '0.000',
  `is_balance` int DEFAULT '0',
  `paymentMode` int NOT NULL COMMENT 'prod_bill_payment_mode',
  `paymentType` int DEFAULT '0' COMMENT 'prod_bill_payment_type',
  `uid` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL DEFAULT '00:00:00',
  `is_cancelled` int DEFAULT '0',
  `bill_type` int DEFAULT '1' COMMENT '1=prod bill',
  `cusName` varchar(255) DEFAULT '""',
  `cusPhn` varchar(255) DEFAULT '-',
  `customerId` int DEFAULT NULL,
  `price_category` int NOT NULL,
  `lr_no` varchar(255) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `lr_name` varchar(255) DEFAULT NULL,
  `attender_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `mode` (`paymentMode`),
  KEY `type` (`paymentType`),
  KEY `idx_is_tax_bill` (`is_tax_bill`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill` */

insert  into `prod_bill`(`id`,`bill_display`,`is_tax_bill`,`is_receipt`,`total`,`prodDisc`,`extraDisc`,`payable`,`paid`,`balance`,`currentBalance`,`is_balance`,`paymentMode`,`paymentType`,`uid`,`date`,`time`,`is_cancelled`,`bill_type`,`cusName`,`cusPhn`,`customerId`,`price_category`,`lr_no`,`lr_date`,`lr_name`,`attender_id`) values 
(1,'26-1',1,1,200.000,0.000,0.000,200.000,150.000,50.000,50.000,1,1,0,1,'2026-07-29','23:06:11',0,1,'jaswa','9597451419',1,3,NULL,NULL,NULL,NULL),
(2,'26-2',1,1,100.000,0.000,0.000,100.000,40.000,60.000,60.000,1,3,1,1,'2026-07-30','11:35:21',0,1,'jaswa','9597451419',1,3,NULL,NULL,NULL,NULL),
(3,'26-3',1,1,100.000,0.000,0.000,100.000,50.000,50.000,50.000,1,1,0,1,'2026-08-04','22:33:50',1,1,'New','9595959595',2,3,NULL,NULL,NULL,NULL),
(4,'26-4',1,1,400.000,0.000,0.000,400.000,400.000,0.000,0.000,0,1,1,1,'2026-08-29','19:39:23',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(5,'26-5',1,1,400.000,0.000,0.000,400.000,400.000,0.000,0.000,0,1,1,1,'2026-08-29','19:54:46',0,1,'jaswa','9597451419',1,3,NULL,NULL,NULL,NULL),
(6,'26-6',1,1,3245.000,0.000,0.000,3245.000,3245.000,0.000,0.000,0,1,1,1,'2026-08-29','19:55:36',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(7,'26-7',1,1,400.000,0.000,200.000,200.000,200.000,0.000,0.000,0,1,1,1,'2026-08-29','20:13:56',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(8,'26-8',1,1,400.000,0.000,0.000,400.000,445.000,0.000,0.000,0,1,1,1,'2026-09-01','14:33:06',0,1,'jeb','8667214152',3,3,NULL,NULL,NULL,NULL),
(9,'26-9',1,1,400.000,0.000,45.000,355.000,355.000,0.000,0.000,0,1,1,1,'2026-09-01','14:40:35',0,1,'jeb','8667214152',3,3,NULL,NULL,NULL,NULL),
(10,'26-10',1,1,45.000,5.000,15.000,25.000,25.000,0.000,0.000,0,1,1,1,'2026-09-01','14:50:22',0,1,'jaswa','9597451419',1,3,NULL,NULL,NULL,NULL),
(11,'26-11',1,1,445.000,0.000,0.000,445.000,445.000,0.000,0.000,0,1,1,1,'2026-09-01','15:12:16',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(12,'26-12',1,1,445.000,0.000,0.000,445.000,445.000,0.000,0.000,0,1,1,1,'2026-09-01','15:18:55',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(13,'26-13',1,1,745.000,0.000,0.000,745.000,745.000,0.000,0.000,0,1,1,1,'2026-09-01','15:22:42',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL);

/*Table structure for table `prod_bill_cancel` */

DROP TABLE IF EXISTS `prod_bill_cancel`;

CREATE TABLE `prod_bill_cancel` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `reason` text,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `billId` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_cancel` */

insert  into `prod_bill_cancel`(`id`,`bill_id`,`reason`,`date`,`time`,`uid`) values 
(1,3,'as','2026-08-04','22:37:14',1);

/*Table structure for table `prod_bill_datechange` */

DROP TABLE IF EXISTS `prod_bill_datechange`;

CREATE TABLE `prod_bill_datechange` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `billId` int NOT NULL,
  `oldDate` date DEFAULT NULL,
  `changeDate` date DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `billId` (`billId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_datechange` */

/*Table structure for table `prod_bill_details` */

DROP TABLE IF EXISTS `prod_bill_details`;

CREATE TABLE `prod_bill_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `prod_id` int NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `price` double(10,3) DEFAULT '0.000',
  `disc` double(10,3) DEFAULT '0.000',
  `total` double(10,3) DEFAULT '0.000',
  `cost` double(10,3) DEFAULT '0.000',
  `commission` double(10,3) DEFAULT '0.000',
  `gst` int NOT NULL DEFAULT '0',
  `is_cancelled` int DEFAULT '0',
  `cancel_date` datetime DEFAULT NULL,
  `is_exchanged` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bill` (`bill_id`),
  KEY `prod` (`prod_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_details` */

insert  into `prod_bill_details`(`id`,`bill_id`,`prod_id`,`qty`,`price`,`disc`,`total`,`cost`,`commission`,`gst`,`is_cancelled`,`cancel_date`,`is_exchanged`) values 
(1,1,1,2.00,100.000,0.000,200.000,50.000,0.000,18,0,NULL,0),
(2,2,1,1.00,100.000,0.000,100.000,50.000,0.000,18,0,NULL,0),
(3,3,1,1.00,100.000,0.000,100.000,50.000,0.000,18,0,NULL,0),
(4,4,3,1.00,400.000,0.000,400.000,150.000,0.000,5,0,NULL,0),
(5,5,3,1.00,400.000,0.000,400.000,150.000,0.000,5,0,NULL,0),
(6,6,2,1.00,45.000,0.000,45.000,25.000,0.000,5,0,NULL,0),
(7,6,3,8.00,400.000,0.000,3200.000,150.000,0.000,5,0,NULL,0),
(8,7,3,1.00,400.000,0.000,400.000,150.000,0.000,5,0,NULL,0),
(9,8,3,1.00,400.000,0.000,400.000,150.000,0.000,5,0,NULL,0),
(10,8,2,1.00,45.000,0.000,45.000,25.000,0.000,5,0,NULL,2),
(11,9,3,1.00,400.000,0.000,400.000,150.000,0.000,5,0,NULL,0),
(12,10,2,1.00,45.000,5.000,40.000,25.000,0.000,5,0,NULL,0),
(13,11,3,1.00,400.000,0.000,400.000,200.000,0.000,5,0,NULL,0),
(14,11,2,1.00,45.000,0.000,45.000,30.000,0.000,5,0,NULL,0),
(15,12,3,1.00,400.000,0.000,400.000,200.000,0.000,5,0,NULL,0),
(16,12,2,1.00,45.000,0.000,45.000,30.000,0.000,5,0,NULL,0),
(17,13,3,1.00,400.000,0.000,400.000,200.000,0.000,5,0,NULL,0),
(18,13,2,1.00,20.000,0.000,20.000,10.000,0.000,5,0,NULL,0),
(19,13,4,1.00,300.000,0.000,300.000,200.000,0.000,0,0,NULL,0),
(20,13,5,1.00,25.000,0.000,25.000,20.000,0.000,0,0,NULL,0);

/*Table structure for table `prod_bill_due` */

DROP TABLE IF EXISTS `prod_bill_due`;

CREATE TABLE `prod_bill_due` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `amount` double(10,3) NOT NULL DEFAULT '0.000',
  `cash_paid` double(10,3) NOT NULL DEFAULT '0.000',
  `bank_paid` double(10,3) NOT NULL DEFAULT '0.000',
  `balance` double(10,3) NOT NULL DEFAULT '0.000',
  `pay_mode` tinyint NOT NULL DEFAULT '1',
  `pay_type` tinyint NOT NULL DEFAULT '0',
  `txn_type` varchar(20) NOT NULL DEFAULT 'COLLECTION',
  `notes` varchar(255) DEFAULT NULL,
  `uid` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_bill_due` */

insert  into `prod_bill_due`(`id`,`customer_id`,`amount`,`cash_paid`,`bank_paid`,`balance`,`pay_mode`,`pay_type`,`txn_type`,`notes`,`uid`,`date`,`time`) values 
(1,1,10.000,10.000,0.000,40.000,1,1,'COLLECTION',NULL,1,'2026-07-29','23:11:00'),
(2,1,100.000,100.000,0.000,40.000,1,1,'ADVANCE','Customer advance',1,'2026-07-29','23:11:08'),
(3,1,100.000,0.000,0.000,140.000,0,0,'OLD_DUE','Old due (before system)',1,'2026-07-29','23:11:15'),
(4,1,140.000,140.000,0.000,0.000,1,1,'COLLECTION',NULL,1,'2026-07-29','23:11:35'),
(5,1,500.000,0.000,0.000,500.000,0,0,'OLD_DUE','Old due (before system)',1,'2026-07-29','23:14:51'),
(6,1,400.000,400.000,0.000,100.000,1,1,'COLLECTION',NULL,1,'2026-07-30','10:23:00'),
(7,1,100.000,100.000,0.000,0.000,1,1,'COLLECTION',NULL,1,'2026-07-30','10:37:25'),
(8,1,60.000,40.000,20.000,0.000,3,1,'COLLECTION',NULL,1,'2026-07-30','11:35:44'),
(9,1,100.000,100.000,0.000,0.000,1,1,'ADVANCE','Customer advance',1,'2026-07-30','11:35:54'),
(10,1,100.000,0.000,0.000,100.000,0,0,'OLD_DUE','Old due (before system)',1,'2026-07-30','11:35:59'),
(11,1,50.000,50.000,0.000,50.000,1,1,'COLLECTION',NULL,1,'2026-09-01','15:03:28');

/*Table structure for table `prod_bill_due_collection` */

DROP TABLE IF EXISTS `prod_bill_due_collection`;

CREATE TABLE `prod_bill_due_collection` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `balance` double(10,2) DEFAULT NULL,
  `paid` double(10,2) DEFAULT NULL,
  `finalBalance` double(10,2) DEFAULT NULL,
  `mode` int DEFAULT NULL,
  `bankOption` int DEFAULT NULL,
  `uid` int NOT NULL,
  `collectDate` varchar(255) DEFAULT NULL,
  `collectTime` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `billId` (`bill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_due_collection` */

/*Table structure for table `prod_bill_payment` */

DROP TABLE IF EXISTS `prod_bill_payment`;

CREATE TABLE `prod_bill_payment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `cash` double(10,2) DEFAULT '0.00',
  `bank` double(10,2) DEFAULT '0.00',
  `paymentType` int DEFAULT '0' COMMENT 'prod_bill_payment_type',
  PRIMARY KEY (`id`),
  KEY `billid` (`bill_id`),
  KEY `paymentType` (`paymentType`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_payment` */

insert  into `prod_bill_payment`(`id`,`bill_id`,`cash`,`bank`,`paymentType`) values 
(1,1,150.00,0.00,0),
(2,2,20.00,20.00,1),
(3,3,50.00,0.00,0),
(4,4,400.00,0.00,1),
(5,5,400.00,0.00,1),
(6,6,3245.00,0.00,1),
(7,7,200.00,0.00,1),
(8,8,445.00,0.00,1),
(9,9,355.00,0.00,1),
(10,10,25.00,0.00,1),
(11,11,445.00,0.00,1),
(12,12,445.00,0.00,1),
(13,13,745.00,0.00,1);

/*Table structure for table `prod_bill_payment_mode` */

DROP TABLE IF EXISTS `prod_bill_payment_mode`;

CREATE TABLE `prod_bill_payment_mode` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `mode` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_payment_mode` */

insert  into `prod_bill_payment_mode`(`id`,`mode`,`is_active`) values 
(1,'cash',1),
(2,'bank',1),
(3,'mixed',1);

/*Table structure for table `prod_bill_payment_type` */

DROP TABLE IF EXISTS `prod_bill_payment_type`;

CREATE TABLE `prod_bill_payment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_payment_type` */

insert  into `prod_bill_payment_type`(`id`,`type`,`is_active`) values 
(0,'CASH',1),
(1,'UPI',1),
(2,'DEBIT CARD',1),
(3,'CREDIT CARD',1),
(4,'NET BANKING',1),
(5,'WALLET',1),
(6,'CHEQUE',1);

/*Table structure for table `prod_bill_payment_type_change` */

DROP TABLE IF EXISTS `prod_bill_payment_type_change`;

CREATE TABLE `prod_bill_payment_type_change` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `old_cash_amount` double(10,3) DEFAULT NULL,
  `cash_amount` double(10,3) DEFAULT NULL,
  `old_bank_amount` double(10,3) DEFAULT NULL,
  `bank_amount` double(10,3) DEFAULT NULL,
  `bank_mode` int DEFAULT NULL,
  `uid` int DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_bill_payment_type_change` */

/*Table structure for table `prod_brands` */

DROP TABLE IF EXISTS `prod_brands`;

CREATE TABLE `prod_brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `prod_brands` */

insert  into `prod_brands`(`id`,`name`,`date`,`time`,`is_active`) values 
(1,'Other','2026-07-21','22:26:54',1),
(2,'Others','2026-07-29','22:34:57',1);

/*Table structure for table `prod_category` */

DROP TABLE IF EXISTS `prod_category`;

CREATE TABLE `prod_category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `prod_category` */

insert  into `prod_category`(`id`,`name`,`date`,`time`,`is_active`) values 
(1,'Stationary','2026-07-21','22:26:49',1),
(2,'General','2026-07-29','22:34:28',1),
(3,'Grocery','2026-09-01','15:20:09',1),
(4,'Clothing','2026-09-01','15:20:18',1);

/*Table structure for table `prod_cheque_allocation` */

DROP TABLE IF EXISTS `prod_cheque_allocation`;

CREATE TABLE `prod_cheque_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `bill_id` int NOT NULL,
  `allocated_amount` double NOT NULL,
  `allocated_date` date DEFAULT NULL,
  `allocated_time` time DEFAULT NULL,
  `due_date` date NOT NULL,
  `credit_days` int DEFAULT '10',
  `status` enum('ALLOCATED','CLEARED','REVERSED','BOUNCED') DEFAULT 'ALLOCATED',
  `cleared_date` date DEFAULT NULL,
  `cleared_time` time DEFAULT NULL,
  `reversed_date` date DEFAULT NULL,
  `reversed_time` time DEFAULT NULL,
  `reversed_by` int DEFAULT NULL,
  `is_reversed` tinyint DEFAULT '0',
  `uid` int NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_bill` (`bill_id`),
  KEY `idx_status` (`status`),
  KEY `idx_due_date` (`due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_cheque_allocation` */

/*Table structure for table `prod_cheque_events` */

DROP TABLE IF EXISTS `prod_cheque_events`;

CREATE TABLE `prod_cheque_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `event_type` enum('BOUNCE','EXPIRY','MANUAL_CLEAR') NOT NULL,
  `event_date` date DEFAULT NULL,
  `event_time` time DEFAULT NULL,
  `reason` text,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_cheque_events` */

/*Table structure for table `prod_cheque_stock` */

DROP TABLE IF EXISTS `prod_cheque_stock`;

CREATE TABLE `prod_cheque_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `cheque_number` varchar(50) NOT NULL,
  `bank_name` text,
  `status` enum('AVAILABLE','PARTIAL','FULLY_USED','CLEARED','BOUNCED','EXPIRED') DEFAULT 'AVAILABLE',
  `entry_date` date DEFAULT NULL,
  `entry_time` time DEFAULT NULL,
  `uid` int NOT NULL,
  `notes` text,
  `is_active` tinyint DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_cheque_stock` */

/*Table structure for table `prod_ledger` */

DROP TABLE IF EXISTS `prod_ledger`;

CREATE TABLE `prod_ledger` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_type` int NOT NULL COMMENT 'FK logical: bill_type.id',
  `bill_id` int NOT NULL DEFAULT '0' COMMENT 'Source row id e.g. prod_bill.id',
  `customer_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  `payment_mode` tinyint NOT NULL DEFAULT '1' COMMENT '1=Cash 2=Bank 3=Mixed',
  `bill_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `cash_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
  `bank_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
  `payment_type` tinyint NOT NULL DEFAULT '0' COMMENT 'UPI, card, etc. from configure_payment_type',
  `uid` int NOT NULL,
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_bill_type_id` (`bill_type`,`bill_id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_supplier` (`supplier_id`),
  KEY `idx_date_time` (`date_time`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_ledger` */

insert  into `prod_ledger`(`id`,`bill_type`,`bill_id`,`customer_id`,`supplier_id`,`payment_mode`,`bill_amount`,`cash_paid`,`bank_paid`,`payment_type`,`uid`,`date_time`) values 
(1,1,1,1,NULL,1,200.00,150.00,0.00,0,1,'2026-07-29 23:06:11'),
(2,2,1,1,NULL,1,10.00,10.00,0.00,1,1,'2026-07-29 23:11:00'),
(3,3,2,1,NULL,1,100.00,100.00,0.00,1,1,'2026-07-29 23:11:08'),
(4,4,3,1,NULL,0,100.00,0.00,0.00,0,1,'2026-07-29 23:11:15'),
(5,2,4,1,NULL,1,140.00,140.00,0.00,1,1,'2026-07-29 23:11:35'),
(6,4,5,1,NULL,0,500.00,0.00,0.00,0,1,'2026-07-29 23:14:51'),
(7,2,6,1,NULL,1,400.00,400.00,0.00,1,1,'2026-07-30 10:23:00'),
(8,2,7,1,NULL,1,100.00,100.00,0.00,1,1,'2026-07-30 10:37:25'),
(9,5,1,NULL,1,1,852.50,52.50,0.00,1,1,'2026-07-30 10:48:39'),
(10,6,1,NULL,1,1,400.00,400.00,0.00,1,1,'2026-07-30 10:49:20'),
(11,7,2,NULL,1,1,100.00,100.00,0.00,1,1,'2026-07-30 10:49:27'),
(12,8,1,NULL,1,1,50.00,0.00,0.00,0,1,'2026-07-30 10:57:05'),
(13,6,4,NULL,1,1,50.00,50.00,0.00,1,1,'2026-07-30 11:01:08'),
(14,9,1,NULL,NULL,2,150.00,0.00,150.00,1,1,'2026-07-30 11:10:20'),
(15,6,5,NULL,1,1,100.00,100.00,0.00,1,1,'2026-07-30 11:17:09'),
(16,7,6,NULL,1,1,100.00,100.00,0.00,1,1,'2026-07-30 11:17:15'),
(17,12,8,NULL,1,0,500.00,0.00,0.00,0,1,'2026-07-30 11:22:11'),
(18,11,1,NULL,NULL,1,10000.00,10000.00,0.00,0,1,'2026-07-30 11:33:49'),
(19,11,2,NULL,NULL,2,10001.00,0.00,10001.00,1,1,'2026-07-30 11:34:00'),
(20,1,2,1,NULL,3,100.00,20.00,20.00,1,1,'2026-07-30 11:35:21'),
(21,2,8,1,NULL,3,60.00,40.00,20.00,1,1,'2026-07-30 11:35:44'),
(22,3,9,1,NULL,1,100.00,100.00,0.00,1,1,'2026-07-30 11:35:54'),
(23,4,10,1,NULL,0,100.00,0.00,0.00,0,1,'2026-07-30 11:35:59'),
(24,1,3,2,NULL,1,100.00,50.00,0.00,0,1,'2026-08-04 22:33:50'),
(25,9,2,NULL,NULL,1,10.00,10.00,0.00,0,1,'2026-08-15 22:36:17'),
(26,5,2,NULL,1,1,1575.00,575.00,0.00,1,1,'2026-08-29 19:28:24'),
(27,8,2,NULL,1,1,150.00,0.00,0.00,0,1,'2026-08-29 19:28:42'),
(28,1,4,NULL,NULL,1,400.00,400.00,0.00,1,1,'2026-08-29 19:39:23'),
(29,1,5,1,NULL,1,400.00,400.00,0.00,1,1,'2026-08-29 19:54:46'),
(30,1,6,NULL,NULL,1,3245.00,3245.00,0.00,1,1,'2026-08-29 19:55:36'),
(31,1,7,NULL,NULL,1,200.00,200.00,0.00,1,1,'2026-08-29 20:13:56'),
(32,1,8,NULL,NULL,1,445.00,445.00,0.00,1,1,'2026-09-01 14:33:06'),
(33,1,9,3,NULL,1,355.00,355.00,0.00,1,1,'2026-09-01 14:40:35'),
(34,1,10,1,NULL,1,25.00,25.00,0.00,1,1,'2026-09-01 14:50:23'),
(35,5,3,NULL,1,1,21315.00,0.00,0.00,1,1,'2026-09-01 15:00:39'),
(36,8,3,NULL,1,1,200.00,0.00,0.00,0,1,'2026-09-01 15:01:27'),
(37,6,9,NULL,1,2,3265.00,0.00,3265.00,1,1,'2026-09-01 15:02:26'),
(38,2,11,1,NULL,1,50.00,50.00,0.00,1,1,'2026-09-01 15:03:28'),
(39,1,11,NULL,NULL,1,445.00,445.00,0.00,1,1,'2026-09-01 15:12:16'),
(40,1,12,NULL,NULL,1,445.00,445.00,0.00,1,1,'2026-09-01 15:18:55'),
(41,5,4,NULL,1,1,620.50,0.00,0.00,1,1,'2026-09-01 15:22:26'),
(42,1,13,NULL,NULL,1,745.00,745.00,0.00,1,1,'2026-09-01 15:22:42'),
(43,6,10,NULL,1,1,10000.00,10000.00,0.00,1,1,'2026-09-01 15:23:16');

/*Table structure for table `prod_lifecycle` */

DROP TABLE IF EXISTS `prod_lifecycle`;

CREATE TABLE `prod_lifecycle` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL DEFAULT '0',
  `batch_id` int NOT NULL,
  `product_id` int NOT NULL,
  `stock_in` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_out` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_now` decimal(10,2) NOT NULL,
  `is_zero_stock_bill` int DEFAULT '0',
  `notes` text,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int NOT NULL,
  `stock_type` int DEFAULT '1' COMMENT '1=stock 2=noStock',
  `stockAdjType` int DEFAULT '0' COMMENT '1=add 2=remove',
  PRIMARY KEY (`id`),
  KEY `batch` (`batch_id`),
  KEY `prod` (`product_id`),
  KEY `uid` (`uid`),
  KEY `stock` (`stockAdjType`),
  KEY `billId` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

/*Data for the table `prod_lifecycle` */

insert  into `prod_lifecycle`(`id`,`bill_id`,`batch_id`,`product_id`,`stock_in`,`stock_out`,`stock_now`,`is_zero_stock_bill`,`notes`,`date`,`time`,`uid`,`stock_type`,`stockAdjType`) values 
(1,0,1,1,10.00,0.00,10.00,0,'WHILE ADD PRODUCT','2026-07-29','23:05:46',1,1,0),
(2,0,2,2,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-07-29','23:05:46',1,1,0),
(3,1,1,1,0.00,2.00,8.00,0,'WHILE BILLING','2026-07-29','23:06:11',1,1,0),
(4,0,1,1,10.00,0.00,18.00,2,'While Stock Added Through Purchase Entry','2026-07-30','10:48:39',1,2,0),
(5,0,1,2,10.00,0.00,10.00,2,'While Stock Added Through Purchase Entry','2026-07-30','10:48:39',1,2,0),
(6,0,1,1,0.00,1.00,17.00,2,'Stock deducted — Purchase return (RTN1)','2026-07-30','10:57:05',1,2,0),
(7,2,1,1,0.00,1.00,16.00,0,'WHILE BILLING','2026-07-30','11:35:21',1,1,0),
(8,3,1,1,0.00,1.00,15.00,0,'WHILE BILLING','2026-08-04','22:33:50',1,1,0),
(9,0,1,1,1.00,0.00,16.00,0,'Cancel bill - returned to stock','2026-08-04','22:37:14',1,1,1),
(10,0,3,3,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-08-29','19:27:22',1,1,0),
(11,0,3,3,5.00,0.00,5.00,0,'Adding Stock - w','2026-08-29','19:27:36',1,1,1),
(12,0,1,3,10.00,0.00,15.00,2,'While Stock Added Through Purchase Entry','2026-08-29','19:28:24',1,2,0),
(13,0,1,3,0.00,1.00,14.00,2,'Stock deducted — Purchase return (RTN2)','2026-08-29','19:28:42',1,2,0),
(14,4,3,3,0.00,1.00,13.00,0,'WHILE BILLING','2026-08-29','19:39:23',1,1,0),
(15,5,3,3,0.00,1.00,12.00,0,'WHILE BILLING','2026-08-29','19:54:46',1,1,0),
(16,6,2,2,0.00,1.00,9.00,0,'WHILE BILLING','2026-08-29','19:55:36',1,1,0),
(17,6,3,3,0.00,8.00,4.00,0,'WHILE BILLING','2026-08-29','19:55:36',1,1,0),
(18,7,3,3,0.00,1.00,3.00,0,'WHILE BILLING','2026-08-29','20:13:56',1,1,0),
(19,8,3,3,0.00,1.00,2.00,0,'WHILE BILLING','2026-09-01','14:33:06',1,1,0),
(20,8,2,2,0.00,1.00,8.00,0,'WHILE BILLING','2026-09-01','14:33:06',1,1,0),
(21,8,2,2,1.00,0.00,9.00,0,'PRODUCT RETURN','2026-09-01','14:39:49',1,1,1),
(22,9,3,3,0.00,1.00,1.00,0,'WHILE BILLING','2026-09-01','14:40:35',1,1,0),
(23,10,2,2,0.00,1.00,8.00,0,'WHILE BILLING','2026-09-01','14:50:23',1,1,0),
(24,0,1,3,100.00,0.00,101.00,2,'While Stock Added Through Purchase Entry','2026-09-01','15:00:39',1,2,0),
(25,0,1,2,10.00,0.00,18.00,2,'While Stock Added Through Purchase Entry','2026-09-01','15:00:39',1,2,0),
(26,0,1,3,0.00,1.00,100.00,2,'Stock deducted — Purchase return (RTN3)','2026-09-01','15:01:27',1,2,0),
(27,11,3,3,0.00,1.00,99.00,0,'WHILE BILLING','2026-09-01','15:12:16',1,1,0),
(28,11,2,2,0.00,1.00,17.00,0,'WHILE BILLING','2026-09-01','15:12:16',1,1,0),
(29,12,3,3,0.00,1.00,98.00,0,'WHILE BILLING','2026-09-01','15:18:55',1,1,0),
(30,12,2,2,0.00,1.00,16.00,0,'WHILE BILLING','2026-09-01','15:18:55',1,1,0),
(31,0,4,4,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-09-01','15:20:45',1,1,0),
(32,0,5,5,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-09-01','15:21:57',1,1,0),
(33,0,1,5,10.00,0.00,10.00,2,'While Stock Added Through Purchase Entry','2026-09-01','15:22:26',1,2,0),
(34,0,1,3,1.00,0.00,99.00,2,'While Stock Added Through Purchase Entry','2026-09-01','15:22:26',1,2,0),
(35,0,1,2,1.00,0.00,17.00,2,'While Stock Added Through Purchase Entry','2026-09-01','15:22:26',1,2,0),
(36,0,1,4,1.00,0.00,1.00,2,'While Stock Added Through Purchase Entry','2026-09-01','15:22:26',1,2,0),
(37,13,3,3,0.00,1.00,98.00,0,'WHILE BILLING','2026-09-01','15:22:42',1,1,0),
(38,13,2,2,0.00,1.00,16.00,0,'WHILE BILLING','2026-09-01','15:22:42',1,1,0),
(39,13,4,4,0.00,1.00,0.00,0,'WHILE BILLING','2026-09-01','15:22:42',1,1,0),
(40,13,5,5,0.00,1.00,9.00,0,'WHILE BILLING','2026-09-01','15:22:42',1,1,0);

/*Table structure for table `prod_order` */

DROP TABLE IF EXISTS `prod_order`;

CREATE TABLE `prod_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_no` varchar(255) NOT NULL,
  `table_id` int NOT NULL,
  `is_delivered` int DEFAULT '0',
  `is_billed` int DEFAULT '0',
  `is_cancelled` int DEFAULT '0',
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_order` */

/*Table structure for table `prod_order_details` */

DROP TABLE IF EXISTS `prod_order_details`;

CREATE TABLE `prod_order_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `prod_id` int NOT NULL,
  `qty` int NOT NULL,
  `price` double(10,3) DEFAULT '0.000',
  `total` double(10,3) DEFAULT '0.000',
  `is_delivered` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_order_details` */

/*Table structure for table `prod_product` */

DROP TABLE IF EXISTS `prod_product`;

CREATE TABLE `prod_product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '0',
  `category_id` int NOT NULL,
  `brand_id` int NOT NULL,
  `unit_id` int DEFAULT '1',
  `hsn` int DEFAULT NULL,
  `uid` int NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `gst` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cat` (`category_id`),
  KEY `brand` (`brand_id`),
  KEY `uid` (`uid`),
  KEY `unit` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `prod_product` */

insert  into `prod_product`(`id`,`name`,`code`,`category_id`,`brand_id`,`unit_id`,`hsn`,`uid`,`date`,`time`,`is_active`,`gst`) values 
(1,'Sample Product 1','SP001',2,2,1,1234,1,'2026-07-29','23:05:46',0,18),
(2,'PEN','102',1,2,1,5678,1,'2026-07-29','23:05:46',1,5),
(3,'PVC','101',2,1,1,NULL,1,'2026-08-29','19:27:22',1,5),
(4,'Shirt size L','103',4,1,1,NULL,1,'2026-09-01','15:20:45',1,0),
(5,'Biscuits','104',3,1,1,NULL,1,'2026-09-01','15:21:57',1,0);

/*Table structure for table `prod_product_components` */

DROP TABLE IF EXISTS `prod_product_components`;

CREATE TABLE `prod_product_components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL COMMENT 'Main product ID',
  `component_product_id` int NOT NULL COMMENT 'Component product ID',
  `quantity` decimal(10,2) DEFAULT '1.00' COMMENT 'Quantity needed',
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `compo` (`component_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_product_components` */

/*Table structure for table `prod_purchase` */

DROP TABLE IF EXISTS `prod_purchase`;

CREATE TABLE `prod_purchase` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prno` varchar(25) NOT NULL DEFAULT '',
  `invno` varchar(255) DEFAULT '',
  `invdate` date DEFAULT NULL,
  `total` double(10,2) NOT NULL DEFAULT '0.00',
  `paid` double(10,2) NOT NULL DEFAULT '0.00',
  `balance` double(10,2) DEFAULT '0.00',
  `discount` double(10,2) DEFAULT '0.00',
  `net` double NOT NULL DEFAULT '0',
  `ent_date` date NOT NULL DEFAULT '0001-01-01',
  `ent_time` time NOT NULL DEFAULT '00:00:00',
  `ent_uid` int unsigned NOT NULL DEFAULT '0',
  `ispending` tinyint unsigned DEFAULT '0',
  `pay_type` int unsigned NOT NULL DEFAULT '0',
  `bank_id` int unsigned NOT NULL DEFAULT '0',
  `deal_id` int unsigned DEFAULT '0',
  `remark` varchar(100) NOT NULL DEFAULT '0',
  `is_cancelled` tinyint(1) NOT NULL DEFAULT '0',
  `cancel_date` date DEFAULT '0001-01-01',
  `cancel_time` time DEFAULT '00:00:00',
  `cancel_uid` varchar(10) DEFAULT '0',
  `is_po` tinyint DEFAULT '0',
  `po_status` tinyint DEFAULT '1',
  `pr_id` int DEFAULT NULL,
  `grn_id` int DEFAULT '0',
  `expected_date` date DEFAULT NULL,
  `po_notes` text,
  `offer` text,
  `offer_date` date DEFAULT NULL,
  `lr_no` varchar(255) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `lr_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prno` (`prno`),
  KEY `dealer` (`deal_id`),
  KEY `grnid` (`grn_id`),
  KEY `status` (`po_status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase` */

insert  into `prod_purchase`(`id`,`prno`,`invno`,`invdate`,`total`,`paid`,`balance`,`discount`,`net`,`ent_date`,`ent_time`,`ent_uid`,`ispending`,`pay_type`,`bank_id`,`deal_id`,`remark`,`is_cancelled`,`cancel_date`,`cancel_time`,`cancel_uid`,`is_po`,`po_status`,`pr_id`,`grn_id`,`expected_date`,`po_notes`,`offer`,`offer_date`,`lr_no`,`lr_date`,`lr_name`) values 
(1,'GRN-1','1','2026-07-30',852.50,52.50,800.00,0.00,852.5,'2026-07-30','10:48:39',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'GRN-2','1','2026-08-29',1575.00,575.00,1000.00,0.00,1575,'2026-08-29','19:28:24',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'GRN-3','1','2026-09-01',21315.00,0.00,21315.00,0.00,21315,'2026-09-01','15:00:38',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'GRN-4','12','2026-09-01',620.50,0.00,620.50,0.00,620.5,'2026-09-01','15:22:26',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `prod_purchase_counter` */

DROP TABLE IF EXISTS `prod_purchase_counter`;

CREATE TABLE `prod_purchase_counter` (
  `id` int NOT NULL,
  `last_pr_no` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_counter` */

/*Table structure for table `prod_purchase_details` */

DROP TABLE IF EXISTS `prod_purchase_details`;

CREATE TABLE `prod_purchase_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prid` int unsigned DEFAULT '0',
  `prods_id` int DEFAULT '0',
  `pack` int DEFAULT '0',
  `qtypack` decimal(10,2) DEFAULT '0.00',
  `quantity` decimal(10,2) unsigned DEFAULT '0.00',
  `free` int unsigned DEFAULT '0',
  `rate` double(10,3) DEFAULT '0.000',
  `mrp` double(10,3) DEFAULT '0.000',
  `totalamt` double(10,3) DEFAULT '0.000',
  `tax` double(10,2) NOT NULL DEFAULT '0.00',
  `tax_amt` double(10,3) DEFAULT '0.000',
  `mrp_vat_amt` double(10,2) DEFAULT '0.00',
  `disc_per` double(10,2) DEFAULT '0.00',
  `disc` double(10,3) DEFAULT '0.000',
  `netamt` double(10,3) DEFAULT '0.000',
  `isinvoicereceived` int unsigned NOT NULL DEFAULT '0',
  `hsn_code` varchar(20) NOT NULL DEFAULT '0',
  `sgst_per` double(10,2) NOT NULL DEFAULT '0.00',
  `cgst_per` double(10,2) NOT NULL DEFAULT '0.00',
  `igst_per` double(10,2) NOT NULL DEFAULT '0.00',
  `sgst_amt` double(10,2) NOT NULL DEFAULT '0.00',
  `cgst_amt` double(10,2) NOT NULL DEFAULT '0.00',
  `igst_amt` double(10,2) NOT NULL DEFAULT '0.00',
  `unitrate` double(10,3) DEFAULT '0.000',
  `unitmrp` double(10,3) DEFAULT '0.000',
  `ordered_qty` int DEFAULT '0',
  `received_qty` int DEFAULT '0',
  `pending_qty` int DEFAULT '0',
  `is_fully_received` tinyint DEFAULT '0',
  `is_cancelled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = this item was cancelled',
  PRIMARY KEY (`id`),
  KEY `prid` (`prid`),
  KEY `prod` (`prods_id`),
  KEY `fullyreceive` (`is_fully_received`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase_details` */

insert  into `prod_purchase_details`(`id`,`prid`,`prods_id`,`pack`,`qtypack`,`quantity`,`free`,`rate`,`mrp`,`totalamt`,`tax`,`tax_amt`,`mrp_vat_amt`,`disc_per`,`disc`,`netamt`,`isinvoicereceived`,`hsn_code`,`sgst_per`,`cgst_per`,`igst_per`,`sgst_amt`,`cgst_amt`,`igst_amt`,`unitrate`,`unitmrp`,`ordered_qty`,`received_qty`,`pending_qty`,`is_fully_received`,`is_cancelled`) values 
(1,1,1,1,10.00,10.00,0,50.000,100.000,500.000,18.00,90.000,0.00,0.00,0.000,590.000,1,'0',9.00,9.00,0.00,45.00,45.00,0.00,5.000,10.000,0,0,0,0,0),
(2,1,2,1,10.00,10.00,0,25.000,45.000,250.000,5.00,12.500,0.00,0.00,0.000,262.500,1,'0',2.50,2.50,0.00,6.25,6.25,0.00,2.500,4.500,0,0,0,0,0),
(3,2,3,1,10.00,10.00,0,150.000,400.000,1500.000,5.00,75.000,0.00,0.00,0.000,1575.000,1,'0',2.50,2.50,0.00,37.50,37.50,0.00,15.000,40.000,0,0,0,0,0),
(4,3,3,1,100.00,100.00,0,200.000,400.000,20000.000,5.00,1000.000,0.00,0.00,0.000,21000.000,1,'0',2.50,2.50,0.00,500.00,500.00,0.00,2.000,4.000,0,0,0,0,0),
(5,3,2,1,10.00,10.00,0,30.000,45.000,300.000,5.00,15.000,0.00,0.00,0.000,315.000,1,'0',2.50,2.50,0.00,7.50,7.50,0.00,3.000,4.500,0,0,0,0,0),
(6,4,5,1,10.00,10.00,0,20.000,25.000,200.000,0.00,0.000,0.00,0.00,0.000,200.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,2.000,2.500,0,0,0,0,0),
(7,4,3,1,1.00,1.00,0,200.000,400.000,200.000,5.00,10.000,0.00,0.00,0.000,210.000,1,'0',2.50,2.50,0.00,5.00,5.00,0.00,200.000,400.000,0,0,0,0,0),
(8,4,2,1,1.00,1.00,0,10.000,20.000,10.000,5.00,0.500,0.00,0.00,0.000,10.500,1,'0',2.50,2.50,0.00,0.25,0.25,0.00,10.000,20.000,0,0,0,0,0),
(9,4,4,1,1.00,1.00,0,200.000,300.000,200.000,0.00,0.000,0.00,0.00,0.000,200.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,200.000,300.000,0,0,0,0,0);

/*Table structure for table `prod_purchase_edit_log` */

DROP TABLE IF EXISTS `prod_purchase_edit_log`;

CREATE TABLE `prod_purchase_edit_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_id` int NOT NULL,
  `purchase_detail_id` int NOT NULL,
  `product_id` int NOT NULL,
  `edit_type` enum('price_edit','cancel') NOT NULL,
  `old_rate` double DEFAULT NULL,
  `new_rate` double DEFAULT NULL,
  `old_mrp` double DEFAULT NULL,
  `new_mrp` double DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `reason` text,
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_edit_log` */

/*Table structure for table `prod_purchase_entry_details_link` */

DROP TABLE IF EXISTS `prod_purchase_entry_details_link`;

CREATE TABLE `prod_purchase_entry_details_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `link_id` int NOT NULL,
  `po_detail_id` bigint unsigned NOT NULL,
  `pe_detail_id` bigint unsigned NOT NULL,
  `quantity_received` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_entry_details_link` */

/*Table structure for table `prod_purchase_entry_link` */

DROP TABLE IF EXISTS `prod_purchase_entry_link`;

CREATE TABLE `prod_purchase_entry_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `po_id` bigint unsigned NOT NULL,
  `pe_id` bigint unsigned NOT NULL,
  `receipt_no` varchar(50) DEFAULT NULL,
  `receipt_date` date DEFAULT NULL,
  `received_by` int DEFAULT NULL,
  `notes` text,
  `created_date` date NOT NULL,
  `created_time` time NOT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_entry_link` */

/*Table structure for table `prod_purchase_order_counter` */

DROP TABLE IF EXISTS `prod_purchase_order_counter`;

CREATE TABLE `prod_purchase_order_counter` (
  `id` int NOT NULL DEFAULT '1',
  `last_po_no` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_order_counter` */

/*Table structure for table `prod_purchase_request` */

DROP TABLE IF EXISTS `prod_purchase_request`;

CREATE TABLE `prod_purchase_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `req_no` varchar(50) NOT NULL COMMENT 'REQ1, REQ2, REQ3...',
  `req_date` date NOT NULL,
  `req_time` time NOT NULL,
  `deal_id` int DEFAULT NULL COMMENT 'Supplier ID - can be null for TBD supplier',
  `total` decimal(15,2) DEFAULT '0.00' COMMENT 'Total request amount',
  `pr_status` tinyint DEFAULT '1' COMMENT '1=Draft, 2=Submitted, 3=Approved, 4=Rejected, 5=Converted to PO',
  `notes` text COMMENT 'Request notes/justification',
  `requested_by` int NOT NULL COMMENT 'User ID who created the request',
  `approver_id` int DEFAULT NULL COMMENT 'User ID who approved/rejected - for future multi-level approval',
  `approved_date` date DEFAULT NULL COMMENT 'Approval date',
  `approved_time` time DEFAULT NULL COMMENT 'Approval time',
  `approval_notes` text COMMENT 'Approval/rejection notes',
  `po_id` int DEFAULT NULL COMMENT 'Link to PO if converted',
  `is_cancelled` tinyint DEFAULT '0' COMMENT '0=Active, 1=Cancelled',
  `ent_date` date NOT NULL,
  `ent_time` time NOT NULL,
  `ent_uid` int NOT NULL COMMENT 'Entry user ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `req_no` (`req_no`),
  KEY `deal` (`deal_id`),
  KEY `status` (`pr_status`),
  KEY `po` (`po_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Purchase Request Header';

/*Data for the table `prod_purchase_request` */

/*Table structure for table `prod_purchase_request_counter` */

DROP TABLE IF EXISTS `prod_purchase_request_counter`;

CREATE TABLE `prod_purchase_request_counter` (
  `id` int NOT NULL DEFAULT '1',
  `last_req_no` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_request_counter` */

/*Table structure for table `prod_purchase_request_details` */

DROP TABLE IF EXISTS `prod_purchase_request_details`;

CREATE TABLE `prod_purchase_request_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pr_id` int NOT NULL COMMENT 'Foreign key to prod_purchase_request',
  `prods_id` int NOT NULL COMMENT 'Product ID',
  `pack` int DEFAULT '1' COMMENT 'Number of packs',
  `qtypack` int DEFAULT '1' COMMENT 'Quantity per pack',
  `quantity` int NOT NULL COMMENT 'Total quantity requested',
  `free` int DEFAULT '0' COMMENT 'Free quantity expected',
  `rate` decimal(15,2) DEFAULT '0.00' COMMENT 'Expected cost per unit',
  `mrp` decimal(15,2) DEFAULT '0.00' COMMENT 'Expected MRP',
  `total` decimal(15,2) DEFAULT '0.00' COMMENT 'Line total',
  `tax` decimal(5,2) DEFAULT '0.00' COMMENT 'Tax percentage',
  `tax_amt` decimal(15,2) DEFAULT '0.00' COMMENT 'Tax amount',
  `disc_per` decimal(5,2) DEFAULT '0.00' COMMENT 'Discount percentage',
  `disc_amt` decimal(15,2) DEFAULT '0.00' COMMENT 'Discount amount',
  `net` decimal(15,2) DEFAULT '0.00' COMMENT 'Net amount',
  `notes` text COMMENT 'Item notes',
  PRIMARY KEY (`id`),
  KEY `idx_pr_id` (`pr_id`),
  KEY `idx_prods_id` (`prods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Purchase Request Line Items';

/*Data for the table `prod_purchase_request_details` */

/*Table structure for table `prod_purchase_return` */

DROP TABLE IF EXISTS `prod_purchase_return`;

CREATE TABLE `prod_purchase_return` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `return_no` varchar(50) DEFAULT NULL,
  `purchase_id` int NOT NULL,
  `supplier_id` int DEFAULT NULL,
  `total` double DEFAULT '0',
  `notes` text,
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `supplier_id` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_return` */

insert  into `prod_purchase_return`(`id`,`return_no`,`purchase_id`,`supplier_id`,`total`,`notes`,`uid`,`date_time`) values 
(1,'RTN1',1,1,50,'a',1,'2026-07-30 10:57:05'),
(2,'RTN2',2,1,150,'',1,'2026-08-29 19:28:42'),
(3,'RTN3',3,1,200,'',1,'2026-09-01 15:01:27');

/*Table structure for table `prod_purchase_return_details` */

DROP TABLE IF EXISTS `prod_purchase_return_details`;

CREATE TABLE `prod_purchase_return_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `return_id` int NOT NULL,
  `purchase_detail_id` int NOT NULL,
  `product_id` int NOT NULL,
  `qty` double DEFAULT '0',
  `rate` double DEFAULT '0',
  `total` double DEFAULT '0',
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `return_id` (`return_id`),
  KEY `purchase_detail_id` (`purchase_detail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_return_details` */

insert  into `prod_purchase_return_details`(`id`,`return_id`,`purchase_detail_id`,`product_id`,`qty`,`rate`,`total`,`uid`,`date_time`) values 
(1,1,1,1,1,50,50,1,'2026-07-30 10:57:05'),
(2,2,3,3,1,150,150,1,'2026-08-29 19:28:42'),
(3,3,4,3,1,200,200,1,'2026-09-01 15:01:27');

/*Table structure for table `prod_purchase_supplier_payment` */

DROP TABLE IF EXISTS `prod_purchase_supplier_payment`;

CREATE TABLE `prod_purchase_supplier_payment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `prid` int NOT NULL,
  `deal_id` int NOT NULL,
  `total` double(10,2) DEFAULT NULL,
  `paid` double(10,2) DEFAULT NULL,
  `balance` double(10,2) DEFAULT NULL,
  `is_active` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prid` (`prid`),
  KEY `deal` (`deal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase_supplier_payment` */

insert  into `prod_purchase_supplier_payment`(`id`,`prid`,`deal_id`,`total`,`paid`,`balance`,`is_active`) values 
(1,1,1,852.50,52.50,800.00,1),
(2,2,1,1575.00,575.00,1000.00,1),
(3,3,1,21315.00,0.00,21315.00,1),
(4,4,1,620.50,0.00,620.50,1);

/*Table structure for table `prod_purchase_supplier_payment_details` */

DROP TABLE IF EXISTS `prod_purchase_supplier_payment_details`;

CREATE TABLE `prod_purchase_supplier_payment_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `supPayId` int NOT NULL,
  `payable` double(10,2) DEFAULT NULL,
  `paid` double(10,2) DEFAULT NULL,
  `balance` double(10,2) DEFAULT NULL,
  `pay_type` int DEFAULT NULL,
  `pay_mode` int DEFAULT '0',
  `uid` int DEFAULT NULL,
  `notes` text,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payId` (`supPayId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase_supplier_payment_details` */

insert  into `prod_purchase_supplier_payment_details`(`id`,`supPayId`,`payable`,`paid`,`balance`,`pay_type`,`pay_mode`,`uid`,`notes`,`date`,`time`) values 
(1,1,852.50,52.50,800.00,1,0,1,'Payment for Purchase Bill','2026-07-30','10:48:39'),
(2,2,1575.00,575.00,1000.00,1,0,1,'Payment for Purchase Bill','2026-08-29','19:28:24'),
(3,3,21315.00,0.00,21315.00,1,0,1,'Payment for Purchase Bill','2026-09-01','15:00:39'),
(4,4,620.50,0.00,620.50,1,0,1,'Payment for Purchase Bill','2026-09-01','15:22:26');

/*Table structure for table `prod_quotation` */

DROP TABLE IF EXISTS `prod_quotation`;

CREATE TABLE `prod_quotation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_display` varchar(255) NOT NULL,
  `total` double(10,3) DEFAULT '0.000',
  `prodDisc` double(10,3) DEFAULT '0.000',
  `extraDisc` double(10,3) DEFAULT '0.000',
  `payable` double(10,3) DEFAULT '0.000',
  `is_billed` int DEFAULT '0',
  `is_cancelled` int DEFAULT '0',
  `cusName` varchar(255) DEFAULT NULL,
  `cusPhn` varchar(255) DEFAULT NULL,
  `customerId` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_quotation` */

insert  into `prod_quotation`(`id`,`bill_display`,`total`,`prodDisc`,`extraDisc`,`payable`,`is_billed`,`is_cancelled`,`cusName`,`cusPhn`,`customerId`,`date`,`time`,`uid`) values 
(1,'Q26-1',445.000,0.000,0.000,445.000,0,0,'-','-',NULL,'2026-09-01','15:07:03',1);

/*Table structure for table `prod_quotation_details` */

DROP TABLE IF EXISTS `prod_quotation_details`;

CREATE TABLE `prod_quotation_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `quot_id` int NOT NULL,
  `prod_id` int NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `price` double(10,3) NOT NULL,
  `disc` double(10,3) DEFAULT NULL,
  `total` double(10,3) DEFAULT NULL,
  `gst` int DEFAULT NULL,
  `is_cancelled` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_quotation_details` */

insert  into `prod_quotation_details`(`id`,`quot_id`,`prod_id`,`qty`,`price`,`disc`,`total`,`gst`,`is_cancelled`) values 
(1,1,3,1.00,400.000,0.000,400.000,5,0),
(2,1,2,1.00,45.000,0.000,45.000,5,0);

/*Table structure for table `prod_stock_adjustment` */

DROP TABLE IF EXISTS `prod_stock_adjustment`;

CREATE TABLE `prod_stock_adjustment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `stockType` int NOT NULL COMMENT '1=add 2=minus',
  `stock` decimal(10,2) NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `notes` text,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `batch` (`batch_id`),
  KEY `stock` (`stockType`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `prod_stock_adjustment` */

insert  into `prod_stock_adjustment`(`id`,`product_id`,`batch_id`,`stockType`,`stock`,`date`,`time`,`notes`,`uid`) values 
(1,3,3,1,5.00,'2026-08-29','19:27:36','Adding Stock - w',1);

/*Table structure for table `prod_stock_totals` */

DROP TABLE IF EXISTS `prod_stock_totals`;

CREATE TABLE `prod_stock_totals` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `prods_id` int unsigned NOT NULL DEFAULT '0',
  `stock` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `rack` char(1) NOT NULL DEFAULT '',
  `shelf` int NOT NULL DEFAULT '0',
  `userlog` text,
  `extra1` tinyint unsigned DEFAULT '0',
  `extra2` tinyint unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `store_id_index` (`prods_id`),
  KEY `stock` (`stock`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `prod_stock_totals` */

insert  into `prod_stock_totals`(`id`,`prods_id`,`stock`,`rack`,`shelf`,`userlog`,`extra1`,`extra2`) values 
(1,1,9.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(2,2,21.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(3,3,109.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(4,5,10.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(5,4,1.00,'',0,'While Stock Added Through Purchase Entry',0,0);

/*Table structure for table `prod_supplier` */

DROP TABLE IF EXISTS `prod_supplier`;

CREATE TABLE `prod_supplier` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `gstin` varchar(255) DEFAULT NULL,
  `is_gst` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `prod_supplier` */

insert  into `prod_supplier`(`id`,`name`,`phone_number`,`description`,`date`,`time`,`is_active`,`gstin`,`is_gst`) values 
(1,'Supplier1','','','2026-07-30','10:48:06',1,NULL,0),
(2,'Supplier2','','','2026-07-30','10:48:11',1,NULL,0);

/*Table structure for table `prod_supplier_cheque_allocation` */

DROP TABLE IF EXISTS `prod_supplier_cheque_allocation`;

CREATE TABLE `prod_supplier_cheque_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `purchase_id` int NOT NULL,
  `allocated_amount` decimal(10,2) NOT NULL,
  `allocated_date` date NOT NULL,
  `allocated_time` time NOT NULL,
  `allocated_uid` int NOT NULL,
  `due_date` date DEFAULT NULL,
  `credit_days` int DEFAULT '10',
  `status` varchar(20) NOT NULL DEFAULT 'ALLOCATED',
  `cleared_date` date DEFAULT NULL,
  `cleared_time` time DEFAULT NULL,
  `cleared_uid` int DEFAULT NULL,
  `is_reversed` tinyint(1) DEFAULT '0',
  `reversed_date` date DEFAULT NULL,
  `reversed_time` time DEFAULT NULL,
  `reversed_uid` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_purchase` (`purchase_id`),
  KEY `idx_status` (`status`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_cheque_allocation` */

/*Table structure for table `prod_supplier_cheque_events` */

DROP TABLE IF EXISTS `prod_supplier_cheque_events`;

CREATE TABLE `prod_supplier_cheque_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `event_type` varchar(20) NOT NULL,
  `event_date` date NOT NULL,
  `event_time` time NOT NULL,
  `event_uid` int NOT NULL,
  `reason` text,
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_cheque_events` */

/*Table structure for table `prod_supplier_cheque_stock` */

DROP TABLE IF EXISTS `prod_supplier_cheque_stock`;

CREATE TABLE `prod_supplier_cheque_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int NOT NULL,
  `cheque_number` varchar(255) NOT NULL,
  `bank_name` text,
  `entry_date` date NOT NULL,
  `entry_time` time NOT NULL,
  `entry_uid` int NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'AVAILABLE',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`),
  KEY `idx_status` (`status`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_cheque_stock` */

/*Table structure for table `prod_supplier_due` */

DROP TABLE IF EXISTS `prod_supplier_due`;

CREATE TABLE `prod_supplier_due` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `supplier_id` int NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `cash_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
  `bank_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
  `balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `pay_mode` tinyint NOT NULL DEFAULT '1',
  `pay_type` tinyint NOT NULL DEFAULT '0',
  `txn_type` varchar(20) NOT NULL DEFAULT 'COLLECTION',
  `notes` varchar(255) DEFAULT NULL,
  `uid` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`),
  KEY `idx_txn_type` (`txn_type`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_due` */

insert  into `prod_supplier_due`(`id`,`supplier_id`,`amount`,`cash_paid`,`bank_paid`,`balance`,`pay_mode`,`pay_type`,`txn_type`,`notes`,`uid`,`date`,`time`) values 
(1,1,400.00,400.00,0.00,400.00,1,1,'COLLECTION',NULL,1,'2026-07-30','10:49:20'),
(2,1,100.00,100.00,0.00,400.00,1,1,'ADVANCE','Supplier advance',1,'2026-07-30','10:49:27'),
(3,1,500.00,0.00,0.00,900.00,0,0,'OLD_DUE','Old due (before system)',1,'2026-07-30','10:49:35'),
(4,1,50.00,50.00,0.00,800.00,1,1,'COLLECTION',NULL,1,'2026-07-30','11:01:08'),
(5,1,100.00,100.00,0.00,700.00,1,1,'COLLECTION',NULL,1,'2026-07-30','11:17:09'),
(6,1,100.00,100.00,0.00,700.00,1,1,'ADVANCE','Supplier advance',1,'2026-07-30','11:17:15'),
(7,1,100.00,0.00,0.00,800.00,0,0,'OLD_DUE','Old due (before system)',1,'2026-07-30','11:17:21'),
(8,1,500.00,0.00,0.00,1300.00,0,0,'OLD_DUE','Old due (before system)',1,'2026-07-30','11:22:11'),
(9,1,3265.00,0.00,3265.00,20000.00,2,1,'COLLECTION',NULL,1,'2026-09-01','15:02:26'),
(10,1,10000.00,10000.00,0.00,10620.50,1,1,'COLLECTION',NULL,1,'2026-09-01','15:23:16');

/*Table structure for table `prod_units` */

DROP TABLE IF EXISTS `prod_units`;

CREATE TABLE `prod_units` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `convertion_unit` varchar(255) DEFAULT NULL,
  `convertion_calculation` decimal(10,2) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_units` */

insert  into `prod_units`(`id`,`name`,`convertion_unit`,`convertion_calculation`,`is_active`) values 
(1,'NOS',NULL,NULL,1),
(2,'Gram',NULL,NULL,1),
(3,'KG',NULL,NULL,1),
(4,'Meter',NULL,NULL,1),
(5,'length','Feet',20.00,1);

/*Table structure for table `sales_area` */

DROP TABLE IF EXISTS `sales_area`;

CREATE TABLE `sales_area` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_active` int DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `sales_area` */

/*Table structure for table `sales_man` */

DROP TABLE IF EXISTS `sales_man`;

CREATE TABLE `sales_man` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  `created_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `sales_man` */

/*Table structure for table `special_permission` */

DROP TABLE IF EXISTS `special_permission`;

CREATE TABLE `special_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `special_permission` */

insert  into `special_permission`(`id`,`content`) values 
(1,'allow to Zero stock billing ');

/*Table structure for table `supplier_account` */

DROP TABLE IF EXISTS `supplier_account`;

CREATE TABLE `supplier_account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int NOT NULL,
  `advance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_supplier` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `supplier_account` */

insert  into `supplier_account`(`id`,`supplier_id`,`advance`,`balance`) values 
(1,1,200.00,10620.50),
(2,2,0.00,0.00);

/*Table structure for table `user_modules` */

DROP TABLE IF EXISTS `user_modules`;

CREATE TABLE `user_modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

/*Data for the table `user_modules` */

insert  into `user_modules`(`id`,`module_name`) values 
(1,'Billing'),
(2,'Master'),
(3,'Stock Reports'),
(4,'User management'),
(5,'Inventory'),
(6,'Account Report'),
(7,'Admin'),
(8,'Statistics'),
(10,'Credit Management'),
(11,'order list'),
(12,'Expense');

/*Table structure for table `user_permission` */

DROP TABLE IF EXISTS `user_permission`;

CREATE TABLE `user_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int NOT NULL,
  `uid` int NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mod` (`module_id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=latin1;

/*Data for the table `user_permission` */

insert  into `user_permission`(`id`,`module_id`,`uid`,`date`,`time`) values 
(70,1,1,'2025-09-19','11:43:23'),
(71,2,1,'2025-09-19','11:43:23'),
(72,3,1,'2025-09-19','11:43:23'),
(73,4,1,'2025-09-19','11:43:23'),
(74,5,1,'2025-09-19','11:43:23'),
(75,6,1,'2025-09-19','11:43:23'),
(76,7,1,'2025-09-19','11:43:23'),
(77,8,1,'2025-09-19','11:43:23'),
(81,8,1,'2025-09-19','11:51:25'),
(102,10,1,'2026-01-16',NULL),
(113,11,1,'2026-01-25','17:40:35'),
(115,1,23,'2026-02-19','12:25:37'),
(116,12,1,'2026-02-19','12:00:00'),
(117,1,22,'2026-02-27','11:51:13'),
(118,12,22,'2026-02-27','11:51:13'),
(119,1,24,'2026-03-05','17:40:35'),
(120,13,1,'2026-03-05','17:40:35'),
(121,1,25,'2026-08-29','19:33:34');

/*Table structure for table `user_special_permission` */

DROP TABLE IF EXISTS `user_special_permission`;

CREATE TABLE `user_special_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user_special_permission` */

insert  into `user_special_permission`(`id`,`content_id`,`user_id`) values 
(3,1,1);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  `fullName` varchar(255) DEFAULT NULL,
  `disc_per` int DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

/*Data for the table `users` */

insert  into `users`(`id`,`user_name`,`password`,`is_active`,`fullName`,`disc_per`) values 
(1,'admin','aecbf9a63cec1e93327dfc212f31acdb31c4f5d10bedccf8fbb8b042a6f0f39155797bdd04517905ae5d98b69fdc452cdb61b018e10939740ec96f36e133d639',1,'admin',50),
(22,'demo','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'demo',100),
(23,'hi','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'hi',100),
(24,'saran','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'saran',100),
(25,'check','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'check',100);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
