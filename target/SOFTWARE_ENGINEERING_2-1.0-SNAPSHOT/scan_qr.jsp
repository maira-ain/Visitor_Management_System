<%--
    Document    : scan_qr (UPDATED)
    Created on : 29 Jun 2025, 1:31:12 am
    Author      : Comp
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-lang-key="checkInStatus">Check-in Status</title>
    <%-- Include common styles and scripts --%>
    <%@ include file="common_styles_script.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* ===== Global Styles (from visitor_form.jsp for consistency) ===== */
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
            justify-content: flex-start; /* Align to top, then push content down with margin */
            padding-top: 70px; /* Space for fixed navbar */
            box-sizing: border-box; /* Include padding in element's total width and height */
        }

        /* ===== Navbar Styles (from visitor_form.jsp for consistency) ===== */
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

        /* Existing CSS from your original file */
        .status-container {
            background-color: #ffffffcc; /* Semi-transparent white to match form-box */
            border: 2px solid #82298c; /* Border color from visitor_form.jsp */
            border-radius: 15px; /* Rounded corners from visitor_form.jsp */
            padding: 30px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); /* Shadow from visitor_form.jsp */
            text-align: center;
            max-width: 450px;
            width: 90%; /* Use responsive width */
            margin-top: 20px; /* Adjusted to use body padding-top */
            margin-bottom: 50px; /* Space from bottom */
        }
        .status-info p {
            margin-bottom: 10px;
            font-size: 1.1em;
            color: #444;
        }
        .status-info span {
            font-weight: bold;
            color: #333;
        }
        .action-buttons button {
            background-color: #4CAF50; /* Green for Check-in */
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin: 10px 5px;
            transition: background-color 0.3s ease;
        }
        .action-buttons button.checkout {
            background-color: #f44336; /* Red for Check-out */
        }
        .action-buttons button:hover {
            opacity: 0.9;
        }
        .location-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .location-section p {
            font-size: 0.95em;
            color: #666;
        }
        .location-status {
            font-weight: bold;
            color: #2196F3;
        }
        .location-coords {
            font-family: monospace;
            background-color: #f0f0f0;
            padding: 5px 10px;
            border-radius: 3px;
            display: inline-block;
            margin-top: 5px;
        }
        .location-buttons button {
            background-color: #2196F3; /* Blue for location */
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9em;
            margin: 5px;
            transition: background-color 0.3s ease;
        }
        .location-buttons button.stop {
            background-color: #ff9800; /* Orange for stop */
        }
        /* Message box styles */
        .message-box {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
        }
        .message-box.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message-box.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .message-box.info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        /* Custom Alert/Message Box Styles (replacement for alert()) */
        .custom-message-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 2000;
            visibility: hidden;
            opacity: 0;
            transition: visibility 0s, opacity 0.3s ease-in-out;
        }
        .custom-message-overlay.visible {
            visibility: visible;
            opacity: 1;
        }
        .custom-message-box {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 350px;
            width: 90%;
            transform: translateY(-20px);
            transition: transform 0.3s ease-in-out;
            position: relative;
        }
        .custom-message-overlay.visible .custom-message-box {
            transform: translateY(0);
        }
        .custom-message-box p {
            font-size: 1.1em;
            color: #333;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        .custom-message-box button {
            background-color: #2196F3;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .custom-message-box button:hover {
            background-color: #1976D2;
        }
        .custom-message-box.error-type {
            border: 2px solid #f44336;
        }
        .custom-message-box.success-type {
            border: 2px solid #4CAF50;
        }
        .custom-message-box.info-type {
            border: 2px solid #2196F3;
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
            .status-container {
                padding: 20px;
            }
        }
    </style>
    <script>
        let watchId = null; // To store the watchPosition ID for stopping

        // Function to display custom messages (replaces alert())
        function showMessageBox(message, type = 'info') {
            const overlay = document.getElementById('customMessageBoxOverlay');
            const box = document.getElementById('customMessageBox');
            const msgContent = document.getElementById('customMessageBoxContent');
            const closeBtn = document.getElementById('customMessageBoxCloseBtn');

            msgContent.textContent = message;
            box.className = 'custom-message-box ' + type + '-type'; // Add type class for styling
            overlay.classList.add('visible');

            closeBtn.onclick = () => {
                overlay.classList.remove('visible');
            };

            // Close if clicked outside
            overlay.onclick = (event) => {
                if (event.target === overlay) {
                    overlay.classList.remove('visible');
                }
            };
        }


        // Get checkinId and detailId from the hidden inputs or directly from EL if available in request scope
        const checkinId = "${checkinId}"; // Accessed via EL
        const detailId = "${detailId}";    // Accessed via EL

        // --- New: Handle Check-in/Check-out Actions via Fetch ---
        async function handleCheckinCheckout(action) {
            if (!checkinId || checkinId === 'null') {
                showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en']['errorMessage'] + ": Check-in ID is missing.", "error");
                return;
            }

            try {
                const response = await fetch('checkin_action.jsp', { // New JSP for checkin/checkout actions
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: `checkin_id=${checkinId}&detail_id=${detailId}&action=${action}`
                });
                const result = await response.json();

                if (result.status === 'success') {
                    showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en'][action + 'Recorded'], "success");

                    // Update UI with new timestamp
                    const timestampSpan = action === 'checkin' ? document.querySelector('.status-info p:nth-of-type(2) span:last-child') : document.querySelector('.status-info p:nth-of-type(3) span:last-child');
                    if (timestampSpan) {
                        timestampSpan.textContent = result.timestamp; // Display timestamp from server response
                    }

                    // Update button visibility
                    if (action === 'checkin') {
                        document.getElementById('checkInBtn').style.display = 'none';
                        document.getElementById('checkOutBtn').style.display = 'inline-block';
                    } else if (action === 'checkout') {
                        document.getElementById('checkInBtn').style.display = 'none';
                        document.getElementById('checkOutBtn').style.display = 'none';
                    }

                } else {
                    showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en']['errorMessage'] + ": " + result.message, "error");
                }
            } catch (error) {
                console.error("Error during check-in/out:", error);
                showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en']['errorMessage'] + ": An unexpected error occurred: " + error.message, "error");
            }
        }
        // --- End New Check-in/Check-out Actions ---


        // Function to update location in DB
        async function updateLocationInDb(latitude, longitude) {
            try {
                const response = await fetch('update_location.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: `checkin_id=${checkinId}&latitude=${latitude}&longitude=${longitude}`
                });
                const result = await response.json();
                if (result.status === 'success') {
                    console.log("Location update successful:", result.message);
                    document.getElementById('locationCoords').textContent = `${translations[localStorage.getItem('preferredLanguage') || 'en']['latitude']} ${latitude}, ${translations[localStorage.getItem('preferredLanguage') || 'en']['longitude']} ${longitude}`;
                    document.getElementById('locationTimestamp').textContent = `${translations[localStorage.getItem('preferredLanguage') || 'en']['updatedAt']} <%= new java.util.Date().toLocaleString() %>`;
                    document.getElementById('locationTrackingStatus').textContent = translations[localStorage.getItem('preferredLanguage') || 'en']['locationTrackingActive'];
                } else {
                    console.error("Location update failed:", result.message);
                    showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en']['errorMessage'] + ": " + result.message, "error");
                }
            } catch (error) {
                console.error("Error sending location to server:", error);
                showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en']['errorMessage'] + ": " + error.message, "error");
            }
        }

        function startLocationTracking() {
            const statusElement = document.getElementById('locationTrackingStatus');
            statusElement.textContent = translations[localStorage.getItem('preferredLanguage') || 'en']['enableLocation']; // Prompt user

            if (navigator.geolocation) {
                if (!checkinId || checkinId === 'null') { // Check if checkinId is valid before tracking
                    showMessageBox(translations[localStorage.getItem('preferredLanguage') || 'en']['errorMessage'] + ": Cannot start tracking. Check-in ID is missing.", "error");
                    statusElement.textContent = translations[localStorage.getItem('preferredLanguage') || 'en']['locationTrackingInactive'];
                    return;
                }

                const geoOptions = {
                    enableHighAccuracy: true,
                    maximumAge: 0, // No caching, get fresh location
                    timeout: 5000 // 5 seconds
                };

                watchId = navigator.geolocation.watchPosition(
                    (position) => {
                        const latitude = position.coords.latitude;
                        const longitude = position.coords.longitude;
                        updateLocationInDb(latitude, longitude); // Send to server
                    },
                    (error) => {
                        console.error("Geolocation Error:", error);
                        let errorMessage = translations[localStorage.getItem('preferredLanguage') || 'en']['locationError'];
                        switch (error.code) {
                            case error.PERMISSION_DENIED:
                                errorMessage += translations[localStorage.getItem('preferredLanguage') || 'en']['locationPermissionDenied'];
                                break;
                            case error.POSITION_UNAVAILABLE:
                                errorMessage += " Location information is unavailable.";
                                break;
                            case error.TIMEOUT:
                                errorMessage += " The request to get user location timed out.";
                                break;
                            default:
                                errorMessage += error.message;
                                break;
                        }
                        statusElement.textContent = errorMessage;
                        showMessageBox(errorMessage, "error");
                        // Automatically stop tracking if permission is denied or a severe error occurs
                        stopLocationTracking();
                    },
                    geoOptions
                );
                document.getElementById('startTrackingBtn').style.display = 'none';
                document.getElementById('stopTrackingBtn').style.display = 'inline-block';
                statusElement.textContent = translations[localStorage.getItem('preferredLanguage') || 'en']['locationTrackingActive'];

            } else {
                statusElement.textContent = "Geolocation is not supported by this browser.";
                showMessageBox("Geolocation is not supported by this browser.", "error");
            }
        }

        function stopLocationTracking() {
            if (watchId !== null) {
                navigator.geolocation.clearWatch(watchId);
                watchId = null;
                document.getElementById('locationTrackingStatus').textContent = translations[localStorage.getItem('preferredLanguage') || 'en']['locationTrackingInactive'];
                document.getElementById('startTrackingBtn').style.display = 'inline-block';
                document.getElementById('stopTrackingBtn').style.display = 'none';
                // Optionally clear coordinates display
                document.getElementById('locationCoords').textContent = '';
                document.getElementById('locationTimestamp').textContent = '';
            }
        }

        // Language translations for this page (ensure these match common_styles_script.jsp or are merged if needed)
        // These are local to this page's script block, but ensure consistency with your common translations.
        const translations = {
            'en': {
                'checkInStatus': 'Check-in Status',
                'home': 'HOME',
                'aboutUs': 'ABOUT US',
                'contactUs': 'CONTACT US',
                'signout': 'SIGNOUT',
                'checkInTime': 'Check-in Time',
                'checkOutTime': 'Check-out Time',
                'currentStatus': 'Current Status',
                'checkInButton': 'Check-in Now',
                'checkOutButton': 'Check-out Now',
                'trackLocation': 'Track Location',
                'shareLocationForTracking': 'Allow sharing location for tracking.',
                'locationStatus': 'Location Tracking Status:',
                'locationTrackingInactive': 'Inactive',
                'locationTrackingActive': 'Active (Tracking)',
                'startTracking': 'Start Location Tracking',
                'stopTracking': 'Stop Location Tracking',
                'enableLocation': 'Enabling location services...',
                'latitude': 'Latitude:',
                'longitude': 'Longitude:',
                'updatedAt': 'Updated At:',
                'locationError': 'Location Error: ',
                'locationPermissionDenied': 'User denied the request for Geolocation.',
                'successMessage': 'Operation successful!',
                'errorMessage': 'An error occurred!',
                'infoMessage': 'Information message.',
                'checkinRecorded': 'Check-in recorded!', // New translation
                'checkoutRecorded': 'Check-out recorded!' // New translation
            },
            'ms': {
                'checkInStatus': 'Status Daftar Masuk',
                'home': 'LAMAN UTAMA',
                'aboutUs': 'TENTANG KAMI',
                'contactUs': 'HUBUNGI KAMI',
                'signout': 'LOG KELUAR',
                'checkInTime': 'Masa Daftar Masuk',
                'checkOutTime': 'Masa Daftar Keluar',
                'currentStatus': 'Status Semasa',
                'checkInButton': 'Daftar Masuk Sekarang',
                'checkOutButton': 'Daftar Keluar Sekarang',
                'trackLocation': 'Jejak Lokasi',
                'shareLocationForTracking': 'Benarkan perkongsian lokasi untuk penjejakan.',
                'locationStatus': 'Status Penjejakan Lokasi:',
                'locationTrackingInactive': 'Tidak Aktif',
                'locationTrackingActive': 'Aktif (Menjejak)',
                'startTracking': 'Mula Penjejakan Lokasi',
                'stopTracking': 'Hentikan Penjejakan Lokasi',
                'enableLocation': 'Mendayakan perkhidmatan lokasi...',
                'latitude': 'Latitud:',
                'longitude': 'Longitud:',
                'updatedAt': 'Dikemas kini Pada:',
                'locationError': 'Ralat Lokasi: ',
                'locationPermissionDenied': 'Pengguna menafikan permintaan untuk Geolocation.',
                'successMessage': 'Operasi berjaya!',
                'errorMessage': 'Ralat telah berlaku!',
                'infoMessage': 'Maklumat mesej.',
                'checkinRecorded': 'Daftar masuk direkodkan!', // New translation
                'checkoutRecorded': 'Daftar keluar direkodkan!' // New translation
            }
        };

        // This ensures the page is updated on load with the correct language
        document.addEventListener('DOMContentLoaded', function() {
            const initialLang = localStorage.getItem('preferredLanguage') || 'en';
            if (typeof updatePageText === 'function') { // Check if common function is defined
                updatePageText(initialLang);
            } else {
                // Fallback if common_styles_script.jsp not loaded correctly or function missing
                document.querySelectorAll('[data-lang-key]').forEach(element => {
                    const key = element.getAttribute('data-lang-key');
                    if (translations[initialLang] && translations[initialLang][key]) {
                        element.textContent = translations[initialLang][key];
                    }
                });
            }

            // Get initial status flags from request attributes passed by the Servlet
            const alreadyCheckedIn = ${alreadyCheckedIn};
            const alreadyCheckedOut = ${alreadyCheckedOut};

            if (alreadyCheckedIn && !alreadyCheckedOut) {
                document.getElementById('checkInBtn').style.display = 'none';
                document.getElementById('checkOutBtn').style.display = 'inline-block';
            } else if (alreadyCheckedOut) {
                document.getElementById('checkInBtn').style.display = 'none';
                document.getElementById('checkOutBtn').style.display = 'none';
            } else {
                document.getElementById('checkInBtn').style.display = 'inline-block';
                document.getElementById('checkOutBtn').style.display = 'none';
            }
        });
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
                <img src="https://flagcdn.com/w40/my.png" onclick="switchLanguage('ms'); updatePageText('ms');" title="Bahasa Melayu �🇾" alt="Malay Flag">
                <img src="https://flagcdn.com/w40/gb.png" onclick="switchLanguage('en'); updatePageText('en');" title="English 🇬🇧" alt="English Flag">
            </div>
            <div class="navbar-buttons">
                <a href="logout.jsp" class="button-link signout-btn" data-lang-key="signout">SIGNOUT</a>
            </div>
        </div>
    </header>

    <div class="status-container">
        <%-- Display server-side messages (success or error) --%>
        <c:if test="${not empty message}">
            <div class="message-box ${messageType}">
                ${message}
            </div>
        </c:if>
        <h2 data-lang-key="currentStatus">Current Status</h2>
        <div class="status-info">
            <p><span data-lang-key="checkInStatus">Check-in Status:</span> <span>${currentCheckinStatus}</span></p>
            <p><span data-lang-key="checkInTime">Check-in Time:</span> <span>${checkInTime}</span></p>
            <p><span data-lang-key="checkOutTime">Check-out Time:</span> <span>${checkOutTime}</span></p>
        </div>

        <div class="action-buttons">
            <%-- Buttons now call JavaScript function for async updates --%>
            <button id="checkInBtn" onclick="handleCheckinCheckout('checkin')" data-lang-key="checkInButton">Check-in Now</button>
            <button id="checkOutBtn" onclick="handleCheckinCheckout('checkout')" class="checkout" data-lang-key="checkOutButton">Check-out Now</button>
        </div>

        <div class="location-section">
            <h3 data-lang-key="trackLocation">Track Location</h3>
            <p data-lang-key="shareLocationForTracking">Allow sharing location for tracking.</p>
            <p><span data-lang-key="locationStatus">Location Tracking Status:</span> <span id="locationTrackingStatus" class="location-status" data-lang-key="locationTrackingInactive">Inactive</span></p>
            <p id="locationCoords"></p>
            <p id="locationTimestamp"></p>
            <div class="location-buttons">
                <button id="startTrackingBtn" onclick="startLocationTracking()" data-lang-key="startTracking">Start Location Tracking</button>
                <button id="stopTrackingBtn" onclick="stopLocationTracking()" class="stop" style="display:none;" data-lang-key="stopTracking">Stop Location Tracking</button>
            </div>
        </div>

        <%-- Hidden inputs to ensure JavaScript can access checkinId and detailId if needed --%>
        <input type="hidden" id="hiddenCheckinId" value="${checkinId}">
        <input type="hidden" id="hiddenDetailId" value="${detailId}">
    </div>

    <%-- Custom Message Box HTML --%>
    <div id="customMessageBoxOverlay" class="custom-message-overlay">
        <div id="customMessageBox" class="custom-message-box">
            <p id="customMessageBoxContent"></p>
            <button id="customMessageBoxCloseBtn">OK</button>
        </div>
    </div>
</body>
</html>