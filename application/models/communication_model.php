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

        $mysqli = new mysqli(  "localhost", "root", "", "corkboard" );
		
		$res = $mysqli->query("call like_post(".$this->db->escape($pid).", ".$this->db->escape($username).")" );
		
		$mysqli->close();
	


		//return $this->db->query("call create_msg(".$this->db->escape($username).",".$this->db->escape($msg_content).",".$this->db->escape($pid).",".$this->db->escape($attachment_link).");");
	}
	
	public function fetch_posts($username, $latest_offset, $fetch_amt)
	{
		$query = $this->db->query("call fetch_post_proc(".$this->db->escape($username).", ".$this->db->escape($latest_offset).", ".$this->db->escape($fetch_amt).")");
		
		$count =0;
		$result = array();
		foreach($query->result_array() as $row)
		{	 
			$result[$count]['postId']= $row['postId'];
			$result[$count]['nickname']= $row['nickname'];
			$result[$count]['userName']= $row['user_commenting'];
			$result[$count]['topic'] = $row['topic'];
			$result[$count]['content']= $row['content'];
			$result[$count]['num_likes']= $row['num_likes'];
			$result[$count]['link'] = $row['link'];
			$count++;
		}		
		return $result;

	}


	public function fetch_pinned_posts($username, $latest_offset, $fetch_amt)
	{
		$query = $this->db->query("call fetch_pinned_post(".$this->db->escape($username).", ".$this->db->escape($latest_offset).", ".$this->db->escape($fetch_amt).")");
		
		$count =0;
		$result = array();
		foreach($query->result_array() as $row)
		{	 
			$result[$count]['postId']= $row['postId'];
			$result[$count]['nickname']= $row['nickname'];
			$result[$count]['userName']= $row['user_commenting'];
			$result[$count]['topic'] = $row['topic'];
			$result[$count]['content']= $row['content'];
			$result[$count]['num_likes']= $row['num_likes'];
			$result[$count]['link'] = $row['link'];
			$count++;
		}		
		return $result;

	}


		public function fetch_public_posts($latest_offset, $fetch_amt)
	{
		$query = $this->db->query("call fetch_public_post(".$this->db->escape($latest_offset).", ".$this->db->escape($fetch_amt).")");
		
		$count =0;
		$result = array();
		foreach($query->result_array() as $row)
		{	 
			$result[$count]['postId']= $row['postId'];
			$result[$count]['nickname']= $row['nickname'];
			$result[$count]['userName']= $row['user_commenting'];
			$result[$count]['topic'] = $row['topic'];
			$result[$count]['content']= $row['content'];
			$result[$count]['num_likes']= $row['num_likes'];
			$result[$count]['link'] = $row['link'];
			$count++;
		}		
		return $result;

	}
	
	public function add_comments($comment_id, $comment,$username){ 
		
		$link = "";
		
		$mysqli = new mysqli(  "localhost", "root", "", "corkboard" );
		
		$res = $mysqli->query("call create_msg(".$this->db->escape($username).",".$this->db->escape($comment).",".$this->db->escape($comment_id).",".$this->db->escape($link).");");
		
		$mysqli->close();
	}


	public function pin_post($username, $postId){
		$this->db->query("call pin_post(".$this->db->escape($username).",".$this->db->escape($postId).");");
	}

	public function unpin_post($username, $postId){
		$this->db->query("call unpin_post(".$this->db->escape($username).",".$this->db->escape($postId).");");
	}
	
	public function add_friend($self,$friend ){
		
			$mysqli = new mysqli(  "localhost", "root", "", "corkboard" );
		
		$res = $mysqli->query("call addFriend(".$this->db->escape($self).", ".$this->db->escape($friend).")" );
		
		$mysqli->close();

	}
	
	public function getFriend($username){
		$query = $this->db->query("call fetch_friends(".$this->db->escape($username).")");
		
		$count =0;
		$result = array();
		foreach($query->result_array() as $row)
		{	 
			
			$result[$count]['nickname']= $row['nickname'];
			$result[$count]['friend_user_name']= $row['friend_user_name'];
			$count++;
		}		
		return $result;
	
	}
	
	public function like ($username, $postID){
		
		$mysqli = new mysqli(  "localhost", "root", "", "corkboard" );
		
		$res = $mysqli->query("call like_post(".$this->db->escape($postID).", ".$this->db->escape($username).")" );
		
		$mysqli->close();
	
	}
	
	public function fetch_like ($username){
	
		$query = $this->db->query("call fetch_likes(".$this->db->escape($username).")");
		
		$count =0;
		$result = array();
		foreach($query->result_array() as $row)
		{	 
			
			$result[$count]['postId']= $row['postId'];
			$result[$count]['topic']= $row['topic'];
			$count++;
		}		
		return $result;
	}
	
}
