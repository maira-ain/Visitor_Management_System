<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.SQLIntegrityConstraintViolationException"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // This scriptlet is placed at the very top to ensure redirection works before any HTML is sent.
    // It will execute on every page load, so we need to guard the processing logic.

    // --- Database Connection Details ---
    // IMPORTANT: Ensure these match your MySQL database configuration.
    // The 'root' user password often needs to be set or reset in MySQL.
    // For production, it's highly recommended to create a dedicated user with specific privileges
    // instead of using 'root'.
    String jdbcURL = "jdbc:mysql://localhost:3306/my_database2?useSSL=false&serverTimezone=UTC";
    String jdbcUsername = "root"; // Your database username (e.g., "root" or a custom user like "mywebappuser")
    // CORRECTION: Setting jdbcPassword to an empty string as per your database configuration.
    String jdbcPassword = ""; // Your database password (ENSURE THIS IS CORRECT for your MySQL root user or custom user)

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet rs = null;
    String message = "";
    String messageType = "";
    // "success" or "error"

    // Only process form submissions (POST requests)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Load JDBC driver
            // Ensure you have the MySQL Connector/J JAR file in your project's lib/ folder
            // or included via Maven (as discussed in pom.xml update).
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            // --- Handle Visitor Registration ---
            if (request.getParameter("submitVisitor") != null) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String icPassportNo = request.getParameter("icPassportNo");
                String phoneNumber = request.getParameter("phoneNumber");
                String email = request.getParameter("email");
                // Hash the password for Visitor (consistent with Admin)
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                md.update(password.getBytes("UTF-8"));
                byte[] digest = md.digest();
                String hashedPassword = Base64.getEncoder().encodeToString(digest);

                String sql = "INSERT INTO Visitor (username, password, full_name, ic_no_passport, phone_no, email, role) VALUES (?, ?, ?, ?, ?, ?, 'visitor')";
                statement = connection.prepareStatement(sql);
                statement.setString(1, username);
                statement.setString(2, hashedPassword); // Use hashed password
                statement.setString(3, fullName);
                statement.setString(4, icPassportNo);
                statement.setString(5, phoneNumber);
                statement.setString(6, email);

                int rowsInserted = statement.executeUpdate();
                if (rowsInserted > 0) {
                    message = "Visitor registration successful!";
                    messageType = "success";
                    response.sendRedirect("success.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return; // Stop further processing and rendering of this JSP
                } else {
                    message = "Visitor registration failed.";
                    messageType = "error";
                    response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return; // Stop further processing and rendering of this JSP
                }
            }
            // --- Handle Admin Registration ---
            else if (request.getParameter("submitAdmin") != null) {
                String staffId = request.getParameter("staffId");
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                // Hash the password
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                md.update(password.getBytes("UTF-8"));
                byte[] digest = md.digest();
                String hashedPassword = Base64.getEncoder().encodeToString(digest);

                String sql = "INSERT INTO Admin (staff_id, username, email, password, full_name, role) VALUES (?, ?, ?, ?, ?, 'admin')";
                statement = connection.prepareStatement(sql);
                statement.setString(1, staffId);
                statement.setString(2, username);
                statement.setString(3, email);
                statement.setString(4, hashedPassword); // Use hashed password
                statement.setString(5, (fullName != null && !fullName.isEmpty()) ? fullName : username);
                int rowsAffected = statement.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Admin account registered successfully! You can now login.";
                    messageType = "success";
                    response.sendRedirect("success.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return;
                } else {
                    message = "Admin registration failed. Please try again.";
                    messageType = "error";
                    response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return;
                }
            }
            // --- Handle Login ---
            else if (request.getParameter("submitLogin") != null) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                MessageDigest md = MessageDigest.getInstance("SHA-256");
                md.update(password.getBytes("UTF-8"));
                byte[] digest = md.digest();
                String hashedPassword = Base64.getEncoder().encodeToString(digest);
                // Try to log in as Admin
                String adminSql = "SELECT staff_id, username FROM admin WHERE username = ? AND password = ?";
                statement = connection.prepareStatement(adminSql);
                statement.setString(1, username);
                statement.setString(2, hashedPassword);
                rs = statement.executeQuery();
                if (rs.next()) {
                    session.setAttribute("user_id", rs.getString("staff_id"));
                    session.setAttribute("username", username);
                    session.setAttribute("role", "admin");
                    response.sendRedirect("admin_dashboard.jsp"); // Redirect to admin dashboard
                    return;
                }

                // Close previous result set and statement before reusing
                if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); } }
                if (statement != null) { try { statement.close(); } catch (SQLException e) { e.printStackTrace(); } }

                // If not an admin, try to log in as Visitor
                String visitorSql = "SELECT visitor_id, username FROM visitor WHERE username = ? AND password = ?";
                statement = connection.prepareStatement(visitorSql);
                statement.setString(1, username);
                statement.setString(2, hashedPassword);
                rs = statement.executeQuery();
                if (rs.next()) {
                    session.setAttribute("user_id", rs.getInt("visitor_id"));
                    session.setAttribute("username", username);
                    session.setAttribute("role", "visitor");
                    response.sendRedirect("visitor_form.jsp"); // Redirect to visitor form
                    return;
                } else {
                    message = "Invalid username or password.";
                    messageType = "error";
                    response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return;
                }
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // Handle duplicate entry errors specifically
            if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("staff_id")) {
                message = "Registration failed: Staff ID already exists. Please use a different Staff ID.";
            } else if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("username")) {
                message = "Registration failed: Username already exists. Please choose a different username.";
            } else if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("email")) {
                message = "Registration failed: Email already registered. Please use a different email.";
            } else {
                message = "Database error (Integrity Constraint): " + e.getMessage();
            }
            messageType = "error";
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        } catch (ClassNotFoundException e) {
            message = "JDBC Driver not found: " + e.getMessage() + ". Please ensure MySQL Connector/J is correctly added to your project dependencies and deployed.";
            messageType = "error";
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        } catch (SQLException e) {
            // General SQL error for registration or login
            message = "Database error: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        } catch (Exception e) {
            message = "An unexpected error occurred: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        } finally {
            // Close resources in finally block to ensure they are always closed
            try {
                if (rs != null) rs.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    // If not a POST request for submission, or if not processing any form,
    // the JSP continues to render the HTML below.
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cybervengers - Visitor Management</title>
    <%-- REMINDER: FIX THIS PATH TO YOUR ACTUAL reg.css LOCATION --%>
    <link rel="stylesheet" href="css/reg.css" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
        /* Global styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Montserrat', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url(usim.jpg) no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center; /* Center content vertically */
            align-items: center; /* Center content horizontally */
        }

        .auth-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            width: 100%; /* Ensure it takes full width */
        }

        /* Navbar styles */
        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: rgba(28, 9, 48, 0.9);
            padding: 10px 20px;
            color: white;
            width: 100%;
            position: fixed; /* Fixed navbar */
            top: 0;
            left: 0;
            z-index: 1000; /* Ensure it's above other content */
        }

        .navbar .logo img {
            height: 40px;
            object-fit: contain;
        }

        .navbar nav a {
            margin: 0 10px;
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        /* Typography styles */
        .form-container h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 2em;
            margin-bottom: 20px;
            color: #333;
        }

        h2.title {
            text-align: center;
            margin: 20px 0 5px 0; /* Changed margin-bottom to 5px */
            font-size: 3.5em; /* Saiz lebih besar */
            font-family: 'Playfair Display', serif; /* Fon berangkai */
            color: white;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.8); /* Shadow yang lebih jelas */
            letter-spacing: 2px; /* Jarak huruf */
        }

        /* Form styles */
        form {
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0 50px;
            height: 100%;
            text-align: center;
            width: 100%;
        }

        input {
            background-color: #eee;
            border: none;
            padding: 12px 15px;
            margin: 8px 0;
            width: 100%;
            border-radius: 5px; /* Added border-radius for inputs */
        }

        p {
            font-size: 1em;
            font-weight: 100;
            line-height: 1.5;
            letter-spacing: 0.5px;
            margin: 20px 0 30px;
            color: #fff;
        }

        button {
            border-radius: 20px;
            border: 1px solid rgb(153, 90, 255);
            background-color: #b54bf3;
            color: #ffffff;
            font-size: 1em;
            font-weight: bold;
            padding: 12px 45px;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: transform 80ms ease-in, background-color 0.3s ease; /* Added transition for background */
            cursor: pointer;
            margin-top: 10px; /* Added margin-top for spacing */
        }

        button:hover {
            background-color: #a03fb0; /* Darker shade on hover */
        }

        button:active {
            transform: scale(0.95);
        }

        button:focus {
            outline: none;
        }

        button.ghost {
            background-color: transparent;
            border-color: #ffffff;
        }

        /* Main container styles */
        .container {
            background-color: #fefeff;
            border-radius: 10px;
            box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25),
                        0 10px 10px rgba(0, 0, 0, 0.22);
            position: relative;
            overflow: hidden;
            width: 850px;
            max-width: 95%;
            min-height: 650px;
            display: flex;
            align-items: center;
            justify-content: center;
            /* CORRECTION: Memastikan kontena tetap berada di bawah tajuk dengan jarak yang sesuai */
            margin-top: 30px; /* Kept at 60px to maintain consistent gap after title */
            margin-bottom: 20px;
        }

        /* Form panels styles */
        .form-container {
            position: absolute;
            top: 0;
            height: 100%;
            width: 50%;
            transition: all 0.6s ease-in-out;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0 50px;
        }

        /* Hide all form containers by default, except the active one */
        .sign-up-admin-container,
        .sign-up-visitor-container,
        .sign-in-container {
            left: 0;
            z-index: 1;
            opacity: 0;
        }

        /* Initial state: show sign-in form by default */
        .sign-in-container {
            opacity: 1;
            z-index: 5;
        }

        /* Show admin sign-up form */
        .container.show-admin .sign-up-admin-container {
            transform: translateX(100%);
            opacity: 1;
            z-index: 5;
        }

        /* Show visitor sign-up form */
        .container.show-visitor .sign-up-visitor-container {
            transform: translateX(100%);
            opacity: 1;
            z-index: 5;
        }

        /* Show unified sign-in form */
        .container.show-signin .sign-in-container {
            transform: translateX(0);
            opacity: 1;
            z-index: 5;
        }

        /* Overlay styles */
        .overlay-container {
            position: absolute;
            top: 0;
            left: 50%;
            width: 50%;
            height: 100%;
            overflow: hidden;
            transition: transform 0.6s ease-in-out;
            z-index: 100;
        }

        .overlay {
            background: linear-gradient(to right, #FF4B2B, #1E2F97);
            background-repeat: no-repeat;
            background-size: cover;
            background-position: 0 0;
            color: #ffffff;
            position: relative;
            left: -100%;
            height: 100%;
            width: 200%;
            transform: translateX(0);
            transition: transform 0.6s ease-in-out;
        }

        /* Overlay movement for sign-up */
        .container.show-admin .overlay-container,
        .container.show-visitor .overlay-container {
            transform: translateX(-100%);
        }

        .container.show-admin .overlay,
        .container.show-visitor .overlay {
            transform: translateX(50%);
        }

        /* Overlay movement for sign-in */
        .container.show-signin .overlay-container {
            transform: translateX(0);
        }

        .container.show-signin .overlay {
            transform: translateX(0);
        }

        .overlay-panel {
            position: absolute;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0 40px;
            text-align: center;
            top: 0;
            height: 100%;
            width: 50%;
            transform: translateX(0);
            transition: transform 0.6s ease-in-out;
        }

        .overlay-left {
            transform: translateX(-20%);
        }

        /* Overlay panel movement for sign-up */
        .container.show-admin .overlay-left,
        .container.show-visitor .overlay-left {
            transform: translateX(0);
        }

        /* Overlay panel movement for sign-in */
        .container.show-signin .overlay-left {
            transform: translateX(-20%);
        }

        .overlay-right {
            right: 0;
            transform: translateX(0);
        }

        /* Overlay panel movement for sign-up */
        .container.show-admin .overlay-right,
        .container.show-visitor .overlay-right {
            transform: translateX(20%);
        }

        /* Overlay panel movement for sign-in */
        .container.show-signin .overlay-right {
            transform: translateX(0);
        }

        /* Link buttons - consider removing if not used or integrating into general button styles */
        .button-link {
            background-color: #82298c;
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            margin-left: 15px;
        }

        .button-link:hover {
            background-color: #a03fb0;
        }

        /* Side-by-side input layout */
        .side-by-side {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: space-between;
            width: 100%;
            margin-bottom: 15px;
        }
        .side-by-side input {
            flex: 1 1 calc(50% - 10px);
            min-width: 150px;
        }

        /* Overlay logo and text styles */
        .overlay-logo {
            width: 250px;
            margin-bottom: 30px;
            max-width: 80%;
            height: auto;
        }

        /* For H1 inside overlay panels (Hello!, Welcome Back!) */
        .overlay-panel h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5em;
            margin-bottom: 15px;
            line-height: 1.2;
        }

        .overlay-panel p {
            font-size: 1em;
            line-height: 1.5;
            margin-bottom: 25px;
            padding: 0 10px;
        }

        .overlay-panel span strong {
            font-size: 0.9em;
        }

        /* Language Switcher Styles */
        .lang-switch {
            display: flex;
            gap: 10px;
            margin-left: auto;
        }

        .lang-switch img {
            width: 40px;
            height: 25px;
            cursor: pointer;
            border: 1px solid #ffffff;
            border-radius: 3px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s ease-in-out;
        }

        .lang-switch img:hover {
            transform: scale(1.05);
        }

        /* Responsive adjustments for smaller screens */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 10px;
            }

            .lang-switch {
                margin-left: 0;
                margin-top: 10px;
            }

            .container {
                flex-direction: column;
                width: 100%;
                min-height: auto; /* Allow height to adjust */
                margin-top: 120px; /* Adjust for larger fixed navbar on small screens */
            }

            .form-container, .overlay-container {
                width: 100%;
                position: relative;
                height: auto;
                padding: 30px 20px; /* Adjust padding for smaller screens */
            }

            .overlay-container {
                left: 0;
                transform: translateX(0) !important;
                height: 250px; /* Adjust height for mobile view overlay */
            }

            .overlay {
                width: 100%;
                left: 0;
                transform: translateX(0) !important;
                flex-direction: column;
            }

            .overlay-panel {
                width: 100%;
                padding: 20px;
                transform: translateX(0) !important;
                height: auto;
            }

            /* Hide all forms and overlays by default on small screens, show with JS */
            .sign-up-admin-container,
            .sign-up-visitor-container,
            .sign-in-container {
                opacity: 1; /* Always visible for JS to control display */
                display: none; /* Hidden by default, JS will show */
                position: absolute; /* Keep absolute for transitions on smaller screens if needed */
                width: 100%;
                left: 0;
                top: 0;
                height: 100%;
                transition: transform 0.6s ease-in-out; /* Add transition for smoothness */
            }

            .container.show-signin .sign-in-container,
            .container.show-admin .sign-up-admin-container,
            .container.show-visitor .sign-up-visitor-container {
                display: flex; /* Show the active form */
                transform: translateX(0); /* Ensure it's in place */
            }

            .overlay-left, .overlay-right {
                display: none; /* Hide one overlay panel for simplicity on small screens */
            }

            /* Only show the right panel for sign-up options on small screens */
            .overlay-panel.overlay-right {
                 display: flex;
            }

            /* Further adjustments for mobile font sizes */
            h2.title {
                font-size: 2em; /* Smaller on mobile */
                margin-top: 100px; /* Adjust for fixed navbar */
            }

            .overlay-panel h1 {
                font-size: 1.8em; /* Smaller on mobile */
            }

            .form-container h1 {
                font-size: 1.5em; /* Smaller on mobile */
            }
        }

        @media (max-width: 480px) {
            .side-by-side input {
                flex: 1 1 100%; /* Stack inputs vertically on very small screens */
            }
        }
    </style>
