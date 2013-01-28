<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar')?>

<div class="container pagination-centered">
	<div class="row-fluid">
		<div class="span12">
			<h1>Welcome <?php echo $username; ?>!</h1>
			<div class="row-fluid">
				<div class="span4">
					<div class="well well-small">
						<?php echo validation_errors(); ?>
						<form>
							<h2 class="muted">Create a new post.</h2>

							<label for="post_topic"><strong>Post Topic:</strong></label>
							<input class="input-large" name="topic" type="text" /><br />

							<label for="post_initail_message"><strong>Initial Message:</strong></label>
							<TEXTAREA class="input-large" name="initial_message"></TEXTAREA><br />

							<label for="post_link"><strong>Attachment</strong></label>
							<input class="input-large" name="post_link" type="text" /><br />

							<a class="btn btn-large btn-primary">Post &raquo</a>
						</form>
					</div>
				</div>
				<div class="span8">
					<div class="well">
						<h2 class="muted">Your Posts</h2>
						<hr>

						<div class="row-fluid">
							<div class="span6">
								<h3>Your Post 1</h3>
								<p>Some content will be posted here.</p>
							</div>

							<div class="span6">
								<h3>Your Post 2</h3>
								<p>Some content will be posted here.</p>
							</div>
						</div>

						<hr>
						<ul class="pager">
							<li><a href="#">Previous</a></li>
							<li><a href="#">Next</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="well">
				<h2 class="muted">Pinned Posts</h2>
				<hr>

				<div class="row-fluid">

					<div class="span4">
						<h3>Pinned Post 1</h3>
						<p>Some content will be posted here.</p>
					</div>

					<div class="span4">
						<h3>Pinned Post 2</h3>
						<p>Some content will be posted here.</p>
					</div>

					<div class="span4">
						<h3>Pinned Post 3</h3>
						<p>Some content will be posted here.</p>
					</div>
				</div>

				<hr>
				<ul class="pager">
					<li><a href="#">Previous</a></li>
					<li><a href="#">Next</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>


<?php $this->load->view('include/footer')?>