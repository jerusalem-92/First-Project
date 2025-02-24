<%@ page import="java.sql.*" %>
<%
    // Get data from the form submission
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String mobile = request.getParameter("mobile");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");
    String dob = request.getParameter("dob");
    String address = request.getParameter("address");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbURL = "jdbc:mysql://localhost:3307/mydb";
        String dbUser = "root";
        String dbPassword = "My&onlymy2005&1817";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Update employee details in the database
        String sql = "UPDATE employees SET name = ?, mobile = ?, email = ?, gender = ?, dob = ?, address = ? WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, name);
        stmt.setString(2, mobile);
        stmt.setString(3, email);
        stmt.setString(4, gender);
        stmt.setString(5, dob);
        stmt.setString(6, address);
        stmt.setInt(7, Integer.parseInt(id));

        int rows = stmt.executeUpdate();
        if (rows > 0) {
            out.println("<script>alert('Employee updated successfully!');</script>");
        } else {
            out.println("<script>alert('Update failed! Employee not found.');</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }

    // Redirect back to employee list
    response.sendRedirect("Employee List.jsp");
%>
