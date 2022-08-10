-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 21, 2022 at 10:43 PM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db2022_a`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `apply_balance` (`id` INT, `remain_balance` INT)  BEGIN
    DECLARE new_balance INT DEFAULT 0;
    SET new_balance = remain_balance - 5000;
    UPDATE account SET balance = new_balance WHERE accountID = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `example1` ()  BEGIN
    DECLARE l_book_count INTEGER;
    SELECT COUNT(*) AS Number_of_books
    INTO l_book_count
    FROM books
    WHERE author LIKE "%HARRISON,GUY%";
    SELECT concat("Guy has written (or co-written) ", l_book_count, " books");

    
    UPDATE books
    SET author = REPLACE (author, 'GUY', 'GUILLERMO')
    WHERE author LIKE '%HARISSON,GUY%';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllEmp` ()  begin
SELECT * FROM emp;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProducts` ()  begin
select * from products;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getdata` ()  begin
declare a varchar(20);
declare b tinytext;
select user_name, user_password into a,b from user_data limit 1;
select a,b;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `member_contact` (IN `fn` VARCHAR(15), IN `ln` VARCHAR(15))  BEGIN
    SELECT Phone FROM member
    WHERE FirstName = fn and LastName = ln;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p2` ()  begin
select 'Testing Procedure' as Title;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pay_out_balance` (`account_id_in` INT)  BEGIN
    DECLARE l_balance_remaining NUMERIC(10,2);
    payout_loop:LOOP
        SET l_balance_remaining = account_balance(account_id_in);
        IF l_balance_remaining < 1000 THEN 
            LEAVE payout_loop;
        ELSE
            CALL apply_balance(account_id_in, l_balance_remaining); 
        END IF;
    END LOOP;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `quiz` (IN `p` VARCHAR(10), IN `q` VARCHAR(10))  begin
set @Name = p;
set @Dep = q;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_product_code` (`in_product_code` VARCHAR(2), `in_product_name` VARCHAR(30))  BEGIN
DECLARE l_dupkey_indicator INT DEFAULT 0; 
DECLARE duplicate_key CONDITION FOR 1062; 
DECLARE CONTINUE HANDLER FOR duplicate_key SET l_dupkey_indicator = 1;
INSERT INTO product_codes (product_code, product_name) VALUES (in_product_code, in_product_name);
IF l_dupkey_indicator THEN 
    UPDATE product_codes SET product_name = in_product_name WHERE product_code = in_product_code; 
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tour_entry` ()  BEGIN
    SELECT TourName, TourType, year FROM tour NATURAL JOIN ENTRY;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_in` (IN `p` VARCHAR(10))  begin
set @Name = p;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_inout` (INOUT `p` INT)  begin
set p = p+2;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_out` (OUT `p` VARCHAR(100))  begin
set p = 'Zahid';
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_variable` (IN `p` INT)  begin
declare a int;
declare b int default 10;
set a = p*b;
insert into tmptest(id, txt) values (a,hex("DEF"));
end$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `account_balance` (`id` INT) RETURNS INT(11) BEGIN
    DECLARE getbalance INT default 0;
    SELECT balance INTO getbalance FROM account WHERE accountID = id;
    return (getbalance);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `depSearch` (`id` INT) RETURNS VARCHAR(30) CHARSET latin1 begin
