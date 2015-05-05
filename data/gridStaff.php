
<?php
	require_once("../codebase/connector/grid_connector.php");
	require_once('config.php');


	$conn = new GridConnector($conn);
 	$conn->enable_log("log.txt",true);
//	$conn->render_table("Staff",
//						"Staff ID",
//						"Staff ID, StaffName,UserName, Classification, Currently employed");


//    $conn->render_sql("SELECT * FROM staff WHERE Username='theok'",
//                       "Username",
//                        "Staff ID, Staffname, Username, Classification, Currently employed",
//                        '',
//                        '');


    $conn->render_sql("SELECT * FROM staff",
                        "Username",
                        "Staff ID, Staffname, Username, Classification, Currently employed",
                        '',
                        '');


?>