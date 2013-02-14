<?php if (!defined('BASEPATH')) exit('No direct script access allowed');
/**
* MY Form validation Class
*
* Extends Form Validation library
*
* Adds one validation rule, "valid_url" and accepts a url and one optional flag:
*
* scheme - FILTER_FLAG_SCHEME_REQUIRED - Requires URL to be an RFC compliant URL (like http://example)
* host - FILTER_FLAG_HOST_REQUIRED - Requires URL to include host name (like http://www.example.com)
* path - FILTER_FLAG_PATH_REQUIRED - Requires URL to have a path after the domain name (like www.example.com/example1/test2/)
* query - FILTER_FLAG_QUERY_REQUIRED - Requires URL to have a query string (like "example.php?name=Peter&age=37")
*
* @link http://github.com/websoftwares/codeigniter-validate-url
* @link http://code.websoftwar.es/codeigniter-validate-url
*
*/
class MY_Form_validation extends CI_Form_validation {

	public $CI;

	private $flags = array(
		'scheme' => 'FILTER_FLAG_SCHEME_REQUIRED',
		'host' => 'FILTER_FLAG_HOST_REQUIRED',
		'path'	=> 'FILTER_FLAG_PATH_REQUIRED',
		'query'	=> 'FILTER_FLAG_QUERY_REQUIRED'
	);

	function __construct()
	{
		parent::__construct();
		$this->CI =& get_instance();
	}
	/**
	* validate url with one optional flag: 'scheme', 'host', 'path', 'query'
	*
	* @param string $url
	* @param string $flag
	* @return bool
	*/
	public function valid_url($url,$flag = FALSE)
	{
		if (isset($flag) && ! empty($flag))
		{
			$this->CI->form_validation->set_message('valid_url', 'The %s does not contain a valid ' . $flag);
			return (!filter_var($url,FILTER_VALIDATE_URL,$this->flags[$flag])) ? FALSE : TRUE;
		}
		else
		{
			$this->CI->form_validation->set_message('valid_url', 'The %s is not a valid url');
			return (!filter_var($url,FILTER_VALIDATE_URL)) ? FALSE : TRUE;
		}
		
	}
}
/* End of file MY_Form_validation.php */


