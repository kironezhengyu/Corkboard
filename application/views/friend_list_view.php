<?php $this->load->view('include/header')?>
<?php $this->load->view('include/navbar_home')?>

<script>
var username;
var base_url = <?php $base = "'" . base_url('') . "'";
						echo $base;
				?>;
var current_offset = 0;
var self_post_fetch_amt = 2;

var ajax_fetch = function(base_url , current_offset, fetch_amt, post_loc, uname){
 	return $.ajax( { url: base_url + "/index.php/friend/fetch_posts/" + current_offset*fetch_amt + "/" + fetch_amt + "/" + uname
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
				var num_likes = 0;
				var fetched_posts = "";
				var ret = "";
				
				while (k < fetch_amt && i < data["posts"].length){ // Post loop
					j = i;
					topic = data["posts"][i]['topic'];
					postID = data["posts"][i]['postId'];
					num_likes = data["posts"][i]['num_likes'];
					messages = "";
					post = "";
					
					
					while (j < data["posts"].length && topic == data["posts"][j]['topic']){ // Message loop
						messages = messages + "<b>" + "<a class='announce btn btn-link' data-toggle='modal' data-uname='" + data["posts"][j]['userName']
										+ "' data-nickname='" + data["posts"][j]['nickname'] + "'>"
										+ data["posts"][j]['nickname'] + ":</a></b> " + data["posts"][j]['content']
										+"<br>";
						j++;
					} // End of message loop
					
					post = "<div class='span" + span_length + "'>" +
								"<div class='well'>" +
									"<h3>" + topic + "<a href='" + <?php echo '"' . base_url('index.php/friend/like/') . '"'; ?> + "/" +
											postID + "'> [" +num_likes+ "  <i class='icon-thumbs-up'></i>]</a></h3>" +
											"<div class='input-append'>" +
										'<?php echo form_open('publicboard/pin_post'); ?>' +
										"<input type='hidden' name='comment1_id' value='"+ postID   +"' />" +
											"<button class='pinning btn' type='submit'> pin </button></form>" +
									"</div>" +
									"<br>" + messages + "<br>" +
									"<div class='input-append'>" +
										'<?php echo form_open('friend/addComment'); ?>' +
										"<input class='input-large' id='comment1' name = 'comment1' type='text'>" +
										"<input type='hidden' name='comment1_id' value='"+ postID   +"' />" +
											"<button class='btn' type='submit'> &raquo </button></form>" +
									"</div>" +
								"</div>" +
							"</div>";
					
					fetched_posts += post;
					ret += messages;
					i += j;
					k++;
				} // End of post loop
				$(post_loc).html(fetched_posts);
 			}
 			, error : function(){
 				$(post_loc).empty();
 				$(post_loc).html('An error occurred');
 			}
			, type: 'GET'
			, async: false
 		});

 }
 var setUname = function (friend_uname){
	username = friend_uname;
	ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area", username);
};

 $(function(){
 
 $('.prev_btn').on("click", function(){
 	current_offset--;
	if(current_offset < 0){
	  current_offset =0;
	}
 	ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area", username);
 });
 $('.next_btn').on("click", function(){
 	current_offset++;
	var success;
 	success = ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area", username);
	if (success == ""){
		current_offset = 0;
		ajax_fetch(base_url, current_offset, self_post_fetch_amt, "#users_post_area", username);
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

 $(document).on("click", ".declare", function(){
	var cookie_uname = '<?php echo $username ?>';
    var uname = $(this).data('uname');
	if (uname != cookie_uname) {
		var nickname = $(this).data('nickname');
		var removefriend = <?php echo '"' . base_url('index.php') . '"'; ?> + "/home/removeFriend/" + uname;
		$('.uname_m1').html("Do you wish to remove " + nickname + " from your friends list?");
		$('#friend_remove').html("<a class='btn btn-primary' href='" + removefriend + "'> Confirm </a>");
		$('#friend_conf1').modal('show');
	}
 }); 
});


</script>

<div class="container">
	<div class="row-fluid">
		<div class="span4">
			<div class="well">
				<div class="friend_list">
				<h1>My Friends</h1>
				<br>
				<?php 
				$i = 0;
				$numFriends= sizeof($friends);
				for ($i=0; $i < $numFriends; $i++){
					echo '<p><i class="declare icon-remove"  data-uname="'. $friends[$i]['friend_user_name']  .'"  data-nickname="'.$friends[$i]["nickname"].'"></i>  &emsp;   <a href="#" class="friends" id="' .  $friends[$i]['friend_user_name'] . '"\'><font size="6">' . $friends[$i]["nickname"] . "&raquo</font></a></p>";
					//echo '<h3><a onclick="' + 'setUname('.$friends[$i]["friend_user_name"].')' + '">' . $friends[$i]["nickname"] . '  &raquo</a></h3>';
				}
				?>
				</div>
			</div>
		</div>
		<div class="span8">
			<div class="well">
				<div class="row-fluid pagination-centered" id="users_post_area">
				<h1>Click on a friend's name to see their posts!</h1>
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

<script type="text/javascript">
var friends = $('.friends');
$.each(friends, function(){
	jQuery(this).on('click' , function(){
		setUname(this.id);
	});
});
</script>

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
	
	<div id="friend_conf1" class="modal hide" >
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 class="uname_m1" >Username</h3>
	  </div>
	  <div class="modal-body" id="friend_body">
		<p>They will be added to your list, but you won't be added to theirs. If you want them to follow you, make them like you!</p>
	  </div>
	  <div class="modal-footer" id="friend_remove">
		<button class="btn btn-large" data-dismiss="modal" aria-hidden="true">Close</button>
	  </div>
	</div>


<?php $this->load->view('include/footer')?>
