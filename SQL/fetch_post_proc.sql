DELIMITER $$
CREATE PROCEDURE fetch_post_proc(IN uname VARCHAR(100), IN latest_offset MEDIUMINT)
BEGIN
	IF uname IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF uname NOT EXISTS IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;

	DECLARE pid INT(30);
	SET pid = (SELECT postId
	FROM post
	WHERE userName = uname
	ORDER BY postId DESC
	LIMIT 1 OFFSET latest_offset);

	SELECT *
	FROM post_view
	WHERE postId = pid;
END $$
DELIMITER ;