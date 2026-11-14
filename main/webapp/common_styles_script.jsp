<%-- common_styles_script.jsp --%>
<script>
    // Define the translations object globally so it is accessible by all other scripts
    const translations = {
        en: {
            home: "HOME",
            aboutUs: "ABOUT US",
            contactUs: "CONTACT US",
            signout: "SIGNOUT",
            checkInStatus: "Check-in Status",
            checkInTime: "Check-in Time",
            checkOutTime: "Check-out Time",
            currentStatus: "Current Status",
            checkInButton: "Check-in Now",
            checkOutButton: "Check-out Now",
            trackLocation: "Track Location",
            shareLocationForTracking: "Allow sharing location for tracking.",
            locationStatus: "Location Tracking Status:",
            locationTrackingInactive: "Inactive",
            locationTrackingActive: "Active (Tracking)",
            startTracking: "Start Location Tracking",
            stopTracking: "Stop Location Tracking",
            enableLocation: "Enabling location services...",
            latitude: "Latitude:",
            longitude: "Longitud:",
            updatedAt: "Updated At:", // Ensure this key exists!
            locationError: "Location Error: ",
            locationPermissionDenied: "User denied the request for Geolocation.",
            successMessage: "Operation successful!",
            errorMessage: "An error occurred!",
            infoMessage: "Information message."
        },
        ms: { // Bahasa Melayu translations
            home: "LAMAN UTAMA",
            aboutUs: "TENTANG KAMI",
            contactUs: "HUBUNGI KAMI",
            signout: "LOG KELUAR",
            checkInStatus: "Status Daftar Masuk",
            checkInTime: "Masa Daftar Masuk",
            checkOutTime: "Masa Daftar Keluar",
            currentStatus: "Status Semasa",
            checkInButton: "Daftar Masuk Sekarang",
            checkOutButton: "Daftar Keluar Sekarang",
            trackLocation: "Jejak Lokasi",
            shareLocationForTracking: "Benarkan perkongsian lokasi untuk penjejakan.",
            locationStatus: "Status Penjejakan Lokasi:",
            locationTrackingInactive: "Tidak Aktif",
            locationTrackingActive: "Aktif (Menjejak)",
            startTracking: "Mula Penjejakan Lokasi",
            stopTracking: "Hentikan Penjejakan Lokasi",
            enableLocation: "Mendayakan perkhidmatan lokasi...",
            latitude: "Latitud:",
            longitude: "Longitud:",
            updatedAt: "Dikemas kini Pada:", // Ensure this key exists!
            locationError: "Ralat Lokasi: ",
            locationPermissionDenied: "Pengguna menafikan permintaan untuk Geolocation.",
            successMessage: "Operasi berjaya!",
            errorMessage: "Ralat telah berlaku!",
            infoMessage: "Maklumat mesej."
        }
    };

    // Function to update text based on selected language (globally accessible)
    function updatePageText(lang) {
        document.querySelectorAll('[data-lang-key]').forEach(element => {
            const key = element.getAttribute('data-lang-key');
            if (translations[lang] && translations[lang][key]) {
                element.textContent = translations[lang][key];
            }
        });
        // Special case for placeholders if needed
    }

    // Function to switch language and save preference (globally accessible)
    function switchLanguage(lang) {
        localStorage.setItem('preferredLanguage', lang);
        updatePageText(lang);
    }

    // Call initial update based on stored preference
    // This uses DOMContentLoaded, which is fine as it's the main script to initialize translations.
    document.addEventListener('DOMContentLoaded', function() {
        const initialLang = localStorage.getItem('preferredLanguage') || 'en';
        updatePageText(initialLang);
    });
</script>

<style>
    /* Common styles for navbar, buttons, etc. */
    body {
        font-family: 'Inter', sans-serif;
        margin: 0;
        background-color: #f4f7f6;
        color: #333;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
    }
    .navbar {
        width: 100%;
        background-color: #3f51b5; /* A primary blue color */
        color: white;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }
    .navbar .logo img {
        height: 40px; /* Adjust as needed */
        border-radius: 5px;
    }
    .navbar nav a {
        color: white;
        text-decoration: none;
        margin: 0 15px;
        font-weight: bold;
        transition: color 0.3s ease;
    }
    .navbar nav a:hover {
        color: #a7b7eb; /* Lighter blue on hover */
    }
    .lang-switch img {
        height: 25px;
        margin-left: 10px;
        cursor: pointer;
        border-radius: 3px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
    }
    .navbar-buttons .button-link {
        background-color: #f44336; /* Red signout button */
        color: white;
        padding: 8px 15px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
        margin-left: 20px;
        transition: background-color 0.3s ease;
    }
    .navbar-buttons .button-link:hover {
        background-color: #d32f2f; /* Darker red on hover */
    }

</style>
