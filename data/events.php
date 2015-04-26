<?php
require_once("../codebase/connector/scheduler_connector.php");

$res=mysql_connect("10.7.145.68","nucmed","nucmed");
mysql_select_db("NMIS");

$conn = new SchedulerConnector($res);

$conn->render_table("events2","APPT_ID","APPTBEGIN,APPTEND,APPT_TYPE,RESOURCE");
  ?>