</head>

<body>
    <header>
        <div class="navbar">
            <div class="logo">
                <img src="logoC.jpg" alt="Cybervengers Logo">
            </div>
            <div class="lang-switch">
                <img src="https://flagcdn.com/w40/my.png" onclick="switchLanguage('ms');"
                     title="Bahasa Melayu 🇲🇾" alt="Malay Flag">
                <img src="https://flagcdn.com/w40/gb.png" onclick="switchLanguage('en');"
                     title="English 🇬🇧" alt="English Flag">
            </div>
        </div>
    </header>

    <section class="auth-section">
        <h2 class="title" data-lang-key="loginRegisterTitle">LOGIN/REGISTER</h2>
        <div class="container" id="container">
            <div class="form-container sign-up-admin-container">
                <form action="register.jsp" method="post">
                    <h1 data-lang-key="createAdminAccount">Create Admin Account</h1>
                    <input type="text" name="staffId" placeholder="Staff ID" required data-lang-placeholder-key="staffIdPlaceholder">
                    <input type="text" name="username" placeholder="Username" required data-lang-placeholder-key="usernamePlaceholder">
                    <input type="email" name="email" placeholder="Email" required data-lang-placeholder-key="emailPlaceholder">
                    <input type="password" name="password" placeholder="Password" required data-lang-placeholder-key="passwordPlaceholder">
                    <input type="text" name="fullName" placeholder="Full Name (Optional)" data-lang-placeholder-key="fullNameOptionalPlaceholder">
                    <button type="submit" name="submitAdmin" data-lang-key="signUpButton">Sign Up</button>
                </form>
            </div>

            <div class="form-container sign-up-visitor-container">
                <form action="register.jsp" method="post">
                    <h1 data-lang-key="createVisitorAccount">Create Visitor Account</h1>
                    <div class="side-by-side">
                        <input type="text" name="username" placeholder="Username" required data-lang-placeholder-key="usernamePlaceholder">
                        <input type="password" name="password" placeholder="Password" required data-lang-placeholder-key="passwordPlaceholder">
                        <input type="text" name="fullName" placeholder="Full Name" required data-lang-placeholder-key="fullNamePlaceholder">
                        <input type="text" name="icPassportNo" placeholder="IC/Passport No" required data-lang-placeholder-key="icPassportNoPlaceholder">
                        <input type="tel" name="phoneNumber" pattern="\d{10,12}" placeholder="Phone Number" required data-lang-placeholder-key="phoneNumberPlaceholder">
                        <input type="email" name="email" placeholder="Email" required data-lang-placeholder-key="emailPlaceholder">
                    </div>
                    <button type="submit" name="submitVisitor" data-lang-key="signUpButton">Sign Up</button>
                </form>
            </div>

            <div class="form-container sign-in-container">
                <form action="register.jsp" method="post">
                    <h1 data-lang-key="signInTitle">Sign In</h1>
                    <input type="text" name="username" placeholder="Username" required data-lang-placeholder-key="usernamePlaceholder">
                    <input type="password" name="password" placeholder="Password" required data-lang-placeholder-key="passwordPlaceholder">
                    <button type="submit" name="submitLogin" data-lang-key="signInButton">Sign In</button> <br />
                </form>
            </div>

            <div class="overlay-container">
                <div class="overlay">
                    <div class="overlay-panel overlay-left">
                        <img src="sayang_usim_logo.png" alt="Sayang USIM Logo" class="overlay-logo">
                        <h1 data-lang-key="welcomeBack">Welcome Back!</h1>
                        <p data-lang-key="welcomeBackMessage">Keep connected with us and log in to your existing account</p>
                        <button class="ghost" id="signIn" data-lang-key="signInButton">Sign In</button>
                        <span data-lang-key="alreadyHaveAccount"><strong>Already have an account?</strong></span>
                    </div>
                    <div class="overlay-panel overlay-right">
                        <img src="sayang_usim_logo.png" alt="Sayang USIM Logo" class="overlay-logo">
                        <h1 data-lang-key="hello">Hello!</h1>
                        <p data-lang-key="signUpMessage">Key in your personal details and enjoy your visit with us.</p>
                        <button class="ghost" id="signUpAdmin" data-lang-key="signUpAsAdmin">Sign Up as Admin</button> <br />
                        <button class="ghost" id="signUpVisitor" data-lang-key="signUpAsVisitor">Sign Up as Visitor</button> <br>
                        <span data-lang-key="dontHaveAccount"><strong>Don't have an account?</strong></span>
                    </div>
                </div>
            </div>
        </div>
    </section>

