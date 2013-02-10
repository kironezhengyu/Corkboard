DELIMITER $$
CREATE PROCEDURE fetch_pinned_post(IN uname VARCHAR(100), IN latest_offset MEDIUMINT, IN fetch_amt MEDIUMINT)
BEGIN
	SELECT *
	FROM post_view pv JOIN (SELECT post.postId as postId FROM post, board_post
							WHERE board_post.userName = uname and board_post.postId=post.postId
							ORDER BY postId DESC
							LIMIT fetch_amt OFFSET latest_offset) pid
		ON pv.postId = pid.postId
	ORDER BY pid.postId DESC;
END $$
DELIMITER ;
