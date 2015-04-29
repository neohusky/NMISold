PHP Login Form with Sessions

user-5
Fugo Of FormGet
Session variables are used to store individual client’s information on web server for later use,  as web server does not know which client’s request to be respond because, HTTP address does not maintained state.

This tutorial enables you to create sessions in PHP via Login form and web server respond according to his/her request.

To Start a PHP Session:


<?php
session_start();
// Do Something
?>


To Store values in PHP Session variable:


<?php
session_start();
// Store Session Data
$_SESSION['login_user']= $username;  // Initializing Session with value of PHP Variable


To Read values of PHP Session variable:


<?php
session_start();
// Store Session Data
$_SESSION['login_user']= $username;  // Initializing Session with value of PHP Variable
echo $_SESSION['login_user'];


To Unset or Destroy a PHP Session:


<?php
session_destroy(); // Is Used To Destroy All Sessions
//Or
if(isset($_SESSION['id']))
unset($_SESSION['id']);  //Is Used To Destroy Specified Session
In our example, we have a login form when user fills up required fields and press login button, a session will be created on server which assigns him a unique ID and stores user information for later use.