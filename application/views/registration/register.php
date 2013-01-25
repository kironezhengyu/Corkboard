<div class="container-fluid pagination-centered">
	<div class="span3">
		<div class="well">
			<?php echo validation_errors(); ?>

			<?php echo form_open('user/register') ?>
				<h2 class="muted">Registration</h2>

				<label for="username"><strong>User Name</strong></label>
				<input style="span3" type="text" name="username" /><br />

				<label for="nickname"><strong>Nick Name</strong></label>
				<input style="span3" type="text" name="nickname" /><br />

				<label for="password"><strong>Password</strong></label>
				<input type="password" name="password" /><br />
				
				<label for="conf_password"><strong>Confirm Password</strong></label>
				<input type="password" name="conf_password" /><br />
				
				<input class="btn btn-primary btn-large" type="submit" name="submit" value="register &raquo" /> 
			</form>
		</div>
	</div>
</div> <!-- /container -->