<h2>User Registration</h2>

<?php echo validation_errors(); ?>

<?php echo form_open('user/register') ?>

	<label for="username">User Name</label> 
	<input type="input" name="username" /><br />

	<label for="nickname">Nick Name</label>
	<input type="input" name="nickname" /><br />

	<label for="password">Password</label>
	<input type="password" name="password" /><br />
	
	<label for="password2">Confirm Password</label>
	<input type="password" name="password2" /><br />
	
	<input type="submit" name="submit" value="register" /> 

</form>
