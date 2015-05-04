<?php

/**
 * Active Directory abstraction layer
 */
class ActiveDirectory {

	var $host = 'dc01.kids';
	var $base = 'ou=nch,dc=nch,dc=kids';
	var $user = 'nch\\ldapproxyuser';
	var $pass = 'cs_x';

/**
 * Constructor
 */
	function __construct() {
		$this->ds = ldap_connect($this->host);
		ldap_set_option($this->ds, LDAP_OPT_REFERRALS, 0);
		ldap_set_option($this->ds, LDAP_OPT_PROTOCOL_VERSION, 3);
		ldap_bind($this->ds, $this->user, $this->pass);
	}

/**
 * Destructor
 */
	function __destruct() {
		ldap_close($this->ds);
	}

/**
 * Perform an LDAP search and returns a single result
 *
 * @param $filters mixed
 * @param $attributes array List of attributes to return
 * @return array Returns an array of matches or FALSE if nothing is found
 */
	function find($filters=null, $attributes=array(), $deep=true) {
		return $this->findAll($filters, $attributes, null, 1, $deep);
	}

/**
 * Perform an LDAP search. Mimics Cake's DBO behaviour
 *
 * @param $filters mixed
 * @param $attributes array List of attributes to return
 * @param $order string Attribute to order results by
 * @param $limit integer Maximum number of records to return
 * @param $deep boolean False to search only the BASE_DN level
 * @return array Returns an array of matches or FALSE if nothing is found
 */
	function findAll($filters=null, $attributes=array(), $order=null, $limit=0, $deep=true) {
		$filter = (is_array($filters)) ? $this->conditionKeysToString($filters) : $filters;
		$function = ($deep) ? 'ldap_search' : 'ldap_list';
		$search = $function($this->ds, $this->base, $filter, $attributes, 0, $limit);

		if ($search) {
			if ($order) { ldap_sort($this->ds, $search, $order); }
			$entries = ldap_get_entries($this->ds, $search);
			$count = array_shift($entries);
			if ($count > 0) {
				return $entries;
			}
		}
		return false;
	}

/**
 * Authenticate a user.
 *
 * @param $username string
 * @param $username password
 * @return boolean
 */
	function authenticate($username, $password) {
		$user = $this->find(array('samaccountname' => $username), array('samaccountname'));
		if ($user && @ldap_bind($this->ds, $user[0]['dn'], $password)) {
			return true;
		}
		return false;
	}

/***
 * Creates an LDAP filter by parsing given conditions array.
 *
 * @param $conditions array Array of conditions
 * @return string LDAP filter
 */
	function conditionKeysToString($conditions) {
		$filter = array();
		foreach ($conditions as $attribute => $value) {
			if (is_array($value)) {
				$tmp = array();
				foreach ($value as $v) {
					$v = $this->escape($v);
					$tmp[] = "({$attribute}={$v})";
				}
				$filter[] = '(|' . implode('', $tmp) . ')';
			} elseif (strpos($value, '<> ') === 0) {
				$value = $this->escape(substr($value, 3));
				$filter[] = "(!({$attribute}={$value}))";
			} else {
				$value = $this->escape($value);
				$filter[] = "({$attribute}={$value})";
			}
		}
		return '(&' . implode('', $filter) . ')';
	}

/**
 * Escapes meta characters in a search filter
 * Asterixes (*) are permitted at this stage to facilitate easy wildcard searches
 *
 * @param $value string Value to be escaped
 * @return string The escaped value
 */
	function escape($value) {
		$find = array('\\', ',', '=', '+', '<', '>', ';', '"', '#', '(', ')');
		$replace = array();
		foreach ($find as $char) {
			$replace[] = sprintf('\\%02x', ord($char));
		}
		$value = str_replace($find, $replace, $value);
		if ($value === null) { $value = '\0'; }
		return $value;
	}

}

?>