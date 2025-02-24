<%@ page import="java.sql.*" %>

<%
    String successMessage = null;
    String errorMessage = null;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String address = request.getParameter("address");

        if (name != null && email != null && password != null && address != null) {
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/mydb", "root", "My&onlymy2005&1817");

                String query = "INSERT INTO managers (name, email, password, address) VALUES (?, ?, ?, ?)";
                ps = conn.prepareStatement(query);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, address);

                int rowsInserted = ps.executeUpdate();
                if (rowsInserted > 0) {
                    successMessage = "Account created successfully. You can now <a href='Manager.jsp'>log in</a>.";
                }
            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "Error occurred while creating the account. Please try again.";
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            errorMessage = "All fields are required!";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Admin Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: url('signup-bg.jpg') no-repeat center center/cover;
            background: url('download.jpg') no-repeat center center/cover;
        }

        .signup-container {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 20px 30px;
            border-radius: 10px;
            width: 300px;
            color: white;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.6);
        }

        .signup-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 15px;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .input-group input {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: none;
            background-color: #282828;
            color: white;
            font-size: 14px;
        }

        .input-group input::placeholder {
            color: #ccc;
        }

        .input-group input[type="submit"] {
            background-color: #007bff;
            color: white;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .input-group input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .message {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .message a {
            color: #007bff;
            text-decoration: none;
        }

        .message a:hover {
            color: #0056b3;
        }

        .success-message {
            color: #4CAF50;
        }

        .error-message {
            color: #FF4D4D;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2>Create Admin Account</h2>
        <form method="POST">
            <div class="input-group">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" placeholder="Enter Full Name" required>
            </div>
            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter Email" required>
            </div>
            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter Password" required>
            </div>
            <div class="input-group">
                <label for="password">comfirm Password</label>
                <input type="password" id="password" name="password" placeholder="Enter Password" required>
            </div>
            <div class="input-group">
                 <label for="address">Address</label>
                 <input type="text" id="address" name="address" placeholder="Enter Address" required>
               </div>

            <div class="input-group">
                <input type="submit" value="Create Account">
            </div>
        </form>

        <div class="message">
            <% if (successMessage != null) { %>
                <div class="success-message"><%= successMessage %></div>
            <% } else if (errorMessage != null) { %>
                <div class="error-message"><%= errorMessage %></div>
            <% } %>
        </div>
    </div>
</body>
</html>
