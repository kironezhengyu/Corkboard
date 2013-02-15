<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar_home')?>

<div class="container pagination-centered">
	<div class="row-fluid">
		<div class="span12">
			<?php
				//if(isset($data['greeted'])) {
				//	$welcome =  '<div class="alert alert-success">' . 
				//					'<button type="button" class="close" data-dismiss="alert">&times;</button>' .
				//					'<h1>Welcome' .  $nickname . '!</h1>' .
				//				'</div>';
				//	echo $welcome;
				//}
				if(validation_errors() != false) {
					$err =  '<div class="alert alert-error">' . 
								'<button type="button" class="close" data-dismiss="alert">&times;</button>' .
								validation_errors() .
							'</div>';
					echo $err;
				}
			?>
			</div>
			<div class="row-fluid">
				<div class="span12">
					<div class="well">
						<h2 class="muted">Your Own Posts</h2>
						<hr>

						<div class="row-fluid" id="users_post_area">
							
						</div>

						<hr>
							<ul class="pager">
								<li><a class="prev_btn" href="#">Previous</a></li>
								<li><a class="next_btn" href="#">Next</a></li>
							</ul>
					</div>
				</div>
			</div>

			<div class="row-fluid">
				<div class="span12">
					<div class="well">
						<h2 class="muted">Your Pinned Posts</h2>
						<hr>

						<div class="row-fluid" id="pinned_post_area">
							
						</div>

						<hr>
							<ul class="pager">
								<li><a class="prev_btn_pin" href="#">Previous</a></li>
								<li><a class="next_btn_pin" href="#">Next</a></li>
							</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal -->
	<div id="friend_conf" class="modal hide" >
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 class="uname_m" >Username</h3>
	  </div>
	  <div class="modal-body" id="friend_body">
		<p>They will be added to your list, but you won't be added to theirs. If you want them to follow you, make them like you!</p>
	  </div>
	  <div class="modal-footer" id="friend_add">
		<button class="btn btn-large" data-dismiss="modal" aria-hidden="true">Close</button>
	  </div>
	</div>
	
	<!-- Modal -->
	<div id="comment_attach" class="modal hide" >
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Attach link and comment.</h3>
	  </div>
	  <div class="modal-body" id="comment_modal_body">
		<?php echo form_open('home/addCommentAttached'); ?>
		
			<input type="hidden" name="pid_at" value="" id="pid_at_id"> </input>
			
			<label for="message_at"><strong>Comment:</strong></label>
			<TEXTAREA class="input-large" name="message_at"></TEXTAREA><br />

			<label for="post_link_at"><strong>Attachment</strong></label>
			<input class="input-large" name="post_link_at" type="text" /><br />

			<input class="btn btn-primary btn-large" type="submit" name="submit" value="Submit &raquo" />
		</form>
	  </div>
	</div>
	
</div>

