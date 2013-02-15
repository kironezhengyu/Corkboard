DELIMITER $$
CREATE PROCEDURE `addFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
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
END $$
DELIMITER ;