DELIMITER $$
CREATE PROCEDURE fetch_public_post(IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	SELECT *
	FROM post_view pv JOIN (SELECT postId FROM post
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END $$
DELIMITER ;
