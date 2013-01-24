<?php
class user_model extends CI_Model {

	public function __construct()
	{
		$this->load->database();
	}

	public function add_user()
	{

		$username = $this->input->post('username');
		$nickname = $this->input->post('nickname');
		$password = $this->input->post('password');
		$conf_password = $this->input->post('conf_password');
	
		return $this->db->query("call register_proc('$username', '$nickname', '$password', '$conf_password');");
	}
}