<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar_home')?>

<div class="container pagination-centered">
	<div class="row-fluid">
		<div class="span12">
			<div class="row-fluid">
				<div class="span12">
					<div class="well">
						<h2 class="muted">Public Posts</h2>
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
		<?php echo form_open('publicboard/addCommentAttached'); ?>
		
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
 	return $.ajax( { url: base_url + "/index.php/home/fetch_public_posts/" + current_offset*fetch_amt + "/" + fetch_amt
 			, success : function(d){
			    var data = JSON.parse(d);
 				var offset = current_offset; 
				$(post_loc).empty();
				
				var span_length = 12 / fetch_amt;
				var i = 0;
				var k = 0;
				var j = 0;
				var messages = "";
				var attachment;
				var topic;
				var postID;
				var post;
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
								"<div class='well'>" +
									"<h3>" + topic + "<a href='" + <?php echo '"' . base_url('index.php/publicboard/like/') . '"'; ?> + "/" +
											postID + "'>  [" +num_likes+ "  <i class='icon-thumbs-up'></i>]</a></h3>" +
									"<div class='input-append'>" +
										'<?php echo form_open('publicboard/pin_post'); ?>' +
										"<input type='hidden' name='comment1_id' value='"+ postID   +"' />" +
											"<button class='pinning btn' type='submit'> pin </button></form>" +
									"</div>" +
									"<br>" + messages + "<br>" +
									"<button class='attachC btn btn-primary' data-toggle='modal' data-pid='" + postID +"'> reply &raquo </button>" +
								//	"<div class='input-append'>" +
								//		'<?php echo form_open('publicboard/addComment'); ?>' +
								//		"<input class='input-large' id='comment1' name = 'comment1' type='text'>" +
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
 ajax_fetch(base_url, 0, self_post_fetch_amt, '#users_post_area'); 
});
</script>

<?php $this->load->view('include/footer')?>
