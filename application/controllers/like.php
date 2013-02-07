<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	class Like extends CI_Controller {

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
		   
		   $results = $this->communication_model->fetch_like($username);
		   
		   $data = array();
		   $data["topic"] = $results;
		   
		   $this->load->view('like_view',$data);
		 }

	}

?>