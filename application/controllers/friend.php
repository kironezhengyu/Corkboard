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
		   $data['nickname'] = $session_data['nickname'];
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
		 
		 function like($postID){
			 $session_data = $this->session->userdata('logged_in');
			 $username = $session_data['username'];
			 $this->communication_model->like($username,$postID );
			 $session_data = $this->session->userdata('logged_in');
			 $data['username'] = $session_data['username'];
			 $data['nickname'] = $session_data['nickname'];
			 $this->load->view('friend_list_view', $data);		
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
			 $data["friends"] = $this->communication_model->getFriend($username);
			 $this->load->view('friend_list_view', $data);
		
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
			$this->load->view('friend_list_view', $data);
		}
	}

?>