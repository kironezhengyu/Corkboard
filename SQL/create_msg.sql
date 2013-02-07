DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_msg`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `pid` INT(30), IN `inlink` VARCHAR(255))
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

END $$
DELIMITER ;