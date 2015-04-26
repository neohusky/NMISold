<?php
	require_once('config.php');
	require_once('../codebase/connector/form_connector.php');
	
//	sleep(1);
	
	$form = new FormConnector($conn);
	$form->enable_log("log.txt",true);
	$form->render_table("packages_plain","Id","Package,Version,Size,Maintainer");
?>