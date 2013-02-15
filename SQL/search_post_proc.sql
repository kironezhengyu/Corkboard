DELIMITER $$
CREATE PROCEDURE `search_post_proc`(IN `keyword` VARCHAR(50),IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	IF latest_offset IS NULL OR fetch_amt IS NULL OR keyword IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF latest_offset < 0 OR fetch_amt < 0
	THEN
		SIGNAL SQLSTATE '08000'
			SET MESSAGE_TEXT = 'Offset and fetch amount must be <= 0.';
	END IF;

	DECLARE sch varchar(100);
	set sch = concat("%", keyword, "%");
	SELECT *
	FROM post_view pv JOIN (
						SELECT *
						FROM post
						WHERE topic like sch
						ORDER BY postId DESC
						LIMIT fetch_amt OFFSET latest_offset) p
		ON pv.postId = p.postId
END$$
DELIMITER ;
