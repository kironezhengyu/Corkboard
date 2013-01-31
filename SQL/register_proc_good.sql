CREATE DEFINER=`root`@`localhost` PROCEDURE `register_proc`( IN username VARCHAR(100),
IN nickname VARCHAR(100),
                                IN password CHAR(32),
                                IN conf_password CHAR(32))
BEGIN
IF username IS NULL OR nickname IS NULL OR
password IS NULL OR conf_password IS NULL
   THEN
   
SIGNAL SQLSTATE '02000'
   
SET MESSAGE_TEXT = 'Values may not be NULL.';
   END IF;

IF username IN (SELECT user.userName FROM user)
THEN
   
SIGNAL SQLSTATE '03000'
   
SET MESSAGE_TEXT = 'Username already exists.';
   END IF;

IF password <> conf_password
THEN
   
SIGNAL SQLSTATE '04000'
   
SET MESSAGE_TEXT = 'Passwords do not match.';
   END IF;

INSERT INTO user
VALUES(MD5(username), nickname, MD5(password));
END;
