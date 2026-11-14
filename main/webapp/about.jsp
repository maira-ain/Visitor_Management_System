<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cybervengers - Visitor Management</title>
    <link rel="stylesheet" href="about.css" />
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background: url(usim.jpg) no-repeat center center fixed;
            background-size: cover;
            color: white;
            display: flex; /* Use flexbox for overall layout */
            flex-direction: column; /* Stack content and footer vertically */
            min-height: 100vh; /* Ensure body takes full viewport height */
        }

        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: rgba(28, 9, 48, 0.9);
            padding: 10px 20px;
            color: white;
            position: sticky; /* Membuat navbar sticky */
            top: 0; /* Tetap di bagian atas */
            z-index: 1000; /* Pastikan di atas elemen lain */
        }

        .navbar-left {
            display: flex;
            align-items: center;
            gap: 20px;
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
            cursor: pointer; /* Menambahkan kursor pointer untuk link navbar */
        }

        .logout-btn {
            background-color: transparent;
            border: 2px solid white;
            color: white;
            border-radius: 20px;
            padding: 5px 15px;
            font-weight: bold;
            cursor: pointer;
        }

        main {
            flex-grow: 1; /* Allow main content to grow and push footer down */
        }

        .content {
            display: flex;
            gap: 20px;
            padding: 30px;
            max-width: 1000px;
            margin: auto;
            margin-top: 40px;
            align-items: stretch;
        }

        .image-card {
            flex: 1;
            overflow: hidden;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            display: flex;
        }

        .image-card img {
            width: 100%;
            height: 100%;
            display: block;
            border-radius: 10px;
            object-fit: cover;
        }

        .about-box {
            flex: 2;
            background: rgba(0, 0, 0, 0.6);
            padding: 20px;
            border-radius: 15px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .about-box h2 {
            color: #fff;
            font-size: 28px;
            margin-bottom: 5px;
        }

        .about-box h3 {
            font-weight: normal;
            font-size: 18px;
            margin-bottom: 15px;
        }

        .about-box .highlight {
            color: #f1c40f;
        }

        .about-box p {
            font-size: 15px;
            line-height: 1.6;
            color: #e0e0e0;
        }

        .header {
            padding: 30px 20px 10px 20px;
            text-align: center;
            color: white;
            text-shadow: 1px 1px 4px #000;
        }

        .header h2 {
            font-family: 'Georgia', serif;
            font-size: 36px;
            margin-bottom: 10px;
        }

        /* Styles for the new slideshow */
        .slideshow-container {
            max-width: 800px;
            position: relative;
            margin: auto;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            background: rgba(0, 0, 0, 0.6);
            /* Pastikan ia display block secara default */
            display: block;
        }

        .mySlides {
            display: none;
            text-align: center;
        }

        .mySlides img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }

        .prev, .next {
            cursor: pointer;
            position: absolute;
            top: 50%;
            width: auto;
            padding: 16px;
            margin-top: -22px;
            color: white;
            font-weight: bold;
            font-size: 18px;
            transition: 0.6s ease;
            user-select: none;
            background-color: rgba(0,0,0,0.5);
            border-radius: 3px;
        }

        .prev {
            left: 0;
            border-radius: 0 3px 3px 0;
        }

        .next {
            right: 0;
            border-radius: 3px 0 0 3px;
        }

        .prev:hover, .next:hover {
            background-color: rgba(0,0,0,0.8);
        }

        .text {
            color: #f2f2f2;
            font-size: 20px;
            padding: 8px 12px;
            position: absolute;
            bottom: 8px;
            width: 100%;
            text-align: center;
            background-color: rgba(0,0,0,0.6);
            border-radius: 0 0 10px 10px;
        }

        .numbertext {
            color: #f2f2f2;
            font-size: 12px;
            padding: 8px 12px;
            position: absolute;
            top: 0;
            left: 0;
            background-color: rgba(0,0,0,0.5);
            border-radius: 10px 0 10px 0;
        }

        .dot {
            cursor: pointer;
            height: 15px;
            width: 15px;
            margin: 0 2px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            transition: background-color 0.6s ease;
        }

        .active, .dot:hover {
            background-color: #717171;
        }

        .fade {
            animation-name: fade;
            animation-duration: 1.5s;
        }

        @keyframes fade {
            from {opacity: .4}
            to {opacity: 1}
        }

        /* Styles for the USIM Map Details Table */
        .usim-map-details {
            background: rgba(0, 0, 0, 0.7);
            padding: 20px;
            border-radius: 15px;
            margin-top: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            display: none; /* Hidden by default */
            text-align: left; /* Align text to the left within the table */
        }

        .usim-map-details h3 {
            color: #fff;
            margin-bottom: 20px;
            text-align: center;
        }

        .usim-map-details table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .usim-map-details th, .usim-map-details td {
            border: 1px solid #ddd;
            padding: 8px;
            color: #e0e0e0;
            vertical-align: top; /* Align content to the top */
        }

        .usim-map-details th {
            background-color: rgba(50, 50, 50, 0.8);
            color: white;
            text-align: left;
        }

        .usim-map-details tr:nth-child(even) {
            background-color: rgba(60, 60, 60, 0.4);
        }

        /* New styles for the map-only view */
        .map-only-view {
            max-width: 800px;
            position: relative;
            margin: auto;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            background: rgba(0, 0, 0, 0.6);
            display: none; /* Hidden by default */
        }

        .map-only-view img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
            cursor: pointer; /* Agar boleh klik untuk kembali ke slideshow */
        }

        /* Footer Styles */
        .footer {
            background-color: rgba(28, 9, 48, 0.9);
            color: white;
            padding: 30px 20px;
            margin-top: 50px; /* Add some space above the footer */
            text-align: center;
            font-size: 14px;
        }

        .footer-content {
            display: flex;
            flex-wrap: wrap; /* Allow items to wrap on smaller screens */
            justify-content: space-between; /* Changed to space-between to push items to ends */
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto 20px auto;
        }

        .footer-section {
            flex: 1;
            min-width: 250px;
            text-align: left;
            padding: 0 10px;
        }

        /* Specific section alignment for desktop */
        .footer-section.contact-details-section {
            order: -1; /* Pushes this section to the very left */
            text-align: left;
        }

        .footer-section.social-media-section {
            /* Menolak elemen ini ke paling kanan dengan margin-left: auto; */
            margin-left: auto;
            text-align: right; /* Alihkan teks ke kanan dalam seksyen ini */
            flex: unset; /* Buang flex grow agar ia tidak mengambil ruang berlebihan */
            min-width: fit-content; /* Saiz minimum mengikut kandungan */
        }
        
        /* Buang empty-spacer yang tidak diperlukan lagi */
        /* .footer-section.empty-spacer {
            order: 1;
        } */


        .footer-section h4 {
            color: #f1c40f;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .social-icons {
            display: flex; /* Use flexbox for icons */
            justify-content: flex-end; /* Alihkan ikon ke kanan */
            gap: 15px; /* Spacing between social icons */
        }

        .social-icons img {
            width: 40px; /* Increased size for social media icons */
            height: 40px; /* Increased size for social media icons */
            vertical-align: middle;
            border-radius: 5px;
            transition: transform 0.2s ease-in-out;
        }

        .social-icons img:hover {
            transform: scale(1.1);
        }

        .contact-info p {
            margin-bottom: 10px; /* Reduced space between contact lines */
            display: flex;
            align-items: flex-start;
            gap: 10px; /* Reduced space between icon and text */
            font-size: 14px; /* Reduced text size for contact info */
            line-height: 1.4; /* Adjusted line height for better appearance with smaller font */
        }

        .contact-info i {
            font-size: 20px; /* Reduced size for contact icons to match smaller text */
            color: #f1c40f;
            flex-shrink: 0;
            line-height: 1.4; /* Adjusted line height for better appearance with smaller font */
            position: relative;
            top: 1px; /* Small adjustment for visual alignment */
        }

        .footer-bottom-text {
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            padding-top: 20px;
            margin-top: 20px;
            font-size: 13px;
        }

        .footer-bottom-text a {
            color: white;
            text-decoration: none;
            margin: 0 5px;
        }

        .footer-bottom-text a:hover {
            text-decoration: underline;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .footer-content {
                flex-direction: column;
                align-items: center;
            }

            .footer-section {
                min-width: unset;
                width: 90%;
                text-align: center;
                margin-bottom: 20px;
                order: unset !important; /* Reset order on small screens */
                margin-left: unset; /* Buang margin-left: auto pada skrin kecil */
            }

            .footer-section.contact-details-section,
            .footer-section.social-media-section {
                text-align: center;
                flex-grow: unset;
            }

            .contact-info p {
                justify-content: center;
            }
            .social-icons {
                justify-content: center;
            }
        }

        /* Styles for the transparent logout confirmation box */
        .logout-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black background */
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000; /* Ensure it's on top of everything */
            display: none; /* Hidden by default */
        }

        .logout-box {
            background-color: rgba(28, 9, 48, 0.9); /* Darker transparent box */
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
            color: white;
            max-width: 400px;
            width: 90%;
        }

        .logout-box p {
            font-size: 20px;
            margin-bottom: 25px;
        }

        .logout-box .button-group button {
            background-color: #f1c40f;
            color: #2c3e50;
            border: none;
            padding: 10px 25px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin: 0 10px;
            transition: background-color 0.3s ease;
        }

        .logout-box .button-group button:hover {
            background-color: #e6b100;
        }

        .logout-box .button-group button:last-child {
            background-color: #e74c3c; /* Red for No button */
            color: white;
        }

        .logout-box .button-group button:last-child:hover {
            background-color: #c0392b;
        }
    </style>

