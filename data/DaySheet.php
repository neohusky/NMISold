<?php
	require_once('config.php');
	require_once('../codebase/connector/grid_connector.php');
	
//	sleep(1);
	
	$grid = new GridConnector($conn);
 	$grid->enable_log("log.txt",true);

	$grid->render_table("hisimport",
						"APPT_ID",
						"SURNAME,GIVEN_NAME,MRN,DOB,NURSE_UNIT,APPT_TYPE,APPTBEGIN,RESOURCE");
?>