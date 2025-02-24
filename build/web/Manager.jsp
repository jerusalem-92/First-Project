<%@ page import="java.sql.*" %>
<%
    String errorMessage = null;
    int maxAttempts = 3;
    int lockoutDuration = 30; // Lockout duration in seconds (30 seconds)
    Integer loginAttempts = (Integer) session.getAttribute("loginAttempts");
    Long lastFailedAttempt = (Long) session.getAttribute("lastFailedAttempt");
    
    if (loginAttempts == null) {
        loginAttempts = 0;
    }

    // Check if the user is locked out
    if (loginAttempts >= maxAttempts) {
        long currentTime = System.currentTimeMillis();
        if (lastFailedAttempt != null && (currentTime - lastFailedAttempt) < lockoutDuration * 1000) {
            long remainingTime = (lockoutDuration * 1000 - (currentTime - lastFailedAttempt)) / 1000;
            errorMessage = "Too many failed attempts. Please try again in " + remainingTime + " seconds.";
            session.setAttribute("remainingTime", remainingTime);
        } else {
            // Reset failed attempts after lockout period has passed
            session.setAttribute("loginAttempts", 0);
            session.setAttribute("lastFailedAttempt", null);
            loginAttempts = 0; // Reset login attempts
            session.setAttribute("remainingTime", 0); // Reset remaining time
        }
    }

    // Process login if the user is not locked out
    if (loginAttempts < maxAttempts) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null && password != null) {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/mydb", "root", "My&onlymy2005&1817");

                String query = "SELECT name FROM managers WHERE email = ? AND password = ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, email);
                ps.setString(2, password);

                rs = ps.executeQuery();

                if (rs.next()) {
                    String managerName = rs.getString("name");
                    session.setAttribute("managerName", managerName);
                    session.setAttribute("loginAttempts", 0); // Reset login attempts on successful login
                    session.setAttribute("remainingTime", 0); // Reset remaining time
                    response.sendRedirect("ManagerDashboard.jsp");
                } else {
                    loginAttempts++;
                    session.setAttribute("loginAttempts", loginAttempts);
                    session.setAttribute("lastFailedAttempt", System.currentTimeMillis());
                    errorMessage = "Invalid email or password! Attempt #" + loginAttempts;
                }
            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "Error occurred during login. Please try again.";
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Here</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: url('download.jpg') no-repeat center center/cover;
        }

        .login-container {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 20px 30px;
            border-radius: 10px;
            width: 300px;
            color: white;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.6);
        }

        .login-container h2 {
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

        .error-message {
            text-align: center;
            color: #ff4d4d;
            font-size: 14px;
        }

        .social-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }

        .social-buttons button {
            width: 48%;
            padding: 10px;
            font-size: 14px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            background-color: #444;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            transition: background-color 0.3s ease;
        }

        .social-buttons button:hover {
            background-color: #333;
        }

        .social-buttons button.google {
            background-color: #db4437;
        }

        .social-buttons button.google:hover {
            background-color: #a93728;
        }

        .social-buttons button.facebook {
            background-color: #4267B2;
        }

        .social-buttons button.facebook:hover {
            background-color: #314d86;
        }
        .action-links {
            text-align: center;
            margin-top: 10px;
        }

        .action-links a {
            color: #ffffff;
            text-decoration: none;
        }

        .action-links a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        // Countdown timer logic
        let remainingTime = <%= session.getAttribute("remainingTime") != null ? session.getAttribute("remainingTime") : 0 %>;
        if (remainingTime > 0) {
            function updateCountdown() {
                if (remainingTime > 0) {
                    document.getElementById("countdown").innerText = "Please wait: " + remainingTime + " seconds.";
                    remainingTime--;
                    setTimeout(updateCountdown, 1000);
                } else {
                    document.getElementById("countdown").innerText = "You can now try logging in again.";
                }
            }
            updateCountdown();
        }
    </script>
</head>
<body>
    <div class="login-container">
        <h2>Login Here</h2>
        <form method="POST">
            <div class="input-group">
                <label for="email">Username</label>
                <input type="text" id="email" name="email" placeholder="Email or Phone" required>
            </div>
            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Password" required>
            </div>
            <div class="action-links">
                <a href="AdminSignUp.jsp">Signup</a>
            </div>
            <div class="input-group">
                <input type="submit" value="Log In">
            </div>
        </form>
        
        <div class="error-message">
            <%= errorMessage != null ? errorMessage : "" %>
        </div>

        <div id="countdown" class="error-message"></div>
    </div>
</body>
</html>
