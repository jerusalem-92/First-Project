<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String name = "", mobile = "", email = "", gender = "", dob = "", address = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbURL = "jdbc:mysql://localhost:3307/mydb";
        String dbUser = "root";
        String dbPassword = "My&onlymy2005&1817";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "SELECT * FROM employees WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(id));
        rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            mobile = rs.getString("mobile");
            email = rs.getString("email");
            gender = rs.getString("gender");
            dob = rs.getString("dob");
            address = rs.getString("address");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Employee</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            padding: 20px;
        }
        form {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        label {
            font-weight: bold;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <form method="post" action="updateEmployee.jsp">
        <h2>Edit Employee</h2>
        <input type="hidden" name="id" value="<%= id %>">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= name %>" required>

        <label for="mobile">Mobile:</label>
        <input type="text" id="mobile" name="mobile" value="<%= mobile %>" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= email %>" required>

        <label for="gender">Gender:</label>
        <select id="gender" name="gender">
            <option value="Male" <%= gender.equals("Male") ? "selected" : "" %>>Male</option>
            <option value="Female" <%= gender.equals("Female") ? "selected" : "" %>>Female</option>
        </select>

        <label for="dob">Date of Birth:</label>
        <input type="date" id="dob" name="dob" value="<%= dob != null ? dob : "" %>" required>


        <label for="address">Address:</label>
        <textarea id="address" name="address"><%= address %></textarea>

        <button type="submit">Update</button>
    </form>
</body>
</html>
