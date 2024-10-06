<?php
require 'connect.php';

// Sanitize user inputs to prevent SQL injection
$user_id = mysqli_real_escape_string($con, $_POST["user_id"]);
$task = mysqli_real_escape_string($con, $_POST["task"]);
$category = mysqli_real_escape_string($con, $_POST["category"]);
$due_date = mysqli_real_escape_string($con, $_POST["due_date"]);

// Flag for success
$flag['success'] = 0;

$query = "INSERT INTO tasks (id, task, category, due_date, created_at, user_id) 
          VALUES ('', '$task', '$category', '$due_date', now(), $user_id)";

// Execute the query
if (mysqli_query($con, $query)) {
    $flag['success'] = 1;
}

// Return the result as JSON
echo json_encode($flag);

// Close the database connection
mysqli_close($con);