<script>
 $(function(){
 var base_url = <?php $base = "'" . base_url('') . "'";
						echo $base;
				?>;
 var current_offset = 0;
 var self_post_fetch_amt = 3;

 var ajax_fetch = function(base_url , current_offset, fetch_amt, post_loc){
 	return $.ajax( { url: base_url + "/index.php/home/fetch_posts/" + current_offset*fetch_amt + "/" + fetch_amt
 			, success : function(d){
			    var data = JSON.parse(d);
 				var offset = current_offset; 
				$(post_loc).empty();
				
				var span_length = 12 / fetch_amt;
				var i = 0;
				var k = 0;
				var j = 0;
				var messages = "";
				var topic;
				var postID;
				var post;
				var attachment;
				var fetched_posts = "";
				var ret = "";
				var num_likes = 0;
				while (k < fetch_amt && i < data["posts"].length){ // Post loop
					j = i;
					topic = data["posts"][i]['topic'];
					postID = data["posts"][i]['postId'];
					num_likes = data["posts"][i]['num_likes'];
					messages = "";
					post = "";
					
					
					
					
					while (j < data["posts"].length && topic == data["posts"][j]['topic']){ // Message loop
						attachment = data["posts"][j]['link'];
						messages = messages + "<b>" + "<a class='announce btn btn-link' data-toggle='modal' data-uname='" + data["posts"][j]['userName']
										+ "' data-nickname='" + data["posts"][j]['nickname'] + "'>"
										+ data["posts"][j]['nickname'] + ":</a></b> " + data["posts"][j]['content'];

						if (attachment==""){
							messages += "<br>";}
						else{
							messages += "  <i><a href='" + attachment + "'>attachment</a></i><br>"
						}


										
						j++;
					} // End of message loop
					
					post = "<div class='span" + span_length + "'>" +
								"<div class='well' style='background-color: rgb(252, 240, 173);>'" +
									"<h3>" + topic + "<a href='" + <?php echo '"' . base_url('index.php/home/like/') . '"'; ?> + "/" +
											postID + "'>  [" +num_likes+ "  <i class='icon-thumbs-up'></i>]</a></h3>" +
									"<br>" + messages + "<br>" +
									"<button class='attachC btn btn-primary' data-toggle='modal' data-pid='" + postID +"'> reply &raquo </button>" +
								//	"<div class='input-append'>" +
								//		'<?php echo form_open('home/addComment'); ?>' +
								//		"<input class='input-large' id='comment1' name = 'comment1' type='text'>" +
								//		"<button class='attachC btn' data-toggle='modal' data-pid='" + postID +"'> <i class='icon-file'></i> </button>" +
								//		"<input type='hidden' name='comment1_id' value='"+ postID   +"' />" +
								//			"<button class='btn' type='submit'> &raquo </button></form>" +
								//	"</div>" +
								"</div>" +
							"</div>";
					
					fetched_posts += post;
					ret += messages;
					i += j;
					k++;
				} // End of post loop
				$(post_loc).html(fetched_posts);
				return ret;
 			}
 			, error : function(){
 				$(post_loc).empty();
 				$(post_loc).html('An error occurred');
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
 	ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area");
 });
 $('.next_btn').on("click", function(){
 	current_offset++;
	var success;
 	success = ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area");
	if (success == ""){
		current_offset = 0;
		ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area");
	}
 });
 ajax_fetch(base_url, 0, self_post_fetch_amt, '#users_post_area'); 
});

 $(function(){
 var base_url = <?php $base = "'" . base_url('') . "'";
						echo $base;
				?>;
 var pinned_offset = 0;
 var self_post_fetch_amt = 3;

 var ajax_fetch_pinned = function(base_url , pinned_offset, fetch_amt, post_loc){
 	return $.ajax( { url: base_url + "/index.php/home/fetch_pinned_posts/" + pinned_offset*fetch_amt + "/" + fetch_amt
 			, success : function(d){
			    var data = JSON.parse(d);
 				var offset = pinned_offset; 
				$(post_loc).empty();
				
				var span_length = 12 / fetch_amt;
				var i = 0;
				var k = 0;
				var j = 0;
				var messages = "";
				var topic;
				var postID;
				var post;
				var attachment;
				var fetched_posts = "";
				var ret = "";
				var num_likes = 0;
				while (k < fetch_amt && i < data["posts"].length){ // Post loop
					j = i;
					topic = data["posts"][i]['topic'];
					postID = data["posts"][i]['postId'];
					num_likes = data["posts"][i]['num_likes'];
					messages = "";
					post = "";
					
					
					while (j < data["posts"].length && topic == data["posts"][j]['topic']){ // Message loop
						attachment = data["posts"][j]['link'];
						messages = messages + "<b>" + "<a class='announce btn btn-link' data-toggle='modal' data-uname='" + data["posts"][j]['userName']
										+ "' data-nickname='" + data["posts"][j]['nickname'] + "'>"
										+ data["posts"][j]['nickname'] + ":</a></b> " + data["posts"][j]['content'];

						if (attachment==""){
							messages += "<br>";}
						else{
							messages += "  <i><a href='" + attachment + "'>attachment</a></i><br>"
						}
						j++;
					} // End of message loop
					
					post = "<div class='span" + span_length + "'>" +
								"<div class='well' style='background-color: rgb(252, 240, 173);>'" +
									"<h3>" + topic + "<a href='" + <?php echo '"' . base_url('index.php/home/like/') . '"'; ?> + "/" +
											postID + "'>  [" +num_likes+ "  <i class='icon-thumbs-up'></i>]</a></h3>" +
									"<div class='input-append'>" +
										'<?php echo form_open('home/unpin_post'); ?>' +
										"<input type='hidden' name='comment1_id' value='"+ postID   +"' />" +
											"<button class='pinning btn' type='submit'> unpin </button></form>" +
									"</div>" +
									
									"<br>" + messages + "<br>" +
									"<button class='attachC btn btn-primary' data-toggle='modal' data-pid='" + postID +"'> reply &raquo </button>" +
								//	"<div class='input-append'>" +
								//		'<?php echo form_open('home/addComment'); ?>' +
								//		"<input class='input-large' id='comment1' name = 'comment1' type='text'>" +
								//		"<button class='attachC btn' data-toggle='modal' data-pid='" + postID +"'> <i class='icon-file'></i> </button>" +
								//		"<input type='hidden' name='comment1_id' value='"+ postID   +"' />" +
								//			"<button class='btn' type='submit'> &raquo </button></form>" +
								//	"</div>" +
								"</div>" +
							"</div>";
					
					fetched_posts += post;
					ret += messages;
					i += j;
					k++;
				} // End of post loop
				$(post_loc).html(fetched_posts);
				return ret;
 			}
 			, error : function(){
 				$(post_loc).empty();
 				$(post_loc).html('An error occurred');
 			}
			, type: 'GET'
			, async: false
 		});
 }
 $('.prev_btn_pin').on("click", function(){
 	pinned_offset--;
	if(pinned_offset < 0){
	  pinned_offset =0;
	}
 	ajax_fetch_pinned(base_url, pinned_offset, self_post_fetch_amt, "#pinned_post_area");
 });
 $('.next_btn_pin').on("click", function(){
 	pinned_offset++;
	var success;
 	success = ajax_fetch_pinned(base_url, pinned_offset, self_post_fetch_amt, "#pinned_post_area");
	if (success == ""){
		pinned_offset = 0;

		ajax_fetch_pinned(base_url, pinned_offset, self_post_fetch_amt, "#pinned_post_area");
	}
 });
 $(document).on("click", ".announce", function(){
	var cookie_uname = '<?php echo $username ?>';
    var uname = $(this).data('uname');
	if (uname != cookie_uname) {
		var nickname = $(this).data('nickname');
		var addfriend = <?php echo '"' . base_url('index.php') . '"'; ?> + "/home/addFriend/" + uname;
		$('.uname_m').html("Do you wish to add " + nickname + " to your friends list?");
		$('#friend_add').html("<a class='btn btn-primary' href='" + addfriend + "'> Confirm </a>");
		$('#friend_conf').modal('show');
	}
 });
 $(document).on("click", ".attachC", function(){
	var uname = '<?php echo $username ?>';
	var pid = $(this).data('pid');
	var pid_field = document.getElementById('pid_at_id');
	pid_field.value = pid;
	$('#comment_attach').modal('show');
 });
 ajax_fetch_pinned(base_url, 0, self_post_fetch_amt, '#pinned_post_area'); 
});
</script>



<?php $this->load->view('include/footer')?>
