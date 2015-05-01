<?php
	require_once('config.php');
	require_once('../codebase/connector/grid_connector.php');
	
//	sleep(1);
	
	$grid = new GridConnector($conn);
 	$grid->enable_log("log.txt",true);

	$grid->render_table("hisimport",
						"APPT_ID",
						"PATIENT_NAME,MRN,DOB,NURSE_UNIT,APPT_TYPE,APPTBEGIN,RESOURCE");


$grid->grid.render_complex_sql(

//grid.render_complex_sql(
//    "SELECT name from tableA WHERE dept= (SELECT dept FROM tableB where name 'John')",
//    "contact_id",
//    "name,surname,age,address",
//    "extra1, extra2"
//);

//SELECT
//	hisimport.PATIENT_NAME,
//	hisimport.MRN,
//	hisimport.DOB,
//	hisimport.SEX,
//	hisimport.APPT_TYPE,
//	hisimport.APPTBEGIN,
//	hisimport.RESOURCE,
//	hisimport.NURSE_UNIT
//FROM
//	hisimport
//WHERE
//	hisimport.RESOURCE <> "NM BMD"
//	AND hisimport.RESOURCE <> "Cardiac Technician"
//ORDER BY
//	hisimport.RESOURCE ASC,
//	hisimport.APPTBEGIN ASC
//
?>