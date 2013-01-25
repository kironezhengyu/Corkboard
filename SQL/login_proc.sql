--
-- Returns the username if the given combo of username and password finds a match
--
-------------------------------------------------------------------------------
--
-- SQL Demo:
-- DECLARE uname_result VARCHAR(10);
-- SET uname_result = (CALL login_proc('someusername', 'somepassword')
-- SELECT uname_result
--
-- Code Igniter Demo:
-- $uname_result = $this->db->query("call login_proc(".$this->db->escape($username).",
--	   												 ".$this->db->escape($password).");");)
--
-------------------------------------------------------------------------------
--
-- Revision History:
-- Created - Jordon Phillips - 1/24/13
--
-------------------------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE login_proc(IN `user_username` VARCHAR(10), IN `user_password` VARCHAR(100))
BEGIN
	SELECT userName
	FROM user
	WHERE userName = user_username
			AND password = user_password;
END $$
DELIMITER ;