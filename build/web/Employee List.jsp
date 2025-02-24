<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee List with Attendance</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            padding: 20px;
        }
        h1 {
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .action-buttons a {
            text-decoration: none;
            color: white;
            padding: 5px 10px;
            margin: 0 5px;
            border-radius: 3px;
        }
        .edit-btn {
            background-color: #28a745;
        }
        .delete-btn {
            background-color: #dc3545;
        }
        .edit-btn:hover {
            background-color: #218838;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <h1>Employee List with Attendance</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Mobile</th>
                <th>Email</th>
                <th>Gender</th>
                <th>Date of Birth</th>
                <th>Address</th>
                <th>Department</th>
                <th>Position</th>
                <th>Employment Type</th>
                <th>Attendance Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    // Database connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String dbURL = "jdbc:mysql://localhost:3307/mydb";
                    String dbUser = "root";
                    String dbPassword = "My&onlymy2005&1817";
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Query to fetch employee and attendance data
                    String sql = "SELECT e.id, e.name, e.mobile_prefix, e.mobile_number, e.email, e.gender, e.dob, e.address, " +
                                 "e.department, e.position, e.employment_type, " +
                                 "CASE " +
                                 "  WHEN e.attendance_status IS NULL THEN 'Absent' " +
                                 "  ELSE e.attendance_status " +
                                 "END AS attendance_status " +
                                 "FROM employees e";
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(sql);

                    // Loop through result set and display data
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String mobile = rs.getString("mobile_prefix") + rs.getString("mobile_number");
                        String email = rs.getString("email");
                        String gender = rs.getString("gender");
                        String dob = rs.getString("dob");
                        String address = rs.getString("address");
                        String department = rs.getString("department");
                        String position = rs.getString("position");
                        String employmentType = rs.getString("employment_type");
                        String attendanceStatus = rs.getString("attendance_status");
            %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= name %></td>
                            <td><%= mobile %></td>
                            <td><%= email %></td>
                            <td><%= gender %></td>
                            <td><%= dob %></td>
                            <td><%= address %></td>
                            <td><%= department %></td>
                            <td><%= position %></td>
                            <td><%= employmentType %></td>
                            <td><%= attendanceStatus %></td>
                            <td class="action-buttons">
                              <!-- Edit button -->
                              <a href="editEmployee.jsp?id=<%= id %>" class="edit-btn">Edit</a>
                             <!-- Delete button -->
                             <a href="deleteEmployee.jsp?id=<%= id %>" class="delete-btn" 
                           onclick="return confirm('Are you sure you want to delete this employee?');">
                            Delete
                             </a>
                              <!-- Detail button -->
                             <a href="employeeDetail.jsp?id=<%= id %>" class="detail-btn" 
                          style="background-color: #17a2b8; color: white; padding: 5px 10px; border-radius: 3px; text-decoration: none;">
                            Detail
                              </a>
                            </td>

                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='12' style='color: red; text-align: center;'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
</body>
</html>