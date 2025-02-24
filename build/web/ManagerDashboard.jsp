<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%
    // Retrieve the manager's name from the session
    String managerName = (String) session.getAttribute("managerName");

    if (managerName == null) {
        // If the manager's name is not available (meaning the user is not logged in), redirect to login page
        response.sendRedirect("Manager.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard</title>
    <!-- Internal CSS -->
    <style>
        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* Body */
        body {
            display: flex;
            background-color: #f4f4f9;
        }

        /* Sidebar */
        .sidebar {
            width: 220px;
            background-color: #23282d;
            color: #fff;
            padding: 20px;
            height: 100vh;
        }

        .sidebar h2 {
            margin-bottom: 20px;
            font-size: 1.2rem;
        }

        .sidebar ul {
            list-style: none;
        }

        .sidebar ul li {
            margin: 15px 0;
        }

        .sidebar ul li a {
            color: #fff;
            text-decoration: none;
            display: block;
            padding: 10px;
            border-radius: 5px;
            transition: background 0.3s ease;
        }

        .sidebar ul li a:hover {
            background-color: #0073aa;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 20px;
        }

        .header {
            background-color: #0073aa;
            color: #fff;
            padding: 15px;
            text-align: center;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        /* Reports Section */
        .reports h2 {
            margin-bottom: 15px;
            color: #333;
            font-size: 1.5rem;
        }

        .report-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .card {
            background-color: #fff;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .card h3 {
            color: #0073aa;
            margin-bottom: 10px;
        }

        .card p {
            color: #555;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }

        .card button {
            background-color: #0073aa;
            color: #fff;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .card button:hover {
            background-color: #005f8d;
        }

        .card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <h2>Dashboard</h2>
        <ul>
            <li><a href="#">Register Form</a></li>
            <li><a href="#">QR Code Generator</a></li>
            <li><a href="#">QR Code Scanner</a></li>
            <li><a href="#">Employee List</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <header class="header">
            <h1>Welcome, <%= managerName != null ? managerName : "Manager" %></h1>
        </header>

        <!-- Reports Section -->
        <section class="reports">
            <h2>Dashboard</h2>
            <div class="report-cards">
                <!-- Card 1 -->
                <div class="card">
                    <h3>Register Form</h3>
                    <p>Allows registration of employees into the system.</p>
                    <a href="Registration.jsp">
                    <button>View</button>
                    </a>
                </div>
                <!-- Card 2 -->
                <div class="card">
                    <h3>QR Code Generator</h3>
                    <p>Generates QR codes for employee attendance tracking.</p>
                    <button>View</button>
                </div>
                <!-- Card 3 -->
                <div class="card">
                    <h3>QR Code Scanner</h3>
                    <p>Scans QR codes to log employee attendance.</p>
                    <a href="QRCodeScanner.jsp">
                    <button>View</button>
                    </a>
                </div>
                <!-- Card 4 -->
                <div class="card">
                    <h3>Employee List</h3>
                    <p>View and manage all registered employees.</p>
                    <a href="Employee List.jsp">
                    <button>View</button>
                    </a>
                </div>
            </div>
        </section>
    </div>
</body>
</html>
