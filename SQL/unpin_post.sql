CREATE DEFINER=`root`@`localhost` PROCEDURE `unpin_post`(IN `uname` VARCHAR(100), IN `pid` INT)
BEGIN

	delete from board_post where userName=uname and postId=pid;

END;
