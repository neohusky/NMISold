<?php
	require_once('config.php');
	require_once('../codebase/connector/form_connector.php');

//	sleep(1);

	$form = new FormConnector($conn);
	$form->enable_log("log.txt",true);
	$conn->render_table("Generators",
						"id",
						"BatchNo, Supplier, ArrivalDate");
?>
