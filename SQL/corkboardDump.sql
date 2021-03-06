
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



  



    IF (select count(*) from post where postId=pid and userName=uname) = 0 
    and (select count(*) from board_post where userName=uname and postId=pid)=0
    
    then insert into board_post(userName, postId) values (uname, pid);

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

DROP PROCEDURE IF EXISTS `removeFriend`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN


	delete from friends where userName=self and friend_user_name=friend;

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

CREATE TABLE user (
         userName VARCHAR(100) NOT NULL,
         nickname VARCHAR(100) NOT NULL,
         password VARCHAR(100) NOT NULL,
		 PRIMARY KEY(userName)
       );
	   
CREATE TABLE post(
       postId INT(30) NOT NULL AUTO_INCREMENT,
	   userName VARCHAR(100),
	   topic VARCHAR(100) NOT NULL,
       FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE SET NULL,
	   PRIMARY KEY(postId)
);

CREATE TABLE message(
       postId INT(30) NOT NULL,
       messageId INT(30) NOT NULL AUTO_INCREMENT,
       content TEXT ,
       ts TIMESTAMP NOT NULL,
       userName VARCHAR(100),
	   FOREIGN KEY (postId) REFERENCES post(postId) ON DELETE CASCADE,
       FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE SET NULL,
	   PRIMARY KEY (messageId)
);

CREATE TABLE likes (
        postId INT(30) NOT NULL,
        userName VARCHAR(100) NOT NULL,
        PRIMARY KEY (postId, userName),
        FOREIGN KEY (postId) REFERENCES post(postId) ON DELETE CASCADE,
        FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE CASCADE
);
CREATE TABLE friends (
        userName VARCHAR(100) NOT NULL,
        friend_user_name VARCHAR(100) NOT NULL,
        PRIMARY KEY (userName, friend_user_name),
        FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE CASCADE,
        FOREIGN KEY (friend_user_name) REFERENCES user(userName) ON DELETE CASCADE
);
CREATE TABLE board_post (
        userName VARCHAR(100) NOT NULL,
        postId INT(30) NOT NULL,
        PRIMARY KEY (userName, PostId),
        FOREIGN KEY (userName) REFERENCES user(userName) ON DELETE CASCADE,
        FOREIGN KEY (postId) REFERENCES post(postId) ON DELETE CASCADE
);
CREATE TABLE attachment (
        messageId INT(30) NOT NULL,
        link varchar(255) NOT NULL,
        PRIMARY KEY (messageId, link),
        FOREIGN KEY (messageId) REFERENCES message(messageId) ON DELETE CASCADE
);

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

