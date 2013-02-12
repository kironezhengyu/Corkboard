DELIMITER $$
CREATE PROCEDURE `search_post_proc`(IN `keyword` VARCHAR(50),IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	DECLARE sch varchar(100);
	set sch = concat("%", keyword, "%");
	SELECT *
	FROM post_view
	 
	WHERE topic like sch
	
        ORDER BY postId DESC
        LIMIT fetch_amt OFFSET latest_offset;      
END$$
DELIMITER ;
