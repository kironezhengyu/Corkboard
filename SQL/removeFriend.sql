CREATE DEFINER=`root`@`localhost` PROCEDURE `removeFriend`(IN self VARCHAR(100), IN friend VARCHAR(100))
BEGIN


	delete from friends where userName=self and friend_user_name=friend;

END
