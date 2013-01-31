<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
session_start(); //we need to call PHP's session object to access it through CI
class Home extends CI_Controller {

 function __construct()
 {
   parent::__construct();
   $this->load->model('communication_model');
 }

 function index()
 {
   if($this->session->userdata('logged_in'))
   {
     $session_data = $this->session->userdata('logged_in');
     $data['username'] = $session_data['username'];
	 $data['nickname'] = $session_data['nickname'];
     $this->load->view('home_view', $data);
   }
   else
   {
     //If no session, redirect to login page
     redirect('login', 'refresh');
   }
 }

 function logout()
 {
   $this->session->unset_userdata('logged_in');
   session_destroy();
   redirect('home', 'refresh');
 }

function addPost()
{
      $this->load->helper('form');
    $this->load->library('form_validation');
    
    $this->form_validation->set_rules('topic', 'Topic', 'required');
    $this->form_validation->set_rules('initial_message', 'Message', 'required');


    if($this->form_validation->run() == TRUE){
      $this->communication_model->add_post();
    }
	

	$session_data = $this->session->userdata('logged_in');
	$data['username'] = $session_data['username'];
    $this->load->view('home_view', $data);


}

}

?>