</head>

<body>
    <header>
        <div class="navbar">
            <div class="navbar-left">
                <div class="logo">
                    <img src="logoC.jpg" alt="cybervengers logo">
                </div>
                <nav>
                    <a href="#" id="navHome">HOME</a>
                    <a href="#" id="navMap">MAP</a>
                    <a href="visitor_form.jsp">FILLED FORM</a>
                    <a href="#">HISTORY</a>
                    <a href="#" id="navContact">CONTACT US</a>
                </nav>
            </div>
            <button class="logout-btn" id="logoutBtn">SIGNOUT</button>
        </div>
    </header>

    <main>
        <section class="content" id="aboutUsSection">
            <div class="image-card">
                <img src="sayang_usim.jpg" alt="Sayang USIM" />
            </div>
            <div class="about-box">
                <h2>About Us</h2>
                <h3><span class="highlight">Cybervengers</span> | Visitor Management System</h3>
                <p>
                    The Visitor’s Recorder system enhances security and visitor management at USIM by tracking attendance and movement digitally.
                    Guards are the primary users, with administrators managing data and visitors checking in via QR codes.
                    This web-based system logs visitor locations in real time and ensures secure attendance management.
                    Costs depend on software development, server hosting, security, and maintenance.
                    The project spans 14 weeks, requiring internet access at USIM for location monitoring and QR scanning.
                    While not linked to other initiatives, future integration with USIM’s security system may be considered.
                </p>
            </div>
        </section>

        <section class="header" id="mapSection">
            <div class="mt-50 about-box">
                <div>
                    <h2>USIM is a unique and renowned university in Malaysia</h2>
                    <p>
                        Universiti Sains Islam Malaysia adopts a balanced approach between the physical and spiritual aspects, not only in the academic programmes offered, but it is also widely practised throughout the university including administration and management levels. USIM embraces a holistic approach towards the delivery of knowledge, which unites the revealed knowledge (Naqli) and Aqli (Acquired).
                    </p>
                </div>

                <div class="slideshow-container" id="usimSlideshow">
                    <div class="mySlides fade">
                        <div class="numbertext">1 / 2</div>
                        <img src="usim_map.png" alt="USIM Map"> 
                        <div class="text">USIM Map</div>
                    </div>

                    <div class="mySlides fade">
                        <div class="numbertext">2 / 2</div>
                        <img src="usim_loc.png" alt="USIM Location">
                        <div class="text">USIM Location</div>
                    </div>

                    <a class="prev" onclick="change(-1)">❮</a>
                    <a class="next" onclick="change(1)">❯</a>
                </div>
                <br>
                <div style="text-align:center" id="dotsContainer">
                    <span class="dot" onclick="goto(1)"></span>
                    <span class="dot" onclick="goto(2)"></span>
                </div>

                <div class="map-only-view" id="mapOnlyView">
                    <img src="usim_map.png" alt="USIM Map" id="usimMapImageFrozen"> 
                    <div class="text">USIM Map Details View (Click to return to slideshow)</div>
                </div>

                <div class="usim-map-details" id="usimMapDetails">
                    <h3>USIM Building Details</h3>
                    <table class="table table-bordered table-dark">
                        <thead>
                            <tr>
                                <th>NO</th>
                                <th>BUILDING</th>
                                <th>DEPARTMENT / CENTRE / OFFICE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>1</td><td>MAIN GATE</td><td></td></tr>
                            <tr>
                                <td>2</td>
                                <td>CANSELORI</td>
                                <td>
                                    Pejabat Canselor<br>
                                    Pejabat Pengerusi LPU<br>
                                    Pejabat Naib Canselor<br>
                                    Pejabat Timbalan-Timbalan Naib Canselor<br>
                                    Jabatan Canselori<br>
                                    Jabatan Pendaftar<br>
                                    Jabatan Bendahari<br>
                                    Pejabat Audit Dalam<br>
                                    Jabatan Undang-Undang (JUU)<br>
                                    Pusat Pengurusan Akademik (Bahagian Pengurusan Prasiswazah)<br>
                                    Pusat Pematuhan Syariah, Integriti, Pengurusan Risiko, Keselamatan dan Kesihatan Pekerjaan (SCIROSH)<br>
                                    Pusat Pengurusan Penyelidikan & Inovasi (PPPI)<br>
                                    Pusat Komunikasi Strategik (StraComm)<br>
                                    Dewan Senat<br>
                                    Executive Lounge (Aras 6)<br>
                                    Ruang Galeri (Aras 1)
                                </td>
                            </tr>
                            <tr><td>3</td><td>FAKULTI KEPIMPINAN & PENGURUSAN</td><td>Pejabat Fakulti Kepimpinan & Pengurusan (FKP)<br>Pusat Jaminan Kualiti (CQA)</td></tr>
                            <tr><td>4</td><td>FAKULTI PENGAJIAN QURAN & SUNNAH</td><td>Pejabat Fakulti Pengajian Quran & Sunnah (FPQS)<br>Pejabat Fakulti Pengajian Bahasa Utama (FPBU)</td></tr>
                            <tr><td>5</td><td>JABATAN PEMBANGUNAN & PENGURUSAN FASILITI</td><td></td></tr>
                            <tr><td>6</td><td>PUSAT PEMBANGUNAN KEMAHIRAN INSANIAH</td><td></td></tr>
                            <tr><td>7</td><td>JABATAN KESELAMATAN</td><td></td></tr>
                            <tr><td>8</td><td>PUSAT TAMHIDI</td><td>Pusat Tamhidi<br>Institut Sains Islam (ISI)</td></tr>
                            <tr><td>9</td><td>PUSAT KEMUDAHAN PELAJAR</td><td></td></tr>
                            <tr><td>10</td><td>PUSAT PENGAJIAN TERAS</td><td></td></tr>
                            <tr><td>11</td><td>MAKMAL PELBAGAI GUNA</td><td></td></tr>
                            <tr><td>12</td><td>FAKULTI SYARIAH & UNDANG-UNDANG</td><td>Pejabat Fakulti Syariah & Undang-Undang (FSU)<br>Institut Pengurusan & Penyelidikan Fatwa Sedunia (IFFAH)</td></tr>
                            <tr><td>13</td><td>KOLEJ PERMATA INSAN</td><td></td></tr>
                            <tr><td>14</td><td>DEWAN KULIAH PUSAT</td><td></td></tr>
                            <tr><td>15</td><td>PUSAT PEMBANGUNAN SISTEM DAN KEJURUTERAAN (SDEC)</td><td></td></tr>
                            <tr><td>16</td><td>PERPUSTAKAAN</td><td>Perpustakaan USIM<br>Pusat Penerbitan (Penerbit USIM)</td></tr>
                            <tr><td>17</td><td>FAKULTI EKONOMI & MUAMALAT</td><td>Pejabat Fakulti Ekonomi & Muamalat FEM)<br>Graduate School of Muamalat (GSM)<br>Islamic Finance and Wealth Management Institute (IFWMI)</td></tr>
                            <tr><td>18</td><td>PUSAT PENGURUSAN AKADEMIK (Bahagian Pengurusan Siswazah)</td><td></td></tr>
                            <tr><td>19</td><td>PUSAT KOMERSIAL</td><td>USIM ‘Alamiyyah<br>Pusat Keusahawanan Universiti (PKUU)<br>Pusat Libatsama Masyarakat & Jaringan Industri (PLMJI)<br>USIM Tijarah Holding Sdn. Bhd.<br>Kedai Buku Penerbit USIM<br>Koperasi Kakitangan USIM<br>Pejabat Ketua Pegawai Digital (CDO)</td></tr>
                            <tr><td>20</td><td>RUMAH KAKITANGAN</td><td></td></tr>
                            <tr><td>21</td><td>STOR PUSAT</td><td></td></tr>
                            <tr><td>22</td><td>STOR KENDERAAN</td><td></td></tr>
                            <tr><td>23</td><td>FAKULTI SAINS & TEKNOLOGI</td><td>Pejabat Fakulti Sains & Teknologi (FST)<br>Pejabat Fakulti Kejuruteraan & Alam Bina (FKAB)</td></tr>
                            <tr><td>24</td><td>PADANG BOLA 2</td><td></td></tr>
                            <tr><td>25</td><td>KOLEJ KEDIAMAN 1</td><td></td></tr>
                            <tr><td>26</td><td>BANGUNAN HAL EHWAL PELAJAR</td><td>Pusat Hal Ehwal Pelajar (PHEP)<br>Pusat Kebudayaan<br>Pusat Kesihatan Universiti (PKU)<br>Pusat Perumahan Pelajar<br>Pusat Alumni & Kerjaya</td></tr>
                            <tr><td>27</td><td>KOMPLEKS ISLAM TUANKU MUHRIZ</td><td>Pejabat Pusat Islam<br>Pusat Wakaf dan Zakat</td></tr>
                            <tr><td>28</td><td>DEWAN TUANKU CANSELOR</td><td></td></tr>
                            <tr><td>29</td><td>KOMPLEKS SUKAN TUANKU NAJIHAH</td><td>Pusat Sukan</td></tr>
                            <tr><td>30</td><td>FAKULTI PERUBATAN DAN SAINS KESIHATAN</td><td>Pejabat Fakulti Perubatan & Sains Kesihatan (FPSK)<br>Pusat Kecemerlangan Pengajaran dan Pembelajaran (CETL)</td></tr>
                            <tr><td>31</td><td>FAKULTI PERGIGIAN</td><td>Pejabat Fakulti Pergigian</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer" id="footerSection">
        <div class="footer-content">
            <div class="footer-section contact-details-section">
                <h4>Contact Us</h4>
                <div class="contact-info">
                    <p><i class="fas fa-phone-alt"></i> 06-798 8000</p>
                    <p><i class="fas fa-envelope"></i> helpdesk@usim.edu.my</p>
                    <p><i class="fas fa-map-marker-alt"></i> Bandar Baru Nilai, 71800 Nilai, Negeri Sembilan</p>
                </div>
            </div>
            
            <div class="footer-section social-media-section">
                <h4>Connect With Us</h4>
                <div class="social-icons">
                    <a href="https://www.tiktok.com/@usimofficial" target="_blank" aria-label="USIM TikTok Official">
                        <img src="tiktok.png" alt="TikTok">
                    </a>
                    <a href="https://www.instagram.com/usimofficial/" target="_blank" aria-label="USIM Instagram Official">
                        <img src="ig.png" alt="Instagram">
                    </a>
                    <a href="https://www.facebook.com/USIMedia/" target="_blank" aria-label="USIM Facebook Official">
                        <img src="fb.png" alt="Facebook">
                    </a>
                </div>
            </div>

            </div>
        <div class="footer-bottom-text">
            Copyright by CyberVengers &copy; 2025 USIM All Rights Reserved | <a href="#">Disclaimer</a> | <a href="#">Privacy Policy</a> | <a href="#">Security Policy</a> | <a href="#">Copyright</a>
        </div>
    </footer>

    <div class="logout-overlay" id="logoutConfirmationOverlay">
        <div class="logout-box">
            <p>ARE YOU SURE YOU WANT TO SIGN-OUT ACCOUNT?</p>
            <div class="button-group">
                <button id="logoutYes">YES</button>
                <button id="logoutNo">NO</button>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
    <script>
        let slideIndex = 1;
        let autoPlay = true;
        let slideTimer;
        let mapDetailsMode = false; // Status baru untuk menjejak paparan butiran peta

        const slides = document.getElementsByClassName('mySlides');
        const dots = document.getElementsByClassName('dot');
        // mapImg kini merujuk kepada imej di dalam slideshow
        const mapImgInSlideshow = slides[0].querySelector('img'); 
        const mapTable = document.getElementById('usimMapDetails');
        const slideshowContainer = document.getElementById('usimSlideshow'); // Kontainer slideshow
        const mapOnlyView = document.getElementById('mapOnlyView'); // Kontainer untuk paparan peta sahaja
        const mapImgFrozen = document.getElementById('usimMapImageFrozen'); // Imej peta dalam map-only-view

        const prevBtn = document.querySelector('.prev');
        const nextBtn = document.querySelector('.next');
        const dotsContainer = document.getElementById('dotsContainer');

        // Logout elements
        const logoutBtn = document.getElementById('logoutBtn');
        const logoutOverlay = document.getElementById('logoutConfirmationOverlay');
        const logoutYesBtn = document.getElementById('logoutYes');
        const logoutNoBtn = document.getElementById('logoutNo');

        // Navbar navigation elements
        const navHome = document.getElementById('navHome');
        const navMap = document.getElementById('navMap');
        const navContact = document.getElementById('navContact');

        // Sections for scrolling
        const aboutUsSection = document.getElementById('aboutUsSection');
        const mapSection = document.getElementById('mapSection');
        const footerSection = document.getElementById('footerSection');


        function startSlideshow(){
            if (!slideTimer && autoPlay) {
                slideTimer = setInterval(() => change(1), 2000);
            }
            console.log("Slideshow started. autoPlay:", autoPlay);
        }

        function stopSlideshow(){
            clearInterval(slideTimer);
            slideTimer = null;
            console.log("Slideshow stopped. autoPlay:", autoPlay);
        }

        function change(n){
            // Hanya benarkan perubahan slaid jika bukan dalam mod peta
            if(mapDetailsMode) return; 

            console.log("Changing slide by:", n);
            showSlide(slideIndex += n);
        }

        function goto(n){
            // Hanya benarkan pergi ke slaid jika bukan dalam mod peta
            if(mapDetailsMode) return; 

            console.log("Going to slide:", n);
            showSlide(slideIndex = n);
        }

        function showSlide(n){
            // Sembunyikan kontainer peta sahaja jika ia kelihatan
            mapOnlyView.style.display = 'none'; 
            slideshowContainer.style.display = 'block'; // Paparkan kontainer slideshow

            for(let i = 0; i < slides.length; i++) {
                slides[i].style.display = 'none'; // Sembunyikan semua slaid
                dots[i].classList.remove('active');
            }

            if(n > slides.length) slideIndex = 1;
            if(n < 1) slideIndex = slides.length;

            slides[slideIndex-1].style.display = 'block'; // Paparkan slaid aktif
            dots[slideIndex-1].classList.add('active');
            
            // Set kursor hanya untuk usim_map.png dalam slideshow
            if (slideIndex === 1) {
                mapImgInSlideshow.style.cursor = 'pointer';
            } else {
                mapImgInSlideshow.style.cursor = 'default';
            }
            console.log("Showing slide index:", slideIndex);

            // Pastikan navigasi kelihatan dalam mod slideshow
            prevBtn.style.display = 'block';
            nextBtn.style.display = 'block';
            dotsContainer.style.display = 'block';
            prevBtn.style.pointerEvents = 'auto';
            nextBtn.style.pointerEvents = 'auto';
            dotsContainer.style.pointerEvents = 'auto';
            prevBtn.style.opacity = '1';
            nextBtn.style.opacity = '1';
            dotsContainer.style.opacity = '1';

            // Sembunyikan tabel detail peta saat menampilkan slideshow
            mapTable.style.display = 'none'; 
        }

        function toggleMap(){
            if(mapDetailsMode){ // Jika butiran peta sedang dipaparkan (mod peta)
                console.log("Hiding map details and resuming slideshow.");
                mapTable.style.display = 'none'; // Sembunyikan jadual butiran
                mapOnlyView.style.display = 'none'; // Sembunyikan kontainer peta sahaja
                mapDetailsMode = false; // Update status

                slideshowContainer.style.display = 'block'; // Paparkan semula slideshow container

                autoPlay = true; // Benarkan auto-play semula
                startSlideshow(); // Mulakan semula slideshow
                showSlide(slideIndex); // Pastikan slaid semasa dipaparkan dengan betul
            } else { // Jika butiran peta tersembunyi (mod slideshow)
                console.log("Displaying map details and stopping slideshow.");
                stopSlideshow(); // Hentikan auto-play
                autoPlay = false; // Halang sebarang perubahan slaid automatik/manual
                mapDetailsMode = true; // Update status

                slideshowContainer.style.display = 'none'; // Sembunyikan keseluruhan slideshow
                
                mapOnlyView.style.display = 'block'; // Paparkan kontainer peta sahaja
                mapTable.style.display = 'block'; // Paparkan jadual butiran

                // Sembunyikan navigasi (kerana slideshow-container tersembunyi)
                prevBtn.style.display = 'none';
                nextBtn.style.display = 'none';
                dotsContainer.style.display = 'none';
            }
        }

        // Event Listener untuk klik pada imej USIM Map dalam slideshow
        mapImgInSlideshow.addEventListener('click', toggleMap);

        // Event Listener untuk klik pada imej peta di "map-only-view" untuk kembali
        mapImgFrozen.addEventListener('click', toggleMap);

        // Pengesetan awal semasa memuatkan halaman
        showSlide(slideIndex); // Paparkan slaid pertama (USIM Map) semasa dimuatkan
        startSlideshow();      // Mulakan slideshow secara automatik pada mulanya


        // --- Logout Confirmation Box ---
        logoutBtn.addEventListener('click', () => {
            logoutOverlay.style.display = 'flex'; // Show the overlay
        });

        logoutYesBtn.addEventListener('click', () => {
            // Implement your logout logic here
            // For example, redirect to a logout page:
            window.location.href = "register.jsp"; // Replace with your actual logout URL
            logoutOverlay.style.display = 'none'; // Hide the overlay
        });

        logoutNoBtn.addEventListener('click', () => {
            logoutOverlay.style.display = 'none'; // Hide the overlay
        });

        // Close the logout box if clicked outside
        logoutOverlay.addEventListener('click', (event) => {
            if (event.target === logoutOverlay) {
                logoutOverlay.style.display = 'none';
            }
        });

        // --- Navbar Navigation (Scroll & Display Logic) ---
        navHome.addEventListener('click', (event) => {
            event.preventDefault(); // Prevent default link behavior
            // Ensure slideshow mode is active before scrolling
            if (mapDetailsMode) {
                toggleMap(); // Go back to slideshow mode
                setTimeout(() => { // Small delay to allow elements to reset
                    aboutUsSection.scrollIntoView({ behavior: 'smooth' });
                }, 100);
            } else {
                aboutUsSection.scrollIntoView({ behavior: 'smooth' });
            }
        });

        navMap.addEventListener('click', (event) => {
            event.preventDefault(); // Prevent default link behavior
            if (!mapDetailsMode) { // If currently in slideshow mode, toggle to map details
                toggleMap();
            }
            mapSection.scrollIntoView({ behavior: 'smooth' });
        });

        navContact.addEventListener('click', (event) => {
            event.preventDefault(); // Prevent default link behavior
            // Ensure slideshow mode is active if we're scrolling to footer (not map)
            if (mapDetailsMode) {
                toggleMap(); // Go back to slideshow mode
                setTimeout(() => { // Small delay to allow elements to reset
                    footerSection.scrollIntoView({ behavior: 'smooth' });
                }, 100);
            } else {
                footerSection.scrollIntoView({ behavior: 'smooth' });
            }
        });

    </script>
</body>
</html>