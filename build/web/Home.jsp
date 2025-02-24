<!DOCTYPE html>
<html>
<head>
    <title>Employee Attendance Tracking System</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background: url('attendance.jpg') no-repeat center center fixed;
            background-size: cover; /* Cover the entire page */
            margin: 0;
            padding: 0;
            color: white; /* Change text color to white for better contrast */
        }

        /* Header Styles */
        header {
            background-color: rgba(102, 102, 102, 0.7); /* Semi-transparent gray background */
            color: white;
            padding: 15px 0;
            position: relative;
            z-index: 1; /* Ensure header text is above the background */
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .header-left h1 {
            margin: 0;
            font-size: 24px;
        }

        /* Main Content */
        main {
            max-width: 800px;
            margin: 50px auto;
            text-align: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.8); /* Semi-transparent white background */
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        main h2 {
            color: #007bff;
        }

        main p {
            color: #333;
            line-height: 1.6;
        }

        /* Footer Styles */
        footer {
            background-color: rgba(102, 102, 102, 0.7); /* Semi-transparent gray background */
            color: #ffffff;
            text-align: center;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            bottom: 0;
        }

        footer a {
            color: #ffffff;
            text-decoration: none;
            margin: 0 10px;
            font-size: 14px;
        }

        footer a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
    <header>
        <div class="header-container">
            <div class="header-left">
                <h1>Employee Attendance Tracking System</h1>
            </div>
            <div class="header-right">
                <!-- Manager button that links to Manager.jsp -->
                <button onclick="location.href='Manager.jsp';">Manager</button>
            </div>         
        </div>
    </header>

    <main>
        <div class="main-content">
            <h2>Welcome to the Employee Attendance Tracking System</h2>
            <p>
                This system is designed to streamline employee attendance management by using QR codes.
                Employees are registered into the system, and attendance is recorded by scanning their unique QR codes.
                Managers can easily access attendance records for efficient workforce management.
            </p>
        </div>
    </main>

    <footer>
        <div class="footer-content">
            <a href="about.jsp">About Us</a> | <a href="contact.jsp">Contact Us</a>
        </div>
    </footer>
</body>
</html>
