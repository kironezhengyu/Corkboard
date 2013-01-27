<body>
  <div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container">
        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a>
        <a class="brand" href="..">CorkBoard</a>
        <div class="nav-collapse collapse">
          <ul class="nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>

            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li class="divider"></li>
                <li class="nav-header">Nav header</li>
                <li><a href="#">Separated link</a></li>
                <li><a href="#">One more separated link</a></li>
              </ul>
            </li>
          </ul>
           <form class="navbar-search pull-left">
            <input type="text" class="search-query" placeholder="Search">
           </form>
          <ul class="nav pull-right">
        <li><a href="/corkboard/index.php/signUp">Sign Up</a></li>
        <li class="divider-vertical"></li>
        <li class="dropdown">
          <a class="dropdown-toggle" href="#" data-toggle="dropdown">Sign In <strong class="caret"></strong></a>
          <div class="dropdown-menu" style="padding: 15px; padding-bottom: 0px;">
            <!-- Login form here -->
            <?php echo validation_errors(); ?>
            <?php echo form_open('verifylogin'); ?>
              <input id="user_username" style="margin-bottom: 15px;" type="text" name="username" size="30" />
              <input id="user_password" style="margin-bottom: 15px;" type="password" name="password" size="30" />
              <input id="user_remember_me" style="float: left; margin-right: 10px;" type="checkbox" name="user[remember_me]" value="1" />
              <label class="string optional" for="user_remember_me"> Remember me</label>

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