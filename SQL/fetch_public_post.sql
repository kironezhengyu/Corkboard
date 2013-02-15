DELIMITER $$
CREATE PROCEDURE fetch_public_post(IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF latest_offset IS NULL OR fetch_amt IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF latest_offset < 0 OR fetch_amt < 0
	THEN
		SIGNAL SQLSTATE '08000'
			SET MESSAGE_TEXT = 'Offset and fetch amount must be <= 0.';
	END IF;

	SELECT *
	FROM post_view pv JOIN (SELECT postId FROM post
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END $$
DELIMITER ;
