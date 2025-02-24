<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Detail</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            padding: 20px;
        }
        h1 {
            text-align: center;
        }
        .container {
            text-align: center;
            margin-top: 50px;
        }
        .image-container {
            margin-top: 20px;
        }
        img {
            max-width: 300px;
            max-height: 300px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>Employee Detail</h1>
    <div class="container">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int employeeId = Integer.parseInt(request.getParameter("id"));

            try {
                // Database connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                String dbURL = "jdbc:mysql://localhost:3307/mydb";
                String dbUser = "root";
                String dbPassword = "My&onlymy2005&1817";
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Fetch employee image
                String sql = "SELECT name, image_path FROM employee1 WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, employeeId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String name = rs.getString("name");
                    String imagePath = rs.getString("image_path");

                    // Display employee name and image
                    out.println("<h2>" + name + "</h2>");
                    out.println("<div class='image-container'>");
                    if (imagePath != null && !imagePath.isEmpty()) {
                        out.println("<img src='" + imagePath + "' alt='Employee Image'>");
                    } else {
                        out.println("<p>No image available.</p>");
                    }
                    out.println("</div>");
                } else {
                    out.println("<p>Employee not found.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</body>
</html>
