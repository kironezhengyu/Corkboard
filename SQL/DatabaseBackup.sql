-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 07, 2013 at 04:06 PM
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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN
	IF(self <> friend) THEN
		INSERT INTO friends
		VALUES(self, friend);
	END IF;
END$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_msg`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `pid` INT(100), IN `inlink` VARCHAR(255))
    NO SQL
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

START TRANSACTION;

insert into message(postId,userName, content) values (pid,inuname,incontent);
IF (inlink!= null) THEN 
	insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), link);
END IF;
COMMIT;

END$$

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_friends`(IN `inuname` VARCHAR(100))
    READS SQL DATA
SELECT friend_user_name, nickname
FROM friends, user
WHERE friends.userName = inuname
	AND user.userName = friend_user_name$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_likes`(IN `inuname` VARCHAR(100))
    READS SQL DATA
SELECT likes.postId, topic
FROM likes, post
WHERE likes.userName = inuname
	AND likes.postId = post.postId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_post_proc`(IN `uname` VARCHAR(100), IN `latest_offset` MEDIUMINT)
BEGIN
	DECLARE pid INT(30);
	SET pid = (SELECT postId
	FROM post
	WHERE userName = uname
	ORDER BY postId DESC
	LIMIT 1 OFFSET latest_offset);

	SELECT *
	FROM post_view
	WHERE postId = pid
        ORDER BY postId DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `like_post`(IN `postId` INT(30), IN `inuname` VARCHAR(100))
    MODIFIES SQL DATA
INSERT INTO likes
VALUES ( postId,inuname)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_proc`(IN `user_username` VARCHAR(100), IN `user_password` VARCHAR(100))
BEGIN
	SELECT userName, nickname
	FROM user
	WHERE userName = user_username
			AND password = user_password;
END$$

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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attachment`
--

