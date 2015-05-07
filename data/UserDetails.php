<?php
require_once('config.php');


$sql = "Select Staffname, Position
		FROM staff
		WHERE Username = 'theok'";

$retval = mysql_query( $sql, $conn );

$rows = array();
   while($r = mysql_fetch_assoc($retval)) {
     $rows['UserDetails'][] = $r;
   }

 print json_encode($rows);

echo "Fetched data successfully\n";

mysql_close($conn);

?>
