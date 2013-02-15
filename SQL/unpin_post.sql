DELIMITER $$
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

END $$
DELIMITER ;
