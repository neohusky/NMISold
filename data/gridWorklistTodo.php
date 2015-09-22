<?php
    require_once('config.php');
	require_once('../codebase/connector/grid_connector.php');

	$grid = new GridConnector($conn);
 	$grid->enable_log("log.txt",true);

    $grid->render_complex_sql(
    "SELECT `dicomworklist`.* FROM dicomworklist INNER JOIN DicomWorklistExclude ON `dicomworklist`.`RequestedProcedureDescription` = `DicomWorklistExclude`.`RequestedProcedureDescription`",
    "StudyInstanceUID",
    "PatientName, PatientID, PatientDOB, PatientSex, RequestedProcedureDescription, CurrentPatientLocation, Modality");


?>
