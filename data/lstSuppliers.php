<?php
    require_once("../codebase/connector/combo_connector.php");
	require_once('config.php');


    $data = new ComboConnector($conn);
    $data->enable_log("log.txt",true);


    $data->render_sql("SELECT DISTINCT `suppliers`.`Name` FROM `suppliers` ","Name","Name");
?>
