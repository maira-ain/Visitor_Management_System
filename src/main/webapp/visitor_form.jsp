<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.UUID"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Get detail_id from the request parameter
    String detailIdStr = request.getParameter("detail_id");
    int detailId = -1;
    if (detailIdStr != null && !detailIdStr.isEmpty()) {
        try {
            detailId = Integer.parseInt(detailIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?msg=" + java.net.URLEncoder.encode("Invalid Visitor Detail ID.", "UTF-8"));
            return;
        }
    } else {
        response.sendRedirect("error.jsp?msg=" + java.net.URLEncoder.encode("Visitor Detail ID is missing.", "UTF-8"));
        return;
    }

    String message = "";
    String messageType = "";
    String checkinId = null; // This will be the ID for the Checkin entry
    String qrCodeValue = null; // The URL to be encoded in the QR code

    // Database Connection Details
    String jdbcURL = "jdbc:mysql://localhost:3306/my_database2?useSSL=false&serverTimezone=UTC";
    String jdbcUsername = "root";
    String jdbcPassword = "";

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Generate a new unique checkin_id (e.g., using UUID)
        checkinId = UUID.randomUUID().toString();

        // Insert a new entry into the Checkin table with detail_id and generated checkin_id
        // check_in_time and check_out_time will be null initially, updated on scan.
        String insertCheckinSql = "INSERT INTO Checkin (checkin_id, detail_id) VALUES (?, ?)";
        statement = connection.prepareStatement(insertCheckinSql);
        statement.setString(1, checkinId);
        statement.setInt(2, detailId);
        statement.executeUpdate();
        
        // Construct the URL that the QR code will point to
        // This URL will be scanned to perform check-in/check-out and location tracking
        // IMPORTANT: Using the specific IPv4 address 192.168.212.203 for accessibility
        // from other devices on the same local network.
        // Make sure this IP and port match your server's configuration.
        String baseURL = request.getScheme() + "://" + "192.168.212.203" + ":" + request.getServerPort() + request.getContextPath();
        qrCodeValue = baseURL + "/scan_qr.jsp?checkin_id=" + checkinId + "&detail_id=" + detailId;

        message = "QR Code generated successfully!";
        messageType = "success";

    } catch (SQLException e) {
        message = "Database error generating QR: " + e.getMessage();
        messageType = "error";
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        message = "JDBC Driver not found: " + e.getMessage();
        messageType = "error";
        e.printStackTrace();
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        messageType = "error";
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-lang-key="yourQrCode">Your QR Code</title>
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs/qrcode.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        /* ===== Global Styles ===== */
        body {
            font-family: 'Source Sans Pro', sans-serif;
            margin: 0;
            background: url(usim.jpg) no-repeat center center fixed; /* Set background image */
            background-size: cover; /* Cover the entire background */
            color: #000;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center; /* Center horizontally */
            justify-content: center; /* Center vertically */
            padding-top: 70px; /* Add padding for fixed navbar */
            box-sizing: border-box; /* Include padding in element's total width and height */
        }

        /* ===== Navbar Styles ===== */
        .navbar {
            display: flex;
            align-items: center;
            gap: 20px; /* Space between logo, nav, and buttons */
            justify-content: space-between; /* Distribute items with space between them */
            background-color: rgba(28, 9, 48, 0.9); /* Semi-transparent background */
            padding: 10px 20px;
            color: white;
            width: 100%; /* Ensure navbar takes full width */
            position: fixed; /* Keep navbar fixed at top */
            top: 0;
            left: 0;
            z-index: 1000; /* Ensure it's above other content */
        }

        .logo img {
            height: 40px; /* Adjust height as needed */
            object-fit: contain;
        }

        .navbar nav {
            display: flex; /* Make nav items flex to control spacing */
            gap: 15px; /* Space between nav links */
            margin-right: auto; /* Push nav to the left, towards logo, and push buttons to right */
        }

        .navbar nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 5px 0; /* Add padding for better touch targets */
            transition: color 0.3s ease;
        }

        .navbar nav a:hover {
            color: #b54bf3; /* Highlight on hover */
        }

        .navbar-buttons {
            display: flex;
            gap: 10px;
        }

        /* Make <a> look like .signout button */
        .button-link {
            background-color: #82298c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s;
        }

        .button-link:hover {
            background-color: #a03fb0;
        }

        .signout-btn {
            background-color: transparent;
            border: 2px solid white;
            color: white;
            border-radius: 20px;
            padding: 5px 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s, color 0.3s;
        }

        .signout-btn:hover {
            background-color: white;
            color: #82298c;
        }

        /* Language Switcher Styles */
        .lang-switch {
            display: flex;
            gap: 10px;
            margin-left: 20px; /* Add some space from navbar-buttons */
        }

        .lang-switch img {
            width: 40px;
            height: 25px; /* Maintain aspect ratio */
            cursor: pointer;
            border: 1px solid #ffffff;
            border-radius: 3px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s ease-in-out;
        }

        .lang-switch img:hover {
            transform: scale(1.05);
        }

        /* QR Container Specific Styles */
        .qr-container {
            background-color: #ffffffcc; /* Semi-transparent white to match form-box */
            border: 2px solid #82298c; /* Border color from visitor_form.jsp */
            border-radius: 15px; /* Rounded corners from visitor_form.jsp */
            padding: 30px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); /* Shadow from visitor_form.jsp */
            text-align: center;
            max-width: 400px; /* Consistent max-width */
            width: 90%; /* Responsive width */
            margin-top: 20px; /* Adjusted margin, body padding handles space from top */
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 2em; /* Larger title for emphasis */
            font-weight: 600;
        }
        .qr-placeholder {
            width: 200px;
            height: 200px;
            margin: 20px auto;
            border: 1px solid #eee; /* Visual border for QR code area */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .qr-data-display {
            word-break: break-all;
            background-color: #e9e9e9;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 0.9em;
            color: #555;
            margin-top: 15px;
        }
        .back-button {
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        .back-button:hover {
            background-color: #5a6268;
        }

        /* Message box styles */
        .message-box {
            background-color: #f0fdf4; /* Light green for success */
            border: 1px solid #34d399; /* Green border */
            color: #065f46; /* Dark green text */
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 600;
            width: 100%; /* Ensure it fills container */
            box-sizing: border-box; /* Include padding in width */
        }

        .message-box.error {
            background-color: #fee2e2; /* Light red for error */
            border-color: #f87171; /* Red border */
            color: #991b1b; /* Dark red text */
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            body {
                padding-top: 150px; /* More padding for stacked navbar */
            }
            .navbar {
                flex-direction: column;
                padding: 10px;
                height: auto; /* Allow navbar height to adjust */
            }
            .navbar nav {
                width: 100%;
                justify-content: center;
                margin-right: 0;
                margin-top: 10px;
            }
            .navbar-buttons {
                margin-top: 10px;
                margin-left: 0;
                width: 100%;
                justify-content: center;
            }
            .lang-switch {
                margin-left: 0;
                margin-top: 10px;
                justify-content: center;
            }
            .qr-container {
                padding: 20px;
            }
        }

        /* --- Modal Pop-up Styles --- */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1001; /* Sit on top, higher than navbar */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgba(0,0,0,0.6); /* Black w/ opacity */
            display: flex; /* Use flexbox for centering */
            align-items: center; /* Center vertically */
            justify-content: center; /* Center horizontally */
        }

        .modal-content {
            background-color: #fefefe;
            margin: auto; /* For browsers that don't support flex centering */
            padding: 30px;
            border: 2px solid #82298c; /* Matches your form border */
            border-radius: 15px; /* Matches your form border-radius */
            width: 90%; /* Responsive width */
            max-width: 350px; /* Max width for the modal */
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4); /* Stronger shadow for pop-up */
            text-align: center;
            animation: fadeIn 0.3s ease-out; /* Simple fade-in animation */
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-content h3 {
            color: #333;
            margin-bottom: 25px;
            font-size: 1.5em;
            font-weight: 700;
        }

        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 20px; /* Space between buttons */
            margin-top: 25px;
        }

        .modal-button {
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .modal-button:hover {
            transform: translateY(-2px);
        }

        .modal-button.yes {
            background-color: #82298c; /* Your brand color */
            color: white;
        }

        .modal-button.yes:hover {
            background-color: #a03fb0;
        }

        .modal-button.no {
            background-color: #6c757d; /* A neutral color */
            color: white;
        }

        .modal-button.no:hover {
            background-color: #5a6268;
        }
    </style>

    <script>
        // Language translations for this page
        const translations = {
            'en': {
                'yourQrCode': 'Your QR Code',
                'showQrToGuard': 'Please show this QR code to the guard.',
                'rawQrData': 'Raw QR Data:',
                'home': 'HOME',
                'aboutUs': 'ABOUT US',
                'contactUs': 'CONTACT US',
                'signout': 'SIGNOUT',
                'fillAnotherForm': 'Fill another form',
                'confirmSignout': 'Are you sure you want to sign out?',
                'yes': 'Yes',
                'no': 'No'
            },
            'ms': {
                'yourQrCode': 'Kod QR Anda',
                'showQrToGuard': 'Sila tunjukkan kod QR ini kepada pengawal.',
                'rawQrData': 'Data QR Mentah:',
                'home': 'LAMAN UTAMA',
                'aboutUs': 'TENTANG KAMI',
                'contactUs': 'HUBUNGI KAMI',
                'signout': 'LOG KELUAR',
                'fillAnotherForm': 'Isi borang lain',
                'confirmSignout': 'Adakah anda pasti ingin log keluar?',
                'yes': 'Ya',
                'no': 'Tidak'
            }
        };

        // Function to update text content based on selected language
        function updatePageText(lang) {
            document.querySelectorAll('[data-lang-key]').forEach(element => {
                const key = element.getAttribute('data-lang-key');
                if (translations[lang] && translations[lang][key]) {
                    if (element.tagName === 'TITLE') {
                        document.title = translations[lang][key];
                    } else {
                        element.textContent = translations[lang][key];
                    }
                }
            });
        }

        // Function to set language preference and update UI
        function switchLanguage(lang) {
            localStorage.setItem('preferredLanguage', lang);
            updatePageText(lang);
        }

        // --- Modal Functions ---
        function showModal() {
            document.getElementById('signoutModalOverlay').style.display = 'flex';
            // Update modal text for current language
            const currentLang = localStorage.getItem('preferredLanguage') || 'en';
            document.getElementById('modalQuestion').textContent = translations[currentLang]['confirmSignout'];
            document.getElementById('modalYesButton').textContent = translations[currentLang]['yes'];
            document.getElementById('modalNoButton').textContent = translations[currentLang]['no'];
        }

        function hideModal() {
            document.getElementById('signoutModalOverlay').style.display = 'none';
        }

        // Function to handle signout confirmation (now uses the custom modal)
        function confirmSignout(event) { // Added 'event' parameter
            // *** CRUCIAL LINE: Prevents the default behavior of the <a> tag ***
            event.preventDefault(); 
            console.log("Signout button clicked, showing modal..."); // For debugging
            showModal();
        }

        window.onload = function() {
            // Initialize language
            const currentLang = localStorage.getItem('preferredLanguage') || 'en';
            updatePageText(currentLang);

            const qrCodeElement = document.getElementById('qrcode');
            const qrData = "<%= qrCodeValue != null ? qrCodeValue.replace("\"", "\\\"") : "" %>";

            if (qrData) {
                new QRCode(qrCodeElement, {
                    text: qrData,
                    width: 200,
                    height: 200,
                    colorDark: "#000000",
                    colorLight: "#ffffff",
                    correctLevel: QRCode.CorrectLevel.H
                });
            } else {
                qrCodeElement.innerHTML = "<p style='color: red; font-weight: bold;'>Failed to generate QR Code. Data missing. Please try again.</p>";
            }

            // Attach event listener to the signout button
            const signoutButton = document.getElementById('signoutButton');
            if (signoutButton) { // Check if the button exists before adding listener
                signoutButton.addEventListener('click', confirmSignout);
                console.log("Event listener attached to signout button."); // For debugging
            } else {
                console.warn("Signout button with ID 'signoutButton' not found."); // For debugging
            }
            
            // Attach event listeners to modal buttons
            document.getElementById('modalYesButton').addEventListener('click', function() {
                hideModal();
                window.location.href = 'register.jsp'; // Redirect to register.jsp if 'Yes'
            });

            document.getElementById('modalNoButton').addEventListener('click', function() {
                hideModal(); // Hide modal and stay on the current page
            });
        };
    </script>
