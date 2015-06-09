<?php
require_once('config.php');

$Table = $_GET["id"];
$id="";

switch ($Table ) {
    case "generators" :
        // table is generators id=ida
        $id ="id";
        break;
    case "eluates" :
        // table is eluates id=EluateID
        $id ="EluateID";
        break;
}


$sql = "Select ".$id."
		FROM ".$Table."
		ORDER BY ".$id."
        DESC LIMIT 1";


$retval = mysql_query( $sql, $conn );

$rows = array();
while($r = mysql_fetch_assoc($retval)) {
    $rows['id'][] = $r;
}

print json_encode($rows);

//echo "Fetched data successfully\n";

mysql_close($conn);

?>