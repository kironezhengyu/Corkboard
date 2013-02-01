DELIMITER $$
CREATE PROCEDURE fetch_post_proc(IN uname VARCHAR(100), IN latest_offset MEDIUMINT)
BEGIN
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