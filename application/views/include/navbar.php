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




          </ul>
           <form class="navbar-search pull-left">
            <input type="text" class="search-query" placeholder="Search">
           </form>
          <ul class="nav pull-right">
        <li><a href="<?php echo base_url('index.php/signUp')?>">Sign Up</a></li>
        <li class="divider-vertical"></li>
        <li class="dropdown">
          <a class="dropdown-toggle" href="<?php echo base_url('index.php/login') ?>" data-toggle="dropdown">Sign In <strong class="caret"></strong></a>
          <div class="dropdown-menu" style="padding: 15px; padding-bottom: 0px;">
            <!-- Login form here -->
            <?php echo validation_errors(); ?>
            <?php echo form_open('verifylogin'); ?>
              <input id="user_username" style="margin-bottom: 15px;" type="text" name="username" size="30" />
              <input id="user_password" style="margin-bottom: 15px;" type="password" name="password" size="30" />

              <input class="btn btn-primary" style="clear: left; width: 100%; height: 32px; font-size: 13px;" type="submit" name="commit" value="Sign In" />
            </form>
          </div>
        </li>
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
