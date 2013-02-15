DELIMITER $$
CREATE PROCEDURE `pin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
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

END $$
DELIMITER ;