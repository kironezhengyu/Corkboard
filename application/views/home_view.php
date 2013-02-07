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
						<button type="button" class="close"><i class="icon-refresh"></i></button>
						<h2 class="muted">Your Posts</h2>
						<hr>

						<div class="row-fluid">
							<div class="span6">
								<div class="well">
									<h3 class="h3post1">Your Post 1</h3>
									<div class="post1">Some content will be posted here.</div>
									<br>
									<div class="input-append">
									<?php echo form_open('home/addComment') ?>
									<input class="input-large" id="comment1" name = "comment1" type="text">
									<input type="hidden" id="comment1_id" name="comment1_id" value="" />
										<button class="btn" type="submit"> &raquo </button></form>
									</div>
								</div>
							</div>

							<div class="span6">
								<div class="well">
									<h3 class="h3post2">Your Post 2</h3>
									<div class="post2">Some content will be posted here.</div>
									<br>
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
				<button type="button" class="close"><i class="icon-refresh"></i></button>
				<h2 class="muted">Pinned Posts</h2>
				<hr>

				<div class="row-fluid">

					<div class="span4">
						<div class="well">
							<h3>Pinned Post 1</h3>
							<div class="pinned1">Some content will be posted here.</div>
							<br>
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
							<br>
							<div class="input-append">
								<input class="input-large" id="comment2" type="text">
								<button class="btn" type="submit"> &raquo </button>
							</div>
						</div>
					</div>

					<div class="span4">
						<div class="well">
							<h3>Pinned Post 3</h3>
							<p>Some content will be posted here.</p>
							<br>
							<div class="input-append">
								<input class="input-large" id="comment" type="text">
								<button class="btn" type="submit"> &raquo </button>
							</div>
						</div>
					</div>
				</div>

				<hr>
				<form name="get_post" action="home/getpost/get_post">
					<input type="submit" value="prev" name="submit" class = "btn"/>
					<input type="submit" value="next" name="submit" class="btn" />
				</form>
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
 				var offset = current_offset; 
				$('.post1').empty();
 				$('.post2').empty();
				var i = 0;
				var topic = data["posts"][0]['topic'];
				$('.h3post1').html(topic);
				var messages = "";
				while(i < data["posts"].length) {
					messages = messages + "<b>" + "<a href=" + <?php echo '"' . base_url('index.php') . '"'; ?> + "/home/addFriend/" + data["posts"][i]['userName'] + '>'
										+ data["posts"][i]['nickname'] + ":</a></b> " + data["posts"][i]['content'] + "<br>";
										
					i++;
				}
				console.log(messages);
				$('.post1').html(messages);
				$('input[name=comment1_id]').val(parseInt(data["posts"][0]['postId']));				
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
