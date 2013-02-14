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
	 $data['greeted'] = TRUE;
     $this->load->view('home_view', $data);
   }
   else
   {
     //If no session, redirect to login page
     redirect('login', 'refresh');
   }
 }

 function unpin_post(){
	$session_data = $this->session->userdata('logged_in');
	$username = $session_data['username'];
	$pid = $this->input->post('comment1_id');
	$this->communication_model->unpin_post($username, $pid);

	$session_data = $this->session->userdata('logged_in');
	$data['username'] = $session_data['username'];
	$data['nickname'] = $session_data['nickname'];
	$this->load->view('home_view', $data);
     		
 }

 function fetch_public_posts(){
     $data = array();
     $data['error'] = 0; 
     if($this->session->userdata('logged_in') && intval($this->uri->segment(3)) > -1 && intval($this->uri->segment(4)) > -1)
     {
     $offset = intval($this->uri->segment(3));
	 $fetch_amt = intval($this->uri->segment(4));
     $session_data = $this->session->userdata('logged_in');
     $data['posts'] = $this->communication_model->fetch_public_posts($offset, $fetch_amt);
	 echo json_encode($data);
     return json_encode($data);   
   }
   else
   {
     $data['error'] =1;
     return json_encode($data);
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


 function fetch_pinned_posts(){
     $data = array();
     $data['error'] = 0; 
     if($this->session->userdata('logged_in') && intval($this->uri->segment(3)) > -1 && intval($this->uri->segment(4)) > -1)
     {
     $offset = intval($this->uri->segment(3));
	 $fetch_amt = intval($this->uri->segment(4));
     $session_data = $this->session->userdata('logged_in');
     $username = $session_data['username'];
     $data['posts'] = $this->communication_model->fetch_pinned_posts($username, $offset, $fetch_amt);
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
	$this->form_validation->set_rules('post_link', 'Link', 'trim|prep_url|valid_url');


    if($this->form_validation->run() === TRUE){
      $this->communication_model->add_post();
    }
	

	$session_data = $this->session->userdata('logged_in');
	$data['username'] = $session_data['username'];
	$data['nickname'] = $session_data['nickname'];
    $this->load->view('home_view', $data);


}

function addCommentAttached(){
	$session_data = $this->session->userdata('logged_in');
	$username = $session_data['username'];

	$this->load->helper('form');
	$this->load->library('form_validation');
	
	$this->form_validation->set_rules('pid_at', 'Post ID', 'trim|required|xss_clean');
	$this->form_validation->set_rules('message_at', 'Comment', 'trim|required|xss_clean');
	$this->form_validation->set_rules('post_link_at', 'Link', 'trim|prep_url|valid_url');
	
	$postID = $this->input->post('pid_at');
	$comment = $this->input->post('message_at');
	$link = prep_url($this->input->post('post_link_at'));
	
	if($this->form_validation->run() === TRUE){
		$this->communication_model->add_comments($postID, $comment,$username, $link);
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
	$link = "";
	$this->communication_model->add_comments($postID, $post,$username, $link);
	

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
	$friend = $this->communication_model->getFriend($self);
	$data["friends"] = $friend;
	$data['username'] = $session_data['username'];
	$data['nickname'] = $session_data['nickname'];
    $this->load->view('friend_list_view', $data);

		}


function removeFriend($friend){
	
     $session_data = $this->session->userdata('logged_in');
     $self = $session_data['username'];
     $this->communication_model->remove_friend($self,$friend );

			$session_data = $this->session->userdata('logged_in');
	$friend = $this->communication_model->getFriend($self);
	$data["friends"] = $friend;
	$data['username'] = $session_data['username'];
	$data['nickname'] = $session_data['nickname'];
    $this->load->view('friend_list_view', $data);

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
