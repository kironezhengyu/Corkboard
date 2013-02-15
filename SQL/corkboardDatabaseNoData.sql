-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2013 at 01:30 PM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

--
-- Database: `corkboard`
--
CREATE DATABASE `corkboard` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `corkboard`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN
	IF self IS NULL OR friend IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF self NOT IN (SELECT userName FROM user)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;
	
	IF friend NOT IN (SELECT userName FROM user)
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

	-- doesn't work if there is any sort of input validation. I have no idea why.

	insert into message(postId,userName, content) values (pid,inuname,incontent);

	insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), inlink);

COMMIT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_msg_rec`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `inlink` VARCHAR(255))
BEGIN 

DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;

DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

START TRANSACTION;

	-- doesn't work if there is any sort of input validation. I have no idea why.
	SET @pid = (SELECT postId from post ORDER BY postId Desc LIMIT 1);

	insert into message(postId,userName, content) values (@pid,inuname,incontent);

	insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), inlink);

COMMIT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post_proc`(IN `uname` VARCHAR(100), IN `ptopic` VARCHAR(100), OUT `pid` INT)
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
	DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

	IF uname IS NULL OR ptopic IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;



	START TRANSACTION;

		insert into post(userName, topic) values (uname, ptopic);

		SET pid = (select postId from post order by postId desc limit 1);
	COMMIT;

	select pid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post_proc_supressed`(IN `uname` VARCHAR(100), IN `ptopic` VARCHAR(100))
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
	DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

	IF uname IS NULL OR ptopic IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;

	START TRANSACTION;

		insert into post(userName, topic) values (uname, ptopic);
	COMMIT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_friends`(IN `inuname` VARCHAR(100))
    READS SQL DATA
BEGIN
	IF inuname IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF inuname NOT IN (SELECT userName FROM user WHERE userName = inuname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;

	SELECT friend_user_name, nickname
	FROM friends, user
	WHERE friends.userName = inuname
		AND user.userName = friend_user_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_likes`(IN `inuname` VARCHAR(100))
    READS SQL DATA
BEGIN
	IF inuname IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF inuname NOT IN (SELECT userName FROM user WHERE userName = inuname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;
	
	SELECT likes.postId, topic
	FROM likes, post
	WHERE likes.userName = inuname
		AND likes.postId = post.postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_pinned_post`(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF uname IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;	

	SELECT *
	FROM post_view pv JOIN (SELECT post.postId as postId FROM post, board_post
							WHERE board_post.userName = uname and board_post.postId=post.postId
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_post_proc`(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF uname IS NULL OR latest_offset IS NULL OR fetch_amt IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;
	
	IF latest_offset < 0 OR fetch_amt < 0
	THEN
		SIGNAL SQLSTATE '08000'
			SET MESSAGE_TEXT = 'Offset and fetch amount must be <= 0.';
	END IF;
	
	SELECT *
	FROM post_view pv JOIN (SELECT postId FROM post
							WHERE userName = uname
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_public_post`(IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF latest_offset IS NULL OR fetch_amt IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF latest_offset < 0 OR fetch_amt < 0
	THEN
		SIGNAL SQLSTATE '08000'
			SET MESSAGE_TEXT = 'Offset and fetch amount must be <= 0.';
	END IF;

	SELECT *
	FROM post_view pv JOIN (SELECT postId FROM post
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `like_post`(IN `postId` INT(30), IN `inuname` VARCHAR(100))
BEGIN
	IF postId IS NULL OR inuname IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF inuname NOT IN (SELECT userName FROM user WHERE userName = inuname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;

	IF postId NOT IN (SELECT postId FROM post)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'PostID does not exist.';
	END IF;

	INSERT INTO likes
	VALUES ( postId,inuname);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_proc`(IN `user_username` VARCHAR(100), IN `user_password` VARCHAR(100))
BEGIN
	IF user_username IS NULL OR user_password IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	SELECT userName, nickname
	FROM user
	WHERE userName = user_username
			AND password = user_password;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN
	IF uname IS NULL OR pid IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;
	
	IF pid NOT IN (SELECT postID FROM post)
	THEN
		SIGNAL SQLSTATE '07000'
			SET MESSAGE_TEXT = 'postID does not exist';
	END IF;

    IF (select count(*) from post where postId=pid and userName=uname) = 0 
    and (select count(*) from board_post where userName=uname and postId=pid)=0
    
    then insert into board_post(userName, postId) values (uname, pid);

    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `register_proc`( IN username VARCHAR(100),
IN nickname VARCHAR(100),
                                IN password CHAR(32),
                                IN conf_password CHAR(32))
BEGIN
IF username IS NULL OR nickname IS NULL OR password IS NULL OR conf_password IS NULL
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `removeFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN
	IF self IS NULL OR friend IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF self NOT IN (SELECT userName FROM user WHERE userName = self)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;
	
	IF friend NOT IN (SELECT userName FROM user WHERE userName = friend)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;

	delete from friends where userName=self and friend_user_name=friend;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_post_proc`(IN `keyword` VARCHAR(50),IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF latest_offset IS NULL OR fetch_amt IS NULL OR keyword IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF latest_offset < 0 OR fetch_amt < 0
	THEN
		SIGNAL SQLSTATE '08000'
			SET MESSAGE_TEXT = 'Offset and fetch amount must be <= 0.';
	END IF;

	SET @sch = concat("%", keyword, "%");
	SELECT * 
	FROM post_view pv
	JOIN (
	SELECT * 
	FROM post
	WHERE topic LIKE @sch 
	ORDER BY postId DESC 
	LIMIT fetch_amt
	OFFSET latest_offset
	)p ON pv.postId = p.postId;     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `unpin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN
	IF uname IS NULL OR pid IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;
	
	IF pid NOT IN (SELECT postID FROM post)
	THEN
		SIGNAL SQLSTATE '07000'
			SET MESSAGE_TEXT = 'postID does not exist';
	END IF;

	delete from board_post where userName=uname and postId=pid;

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
  KEY `friends_ibfk_2` (`friend_user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `postId` int(30) NOT NULL,
  `messageId` int(30) NOT NULL AUTO_INCREMENT,
  `content` text,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`messageId`),
  KEY `postId` (`postId`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE IF NOT EXISTS `post` (
  `postId` int(30) NOT NULL AUTO_INCREMENT,
  `userName` varchar(100) DEFAULT NULL,
  `topic` varchar(100) NOT NULL,
  PRIMARY KEY (`postId`),
  KEY `userName` (`userName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `post_likes`
--
CREATE TABLE IF NOT EXISTS `post_likes` (
`postId` int(30)
,`num_likes` bigint(21)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `post_view`
--
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

CREATE TABLE IF NOT EXISTS `user` (
  `userName` varchar(100) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  ADD CONSTRAINT `attachment_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `message` (`messageId`) ON DELETE CASCADE;

--
-- Constraints for table `board_post`
--
ALTER TABLE `board_post`
  ADD CONSTRAINT `board_post_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`) ON DELETE CASCADE,
  ADD CONSTRAINT `board_post_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`) ON DELETE CASCADE;

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`friend_user_name`) REFERENCES `user` (`userName`) ON DELETE CASCADE,
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`) ON DELETE CASCADE;

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`) ON DELETE CASCADE,
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`) ON DELETE SET NULL;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `user` (`userName`) ON DELETE SET NULL;
