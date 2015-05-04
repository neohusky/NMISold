<?php

  include('./data/config.php');
  session_start();
  $username = $_SESSION['login_user'];// Initializing Session

    //MYSQL insert query
    $date = date('Y-m-d H:i:s');
    $action = "Logout";
    $sql = "INSERT INTO log (Username, Action, Time)
      VALUES ('$username', '$action','$date')";

    $query = mysql_query($sql, $conn);


  if(session_destroy()) // Destroying All Sessions
  {
  header("Location: ../index.php"); // Redirecting To Home Page
  }
 $conn->close();
?>