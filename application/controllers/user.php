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
		
		$data['title'] = 'User Registration';
		
		$this->form_validation->set_rules('username', 'User Name', 'required');
		$this->form_validation->set_rules('nickname', 'Nick Name', 'required');
		$this->form_validation->set_rules('password', 'Password', 'required');	
		$this->form_validation->set_rules('password2', 'Password2', 'required');	
		
		if ($this->form_validation->run() === FALSE)
		{
			$this->load->view('templates/header', $data);	
			$this->load->view('registration/register');
			$this->load->view('templates/footer');
		
		}
		else
		{
			$this->user_model->add_user();
			$this->load->view('templates/header', $data);	
			$this->load->view('registration/success');
			$this->load->view('templates/footer');
		}
	}
}
