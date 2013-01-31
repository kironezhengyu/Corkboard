<?php
class user extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
		$this->load->model('user_model');
	}

	public function register()
	{
		$this->load->helper('form');
		$this->load->library('form_validation');
		
		$this->form_validation->set_rules('username', 'User Name', 'trim|required|is_unique[user.userName]|xss_clean');
		$this->form_validation->set_rules('nickname', 'Nick Name', 'trim|required|is_unique[user.nickname]|xss_clean');
		$this->form_validation->set_rules('password', 'Password', 'trim|required|min_length[4]|max_length[100]|xss_clean');	
		$this->form_validation->set_rules('conf_password', 'Confirm Password', 'trim|required|matches[password]|xss_clean');	
		
		if ($this->form_validation->run() === FALSE)
		{

			$this->load->view('register');
		
		}
		else
		{
			$this->user_model->add_user();	
			$this->load->view('login_view');
		}
	}
}
