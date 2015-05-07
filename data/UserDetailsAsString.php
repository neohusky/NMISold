<?php
require_once('config.php');


$sql = "Select Staffname, Position
		FROM staff
		WHERE Username = 'theok'";

$retval = mysql_query( $sql, $conn );
if(! $retval )
{
  die('Could not get data: ' . mysql_error());
}
while($row = mysql_fetch_array($retval, MYSQL_ASSOC))
{
    echo "Staffname :{$row['Staffname']}  <br> ".
         "Position: {$row['Rosition']} <br> ".
         "--------------------------------<br>";
}
echo "Fetched data successfully\n";
mysql_close($conn);

?>