</head>

<body>
    <header>
        <div class="navbar">
            <div class="logo">
                <img src="logoC.jpg" alt="cybervengers logo">
            </div>
            <nav>
                <a href="about.jsp" data-lang-key="home">HOME</a>
                <a href="about.jsp" data-lang-key="aboutUs">ABOUT US</a>
                <a href="about.jsp" data-lang-key="contactUs">CONTACT US</a>
            </nav>
            <div class="lang-switch">
                <img src="https://flagcdn.com/w40/my.png" onclick="switchLanguage('ms');" title="Bahasa Melayu 🇲🇾" alt="Malay Flag">
                <img src="https://flagcdn.com/w40/gb.png" onclick="switchLanguage('en');" title="English 🇬🇧" alt="English Flag">
            </div>
            <div class="navbar-buttons">
                <a href="#" id="signoutButton" class="button-link signout-btn" data-lang-key="signout">SIGNOUT</a>
            </div>
        </div>
    </header>

    <div class="qr-container">
        <%-- Display server-side messages (success or error) --%>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="message-box <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        <h2 data-lang-key="yourQrCode">Your QR Code</h2>
        <p data-lang-key="showQrToGuard">
            Please show this QR code to the guard.
        </p>
        <div id="qrcode" class="qr-placeholder"></div>
        <div class="qr-data-display">
            <span data-lang-key="rawQrData">Raw QR Data: </span><%= qrCodeValue != null ? qrCodeValue : "N/A" %>
        </div>
        <a href="visitor_form.jsp" class="back-button" data-lang-key="fillAnotherForm">Fill another form</a>
    </div>

    <div id="signoutModalOverlay" class="modal-overlay">
        <div class="modal-content">
            <h3 id="modalQuestion" data-lang-key="confirmSignout">Are you sure you want to sign out?</h3>
            <div class="modal-buttons">
                <button id="modalYesButton" class="modal-button yes" data-lang-key="yes">Yes</button>
                <button id="modalNoButton" class="modal-button no" data-lang-key="no">No</button>
            </div>
        </div>
    </div>
</body>
</html>