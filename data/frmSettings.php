<?php
	require_once('config.php');
	require_once('../codebase/connector/form_connector.php');

//	sleep(1);

	$form = new FormConnector($conn);
	$form->enable_log("log.txt",true);
	$form->render_table("Settings",
						"id",
						"DWL_ServerAET, DWL_ServerIP, DWL_ServerPort, DWL_OwnAET, DWL_OwnIP, DWL_SearchModality, DWL_RefreshTime, App_TimeOut, App_HotlabConnectServer,App_HotlabConnectPort");
?>
