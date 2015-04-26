<?php
	require_once("../codebase/connector/grid_connector.php");
	require_once('config.php');


	$conn = new GridConnector($conn);
 	$conn->enable_log("log.txt",true);
	$conn->render_table("Generators",
						"id",
						"id, BatchNo, Supplier, ArrivalDate");
?>
