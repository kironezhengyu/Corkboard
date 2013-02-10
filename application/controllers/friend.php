<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	class Friend extends CI_Controller {

		 function __construct()
		 {
		   parent::__construct();
		   $this->load->model('communication_model');
		    header('Access-Control-Allow-Origin: *');

		 }

		 function index()
		 {
		   
		   
		   $session_data = $this->session->userdata('logged_in');
		   $username = $session_data['username'];
		   
		   $friend = $this->communication_model->getFriend($username);
		   
		   $data = array();
		   $data["friends"] = $friend;
		   $data['username'] = $username;
		   $this->load->view('friend_list_view',$data);
		 }
		 
		 function fetch_posts(){
			 $data = array();
			 $data['error'] = 0; 
			 if($this->session->userdata('logged_in') && intval($this->uri->segment(3)) > -1 && intval($this->uri->segment(4)) > -1)
			 {
			 $offset = intval($this->uri->segment(3));
			 $fetch_amt = intval($this->uri->segment(4));
			 $session_data = $this->session->userdata('logged_in');
			 $username = $this->uri->segment(5);
			 $data['posts'] = $this->communication_model->fetch_posts($username, $offset, $fetch_amt);
			 echo json_encode($data);
			 return json_encode($data);   
		   }
		   else
		   {
			 $data['error'] =1;
			 return json_encode($data);
		   }

		 }
	}

?>