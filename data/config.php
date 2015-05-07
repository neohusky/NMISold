<?php

$mysql_host = "localhost";
$mysql_user = "nucmed";
$mysql_pasw = "nucmed";
$mysql_db   = "NMIS";

$conn = mysql_connect($mysql_host,$mysql_user,$mysql_pasw);
mysql_select_db($mysql_db);

?>