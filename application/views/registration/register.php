<div class="container">
	<h2>User Registration</h2>

	<?php echo validation_errors(); ?>

	<?php echo form_open('user/register') ?>

		<label for="username">User Name</label> 
		<input style="margin-bottom: 15px;" type="text" name="username" /><br />

		<label for="nickname">Nick Name</label>
		<input style="margin-bottom: 15px;" type="text" name="nickname" /><br />

		<label for="password">Password</label>
		<input type="password" name="password" /><br />
		
		<label for="password2">Confirm Password</label>
		<input type="password" name="password2" /><br />
		
		<input class="btn" type="submit" name="submit" value="register &raquo" /> 

	</form>

</div> <!-- /container -->