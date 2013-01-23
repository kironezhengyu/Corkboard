<?php
class user_model extends CI_Model {

	public function __construct()
	{
		$this->load->database();
	}

	public function add_user()
	{
	
		$data = array(
			'userName' => $this->input->post('username'),
			'nickname' => $this->input->post('nickname'),
			'password' => $this->input->post('password')
		);
	
		return $this->db->insert('user', $data);
	}
}
