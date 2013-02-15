DELIMITER $$

CREATE PROCEDURE `create_msg_rec`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `inlink` VARCHAR(255))
BEGIN 

DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;

DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

START TRANSACTION;

	-- doesn't work if there is any sort of input validation. I have no idea why.
	SET @pid = (SELECT postId from post ORDER BY postId Desc LIMIT 1);

	insert into message(postId,userName, content) values (@pid,inuname,incontent);

	insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), inlink);

COMMIT;

END $$
DELIMITER ;