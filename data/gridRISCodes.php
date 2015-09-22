<?php
/**
 * Created by PhpStorm.
 * User: nucmed
 * Date: 19/06/15
 * Time: 9:36 AM
 */
	require_once("../codebase/connector/grid_connector.php");
	require_once('config.php');


	$conn = new GridConnector($conn);
 	$conn->enable_log("log.txt",true);
	$conn->render_table("riscodes",
        "id",
        "id,RIScode, Show");
?>