DECLARE l_Dep_Found varchar(30) DEFAULT "";
SELECT depName INTO l_Dep_Found FROM department WHERE depID = id;
RETURN l_Dep_Found;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `empSearch` (`id` INT) RETURNS VARCHAR(30) CHARSET latin1 begin
DECLARE l_Name_Found varchar(30) DEFAULT "";
SELECT empName INTO l_Name_Found FROM emp WHERE empID = id;
RETURN l_Name_Found;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `f_age` (`in_dob` DATETIME) RETURNS INT(11) NO SQL
begin
    declare l_age INt;
    if DATE_FORmat(now(), '00-%m-%d') >= DATE_FORmat(in_dob, '00-%m-%d') then 
        SET l_age = DATE_FORmat(now(), '%Y') - DATE_FORmat(in_dob, '%Y');
    ELSE
        SET l_age = DATE_FORmat(now(), '%Y') - DATE_FORmat(in_dob, '%Y') - 1;
    END IF;
    return(l_age);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `memberDuration` (`d` YEAR) RETURNS INT(11) begin
    declare a int;
    select year(current_date) into a;
    set a = a - d;
    return(a);
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `member_con` (`fn` VARCHAR(15), `ln` VARCHAR(15)) RETURNS INT(11) begin
    declare contact int default 0;
    select Phone into contact from member where FirstName = fn and LastName = ln;
    return contact;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `search_emp` (`id` INT) RETURNS VARCHAR(30) CHARSET latin1 begin
    declare name_found varchar(30) default "";
    select empName into name_found from emp where empID = id;
    return name_found;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `accountID` int(11) NOT NULL,
  `accountOwner` varchar(30) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`accountID`, `accountOwner`, `balance`) VALUES
(1, 'Fasih Zaman', 10000000);

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `bookID` int(11) NOT NULL,
  `bookName` varchar(40) DEFAULT NULL,
  `author` varchar(40) DEFAULT 'Guy'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`bookID`, `bookName`, `author`) VALUES
(1, 'MySQL', 'Harrison'),
(2, 'NoSQL', 'Guy');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `depID` int(11) NOT NULL,
  `depName` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`depID`, `depName`) VALUES
(10, 'CSE'),
(15, 'EE'),
(20, 'MinE'),
(25, 'AgriE');

-- --------------------------------------------------------

--
-- Table structure for table `dummy`
--

