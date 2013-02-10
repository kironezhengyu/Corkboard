<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	class publicboard extends CI_Controller {



 		function __construct()
 		{
   		parent::__construct();
   		header('Access-Control-Allow-Origin: *');
	   $this->load->model('communication_model');
		}

 		function index()
 		{
   		if($this->session->userdata('logged_in'))
   		{
     	$session_data = $this->session->userdata('logged_in');
     	$data['username'] = $session_data['username'];
	 	$data['nickname'] = $session_data['nickname'];
     	$data['posts'] = $this->communication_model->fetch_posts($data['username'], 0, 1);
     	$this->load->view('public_view', $data);
   		}
   		else
   		{
     	//If no session, redirect to login page
     	redirect('login', 'refresh');
   		}
 		}

		function pin_post(){
			$session_data = $this->session->userdata('logged_in');
			$username = $session_data['username'];
			$pid = $this->input->post('comment1_id');
			$this->communication_model->pin_post($username, $pid);

			$session_data = $this->session->userdata('logged_in');
			$data['username'] = $session_data['username'];
			$data['nickname'] = $session_data['nickname'];
    		$this->load->view('home_view', $data);
     		
		 }

		function like($postID){
			$session_data = $this->session->userdata('logged_in');
			$username = $session_data['username'];
		    $this->communication_model->like($username,$postID );
	
			$session_data = $this->session->userdata('logged_in');
			$data['username'] = $session_data['username'];
			$data['nickname'] = $session_data['nickname'];
		    $this->load->view('public_view', $data);
	
		}


		

	}

?>