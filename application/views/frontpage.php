<?php $this->load->view('include/navbar')?>

<div class="container">

  <!-- Main hero unit for a primary marketing message or call to action -->
  <div class="hero-unit pagination-centered">
    <h1>Welcome to CorkBoard Pre-Alpha!</h1>
    <p>A new way to discover and share</p>
    <p><a class="btn btn-primary btn-large" href="index.php/signUp">Sign Up &raquo;</a></p>
  </div>

  <!-- Example row of columns -->
  <!-- div class="row">
    <div class="span4">
      <h2>What's up!</h2>
      <p>Click to see what people are talking about </p>
      <p><a class="btn" href="#">View details &raquo;</a></p>
    </div> -->



    <div class="row">
  
    <div class="span4">
      <img src="http://lorempixel.com/400/300/nightlife/<?php echo rand(1,10);?>" />
      <h4>Post 'n' Share</h4>
      <p>Post what ever you want and link to your favorite content!</p>
    </div>
    
    <div class="span4">
      <img src="http://lorempixel.com/400/300/business/<?php $r = rand(1,10); while($r==3){ $r = rand(1,10); } echo $r;?>" />
      <h4>Pin 'n' Chat</h4>
      <p>Like a post? Pin to your board and start conversation with people!</p>
    </div>
    
    <div class="span4">
      <img src="http://lorempixel.com/400/300/transport/<?php echo rand(1,10);?>" />
      <h4>Explore 'n' Socialize </h4>
      <p>Check out the latest news among your friends!</p>
    
  </div>
  
 

  <hr>

</div> <!-- /container -->