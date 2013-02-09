DELIMITER $$
CREATE PROCEDURE `search_post_proc`(IN `keyword` VARCHAR(50))
BEGIN
	DECLARE sch varchar(100);
	set sch = concat("%", keyword, "%");
	SELECT *
	FROM post_view
	WHERE topic like sch
        ORDER BY postId DESC;
END$$
DELIMITER ;
