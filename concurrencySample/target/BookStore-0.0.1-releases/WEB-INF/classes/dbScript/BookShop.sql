/*
 Navicat Premium Data Transfer

 Source Server         : MySql
 Source Server Type    : MySQL
 Source Server Version : 50710
 Source Host           : localhost
 Source Database       : BookShop

 Target Server Type    : MySQL
 Target Server Version : 50710
 File Encoding         : utf-8

 Date: 07/21/2016 18:23:36 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `APP_User`
-- ----------------------------
DROP TABLE IF EXISTS `APP_User`;
CREATE TABLE `APP_User` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `UserName` varchar(30) NOT NULL,
  `PassWord` varchar(60) NOT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `IsEnabled` bit(1) NOT NULL,
  `is_online` bit(1) NOT NULL,
  `VisitedCount` int(11) DEFAULT NULL,
  `LastVisitDate` datetime DEFAULT NULL,
  `CreatedDate` datetime NOT NULL,
  `UpdatedDate` datetime NOT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `UpdatedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `uniq_User_Name` (`UserName`),
  KEY `FK_huktl0hlltq92c4tvfxg83kth` (`CreatedBy`),
  KEY `FK_7cxhoojweut5wq1ahj20rbcb9` (`UpdatedBy`),
  CONSTRAINT `FK_7cxhoojweut5wq1ahj20rbcb9` FOREIGN KEY (`UpdatedBy`) REFERENCES `APP_User` (`Id`),
  CONSTRAINT `FK_huktl0hlltq92c4tvfxg83kth` FOREIGN KEY (`CreatedBy`) REFERENCES `APP_User` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `APP_User`
-- ----------------------------
BEGIN;
INSERT INTO `APP_User` VALUES ('1', 'mohamamd', 'mirzaeyan', 'admin', '40bd001563085fc35165329ea1ff5c5ecbdbbeef', 'mohammad.mirzaeyan@gmail.com', b'1', b'1', '0', '2016-02-19 13:21:53', '2016-02-19 13:21:53', '2016-02-19 13:21:53', '1', '1'), ('34', 'اغاغا', 'اغااغاغ', 'jijijiji', '9d8a36ad37cdea4d9b9439915feee84a58e2d1a4', 'اغاغاغاغاغ', b'1', b'0', '0', null, '2016-05-13 13:21:24', '2016-05-13 13:21:24', '1', '1'), ('36', 'hamed', 'hamed', 'hamed', '2c205202f37171e34505a16971a84888377cc404', 'h@h.com', b'1', b'0', '0', null, '2016-05-13 17:33:10', '2016-05-13 17:33:10', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `App_BaseInformation`
-- ----------------------------
DROP TABLE IF EXISTS `App_BaseInformation`;
CREATE TABLE `App_BaseInformation` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Code` int(11) DEFAULT NULL,
  `Topic` varchar(100) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `ACTIVE` bit(1) DEFAULT NULL,
  `ParentId` bigint(20) DEFAULT NULL,
  `Master_Information_Id` bigint(20) DEFAULT NULL,
  `CreatedBy` int(11) NOT NULL,
  `UpdatedBy` int(11) NOT NULL,
  `CreatedDate` datetime NOT NULL,
  `UpdatedDate` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_27gvnrj4cevwdi1o40dc24225` (`ParentId`),
  KEY `FK_cm1okinhwqvox26fvng6uxi5g` (`Master_Information_Id`),
  KEY `FK_l7woxfilgifew596vluswiivy` (`CreatedBy`),
  KEY `FK_57oeoc45d9a8b4r03n8c7tbw4` (`UpdatedBy`),
  CONSTRAINT `FK_27gvnrj4cevwdi1o40dc24225` FOREIGN KEY (`ParentId`) REFERENCES `App_BaseInformationHeader` (`ID`),
  CONSTRAINT `FK_57oeoc45d9a8b4r03n8c7tbw4` FOREIGN KEY (`UpdatedBy`) REFERENCES `APP_User` (`Id`),
  CONSTRAINT `FK_cm1okinhwqvox26fvng6uxi5g` FOREIGN KEY (`Master_Information_Id`) REFERENCES `App_BaseInformation` (`ID`),
  CONSTRAINT `FK_l7woxfilgifew596vluswiivy` FOREIGN KEY (`CreatedBy`) REFERENCES `APP_User` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `App_BaseInformation`
-- ----------------------------
BEGIN;
INSERT INTO `App_BaseInformation` VALUES ('11', '1', 'وزیری', '', b'1', '3', null, '1', '1', '2016-06-30 16:58:04', '2016-06-30 16:58:04'), ('12', '1', 'ریاضی', '', b'1', '7', null, '1', '1', '2016-06-30 17:11:30', '2016-06-30 17:11:30'), ('13', '1', 'انسانی', '', b'1', '6', null, '1', '1', '2016-06-30 17:11:45', '2016-06-30 17:11:45'), ('14', '1', 'ابتدایی', '', b'1', '5', null, '1', '1', '2016-06-30 17:12:00', '2016-06-30 17:12:00'), ('15', '1', 'کمک درسی ', '', b'1', '4', null, '1', '1', '2016-06-30 17:12:14', '2016-06-30 17:12:14'), ('16', '2', 'تجربی', '', b'1', '6', null, '1', '1', '2016-07-06 20:28:36', '2016-07-06 20:28:36'), ('17', '3', 'ریاضی', '', b'1', '6', null, '1', '1', '2016-07-06 20:28:55', '2016-07-06 20:28:55'), ('18', '2', 'راهنمایی', '', b'1', '5', null, '1', '1', '2016-07-06 20:29:22', '2016-07-06 20:29:22'), ('19', '3', 'دبیرستان', '', b'1', '5', null, '1', '1', '2016-07-06 20:31:13', '2016-07-06 20:31:13'), ('20', '2', 'درسی', '', b'1', '4', null, '1', '1', '2016-07-06 20:31:25', '2016-07-06 20:31:25'), ('21', '3', 'رمان', '', b'1', '4', null, '1', '1', '2016-07-06 20:31:38', '2016-07-06 20:31:38');
COMMIT;

-- ----------------------------
--  Table structure for `App_BaseInformationHeader`
-- ----------------------------
DROP TABLE IF EXISTS `App_BaseInformationHeader`;
CREATE TABLE `App_BaseInformationHeader` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Topic` varchar(50) NOT NULL,
  `CreatedBy` int(11) NOT NULL,
  `UpdatedBy` int(11) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_da82iv3hc0ggew127e7958jsv` (`CreatedBy`),
  KEY `FK_nhtg5gn329250yc9wx7x9imjc` (`UpdatedBy`),
  CONSTRAINT `FK_da82iv3hc0ggew127e7958jsv` FOREIGN KEY (`CreatedBy`) REFERENCES `APP_User` (`Id`),
  CONSTRAINT `FK_nhtg5gn329250yc9wx7x9imjc` FOREIGN KEY (`UpdatedBy`) REFERENCES `APP_User` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `App_BaseInformationHeader`
-- ----------------------------
BEGIN;
INSERT INTO `App_BaseInformationHeader` VALUES ('3', 'قطع کتاب', '1', '1', '2016-01-01', '2016-01-01'), ('4', 'نوع کتاب', '1', '1', '2016-01-01', '2016-01-01'), ('5', 'مقطع تحصیلی ', '1', '1', '2016-01-01', '2016-01-01'), ('6', 'رشته', '1', '1', '2016-01-01', '2016-01-01'), ('7', 'درس', '1', '1', '2016-01-01', '2016-01-01');
COMMIT;

-- ----------------------------
--  Table structure for `App_Order`
-- ----------------------------
DROP TABLE IF EXISTS `App_Order`;
CREATE TABLE `App_Order` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `User_Id` bigint(20) NOT NULL,
  `orderStatus` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `tel` varchar(255) DEFAULT NULL,
  `mobilePhone` varchar(255) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `CreatedBy` bigint(20) NOT NULL,
  `UpdatedBy` bigint(20) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  `Ip` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `App_Order_Item`
-- ----------------------------
DROP TABLE IF EXISTS `App_Order_Item`;
CREATE TABLE `App_Order_Item` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Order_Id` bigint(20) NOT NULL,
  `goods_Id` bigint(20) NOT NULL,
  `CreatedBy` bigint(20) NOT NULL,
  `UpdatedBy` bigint(20) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  `Ip` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_8fxipco1xfk31nd3memrbk6rx` (`Order_Id`),
  KEY `FK_lipjbf4ljpa1hncv9q5dv923k` (`goods_Id`),
  CONSTRAINT `FK_8fxipco1xfk31nd3memrbk6rx` FOREIGN KEY (`Order_Id`) REFERENCES `App_Order` (`ID`),
  CONSTRAINT `FK_lipjbf4ljpa1hncv9q5dv923k` FOREIGN KEY (`goods_Id`) REFERENCES `Core_Goods` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `Core_Goods`
-- ----------------------------
DROP TABLE IF EXISTS `Core_Goods`;
CREATE TABLE `Core_Goods` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Goods_Type` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `CreatedBy` bigint(20) NOT NULL,
  `UpdatedBy` bigint(20) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  `Ip` varchar(255) NOT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `Core_Goods`
-- ----------------------------
BEGIN;
INSERT INTO `Core_Goods` VALUES ('1', null, '1/1', '1', '1', '2016-07-06', '2016-07-06', '0:0:0:0:0:0:0:1', '11000');
COMMIT;

-- ----------------------------
--  Table structure for `Core_Goods_Book`
-- ----------------------------
DROP TABLE IF EXISTS `Core_Goods_Book`;
CREATE TABLE `Core_Goods_Book` (
  `Goods_Id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `print_Year` int(11) DEFAULT NULL,
  `author` varchar(255) NOT NULL,
  `translator` varchar(255) DEFAULT NULL,
  `pages_Count` int(11) DEFAULT NULL,
  `book_Weight` double DEFAULT NULL,
  `publish_Edition` int(11) DEFAULT NULL,
  `picture_Name` varchar(255) DEFAULT NULL,
  `picture_Code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `book_Format_Type_Id` bigint(20) DEFAULT NULL,
  `book_Type_Id` bigint(20) DEFAULT NULL,
  `field_Id` bigint(20) DEFAULT NULL,
  `lesson_Id` bigint(20) DEFAULT NULL,
  `publisher_Id` bigint(20) NOT NULL,
  `publisher_Product_Id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Goods_Id`),
  KEY `FK_mjbqky27uic72dhnn95ed3xpp` (`book_Format_Type_Id`),
  KEY `FK_dioylq2rmrk3pttr9ysp34kc4` (`book_Type_Id`),
  KEY `FK_ok9qshb0us27fderlng3dks75` (`field_Id`),
  KEY `FK_a2fs05ooeauphne5ycoutsyfm` (`lesson_Id`),
  KEY `FK_tcg0vvx4h0elrif42o89o6lr2` (`publisher_Id`),
  KEY `FK_gsenw2cvbrlf5aniwubf0ff1p` (`publisher_Product_Id`),
  CONSTRAINT `FK_a2fs05ooeauphne5ycoutsyfm` FOREIGN KEY (`lesson_Id`) REFERENCES `App_BaseInformation` (`ID`),
  CONSTRAINT `FK_dioylq2rmrk3pttr9ysp34kc4` FOREIGN KEY (`book_Type_Id`) REFERENCES `App_BaseInformation` (`ID`),
  CONSTRAINT `FK_gsenw2cvbrlf5aniwubf0ff1p` FOREIGN KEY (`publisher_Product_Id`) REFERENCES `Core_Publisher_Product` (`ID`),
  CONSTRAINT `FK_mjbqky27uic72dhnn95ed3xpp` FOREIGN KEY (`book_Format_Type_Id`) REFERENCES `App_BaseInformation` (`ID`),
  CONSTRAINT `FK_ok9qshb0us27fderlng3dks75` FOREIGN KEY (`field_Id`) REFERENCES `App_BaseInformation` (`ID`),
  CONSTRAINT `FK_q33afa3t9xjjcc6wqggxrh47m` FOREIGN KEY (`Goods_Id`) REFERENCES `Core_Goods` (`ID`),
  CONSTRAINT `FK_tcg0vvx4h0elrif42o89o6lr2` FOREIGN KEY (`publisher_Id`) REFERENCES `Core_Publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `Core_Goods_Book`
-- ----------------------------
BEGIN;
INSERT INTO `Core_Goods_Book` VALUES ('1', 'ریاضی پیش دانشگاهی', '2222-111222-222', '1394', 'test', '', '100', '100', '1', '', '', '', '11', '15', null, '12', '10', null);
COMMIT;

-- ----------------------------
--  Table structure for `Core_Publisher`
-- ----------------------------
DROP TABLE IF EXISTS `Core_Publisher`;
CREATE TABLE `Core_Publisher` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `publisher_Name` varchar(255) NOT NULL,
  `tel` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `CreatedBy` bigint(20) NOT NULL,
  `UpdatedBy` bigint(20) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  `Ip` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `Core_Publisher`
-- ----------------------------
BEGIN;
INSERT INTO `Core_Publisher` VALUES ('10', 'گاج', '۲۱۳۱۲', 'تتمنمن', '1', '1', '2016-06-18', '2016-06-18', '0:0:0:0:0:0:0:1'), ('11', 'خیلی سبز', '111223', 'daasdasd', '1', '1', '2016-07-01', '2016-07-01', '0:0:0:0:0:0:0:1');
COMMIT;

-- ----------------------------
--  Table structure for `Core_Publisher_Product`
-- ----------------------------
DROP TABLE IF EXISTS `Core_Publisher_Product`;
CREATE TABLE `Core_Publisher_Product` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `productName` varchar(255) NOT NULL,
  `publisher_Id` bigint(20) NOT NULL,
  `CreatedBy` bigint(20) NOT NULL,
  `UpdatedBy` bigint(20) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  `Ip` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_to29baobk6t42sj3eoiqi9wtp` (`publisher_Id`),
  CONSTRAINT `FK_to29baobk6t42sj3eoiqi9wtp` FOREIGN KEY (`publisher_Id`) REFERENCES `Core_Publisher` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `Core_Publisher_Product`
-- ----------------------------
BEGIN;
INSERT INTO `Core_Publisher_Product` VALUES ('1', 'میکرو', '10', '1', '1', '2016-06-18', '2016-06-18', '0:0:0:0:0:0:0:1'), ('2', 'محصول ۱ ', '11', '1', '1', '2016-07-01', '2016-07-01', '0:0:0:0:0:0:0:1');
COMMIT;

-- ----------------------------
--  Table structure for `Core_file`
-- ----------------------------
DROP TABLE IF EXISTS `Core_file`;
CREATE TABLE `Core_file` (
  `Id` bigint(20) NOT NULL AUTO_INCREMENT,
  `File_Name` varchar(255) DEFAULT NULL,
  `File_Type` varchar(255) DEFAULT NULL,
  `File_Code` varchar(255) DEFAULT NULL,
  `Attachment` longblob,
  `AcceptDate` varchar(255) DEFAULT NULL,
  `CreatedBy` int(11) NOT NULL,
  `UpdatedBy` int(11) NOT NULL,
  `CreatedDate` date NOT NULL,
  `UpdatedDate` date NOT NULL,
  `Ip` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_o5cuicep52r8dq3vqvy6xjs3b` (`CreatedBy`),
  KEY `FK_dfegdhnl0ub8bo7ymiwkiw4uo` (`UpdatedBy`),
  CONSTRAINT `FK_dfegdhnl0ub8bo7ymiwkiw4uo` FOREIGN KEY (`UpdatedBy`) REFERENCES `APP_User` (`Id`),
  CONSTRAINT `FK_o5cuicep52r8dq3vqvy6xjs3b` FOREIGN KEY (`CreatedBy`) REFERENCES `APP_User` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `STR_Books_Field`
-- ----------------------------
DROP TABLE IF EXISTS `STR_Books_Field`;
CREATE TABLE `STR_Books_Field` (
  `Book_Id` bigint(20) NOT NULL,
  `Field_Id` bigint(20) NOT NULL,
  PRIMARY KEY (`Book_Id`,`Field_Id`),
  KEY `FK_sugouraw8y04hou7kslff5q12` (`Field_Id`),
  CONSTRAINT `FK_fllxw3tss6rs7c2esec1arujt` FOREIGN KEY (`Book_Id`) REFERENCES `Core_Goods_Book` (`Goods_Id`),
  CONSTRAINT `FK_sugouraw8y04hou7kslff5q12` FOREIGN KEY (`Field_Id`) REFERENCES `App_BaseInformation` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `STR_Books_Field`
-- ----------------------------
BEGIN;
INSERT INTO `STR_Books_Field` VALUES ('1', '16'), ('1', '17');
COMMIT;

-- ----------------------------
--  Table structure for `STR_Books_Grade`
-- ----------------------------
DROP TABLE IF EXISTS `STR_Books_Grade`;
CREATE TABLE `STR_Books_Grade` (
  `Book_Id` bigint(20) NOT NULL,
  `Grade_Id` bigint(20) NOT NULL,
  PRIMARY KEY (`Book_Id`,`Grade_Id`),
  KEY `FK_qw73bxym379dq0kyxxeti00n8` (`Grade_Id`),
  CONSTRAINT `FK_gads41ixo86dq6ntb3eyy1h00` FOREIGN KEY (`Book_Id`) REFERENCES `Core_Goods_Book` (`Goods_Id`),
  CONSTRAINT `FK_qw73bxym379dq0kyxxeti00n8` FOREIGN KEY (`Grade_Id`) REFERENCES `App_BaseInformation` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `STR_Books_Grade`
-- ----------------------------
BEGIN;
INSERT INTO `STR_Books_Grade` VALUES ('1', '18');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
