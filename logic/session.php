<?php
require_once('./data/config.php');

session_start();// Starting Session
// Storing Session
$user_check=$_SESSION['login_user'];
// SQL Query To Fetch Complete Information Of User
$ses_sql=mysql_query("select Username,Staffname from staff where username='$user_check'", $conn);
$row = mysql_fetch_assoc($ses_sql);
$login_session =$row['Username'];
$login_staffname =$row['Staffname'];
$_SESSION['login_user']= $username;

if(!isset($login_session)){
mysql_close($conn); // Closing Connection
header('Location: /index.php'); // Redirecting To Home Page
}
?>