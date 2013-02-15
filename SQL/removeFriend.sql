DELIMITER $$
CREATE PROCEDURE `removeFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
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

END $$
DELIMITER ;
