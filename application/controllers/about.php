<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	class About extends CI_Controller {

		 function __construct()
		 {
		   parent::__construct();
		 }

		 function index()
		 {

		 	$this->load->view('include/header');
		 	// $this->load->view('include/navbar');
		 	
	
		$this->load->view('about_view');
		
		$this->load->view('include/footer');
		 }

	}

?>