<div class="container">

	<?php echo validation_errors(); ?>

	<?php echo form_open('user/register') ?>

		<label for="username">User Name</label> 
		<input style="margin-bottom: 15px;" type="text" name="username" /><br />

		<label for="nickname">Nick Name</label>
		<input style="margin-bottom: 15px;" type="text" name="nickname" /><br />

		<label for="password">Password</label>
		<input type="password" name="password" /><br />
		
		<label for="conf_password">Confirm Password</label>
		<input type="password" name="conf_password" /><br />
		
		<input class="btn" type="submit" name="submit" value="register &raquo" /> 

	</form>

</div> <!-- /container -->