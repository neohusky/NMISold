<?php

/*http://localhost/register.php?id=1&username=bob&password=123&act=register

$id  = $_REQUEST['id'];
$username = $_REQUEST['username'];
$password = $_REQUEST['password'];
$act   = $_REQUEST['act'];*/


$id  = $_REQUEST['id'];

require_once('../data/config.php');


$sql = "Select id,BatchNo, Supplier, ArrivalDate, Username
		FROM nmis.generators
		WHERE id = $id";

$result = mysql_query( $sql, $conn );

if (!$result) {
    $message  = 'Invalid query: ' . mysql_error() . "\n";
    $message .= 'Whole query: ' . $query;
    die($message);
}
while ($row = mysql_fetch_assoc($result)) {

    $BatchNo = $row['BatchNo'];
    $Supplier = $row['Supplier'];
    $ArrivalDate = $row['ArrivalDate'];
    $Username = $row['Username'];


    echo $row['Id'] . " " . $BatchNo . " " . $Supplier . " " . $ArrivalDate ." " . $Username ."\n";
}

$myFile = "../toprint/testFile.txt";
$fh = fopen($myFile, 'w') or die("can't open file");
$stringData = "Bobby Bopper\n";
fwrite($fh, $stringData);
$stringData = "Tracy Tanner\n";
fwrite($fh, $stringData);
fclose($fh);

/**
 * Created by PhpStorm.
 * User: nucmed
 * Date: 2/11/15
 * Time: 1:36 PM
 */


?>