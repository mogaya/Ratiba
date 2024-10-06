<?php
require 'connect.php';

// Sanitizing input to prevent SQL injection
$id = mysqli_real_escape_string($con, $_GET["id"]);

$flag = ['success' => 0];

// Using a prepared statement to prevent SQL injection
$query = "DELETE FROM tasks WHERE id = ?";
$stmt = mysqli_prepare($con, $query);
mysqli_stmt_bind_param($stmt, 'i', $id);

if (mysqli_stmt_execute($stmt)) {
    $flag['success'] = 1;
} else {
    // Handling errors
    $flag['error'] = 'Failed to delete task: ' . mysqli_error($con);
}

// Return the result as JSON
echo json_encode($flag);

// Close the statement and database connection
mysqli_stmt_close($stmt);
mysqli_close($con);
?>