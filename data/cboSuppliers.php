<?php
	require_once('config.php');
	require_once('../codebase/connector/combo_connector.php');
	
//	sleep(1);
	
	$data = new ComboConnector($conn);
	$data->enable_log("log.txt",true);
	//$data->render_table("Suppliers","id","Supplier, Supplier");
/*
	$data->render_sql("SELECT `kittypes`.`Supplier`",
                       "FROM `kittypes`",
                       "WHERE (`kittypes`.`Supplier` is not null)",
                       "ORDER BY `kittypes`.`Supplier` DESC)","Supplier","Supplier,Supplier");
*/
	$data->render_sql("SELECT DISTINCT `kittypes`.`Supplier` FROM `kittypes` ","Kit ID ","Supplier,Supplier");

?>