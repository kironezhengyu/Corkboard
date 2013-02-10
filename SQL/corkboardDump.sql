-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2013 at 08:58 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_public_post`(IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN

	SELECT *

	FROM post_view pv JOIN (SELECT postId FROM post

							ORDER BY postId DESC

							LIMIT fetch_amt OFFSET latest_offset) pid

		ON pv.postId = pid.postId

	ORDER BY pid.postId DESC;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `pin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN

  

    IF (select count(*) from post where postId=pid and userName=uname) = 0 then insert into board_post(userName, postId) values (uname, pid);
    END IF;



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

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_post_proc`(IN `keyword` VARCHAR(50))
BEGIN

	DECLARE sch varchar(100);
	set sch = concat("%", keyword, "%");

	SELECT *

	FROM post_view

	WHERE topic like sch

        ORDER BY postId DESC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `unpin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN

	delete from board_post where userName=uname and postId=pid;



END$$

DELIMITER ;

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
-- Structure for view `post_likes`
--
DROP TABLE IF EXISTS `post_likes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `post_likes` AS select `likes`.`postId` AS `postId`,count(0) AS `num_likes` from `likes` group by `likes`.`postId`;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
