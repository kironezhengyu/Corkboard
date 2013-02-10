-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2013 at 10:22 AM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `corkboard`
--
CREATE DATABASE `corkboard` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `corkboard`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `addFriend`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN



	IF(self <> friend) THEN



		INSERT INTO friends



		VALUES(self, friend);



	END IF;



END$$

DROP PROCEDURE IF EXISTS `addFriend2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addFriend2`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN



	IF self IS NULL OR friend IS NULL



	THEN



		SIGNAL SQLSTATE '02000'



			SET MESSAGE_TEXT = 'Values may not be NULL.';



	END IF;







	IF self OR friend NOT IN (SELECT userName FROM user)



	THEN



		SIGNAL SQLSTATE '05000'



			SET MESSAGE_TEXT = 'Username does not exist.';



	END IF;







	IF(self <> friend) THEN



		INSERT INTO friends



		VALUES(self, friend);



	END IF;



END$$

DROP PROCEDURE IF EXISTS `create_msg`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_msg`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `pid` INT(100), IN `inlink` VARCHAR(255))
    NO SQL
BEGIN 



DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;



DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;







START TRANSACTION;







insert into message(postId,userName, content) values (pid,inuname,incontent);


 



	insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), inlink);




COMMIT;







END$$

DROP PROCEDURE IF EXISTS `create_msg_2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_msg_2`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `pid` INT(30), IN `inlink` VARCHAR(255))
BEGIN







	IF inuname IS NULL OR incontent IS NULL OR pid IS NULL



	THEN



		SIGNAL SQLSTATE '02000'



			SET MESSAGE_TEXT = 'Values may not be NULL.';



	END IF;







	IF inuname NOT IN (SELECT userName FROM user WHERE userName = inuname)



	THEN



		SIGNAL SQLSTATE '05000'



			SET MESSAGE_TEXT = 'Username does not exist.';



	END IF;



	



	IF pid NOT IN (SELECT pid FROM posts)



	THEN



		SIGNAL SQLSTATE '06000'



			SET MESSAGE_TEXT = 'PostID does not exist.';



	END IF;







	START TRANSACTION;







	insert into message(postId,userName, content) values (pid,inuname,incontent);



	IF (inlink!= '') THEN 



		insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), inlink);



	END IF;



	COMMIT;







END$$

DROP PROCEDURE IF EXISTS `create_post_proc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post_proc`(IN `uname` VARCHAR(100), IN `ptopic` VARCHAR(100), OUT `pid` INT)
BEGIN







DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;



DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;







START TRANSACTION;







insert into post(userName, topic) values (uname, ptopic);







SET pid = (select postId from post order by postId desc limit 1);



COMMIT;







select pid;







END$$

DROP PROCEDURE IF EXISTS `fetch_friends`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_friends`(IN `inuname` VARCHAR(100))
    READS SQL DATA
SELECT friend_user_name, nickname



FROM friends, user



WHERE friends.userName = inuname



	AND user.userName = friend_user_name$$

DROP PROCEDURE IF EXISTS `fetch_likes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_likes`(IN `inuname` VARCHAR(100))
    READS SQL DATA
SELECT likes.postId, topic



FROM likes, post



WHERE likes.userName = inuname



	AND likes.postId = post.postId$$