CREATE TABLE IF NOT EXISTS `attachment` (
  `messageId` int(30) NOT NULL,
  `link` varchar(255) NOT NULL,
  PRIMARY KEY (`messageId`,`link`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `board_post`
--

CREATE TABLE IF NOT EXISTS `board_post` (
  `userName` varchar(100) NOT NULL,
  `postId` int(30) NOT NULL,
  PRIMARY KEY (`userName`,`postId`),
  KEY `postId` (`postId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE IF NOT EXISTS `friends` (
  `userName` varchar(100) NOT NULL,
  `friend_user_name` varchar(100) NOT NULL,
  PRIMARY KEY (`userName`,`friend_user_name`),
  KEY `friend_user_name` (`friend_user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `friends`
--

INSERT INTO `friends` (`userName`, `friend_user_name`) VALUES
('9849f97a8c5546c9906a059d1dd3ec64', '0e0f92be6d39b1e3beabc7175cbef538'),
('9849f97a8c5546c9906a059d1dd3ec64', 'afe3bd960b4c46a68580c4e564cca24e');

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

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
(14, '9849f97a8c5546c9906a059d1dd3ec64'),
(15, '9849f97a8c5546c9906a059d1dd3ec64');

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `postId` int(30) NOT NULL,
  `messageId` int(30) NOT NULL AUTO_INCREMENT,
  `content` text,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userName` varchar(100) NOT NULL,
  PRIMARY KEY (`messageId`),
  KEY `postId` (`postId`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=34 ;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`postId`, `messageId`, `content`, `ts`, `userName`) VALUES
(6, 1, 'somemessage', '2013-01-31 13:25:33', '9849f97a8c5546c9906a059d1dd3ec64'),
(7, 2, 'a;dlfj', '2013-01-31 13:38:51', '9849f97a8c5546c9906a059d1dd3ec64'),
(8, 3, 'a;dlfj', '2013-01-31 13:39:29', '9849f97a8c5546c9906a059d1dd3ec64'),
(9, 4, 'something else', '2013-01-31 13:59:45', '437b930db84b8079c2dd804a71936b5f'),
(10, 5, 'new topic 3', '2013-01-31 14:02:03', '437b930db84b8079c2dd804a71936b5f'),
(14, 12, 'stupid triggers', '2013-02-01 05:34:21', '9849f97a8c5546c9906a059d1dd3ec64'),
(15, 13, 'something blue', '2013-02-01 05:40:43', '9849f97a8c5546c9906a059d1dd3ec64'),
(16, 14, 'dasda', '2013-02-01 15:33:56', '5d41402abc4b2a76b9719d911017c592'),
(17, 15, 'ewqe', '2013-02-01 15:34:15', '5d41402abc4b2a76b9719d911017c592'),
(15, 16, 'second comment', '2013-02-02 19:06:48', '9849f97a8c5546c9906a059d1dd3ec64'),
(18, 17, 'test', '2013-02-06 22:56:02', '9180b4da3f0c7e80975fad685f7f134e'),
(19, 18, 'test', '2013-02-06 22:56:04', '9180b4da3f0c7e80975fad685f7f134e'),
(20, 19, 'test', '2013-02-06 22:57:51', '9180b4da3f0c7e80975fad685f7f134e'),
(21, 20, 'test', '2013-02-06 22:59:38', '9180b4da3f0c7e80975fad685f7f134e'),
(22, 21, 'test', '2013-02-06 23:00:13', '9180b4da3f0c7e80975fad685f7f134e'),
(15, 24, 'crap', '2013-02-07 02:08:38', '9849f97a8c5546c9906a059d1dd3ec64'),
(15, 26, 'andy is le shit', '2013-02-07 02:09:06', '9849f97a8c5546c9906a059d1dd3ec64'),
(15, 27, 'I commented on your post', '2013-02-07 02:29:17', '0e0f92be6d39b1e3beabc7175cbef538'),
(15, 28, 'I LOVE SRIRAM', '2013-02-07 04:56:37', 'afe3bd960b4c46a68580c4e564cca24e'),
(15, 29, 'commenting still works', '2013-02-07 13:06:42', '9849f97a8c5546c9906a059d1dd3ec64'),
(14, 30, 'I have no idea why that thumbs up refuses to move', '2013-02-07 13:07:44', '9849f97a8c5546c9906a059d1dd3ec64'),
(15, 31, 'ddfdf', '2013-02-07 13:40:35', '9180b4da3f0c7e80975fad685f7f134e'),
(15, 32, 'add comment', '2013-02-07 14:18:01', '9849f97a8c5546c9906a059d1dd3ec64'),
(15, 33, 'fffrfffff', '2013-02-07 14:18:35', '9849f97a8c5546c9906a059d1dd3ec64');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE IF NOT EXISTS `post` (
  `userName` varchar(100) NOT NULL,
  `postId` int(30) NOT NULL AUTO_INCREMENT,
  `topic` varchar(100) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`postId`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`userName`, `postId`, `topic`, `ts`) VALUES
('9849f97a8c5546c9906a059d1dd3ec64', 5, 'helloworld', '0000-00-00 00:00:00'),
('9849f97a8c5546c9906a059d1dd3ec64', 6, 'sometopic', '0000-00-00 00:00:00'),
('9849f97a8c5546c9906a059d1dd3ec64', 7, 'lkasd', '0000-00-00 00:00:00'),
('9849f97a8c5546c9906a059d1dd3ec64', 8, 'lkasddfad', '0000-00-00 00:00:00'),
('437b930db84b8079c2dd804a71936b5f', 9, 'something', '0000-00-00 00:00:00'),
('437b930db84b8079c2dd804a71936b5f', 10, 'new topic', '0000-00-00 00:00:00'),
('9849f97a8c5546c9906a059d1dd3ec64', 11, 'fdsfadsf', '2013-02-01 04:57:25'),
('9849f97a8c5546c9906a059d1dd3ec64', 12, 'fdsfadsf', '2013-02-01 04:57:56'),
('9849f97a8c5546c9906a059d1dd3ec64', 13, 'fdsfadsf', '2013-02-01 04:58:16'),
('9849f97a8c5546c9906a059d1dd3ec64', 14, 'fdsfadsf', '2013-02-01 04:58:36'),
('9849f97a8c5546c9906a059d1dd3ec64', 15, 'something new', '2013-02-01 05:40:42'),
('5d41402abc4b2a76b9719d911017c592', 16, 'sadasda', '2013-02-01 15:33:55'),
('5d41402abc4b2a76b9719d911017c592', 17, 'eqw', '2013-02-01 15:34:13'),
('9180b4da3f0c7e80975fad685f7f134e', 18, 'test', '2013-02-06 22:56:01'),
('9180b4da3f0c7e80975fad685f7f134e', 19, 'test', '2013-02-06 22:56:03'),
('9180b4da3f0c7e80975fad685f7f134e', 20, 'test', '2013-02-06 22:57:50'),
('9180b4da3f0c7e80975fad685f7f134e', 21, 'test', '2013-02-06 22:59:37'),
('9180b4da3f0c7e80975fad685f7f134e', 22, 'test', '2013-02-06 23:00:12');

-- --------------------------------------------------------

--
-- Stand-in structure for view `post_view`
--
CREATE TABLE IF NOT EXISTS `post_view` (
`postId` int(30)
,`topic` varchar(100)
,`messageId` int(30)
,`userName` varchar(100)
,`nickname` varchar(100)
,`ts` timestamp
,`content` text
);
-- --------------------------------------------------------

--
-- Table structure for table `user`
--

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
('0e0f92be6d39b1e3beabc7175cbef538', 'manny', '8fe78ac0eaabf2f474b0de3a968e165e'),
('1a1dc91c907325c69271ddf0c944bc72', 'pass', '1a1dc91c907325c69271ddf0c944bc72'),
('2f8a6763c6be96f8660833e0f2457aee', 'minni', '2f8a6763c6be96f8660833e0f2457aee'),
('437b930db84b8079c2dd804a71936b5f', 'something', '437b930db84b8079c2dd804a71936b5f'),
('5d41402abc4b2a76b9719d911017c592', 'hell', '81dc9bdb52d04dc20036dbd8313ed055'),
('8fe78ac0eaabf2f474b0de3a968e165e', 'manny6', '8fe78ac0eaabf2f474b0de3a968e165e'),
('9180b4da3f0c7e80975fad685f7f134e', 'dan', '81dc9bdb52d04dc20036dbd8313ed055'),
('9849f97a8c5546c9906a059d1dd3ec64', 'passed', '9849f97a8c5546c9906a059d1dd3ec64'),
('afe3bd960b4c46a68580c4e564cca24e', 'yves', 'afe3bd960b4c46a68580c4e564cca24e'),
('b3af409bb8423187c75e6c7f5b683908', 'dsfafd', '74b87337454200d4d33f80c4663dc5e5');

-- --------------------------------------------------------

--
-- Structure for view `post_view`
--
DROP TABLE IF EXISTS `post_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `post_view` AS select `post`.`postId` AS `postId`,`post`.`topic` AS `topic`,`message`.`messageId` AS `messageId`,`message`.`userName` AS `userName`,`user`.`nickname` AS `nickname`,`message`.`ts` AS `ts`,`message`.`content` AS `content` from ((`post` join `message`) join `user`) where ((`post`.`postId` = `message`.`postId`) and (`message`.`userName` = `user`.`userName`));

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
