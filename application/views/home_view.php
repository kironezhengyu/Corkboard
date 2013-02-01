<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar_home')?>

<div class="container pagination-centered">
	<div class="row-fluid">
		<div class="span12">
			<div class="alert alert-success">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<h1>Welcome <?php echo $nickname; ?>!</h1>
			</div>
			<div class="row-fluid">
				<div class="span4">
					<div class="well well-small">
						<?php echo validation_errors(); ?>
						<?php echo form_open('home/addPost') ?>
							<h2 class="muted">Create a new post.</h2>

							<label for="post_topic"><strong>Post Topic:</strong></label>
							<input class="input-large" name="topic" type="text" /><br />

							<label for="post_initail_message"><strong>Initial Message:</strong></label>
							<TEXTAREA class="input-large" name="initial_message"></TEXTAREA><br />

							<label for="post_link"><strong>Attachment</strong></label>
							<input class="input-large" name="post_link" type="text" /><br />

							<input class="btn btn-primary btn-large" type="submit" name="submit" value="Post &raquo" /> 
						</form>
					</div>
				</div>
				<div class="span8">
					<div class="well">
						<h2 class="muted">Your Posts</h2>
						<hr>

						<div class="row-fluid">
						
							<div class="span6">
								<div class="well">
									<h3 class="h3post1">Your Post 1</h3>
									<div class="post1">Some content will be posted here.</div>
									<div class="input-append">
										<input class="input-large" id="comment" type="text">
										<button class="btn" type="submit"> &raquo </button>
									</div>
								</div>
							</div>

							<div class="span6">
								<div class="well">
									<h3 class="h3post2">Your Post 2</h3>
									<div class="post2">Some content will be posted here.</div>
									<div class="input-append">
										<input class="input-large" id="comment" type="text">
										<button class="btn" type="submit"> &raquo </button>
									</div>
								</div>
							</div>
						</div>

						<hr>
							<ul class="pager">
								<li>><a class="prev_btn" href="#">Previous</a></li>
								<li><a class="next_btn" href="#">Next</a></li>
							</ul>
					</div>
				</div>
			</div>
			<div class="well">
				<h2 class="muted">Pinned Posts</h2>
				<hr>

				<div class="row-fluid">

					<div class="span4">
						<div class="well">
							<h3>Pinned Post 1</h3>
							<div class="pinned1">Some content will be posted here.</div>
							<div class="input-append">
								<input class="input-large" id="comment" type="text">
								<button class="btn" type="submit"> &raquo </button>
							</div>
						</div>
					</div>

					<div class="span4">
						<div class="well">
							<h3>Pinned Post 2</h3>
							<div class="pinned2">Some content will be posted here.</div>
							<div class="input-append">
								<input class="input-large" id="comment" type="text">
								<button class="btn" type="submit"> &raquo </button>
							</div>
						</div>
					</div>

					<div class="span4">
						<div class="well">
							<h3>Pinned Post 3</h3>
							<p>Some content will be posted here.</p>
							<div class="input-append">
								<input class="input-large" id="comment" type="text">
								<button class="btn" type="submit"> &raquo </button>
							</div>
						</div>
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

<script>
 $(function(){
 var base_url = <?php $base = "'" . base_url('') . "'";
						echo $base;
				?>;
 var current_offset = 0;
 var ajax_fetch = function(base_url , current_offset){
 	return $.ajax( { url: base_url + "/index.php/home/fetch_posts/" + current_offset
 			, success : function(d){
			    var data = JSON.parse(d);
 				$('.post1').empty();
 				$('.post2').empty();
				if(data["posts"].length > 0){ 
					$('.post1').html("<b>" + data["posts"][0]['nickname'] + ":</b> - " + data["posts"][0]['content']);
					$('.h3post1').html(data["posts"][0]['topic']);
				}
				if(data["posts"].length > 1){
				    $('.h3post2').html(data["posts"][1]['topic']);
					$('.post2').html("<b>" + data["posts"][1]['nickname'] + ":</b> - " + data["posts"][1]['content']);
				}
 			}
 			, error : function(){
 				$('.post1').empty();
 				$('.post2').empty();
 				$('.post1').html('An error occurred');
 				$('.post2').html('An error occurred');
 			}
			, type: 'GET'
			, async: false
 		});
 }
 $('.prev_btn').on("click", function(){
 	current_offset--;
	if(current_offset < 0){
	  current_offset =0;
	}
 	ajax_fetch(base_url, current_offset);
 });
 $('.next_btn').on("click", function(){
 	current_offset++;
 	ajax_fetch(base_url, current_offset);
 });
 ajax_fetch(base_url, 0); 
});
</script>

<?php $this->load->view('include/footer')?>