<script>
    // Language translations
    const translations = {
        'en': {
            'loginRegisterTitle': 'LOGIN/REGISTER',
            'createAdminAccount': 'Create Admin Account',
            'createVisitorAccount': 'Create Visitor Account',
            'signInTitle': 'Sign In',
            'signUpButton': 'Sign Up',
            'signInButton': 'Sign In',
            'welcomeBack': 'Welcome Back!',
            'welcomeBackMessage': 'Keep connected with us and log in to your existing account',
            'alreadyHaveAccount': 'Already have an account?',
            'hello': 'Hello!',
            'signUpMessage': 'Key in your personal details and enjoy your visit with us.',
            'signUpAsAdmin': 'Sign Up as Admin',
            'signUpAsVisitor': 'Sign Up as Visitor',
            'dontHaveAccount': 'Don\'t have an account?',
            // Placeholders for input fields
            'staffIdPlaceholder': 'Staff ID',
            'usernamePlaceholder': 'Username',
            'emailPlaceholder': 'Email',
            'passwordPlaceholder': 'Password',
            'fullNameOptionalPlaceholder': 'Full Name (Optional)',
            'fullNamePlaceholder': 'Full Name',
            'icPassportNoPlaceholder': 'IC/Passport No',
            'phoneNumberPlaceholder': 'Phone Number'
        },
        'ms': {
            'loginRegisterTitle': 'LOG MASUK/DAFTAR',
            'createAdminAccount': 'Cipta Akaun Admin',
            'createVisitorAccount': 'Cipta Akaun Pelawat',
            'signInTitle': 'Log Masuk',
            'signUpButton': 'Daftar',
            'signInButton': 'Log Masuk',
            'welcomeBack': 'Selamat Kembali!',
            'welcomeBackMessage': 'Kekal berhubung dengan kami dan log masuk ke akaun sedia ada anda',
            'alreadyHaveAccount': 'Sudah mempunyai akaun?',
            'hello': 'Helo!',
            'signUpMessage': 'Masukkan butiran peribadi anda dan nikmati lawatan anda bersama kami.',
            'signUpAsAdmin': 'Daftar sebagai Admin',
            'signUpAsVisitor': 'Daftar sebagai Pelawat',
            'dontHaveAccount': 'Tiada akaun?',
            // Placeholders for input fields
            'staffIdPlaceholder': 'ID Kakitangan',
            'usernamePlaceholder': 'Nama Pengguna',
            'emailPlaceholder': 'Emel',
            'passwordPlaceholder': 'Kata Laluan',
            'fullNameOptionalPlaceholder': 'Nama Penuh (Pilihan)',
            'fullNamePlaceholder': 'Nama Penuh',
            'icPassportNoPlaceholder': 'No. IC/Pasport',
            'phoneNumberPlaceholder': 'Nombor Telefon'
        }
    };

    // Function to set language preference and update UI
    function switchLanguage(lang) {
        localStorage.setItem('preferredLanguage', lang); // Store preference
        updateContent(lang);
        updatePlaceholderTexts(lang);
    }

    // Function to update static content based on selected language
    function updateContent(lang) {
        document.querySelectorAll('[data-lang-key]').forEach(element => {
            const key = element.getAttribute('data-lang-key');
            if (translations[lang] && translations[lang][key]) {
                if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                    // Handled by updatePlaceholderTexts
                } else if (element.tagName === 'BUTTON') {
                    element.textContent = translations[lang][key];
                } else if (element.tagName === 'STRONG') {
                    element.textContent = translations[lang][key];
                }
                else {
                    element.innerHTML = translations[lang][key];
                }
            }
        });
    }

    // Function to update placeholder texts based on selected language
    function updatePlaceholderTexts(lang) {
        document.querySelectorAll('[data-lang-placeholder-key]').forEach(element => {
            const key = element.getAttribute('data-lang-placeholder-key');
            if (translations[lang] && translations[lang][key]) {
                element.placeholder = translations[lang][key];
            }
        });
    }

    document.addEventListener('DOMContentLoaded', (event) => {
        console.log('DOM Content Loaded! Running JavaScript...');

        // DOM Elements for form switching
        const container = document.getElementById('container');
        const signInButton = document.getElementById('signIn');
        const signUpAdminButton = document.getElementById('signUpAdmin');
        const signUpVisitorButton = document.getElementById('signUpVisitor');

        // --- Form Switching Logic ---
        // Initial state: show sign-in form
        if (container) {
            // Check if it's a mobile view, and adjust class for initial display
            if (window.matchMedia("(max-width: 768px)").matches) {
                // On mobile, default to showing the sign-in form explicitly for direct display
                container.querySelector('.sign-in-container').style.display = 'flex';
                container.querySelector('.sign-up-admin-container').style.display = 'none';
                container.querySelector('.sign-up-visitor-container').style.display = 'none';
                container.classList.add('show-signin'); // Keep class for overlay logic consistency
            } else {
                container.className = 'container show-signin';
            }
        } else {
            console.error("Container element with ID 'container' not found!");
        }

        // Event listeners for form switching buttons
        if (signUpAdminButton) {
            signUpAdminButton.addEventListener('click', () => {
                if (window.matchMedia("(max-width: 768px)").matches) {
                    container.querySelector('.sign-in-container').style.display = 'none';
                    container.querySelector('.sign-up-admin-container').style.display = 'flex';
                    container.querySelector('.sign-up-visitor-container').style.display = 'none';
                }
                container.className = 'container show-admin';
            });
        }
        if (signUpVisitorButton) {
            signUpVisitorButton.addEventListener('click', () => {
                if (window.matchMedia("(max-width: 768px)").matches) {
                    container.querySelector('.sign-in-container').style.display = 'none';
                    container.querySelector('.sign-up-admin-container').style.display = 'none';
                    container.querySelector('.sign-up-visitor-container').style.display = 'flex';
                }
                container.className = 'container show-visitor';
            });
        }
        if (signInButton) {
            signInButton.addEventListener('click', () => {
                if (window.matchMedia("(max-width: 768px)").matches) {
                    container.querySelector('.sign-in-container').style.display = 'flex';
                    container.querySelector('.sign-up-admin-container').style.display = 'none';
                    container.querySelector('.sign-up-visitor-container').style.display = 'none';
                }
                container.className = 'container show-signin';
            });
        }

        // --- Language Initialization ---
        // Check for preferred language in localStorage, default to English
        const currentLang = localStorage.getItem('preferredLanguage') || 'en';
        switchLanguage(currentLang);
    });
</script>
</body>
</html>