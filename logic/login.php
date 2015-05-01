<?php

  include('./logic/ad.php'); // Includes Login Script
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

    $ad = new ActiveDirectory();
    $login = $ad->authenticate($username, $password);

  if ($login == 1) {

  $_SESSION['login_user']=$username; // Initializing Session
    //header("location: profile.php"); // Redirecting To Other Page
    header("location: /index.html"); // Redirecting To Other Page
  $error = "True";

  } else {
  $error = "Fail";
  }
  mysql_close($connection); // Closing Connection
  }
  }
 ?>