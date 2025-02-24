<%@ page import="java.io.File"%>
<%@ page import="java.sql.*, com.google.zxing.BarcodeFormat, com.google.zxing.WriterException, com.google.zxing.qrcode.QRCodeWriter, com.google.zxing.client.j2se.MatrixToImageWriter, com.google.zxing.common.BitMatrix"%>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Employee Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #0077b6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #023047;
            color: white;
            border-radius: 10px;
            width: 100%;
            max-width: 1200px;
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
        }

        .left-section {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .left-section h2 {
            margin-bottom: 10px;
        }

        .left-section p {
            font-size: 1rem;
        }

        .right-section {
            flex: 2;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .right-section h1 {
            text-align: center;
            font-size: 2rem;
            margin-bottom: 10px;
            color: #00b4d8;
        }

        form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            max-width: 600px;
            width: 100%;
            height: 600px;
            overflow-y: auto;
        }

        form div {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 5px;
            font-weight: bold;
        }

        input, select, textarea {
            padding: 10px;
            border: none;
            border-radius: 5px;
        }

        textarea {
            resize: none;
        }

        .full-width {
            grid-column: span 2;
        }

        button {
            padding: 10px;
            background-color: #00b4d8;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1rem;
            grid-column: span 2;
        }

        button:hover {
            background-color: #0096c7;
        }

        .qr-code {
            text-align: center;
            margin-top: 20px;
        }

        .qr-code img {
            width: 200px;
            height: 200px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="left-section">
            <h1>Let’s Make It Happen Together!</h1>
            <p>Create your employee account and join us now.</p>
        </div>
        <div class="right-section">
            <h1>Create An Account</h1>

            <!-- Handle Form Submission -->
            <% 
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    String employeeId = request.getParameter("employeeId");
                    String name = request.getParameter("name");
                    String mobilePrefix = request.getParameter("mobilePrefix");
                    String mobileNumber = request.getParameter("mobileNumber");
                    String email = request.getParameter("email");
                    String gender = request.getParameter("gender");
                    String dob = request.getParameter("dob");
                    String address = request.getParameter("address");
                    String department = request.getParameter("department");
                    String position = request.getParameter("position");
                    String employmentType = request.getParameter("employmentType");

                    // Validation: Name length
                    if (name.length() < 10) {
                        out.println("<p style='color: red;'>Name must be at least 10 characters long.</p>");
                    } else if (dob.compareTo("2002-01-01") > 0) {
                        out.println("<p style='color: red;'>Employee must be born before 2002.</p>");
                    } else {
                        // Database connection setup
                        String url = "jdbc:mysql://localhost:3307/mydb";
                        String username = "root";
                        String password = "My&onlymy2005&1817";
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(url, username, password);
                            
                            // Check if employee ID already exists
                            String checkEmployeeIdQuery = "SELECT * FROM employees WHERE employee_id = ?";
                            stmt = conn.prepareStatement(checkEmployeeIdQuery);
                            stmt.setString(1, employeeId);
                            rs = stmt.executeQuery();

                            if (rs.next()) {
                                out.println("<p style='color: red;'>An employee with this ID already exists. Please use a different ID.</p>");
                            } else {
                                // Check if email already exists
                                String checkEmailQuery = "SELECT * FROM employees WHERE email = ?";
                                stmt = conn.prepareStatement(checkEmailQuery);
                                stmt.setString(1, email);
                                rs = stmt.executeQuery();

                                if (rs.next()) {
                                    out.println("<p style='color: red;'>An employee with this email already exists. Please use a different email.</p>");
                                } else {
                                    // Proceed with insertion if employee ID and email don't exist
                                    String query = "INSERT INTO employees (employee_id, name, mobile_prefix, mobile_number, email, gender, dob, address, department, position, employment_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                    stmt = conn.prepareStatement(query);
                                    stmt.setString(1, employeeId);
                                    stmt.setString(2, name);
                                    stmt.setString(3, mobilePrefix);
                                    stmt.setString(4, mobileNumber);
                                    stmt.setString(5, email);
                                    stmt.setString(6, gender);
                                    stmt.setString(7, dob);
                                    stmt.setString(8, address);
                                    stmt.setString(9, department);
                                    stmt.setString(10, position);
                                    stmt.setString(11, employmentType);
                                    int rowsInserted = stmt.executeUpdate();

                                    if (rowsInserted > 0) {
                                        // Set the directory path for QR Code
                                        String qrCodeDirPath = "C:/Users/dell/Documents/NetBeansProjects/P2PWebApp/qrcodes/";
                                        File qrCodeDir = new File(qrCodeDirPath);
                                        if (!qrCodeDir.exists()) {
                                            qrCodeDir.mkdirs();
                                        }

                                        // QR Code generation
                                        String qrContent = "Employee ID: " + employeeId + "\nName: " + name + "\nMobile: " + mobilePrefix + mobileNumber + "\nEmail: " + email;
                                        QRCodeWriter qrCodeWriter = new QRCodeWriter();
                                        BitMatrix bitMatrix = qrCodeWriter.encode(qrContent, BarcodeFormat.QR_CODE, 200, 200);

                                        // Save QR Code with employee's ID as the filename
                                        String fileName = employeeId + "_QRCode.png";
                                        String outputPath = qrCodeDirPath + fileName;
                                        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", java.nio.file.Paths.get(outputPath));

                                        // Display the QR Code image
                                        out.println("<p>Employee registered successfully! QR code saved as: " + fileName + "</p>");
                                        request.setAttribute("fileName", fileName);

                                        // Redirect to ManagerDashboard.jsp
                                        response.sendRedirect("ManagerDashboard.jsp");
                                    }
                                }
                            }
                        } catch (SQLException | ClassNotFoundException | WriterException | IOException e) {
                            e.printStackTrace();
                            out.println("<p>Error: " + e.getMessage() + "</p>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    }
                }
            %>

            <!-- Registration Form -->
            <form method="post" action="Registration.jsp">
                <div>
                    <label for="employeeId">Employee ID:</label>
                    <input type="text" id="employeeId" name="employeeId" required>
                </div>
                <div>
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div>
                    <label for="mobile">Mobile Number:</label>
                    <div style="display: flex; gap: 10px;">
                        <select id="mobilePrefix" name="mobilePrefix">
                            <option value="+2519">+2519</option>
                            <option value="+2517">+2517</option>
                        </select>
                        <input type="text" id="mobileNumber" name="mobileNumber" maxlength="8" placeholder="XXXXXXXX" required style="flex: 1;">
                    </div>
                </div>
                <div>
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div>
                    <label for="gender">Gender:</label>
                    <select id="gender" name="gender">
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div>
                    <label for="dob">Date of Birth:</label>
                    <input type="date" id="dob" name="dob" required>
                </div>
                <div>
                    <label for="address">Address:</label>
                    <textarea id="address" name="address" rows="3" required></textarea>
                </div>
                <div>
                    <label for="department">Department:</label>
                    <select id="department" name="department">
                        <option value="IT">IT</option>
                        <option value="Finance">Finance</option>
                        <option value="Human Resources">Human Resources</option>
                        <option value="Academic">Academic</option>
                        <option value="Administrative">Administrative</option>
                    </select>
                </div>
                <div>
                    <label for="position">Position:</label>
                    <input type="text" id="position" name="position" placeholder="e.g., Lecturer, Accountant, etc." required>
                </div>
                <div>
                    <label for="employmentType">Employment Type:</label>
                    <select id="employmentType" name="employmentType">
                        <option value="Permanent">Permanent</option>
                        <option value="Contract">Contract</option>
                    </select>
                </div>
                <button type="submit">Register</button>
            </form>

            <!-- Display QR Code Image -->
            <div class="qr-code">
                <% 
                    if (request.getAttribute("fileName") != null) {
                        String fileName = (String) request.getAttribute("fileName");
                        out.println("<img src='file:///C:/Users/dell/Documents/NetBeansProjects/P2PWebApp/qrcodes/" + fileName + "' alt='QR Code' />");
                        out.println("<br><a href='file:///C:/Users/dell/Documents/NetBeansProjects/P2PWebApp/qrcodes/" + fileName + "' download>Click here to download the QR code</a>");
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
