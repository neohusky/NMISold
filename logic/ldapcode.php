/*
<?php
include('./logic/ad.php');


session_start(); // Starting Session
$error=''; // Variable To Store Error Message
if (isset($_POST['submit'])) {
if (empty($_POST['username']) || empty($_POST['password'])) {
$error = "Username or Password is invalid";
}
else
{
// Define $username and $password
$username=$_POST['username'];
$password=$_POST['password'];

$ad = new ActiveDirectory();

$login = $ad->authenticate('username', 'password');
if ($login) {
     // login success, yay!
     $_SESSION['login_user']=$username; // Initializing Session
     //header("location: profile.php"); // Redirecting To Other Page
     header("location: /index.html"); // Redirecting To Other Page
} else {
     // login failed, boo :(
     $error = "Username or Password is invalid";
}

?>*/