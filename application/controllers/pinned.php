<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	class Pinned extends CI_Controller {

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
		   
		   $this->load->view('pinned_view');
		 }

	}

?>