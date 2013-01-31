CREATE DEFINER=`root`@`localhost` PROCEDURE `create_msg`(IN `inuname` VARCHAR(100), IN `incontent` TEXT, IN `pid` INT(100), IN `link` VARCHAR(255))
    NO SQL
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

START TRANSACTION;

insert into message(postId,userName, content) values (pid,inuname,pid);
insert into attachment (messageId, link) values((select messageId from message order by messageId desc limit 1), link);

COMMIT;

END;