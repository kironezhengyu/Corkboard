DELIMITER $$
CREATE PROCEDURE `fetch_friends`(IN `inuname` VARCHAR(100))
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
END $$
DELIMITER ;