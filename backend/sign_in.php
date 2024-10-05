<?php
require "connect.php";

$flag['success'] = 0;
$phone = mysqli_real_escape_string($con, $_GET['phone']);
$password = $_GET['password'];
$encrypted_password = md5($password);

$flag['userdata'] = array();

// I am using a prepared statement to avoid SQL injection
$query = "SELECT * FROM users WHERE user_phone = ? AND user_password = ? LIMIT 1";
$stmt = mysqli_prepare($con, $query);

if ($stmt) {
    // Bind parameters
    mysqli_stmt_bind_param($stmt, "ss", $phone, $encrypted_password);

    // Execute the query
    mysqli_stmt_execute($stmt);

    // Fetch the result
    $result = mysqli_stmt_get_result($stmt);

    if (mysqli_num_rows($result) > 0) {
        $flag['success'] = 1;
        $flag['userdata'] = mysqli_fetch_assoc($result);  // Fetch user data
    }

    // Close the statement
    mysqli_stmt_close($stmt);
}

// Return the JSON response
echo json_encode($flag);

// Close the database connection
mysqli_close($con);
