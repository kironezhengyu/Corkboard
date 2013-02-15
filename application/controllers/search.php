  <?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	class Search extends CI_Controller {


		function __construct()
 		{
   		parent::__construct();
   		header('Access-Control-Allow-Origin: *');
	   $this->load->model('communication_model');
		}
		public function index(){
 
     	
   		
	$session_data = $this->session->userdata('logged_in');
      $keyword = $_POST['keyword']; // you can also use $this->input->post('keyword');

			$data['posts'] = $this->communication_model->search($keyword, 0, 3);
			$data['username'] = $session_data['username'];
			$data['nickname'] = $session_data['nickname'];
			$data['keyword'] = $keyword;
          	$this->load->view('search_view', $data);

          //	var_dump($data);
 		}

	
	function fetch_search(){
     $data = array();
    
     $keyword = $this->uri->segment(5);
     $offset = intval($this->uri->segment(3));
	 $fetch_amt = intval($this->uri->segment(4));
     $session_data = $this->session->userdata('logged_in');

     $data['posts'] = $this->communication_model->search($keyword, $offset, $fetch_amt);
         
     
	 echo json_encode($data);
   //return json_encode($data);   

 }

		

		function pin_post(){


   		if($this->session->userdata('logged_in'))
   		{
			$session_data = $this->session->userdata('logged_in');
			$username = $session_data['username'];
			$pid = $this->input->post('comment1_id');
			$this->communication_model->pin_post($username, $pid);

			$session_data = $this->session->userdata('logged_in');
			$data['username'] = $session_data['username'];
			$data['nickname'] = $session_data['nickname'];
    		$this->load->view('home_view', $data);
     		
			}
     		else
   		{
     	//If no session, redirect to login page
     	redirect('login', 'refresh');
   		}
		 }

		function like($postID){
			if($this->session->userdata('logged_in'))
   		{
			$session_data = $this->session->userdata('logged_in');
			$username = $session_data['username'];
		    $this->communication_model->like($username,$postID );
	
			$session_data = $this->session->userdata('logged_in');
			$data['username'] = $session_data['username'];
			$data['nickname'] = $session_data['nickname'];
		    $this->load->view('public_view', $data);
		}
     		else
   		{
     	//If no session, redirect to login page
     	redirect('login', 'refresh');
   		}
		}


	}	

?>