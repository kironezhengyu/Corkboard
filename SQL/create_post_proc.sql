-- usage:  call create_post_proc("jack", "some topic", @pid)

DELIMITER $$
CREATE PROCEDURE `create_post_proc`(IN `uname` VARCHAR(100), IN `ptopic` VARCHAR(100), OUT `pid` INT)
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
	DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

	IF uname IS NULL OR ptopic IS NULL
	THEN
		SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Values may not be NULL.';
	END IF;
	
	IF uname NOT IN (SELECT userName FROM user WHERE userName = uname)
	THEN
		SIGNAL SQLSTATE '05000'
			SET MESSAGE_TEXT = 'Username does not exist.';
	END IF;

	START TRANSACTION;

		insert into post(userName, topic) values (uname, ptopic);

		SET pid = (select postId from post order by postId desc limit 1);
	COMMIT;

	select pid;

END $$
DELIMITER ;
