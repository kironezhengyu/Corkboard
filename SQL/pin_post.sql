CREATE DEFINER=`root`@`localhost` PROCEDURE `pin_post`(IN `uname` VARCHAR(100), IN `pid` INT)

BEGIN

  

    IF (select count(*) from post where postId=pid and userName=uname) = 0 then insert into board_post(userName, postId) values (uname, pid);
    END IF;



END;
