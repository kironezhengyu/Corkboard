<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar')?>

<div class="container pagination-centered">
	<div class="span4 offset4">
		<div class="well">
			<?php if(validation_errors()):?>
				<div class="alert alert-error">
					<button type="button" class="close" data-dismiss="alert">&times;</button>
					<?php echo validation_errors(); ?>
				</div>
			<?php endif;?>
			
			<?php echo form_open('verifylogin'); ?>
			  <label for="username">Username:</label>
			  <input type="text" size="20" id="username" name="username"/>
			  <br/>
			  <label for="password">Password:</label>
			  <input type="password" size="20" id="password" name="password"/>
			   <br/>
			  <input class="btn btn-primary" type="submit" value="Login"/>
			</form>
		</div>
	</div>
</div>

<?php $this->load->view('include/footer')?>