CREATE TABLE `dummy` (
  `num` int(11) NOT NULL,
  `data` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `emp`
--

CREATE TABLE `emp` (
  `empID` int(11) NOT NULL,
  `empName` varchar(30) DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `empJob` varchar(30) DEFAULT NULL,
  `depID` int(11) NOT NULL,
  `salary` int(11) DEFAULT 20000,
  `bonus` int(11) DEFAULT 0,
  `contrib_401K` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `emp`
--

INSERT INTO `emp` (`empID`, `empName`, `date_of_birth`, `empJob`, `depID`, `salary`, `bonus`, `contrib_401K`) VALUES
(1, 'Fahim Jan', '1992-02-25', 'Lab Assistant', 15, 35000, 2250, 500),
(2, 'Khalil Khan', '1982-07-15', 'Assistant Professor', 10, 25000, 1750, 500),
(3, 'Zia Ullah', '1990-02-05', 'Lecturer', 10, 10500, 500, 500),
(4, 'Tariq Kamal', '1999-08-01', 'Lab Engineer', 15, 20000, 500, 500),
(5, 'Shandana Khalil', '2000-07-31', 'Lecturer', 15, 20000, 500, 500),
(6, 'Syed Shaaf', '2001-02-28', 'Assistant Professor', 15, 50000, 3000, 500);

--
-- Triggers `emp`
--
DELIMITER $$
CREATE TRIGGER `emp_bonus` BEFORE UPDATE ON `emp` FOR EACH ROW begin
    if new.salary < 25000 then set new.bonus = 500;
    else set new.bonus = 500 + (new.salary * 0.05);
    end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `emp_trg_bu` BEFORE UPDATE ON `emp` FOR EACH ROW begin
if new.salary < 30000 then
set new.bonus = 500;
else
set new.bonus = 500+(new.salary-30000)*0.01;
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `employees_trg_bu` BEFORE UPDATE ON `emp` FOR EACH ROW begin
    If NEW.salary < 50000 THEN
        SET NEW.contrib_401K = 500;
    ELSE
        SET NEW.contrib_401K = 500 + (NEW.salary - 50000) * .01;
    ENd If;
ENd
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `empdep`
-- (See below for the actual view)
--
CREATE TABLE `empdep` (
`empName` varchar(30)
,`depName` varchar(30)
);

-- --------------------------------------------------------

--
-- Table structure for table `entry`
--

CREATE TABLE `entry` (
  `EntryID` int(11) NOT NULL,
  `EntryName` varchar(30) DEFAULT NULL,
  `tourID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `entry`
--

INSERT INTO `entry` (`EntryID`, `EntryName`, `tourID`) VALUES
(1, 'Fahad', 1),
(2, 'Ammar', 1);

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `memberID` int(11) NOT NULL,
  `FirstName` varchar(30) DEFAULT NULL,
  `LastName` varchar(30) DEFAULT NULL,
  `Team` varchar(20) NOT NULL,
  `Phone` int(11) DEFAULT NULL,
  `JoinDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`memberID`, `FirstName`, `LastName`, `Team`, `Phone`, `JoinDate`) VALUES
(1, 'Talha', 'Khurshid', '', 12354, '2019-05-01'),
(2, 'Uzair', 'Khattak', 'Team B', 84536, '2020-06-30'),
(3, 'Anis', 'Khan Achakzai', 'Team A', 86896, '2021-01-20');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_ID` int(11) NOT NULL,
  `productName` varchar(20) DEFAULT NULL,
  `productDesc` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_ID`, `productName`, `productDesc`) VALUES
(1, 'Tea', 'Lipton Black Tea 950 grams');

-- --------------------------------------------------------

--
-- Table structure for table `product_codes`
--

CREATE TABLE `product_codes` (
  `product_code` int(11) NOT NULL,
  `product_name` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_codes`
--

INSERT INTO `product_codes` (`product_code`, `product_name`) VALUES
(54, 'Lays Masala Chips'),
(84, 'Nestle Guava Juice');

-- --------------------------------------------------------

--
-- Table structure for table `tmptest`
--

CREATE TABLE `tmptest` (
  `id` int(11) NOT NULL,
  `txt` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tmptest`
--

INSERT INTO `tmptest` (`id`, `txt`) VALUES
(40, '444546');

-- --------------------------------------------------------

--
-- Table structure for table `tour`
--

CREATE TABLE `tour` (
  `tourID` int(11) NOT NULL,
  `TourName` varchar(30) DEFAULT NULL,
  `TourType` varchar(30) DEFAULT NULL,
  `year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tour`
--

INSERT INTO `tour` (`tourID`, `TourName`, `TourType`, `year`) VALUES
(1, 'Tour de Swat', '1 day trek', 2022);

-- --------------------------------------------------------

--
-- Table structure for table `user_data`
--

CREATE TABLE `user_data` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(30) DEFAULT NULL,
  `user_password` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_data`
--

INSERT INTO `user_data` (`user_id`, `user_name`, `user_password`) VALUES
(1, 'user1234', 'uet1234');

-- --------------------------------------------------------

--
-- Structure for view `empdep`
--
DROP TABLE IF EXISTS `empdep`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `empdep`  AS  select `emp`.`empName` AS `empName`,`department`.`depName` AS `depName` from (`emp` join `department`) where `emp`.`depID` = `department`.`depID` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`bookID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`depID`);

--
-- Indexes for table `dummy`
--
ALTER TABLE `dummy`
  ADD PRIMARY KEY (`num`);

--
-- Indexes for table `emp`
--
ALTER TABLE `emp`
  ADD PRIMARY KEY (`empID`),
  ADD KEY `depID` (`depID`);

--
-- Indexes for table `entry`
--
ALTER TABLE `entry`
  ADD PRIMARY KEY (`EntryID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_ID`);

--
-- Indexes for table `product_codes`
--
ALTER TABLE `product_codes`
  ADD PRIMARY KEY (`product_code`);

--
-- Indexes for table `tmptest`
--
ALTER TABLE `tmptest`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tour`
--
ALTER TABLE `tour`
  ADD PRIMARY KEY (`tourID`);

--
-- Indexes for table `user_data`
--
ALTER TABLE `user_data`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `emp`
--
ALTER TABLE `emp`
  ADD CONSTRAINT `depID` FOREIGN KEY (`depID`) REFERENCES `department` (`depID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