DROP PROCEDURE IF EXISTS `fetch_pinned_post`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_pinned_post`(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN



	SELECT *



	FROM post_view pv JOIN (SELECT post.postId as postId FROM post, board_post



							WHERE board_post.userName = uname and board_post.postId=post.postId



							ORDER BY postId DESC



							LIMIT fetch_amt OFFSET latest_offset) pid



		ON pv.postId = pid.postId



	ORDER BY pid.postId DESC;



END$$

DROP PROCEDURE IF EXISTS `fetch_post_proc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_post_proc`(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN



	SELECT *



	FROM post_view pv JOIN (SELECT postId FROM post



							WHERE userName = uname



							ORDER BY postId DESC



							LIMIT fetch_amt OFFSET latest_offset) pid



		ON pv.postId = pid.postId



	ORDER BY pid.postId DESC;



END$$

DROP PROCEDURE IF EXISTS `fetch_public_post`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_public_post`(IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN



	SELECT *



	FROM post_view pv JOIN (SELECT postId FROM post



							ORDER BY postId DESC



							LIMIT fetch_amt OFFSET latest_offset) pid



		ON pv.postId = pid.postId



	ORDER BY pid.postId DESC;



END$$

DROP PROCEDURE IF EXISTS `like_post`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `like_post`(IN `postId` INT(30), IN `inuname` VARCHAR(100))
    MODIFIES SQL DATA
INSERT INTO likes



VALUES ( postId,inuname)$$

DROP PROCEDURE IF EXISTS `login_proc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_proc`(IN `user_username` VARCHAR(100), IN `user_password` VARCHAR(100))
BEGIN



	SELECT userName, nickname



	FROM user



	WHERE userName = user_username



			AND password = user_password;



END$$

DROP PROCEDURE IF EXISTS `pin_post`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN



  



    IF (select count(*) from post where postId=pid and userName=uname) = 0 then insert into board_post(userName, postId) values (uname, pid);

    END IF;







END$$

DROP PROCEDURE IF EXISTS `register_proc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_proc`( IN username VARCHAR(100),



IN nickname VARCHAR(100),



                                IN password CHAR(32),



                                IN conf_password CHAR(32))
BEGIN



IF username IS NULL OR nickname IS NULL OR



password IS NULL OR conf_password IS NULL



   THEN



   



SIGNAL SQLSTATE '02000'



   



SET MESSAGE_TEXT = 'Values may not be NULL.';



   END IF;







IF username IN (SELECT user.userName FROM user)



THEN



   



SIGNAL SQLSTATE '03000'



   



SET MESSAGE_TEXT = 'Username already exists.';



   END IF;







IF password <> conf_password



THEN



   



SIGNAL SQLSTATE '04000'



   



SET MESSAGE_TEXT = 'Passwords do not match.';



   END IF;







INSERT INTO user



VALUES(username, nickname, password);



END$$

DROP PROCEDURE IF EXISTS `search_post_proc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_post_proc`(IN `keyword` VARCHAR(50))
BEGIN



	DECLARE sch varchar(100);

	set sch = concat("%", keyword, "%");



	SELECT *



	FROM post_view



	WHERE topic like sch



        ORDER BY postId DESC;



END$$

DROP PROCEDURE IF EXISTS `unpin_post`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unpin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN



	delete from board_post where userName=uname and postId=pid;







END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attachment`
--

DROP TABLE IF EXISTS `attachment`;
CREATE TABLE IF NOT EXISTS `attachment` (
  `messageId` int(30) NOT NULL,
  `link` varchar(255) NOT NULL,
  PRIMARY KEY (`messageId`,`link`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attachment`
--

INSERT INTO `attachment` (`messageId`, `link`) VALUES
(10, 'http://www.google.com'),
(11, ''),
(12, ''),
(13, ''),
(14, ''),
(15, ''),
(16, 'http://www.xxx.com'),
(17, ''),
(18, '');

-- --------------------------------------------------------

--
-- Table structure for table `board_post`
--

DROP TABLE IF EXISTS `board_post`;
CREATE TABLE IF NOT EXISTS `board_post` (
  `userName` varchar(100) NOT NULL,
  `postId` int(30) NOT NULL,
  PRIMARY KEY (`userName`,`postId`),
  KEY `postId` (`postId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `board_post`
--

INSERT INTO `board_post` (`userName`, `postId`) VALUES
('527bd5b5d689e2c32ae974c6229ff785', 6);

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
CREATE TABLE IF NOT EXISTS `friends` (
  `userName` varchar(100) NOT NULL,
  `friend_user_name` varchar(100) NOT NULL,
  PRIMARY KEY (`userName`,`friend_user_name`),
  KEY `friend_user_name` (`friend_user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
CREATE TABLE IF NOT EXISTS `likes` (
  `postId` int(30) NOT NULL,
  `userName` varchar(100) NOT NULL,
  PRIMARY KEY (`postId`,`userName`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`postId`, `userName`) VALUES
(6, '18126e7bd3f84b3f3e4df094def5b7de'),
(7, '18126e7bd3f84b3f3e4df094def5b7de'),
(8, '18126e7bd3f84b3f3e4df094def5b7de'),
(6, '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(7, '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(8, '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(6, '527bd5b5d689e2c32ae974c6229ff785'),
(9, '527bd5b5d689e2c32ae974c6229ff785'),
(10, '527bd5b5d689e2c32ae974c6229ff785');

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
CREATE TABLE IF NOT EXISTS `message` (
  `postId` int(30) NOT NULL,
  `messageId` int(30) NOT NULL AUTO_INCREMENT,
  `content` text,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userName` varchar(100) NOT NULL,
  PRIMARY KEY (`messageId`),
  KEY `postId` (`postId`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`postId`, `messageId`, `content`, `ts`, `userName`) VALUES
(6, 10, 'm1', '2013-02-10 09:08:11', '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(6, 11, 'shutup', '2013-02-10 09:08:36', '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(6, 12, 'oh no', '2013-02-10 09:12:37', '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(7, 13, 'm2', '2013-02-10 09:14:45', '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(8, 14, 'm3', '2013-02-10 09:15:00', '4ff9fc6e4e5d5f590c4f2134a8cc96d1'),
(9, 15, 'm1', '2013-02-10 09:17:18', '527bd5b5d689e2c32ae974c6229ff785'),
(10, 16, 'm2', '2013-02-10 09:17:38', '527bd5b5d689e2c32ae974c6229ff785'),
(9, 17, 'hey john', '2013-02-10 09:18:34', '18126e7bd3f84b3f3e4df094def5b7de'),
(7, 18, 'hi jack', '2013-02-10 09:21:48', '18126e7bd3f84b3f3e4df094def5b7de');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
CREATE TABLE IF NOT EXISTS `post` (
  `userName` varchar(100) NOT NULL,
  `postId` int(30) NOT NULL AUTO_INCREMENT,
  `topic` varchar(100) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`postId`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`userName`, `postId`, `topic`, `ts`) VALUES
('4ff9fc6e4e5d5f590c4f2134a8cc96d1', 6, 'jackpt1', '2013-02-10 09:08:10'),
('4ff9fc6e4e5d5f590c4f2134a8cc96d1', 7, 'jackpt2', '2013-02-10 09:14:44'),
('4ff9fc6e4e5d5f590c4f2134a8cc96d1', 8, 'jackpt3', '2013-02-10 09:14:59'),
('527bd5b5d689e2c32ae974c6229ff785', 9, 'johnpt1', '2013-02-10 09:17:17'),
('527bd5b5d689e2c32ae974c6229ff785', 10, 'johnpt2', '2013-02-10 09:17:37');

-- --------------------------------------------------------

--
-- Stand-in structure for view `post_likes`
--
DROP VIEW IF EXISTS `post_likes`;
CREATE TABLE IF NOT EXISTS `post_likes` (
`postId` int(30)
,`num_likes` bigint(21)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `post_view`
--
DROP VIEW IF EXISTS `post_view`;
CREATE TABLE IF NOT EXISTS `post_view` (
`postId` int(30)
,`topic` varchar(100)
,`messageId` int(30)
,`user_commenting` varchar(100)
,`user_op` varchar(100)
,`nickname` varchar(100)
,`ts` timestamp
,`content` text
,`num_likes` bigint(22)
,`link` varchar(255)
);
-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `userName` varchar(100) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userName`, `nickname`, `password`) VALUES
('18126e7bd3f84b3f3e4df094def5b7de', 'mike', '99754106633f94d350db34d548d6091a'),
('4ff9fc6e4e5d5f590c4f2134a8cc96d1', 'jack', '99754106633f94d350db34d548d6091a'),
('527bd5b5d689e2c32ae974c6229ff785', 'john', '99754106633f94d350db34d548d6091a');

-- --------------------------------------------------------

--
-- Structure for view `post_likes`
--
DROP TABLE IF EXISTS `post_likes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `post_likes` AS select `likes`.`postId` AS `postId`,count(0) AS `num_likes` from `likes` group by `likes`.`postId`;

-- --------------------------------------------------------

--
-- Structure for view `post_view`
--
DROP TABLE IF EXISTS `post_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `post_view` AS select `post`.`postId` AS `postId`,`post`.`topic` AS `topic`,`message`.`messageId` AS `messageId`,`message`.`userName` AS `user_commenting`,`post`.`userName` AS `user_op`,`user`.`nickname` AS `nickname`,`message`.`ts` AS `ts`,`message`.`content` AS `content`,(`post_likes`.`num_likes` - 1) AS `num_likes`,`attachment`.`link` AS `link` from ((((`post` join `message`) join `user`) join `post_likes`) join `attachment`) where ((`post`.`postId` = `message`.`postId`) and (`message`.`userName` = `user`.`userName`) and (`post_likes`.`postId` = `post`.`postId`) and (`message`.`messageId` = `attachment`.`messageId`));

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attachment`
--
ALTER TABLE `attachment`
  ADD CONSTRAINT `attachment_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `message` (`messageId`);

--
-- Constraints for table `board_post`
--
ALTER TABLE `board_post`
  ADD CONSTRAINT `board_post_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`),
  ADD CONSTRAINT `board_post_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`);

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`),
  ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`friend_user_name`) REFERENCES `user` (`userName`);

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`),
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`);

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`);

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
