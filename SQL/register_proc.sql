-- You HAVE to change the delimiter. $$ was suggested to me, but // also works.
-- The idea is that it is something that won't actually be in your code.
-- Input parameters are identified with IN, output is identified with OUT.
DELIMITER $$
CREATE PROCEDURE register_proc( IN username VARCHAR(10),
								IN nickname VARCHAR(100),
                                IN password CHAR(32),
                                IN conf_password CHAR(32))
-- NOTE: There is only one BEGIN..END enclosure
BEGIN
	-- Checks for null values. This is done client-side as well, but it's
	-- always best to double check.
	-- NOTE: If statements are of the form IF..THEN..END IF; with an optional
	-- ELSE thrown in if need be.
	IF username IS NULL OR nickname IS NULL OR
		password IS NULL OR conf_password IS NULL
	    THEN
	    	-- Used to throw an error
	    	-- Detailed info: http://dev.mysql.com/doc/refman/5.5/en/signal.html
	    	SIGNAL SQLSTATE '02000'
	    		-- Sets the message to be displayed if the error runs.
	    		SET MESSAGE_TEXT = 'Values may not be NULL.';
	    END IF; --Every statement needs to be terminated with a ;

	-- Ensures that there isn't a registered user with that username
	IF username IN (SELECT userName FROM user)
		THEN
	    	SIGNAL SQLSTATE '03000'
	    		SET MESSAGE_TEXT = 'Username already exists.';
	    END IF;

	-- Confirms that the password and confirmation password are the same.
	-- TODO: Do this client-side
	IF password <> conf_password
		THEN
	    	SIGNAL SQLSTATE '04000'
	    		SET MESSAGE_TEXT = 'Passwords do not match.';
	    END IF;

	-- Adds the new user to the database
	INSERT INTO user
	VALUES(username, nickname, password);
END $$ -- Don't forget to use the new delimiter here.
DELIMITER ; -- You have to reset the delimiter.