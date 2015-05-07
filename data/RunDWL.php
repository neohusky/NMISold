<?php
require_once('config.php');


$sql = 'UPDATE settings
		SET DWL_Trigger = 1
		WHERE id = 1';

$retval = mysql_query( $sql, $conn );

if(! $retval )
{
  die('Could not force mysql DWL update: ' . mysql_error());
}
echo "Dicom Worklist refresh sent";
mysql_close($conn);

?>
