<?php
	require_once('config.php');
	require_once('../codebase/connector/grid_connector.php');
	
//	sleep(1);
	
	$grid = new GridConnector($conn);
 	$grid->enable_log("log.txt",true);

//	$grid->render_table("hisimport",
//						"APPT_ID",
//						"PATIENT_NAME,MRN,DOB,NURSE_UNIT,APPT_TYPE,APPTBEGIN,RESOURCE");


	$grid->grid.render_complex_sql(
    "SELECT PATIENT_NAME, MRN, DOB, SEX, APPT_TYPE,APPTBEGIN,RESOURCE,NURSE_UNIT FROM hisimport WHERE RESOURCE <> "NM BMD" AND RESOURCE <> "Cardiac Technician" ORDER BY RESOURCE ASC,APPTBEGIN ASC",
	"PATIENT_NAME",
    "Patient Name,MRN,DOB,Sex,Scan,Date Time,Resource,Ward"
);

//
//FROM
//	hisimport
//WHERE
//	hisimport.RESOURCE <> "NM BMD"
//	AND hisimport.RESOURCE <> "Cardiac Technician"
//ORDER BY
//	hisimport.RESOURCE ASC,
//	hisimport.APPTBEGIN ASC
?>