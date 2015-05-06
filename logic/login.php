<?php

  require_once('./data/config.php');
  include('./logic/activedirectory.php'); // Includes Login Script

  session_start(); // Starting Session
  $error=''; // Variable To Store Error Message
  if (isset($_POST['submit'])) {
  if (empty($_POST['username']) || empty($_POST['password'])) {
  $error = "Username or Password empty";
  }
  else
  {
  // Define $username and $password
  $username=$_POST['username'];
  $password=$_POST['password'];


if ($username == "test") {
    $_SESSION['login_user']=$username; // Initializing Session


  header("location: ./index.html?id=$username"); // Redirecting To Other Page

};
$ad = new ActiveDirectory();
    $login = $ad->authenticate($username, $password);

  if ($login == 1) {

  $_SESSION['login_user']=$username; // Initializing Session


  header("location: ./index.html?id=$username"); // Redirecting To Other Page

  //MYSQL insert query
  $date = date('Y-m-d H:i:s');
  $action = "Login";
  $sql = "INSERT INTO log (Username, Action, Time)
  VALUES ('$username', '$action','$date')";

  $query = mysql_query($sql, $conn);
  //////////

  $error = "True"; //Successfully authorised


  } else {
  $error = "Fail"; //Failed to authorised
  }

  $conn->close();

  }
  }

 ?>