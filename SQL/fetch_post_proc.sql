DELIMITER $$
CREATE PROCEDURE fetch_post_proc(IN pid int(30))
BEGIN
	SELECT *
	FROM post_view
	WHERE post_view.postId = pid;
END $$
DELIMITER ;