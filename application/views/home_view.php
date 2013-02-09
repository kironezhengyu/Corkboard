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
				<div class="span12">
					<div class="well">
						<button type="button" class="close"><i class="icon-refresh"></i></button>
						<h2 class="muted">Your Posts</h2>
						<hr>

						<div class="row-fluid">
							<div class="span6">
								<div class="well">
									<h3 class="h3post1">Your Post 1</h3>
									<div class="post1" name = "p1">Some content will be posted here.</div>
									<br>
									<div class="input-append">
									<?php echo validation_errors(); ?>
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
									<div class="post2" name = "p2" value= "">Some content will be posted here.</div>
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
				var postID = data["posts"][0]['postId'];
				$('.h3post1').html(topic + "<a href=" + <?php echo '"' . base_url('index.php') . '"'; ?> + "/home/like/" + postID + "><i class='icon-thumbs-up'></i>"+"</a>");

				
				$('.h3post2').html(topic + "<a href=" + <?php echo '"' . base_url('index.php') . '"'; ?> + "/home/like/" + postID + "><i class='icon-thumbs-up'></i>"+"</a>");

				var messages = "";
				while(i < data["posts"].length) {
					messages = messages + "<b>" + "<a href=" + <?php echo '"' . base_url('index.php') . '"'; ?> + "/home/addFriend/" + data["posts"][i]['userName'] + '>'
										+ data["posts"][i]['nickname'] + ":</a></b> " + data["posts"][i]['content']
										+"<br>";
										
					i++;
				}
				console.log(messages);
				$('.post1').html(messages);
				$('.post2').html(messages);
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
