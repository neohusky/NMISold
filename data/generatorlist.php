<?php
	require_once('config.php');
	require_once('../codebase/connector/grid_connector.php');
	
//	sleep(1);
	
	$conn = new GridConnector($res,"MySQL");
 	$conn->enable_log("log.txt",true);
	$conn->render_table("Generators","id","id,BatchNo,Supplier,ArrivalDate");
?>