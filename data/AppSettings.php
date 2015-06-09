<?php
require_once('config.php');

$sql = "Select App_TimeOut, App_HotlabConnectServer,App_HotlabConnectPort
		FROM Settings
		WHERE id = 1";


$retval = mysql_query( $sql, $conn );

$rows = array();
while($r = mysql_fetch_assoc($retval)) {
    $rows['AppSettings'][] = $r;
}

print json_encode($rows);

//echo "Fetched data successfully\n";

mysql_close($conn);

?>