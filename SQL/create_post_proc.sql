-- usage:  call create_post_proc("jack", "some topic", @pid)

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_post_proc`(IN `uname` VARCHAR(100), IN `ptopic` VARCHAR(100), OUT `pid` INT)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

START TRANSACTION;

insert into post(userName, topic) values (uname, ptopic);

SET pid = (select postId from post order by postId desc limit 1);
COMMIT;

select pid;

END;
