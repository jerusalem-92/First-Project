<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id"); // Employee ID to delete

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbURL = "jdbc:mysql://localhost:3307/mydb";
        String dbUser = "root";
        String dbPassword = "My&onlymy2005&1817";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Delete employee by ID
        String sql = "DELETE FROM employees WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(id));

        int rows = stmt.executeUpdate();
        if (rows > 0) {
            out.println("<script>alert('Employee deleted successfully!');</script>");
        } else {
            out.println("<script>alert('Delete failed! Employee not found.');</script>");
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
