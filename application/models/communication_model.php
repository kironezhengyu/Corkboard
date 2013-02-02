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
	
	public function fetch_posts($username, $latest_offset)
	{
		$query = $this->db->query("call fetch_post_proc('".$this->db->escape($username)."', ".$this->db->escape($latest_offset).")");
		
		$count =0;
		$result = array();
		foreach($query->result_array() as $row)
		{	 
			$result[$count]['nickname']= $row['nickname'];
			$result[$count]['topic'] = $row['topic'];
			$result[$count]['content']= $row['content'];
			$count++;
		}		
		return $result;

	}
}
