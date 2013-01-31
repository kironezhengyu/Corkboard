<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar')?>

<div class="container-fluid pagination-centered">
	<div class="container">
		<div class="row-fluid">
			<div class="span4 offset4">
				<div class="well">
					<?php if(validation_errors()):?>
						<div class="alert alert-error">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							<?php echo validation_errors(); ?>
						</div>
					<?php endif;?>

					<?php echo form_open('user/register') ?>
						<h2 class="muted">Registration</h2>

						<label for="username"><strong>User Name</strong></label>
						<input class="input-large" type="text" name="username" /><br />

						<label for="nickname"><strong>Nick Name</strong></label>
						<input class="input-large" type="text" name="nickname" /><br />

						<label for="password"><strong>Password</strong></label>
						<input class="input-large" type="password" name="password" /><br />
						
						<label for="conf_password"><strong>Confirm Password</strong></label>
						<input class="input-large" type="password" name="conf_password" /><br />
						
						<input class="btn btn-primary btn-large" type="submit" name="submit" value="register &raquo" /> 
					</form>
				</div>
			</div>
		</div>
	</div>
</div> <!-- /container -->

<?php $this->load->view('include/footer')?>