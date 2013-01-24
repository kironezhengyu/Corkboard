--
-- Registers a new user to the user database.
--
-------------------------------------------------------------------------------
--
-- SQL Demo:
-- CALL register_proc('username', 'nickname', 'password', 'conf_password');
--
-- CodeIgniter Demo:
-- Put the following into a model (see '\application\models\user_model.php' for full code):
-- 	public function add_user()
--	{
--		$username = $this->input->post('username');
--		$nickname = $this->input->post('nickname');
--		$password = $this->input->post('password');
--		$conf_password = $this->input->post('conf_password');
--	
--		return $this->db->query("call register_proc('$username', '$nickname', '$password', '$conf_password');");
--	}
--
-- Then call inside a controller (see '\application\controllers\user.php' for full code):
-- $this->user_model->add_user();
--
-- Finally, invoke in a view (see '\application\views\registration\register.php' for full code):
-- <?php echo form_open('user/register') ?>
--
-------------------------------------------------------------------------------
--
-- Revision History:
-- Created - Jordon Phillips - 1/24/13 4:58 p.m.
-- Documented - Jordon Phillips 1/24/13 5:24 p.m.
--
-------------------------------------------------------------------------------

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
			--The statement 'RETURN' WILL NOT WORK, don't try it.
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