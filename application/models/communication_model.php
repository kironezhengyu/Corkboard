<?php
class communication_model extends CI_Model {

	public function __construct()
	{
		$this->load->database();

	}

	public function add_post()
	{
		$session_data = $this->session->userdata('logged_in');
		$username = $session_data['username'];
		$topic = $this->input->post('topic');
		$msg_content = $this->input->post('initial_message');
		$attachment_link = $this->input->post('post_link');

	    $result =  $this->db->query("call create_post_proc(".$this->db->escape($username).",".$this->db->escape($topic).", @pp);");
		$pid = $result->row();
		$pid = $pid->pid;



		$mysqli = new mysqli(  "localhost", "root", "", "corkboard" );

		$res = $mysqli->query("call create_msg(".$this->db->escape($username).",".$this->db->escape($msg_content).",".$this->db->escape($pid).",".$this->db->escape($attachment_link).");");

		//$res->close();
		$mysqli->close();


		//return $this->db->query("call create_msg(".$this->db->escape($username).",".$this->db->escape($msg_content).",".$this->db->escape($pid).",".$this->db->escape($attachment_link).");");
	}
	
	public function fetch_post()
	{
		$query = $this->db->query("call fetch_post_proc(".$username.", ".$latest_offset.")");
		
		foreach($query->result_array() as $row)
		{
			echo $row['nickname']
			echo ': '
			echo $row['content']
		}		
	}
}
