DELIMITER $$
CREATE PROCEDURE fetch_post_proc(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	SELECT *
	FROM post_view pv JOIN (SELECT postId FROM post
							WHERE userName = uname
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END $$
DELIMITER ;
