DELIMITER $$
CREATE PROCEDURE fetch_pinned_post(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF uname IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;

	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;	

	SELECT *
	FROM post_view pv JOIN (SELECT post.postId as postId FROM post, board_post
							WHERE board_post.userName = uname and board_post.postId=post.postId
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END $$
DELIMITER ;
