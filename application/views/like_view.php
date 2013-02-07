<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar_home')?>

<div class="container">
	<div class="row-fluid">
		<div class="span4">
			<div class="well">
				<div class="friend_list">
				<h1>Liked Posts</h1>
				<br>
				<?php 
				$i = 0;
				$num= sizeof($topic);
				for ($i=0; $i < $num; $i++){
					echo '<h3><a href="#">' . $topic[$i]["topic"] . '  &raquo</a></h3>';
				}
				?>
				</div>
			</div>
		</div>
		<div class="span8">
			<div class="well">
				<button type="button" class="close"><i class="icon-refresh"></i></button>
				<hr>
				<div class="row-fluid pagination-centered">
					<div class="span12">
						<div class="well">
							<h3 class="h3post1">Liked Post</h3>
							<div class="post1">Some content will be posted here.</div>
							<br>
							<div class="input-append">
							<?php echo form_open('home/like') ?>
							<input class="input-large" id="comment1" name = "comment1" type="text">
							<input type="hidden" id="comment1_id" name="comment1_id" value="" />
								<button class="btn" type="submit"> &raquo </button></form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<?php $this->load->view('include/footer')?>