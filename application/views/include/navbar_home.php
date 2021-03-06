<body>
  <div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container">
        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a>
        <a class="brand" href="<?php echo base_url('') ?>">CorkBoard</a>
        <div class="nav-collapse collapse">
          <ul class="nav">
            <li class="button"><a href="<?php echo base_url('index.php/home') ?>">Home</a></li>
            <li class="contact_popover">
             <a href="#" role="button">About</a>
              <script>
              var options = {
                placement : 'bottom'
                , title : 'About corkboard'
                , content : 'CorkBoard is a database project that designed to explore a new way to communicate'
              }
              jQuery('.contact_popover').popover(options);           </script>
            </li>

              <li  class= "button"><a href="<?php echo base_url('index.php/about') ?>">Contact</a></li>
                         <li class="button navbar-left" style="margin-top:5px; height:40px;"><?php echo form_open('search/search');?>
        <input type="text" name="keyword">
        </form></li>
          </ul>

           
            <ul class="nav pull-right">
				<li><a href="#create_post" role="button" data-backdrop="false" data-toggle="modal" ><i class="icon-edit"></i></a></li>
				<div id="create_post" class="modal hide" >
				  <div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
					<h3 id="myModalLabel">Create a new Post</h3>
				  </div>
				  <div class="modal-body">
					<?php echo validation_errors(); ?>
					<?php echo form_open('home/addPost') ?>
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
			 <li><a href="<?php echo base_url('index.php/friend');?>">Friends</a></li>
			 <li><a href="<?php echo base_url('index.php/publicboard');?>">Public</a></li>
			 <li class="divider-vertical"></li>
             <li><a href="<?php echo base_url('index.php/home/logout');?>">Log Out</a></li>
            </ul>
         <!--  <form class="navbar-form pull-right">
            <input class="span2" type="text" placeholder="Email">
            <input class="span2" type="password" placeholder="Password">
            <button type="submit" class="btn">Sign in</button>
          </form> -->
        </div><!--/.nav-collapse -->
      </div>
    </div>
  </div>
