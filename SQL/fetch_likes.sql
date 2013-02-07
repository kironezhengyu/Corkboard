DELIMITER $$
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
END $$
DELIMITER ;