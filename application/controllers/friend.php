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
		   $this->load->view('friend_list_view',$data);
		 }

	}

?>