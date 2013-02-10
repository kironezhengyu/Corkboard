<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
session_start(); //we need to call PHP's session object to access it through CI
class Home extends CI_Controller {

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
     $this->load->view('home_view', $data);
   }
   else
   {
     //If no session, redirect to login page
     redirect('login', 'refresh');
   }
 }

 function fetch_posts(){
     $data = array();
     $data['error'] = 0; 
     if($this->session->userdata('logged_in') && intval($this->uri->segment(3)) > -1 && intval($this->uri->segment(4)) > -1)
     {
     $offset = intval($this->uri->segment(3));
	 $fetch_amt = intval($this->uri->segment(4));
     $session_data = $this->session->userdata('logged_in');
     $username = $session_data['username'];
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
    
    $this->form_validation->set_rules('topic', 'Topic', 'trim|required|xss_clean');
    $this->form_validation->set_rules('initial_message', 'Message', 'trim|required|xss_clean');


    if($this->form_validation->run() == TRUE){
      $this->communication_model->add_post();
    }
	

	$session_data = $this->session->userdata('logged_in');
	$data['username'] = $session_data['username'];
	$data['nickname'] = $session_data['nickname'];
    $this->load->view('home_view', $data);


}

function addComment(){

	$session_data = $this->session->userdata('logged_in');
	$username = $session_data['username'];

	$this->load->helper('form');
	$postID = $this->input->post('comment1_id');
	$post = $this->input->post('comment1');
	$this->communication_model->add_comments($postID, $post,$username);
	

	$session_data = $this->session->userdata('logged_in');
	$data['username'] = $session_data['username'];
	$data['nickname'] = $session_data['nickname'];
    $this->load->view('home_view', $data);
	
	}
function addFriend($friend){
	
     $session_data = $this->session->userdata('logged_in');
     $self = $session_data['username'];
     $this->communication_model->add_friend($self,$friend );

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
    $this->load->view('home_view', $data);
	
	
	}
}

?>
