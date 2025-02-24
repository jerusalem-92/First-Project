<%@ page import="java.sql.*" %>
<%@ page import="com.google.gson.JsonObject" %>

<%
    // Set response content type to JSON
    response.setContentType("application/json");

    // Database connection details
    String dbUrl = "jdbc:mysql://localhost:3307/mydb";  // Update this with your database details
    String dbUser = "root";
    String dbPassword = "My&onlymy2005&1817";

    // Get the QR code data (id) from the POST request
    String qrData = request.getParameter("qrData");

    JsonObject jsonResponse = new JsonObject();

    if (qrData == null || qrData.trim().isEmpty()) {
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", "QR data is missing.");
    } else {
        try (Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            // Query to check if employee exists by id
            String checkEmployeeQuery = "SELECT * FROM employees WHERE id = ?";
            try (PreparedStatement checkStmt = connection.prepareStatement(checkEmployeeQuery)) {
                checkStmt.setString(1, qrData);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    // Update attendance status for the employee with the given id
                    String updateQuery = "UPDATE employees SET attendance_status = 'Present', last_scanned = NOW() WHERE id = ?";
                    try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                        updateStmt.setString(1, qrData);
                        int rowsUpdated = updateStmt.executeUpdate();

                        if (rowsUpdated > 0) {
                            jsonResponse.addProperty("success", true);
                            jsonResponse.addProperty("message", "Attendance recorded successfully.");
                        } else {
                            jsonResponse.addProperty("success", false);
                            jsonResponse.addProperty("message", "Failed to update attendance.");
                        }
                    }
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Employee not found.");
                }
            }
        } catch (SQLException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Database error: " + e.getMessage());
        }
    }

    // Send the JSON response back to the client
    out.print(jsonResponse.toString());
    out.flush();
%>
