<?php
require 'connect.php';

// Sanitize user inputs to prevent SQL injection
$username = mysqli_real_escape_string($con, $_POST["username"]);
$phone = mysqli_real_escape_string($con, $_POST["phone"]);
$email = mysqli_real_escape_string($con, $_POST["email"]);
$password = md5(mysqli_real_escape_string($con, $_POST["password"]));

// Flag for success
$flag['success'] = 0;

// Proper query with 'INSERT INTO'
$query = "INSERT INTO users (id, username, phone, email, password, created_at) 
          VALUES ('', '$username', '$phone', '$email', '$password', now())";

// Execute the query
if (mysqli_query($con, $query)) {
    $flag['success'] = 1;
}

// Return the result as JSON
echo json_encode($flag);

// Close the database connection
mysqli_close($con);
