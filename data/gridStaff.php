
<?php
	require_once("../codebase/connector/grid_connector.php");
	require_once('config.php');


	$conn = new GridConnector($conn);
 	$conn->enable_log("log.txt",true);
//	$conn->render_table("Staff",
//						"Username",
//						"Username,Staffname, Classification, Currently employed");


//    $conn->render_sql("SELECT * FROM staff WHERE Username='theok'",
//                       "Username",
//                        "Staff ID, Staffname, Username, Classification, Currently employed",
//                        '',
//                        '');


    $conn->render_sql("SELECT * FROM staff",
                        "Username",
                        "Username,Staffname,StaffID,Position,CeasedEmploymentDate,Address,City,Postcode,State,MobilePhone,HomePhone,Contact1tName,Contact1Address,Contact1City,Contact1Postcode,Contact1State,Contact1MobilePhone,Contact1HomePhone",
                        '',


?>