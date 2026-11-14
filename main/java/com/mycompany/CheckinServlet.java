// src/main/java/com/yourpackage/CheckinServlet.java
package com.mycompany; // FIX: Changed to a common default package name, adjust if different

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/checkin") // This annotation maps the servlet to the URL /checkin
public class CheckinServlet extends HttpServlet {

    // Database Connection Details (consider moving these to a separate config file or context parameters)
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/my_database2?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Initialize variables to pass to JSP
        String checkinId = null;
        int detailId = -1;
        String message = "";
        String messageType = "";
        String currentCheckinStatus = "Not Checked In";
        String checkInTime = "N/A";
        String checkOutTime = "N/A";

        // FIX: Declare alreadyCheckedIn and alreadyCheckedOut here, outside the try block
        boolean alreadyCheckedIn = false;
        boolean alreadyCheckedOut = false;


        // 1. Safely retrieve parameters from the request
        checkinId = request.getParameter("checkin_id");
        String detailIdStr = request.getParameter("detail_id");
        String action = request.getParameter("action"); // checkin or checkout action

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            // Validate checkinId
            if (checkinId == null || checkinId.trim().isEmpty()) {
                response.sendRedirect("error.jsp?msg=" + java.net.URLEncoder.encode("Check-in ID is missing.", "UTF-8"));
                return;
            }

            // Validate detailId (robust parsing with null and NumberFormatException check)
            if (detailIdStr != null && !detailIdStr.trim().isEmpty()) {
                try {
                    detailId = Integer.parseInt(detailIdStr);
                } catch (NumberFormatException e) {
                    // Handle case where detailId is not a valid number
                    response.sendRedirect("error.jsp?msg=" + java.net.URLEncoder.encode("Invalid Visitor Detail ID format.", "UTF-8"));
                    return;
                }
            } else {
                response.sendRedirect("error.jsp?msg=" + java.net.URLEncoder.encode("Visitor Detail ID is missing.", "UTF-8"));
                return;
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);

            // Fetch current checkin status
            String selectCheckinSql = "SELECT check_in_time, check_out_time FROM Checkin WHERE checkin_id = ? AND detail_id = ?";
            statement = connection.prepareStatement(selectCheckinSql);
            statement.setString(1, checkinId);
            statement.setInt(2, detailId);
            rs = statement.executeQuery();

            Timestamp dbCheckInTime = null;
            Timestamp dbCheckOutTime = null;

            if (rs.next()) {
                dbCheckInTime = rs.getTimestamp("check_in_time");
                dbCheckOutTime = rs.getTimestamp("check_out_time");

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                if (dbCheckInTime != null) {
                    alreadyCheckedIn = true; // Value assigned inside try block
                    checkInTime = sdf.format(dbCheckInTime);
                    currentCheckinStatus = "Checked In";
                }
                if (dbCheckOutTime != null) {
                    alreadyCheckedOut = true; // Value assigned inside try block
                    checkOutTime = sdf.format(dbCheckOutTime);
                    currentCheckinStatus = "Checked Out";
                } else if (alreadyCheckedIn) {
                    currentCheckinStatus = "Checked In (awaiting checkout)";
                }
            } else {
                message = "Error: Check-in entry not found for this QR code.";
                messageType = "error";
                // Do not proceed if check-in entry is not found
                response.sendRedirect("error.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                return;
            }

            // Action based on request parameter
            Timestamp now = new Timestamp(System.currentTimeMillis());
            if ("checkin".equals(action)) {
                if (!alreadyCheckedIn) {
                    String updateSql = "UPDATE Checkin SET check_in_time = ? WHERE checkin_id = ?";
                    try (PreparedStatement updateStatement = connection.prepareStatement(updateSql)) {
                        updateStatement.setTimestamp(1, now);
                        updateStatement.setString(2, checkinId);
                        int updatedRows = updateStatement.executeUpdate();
                        if (updatedRows > 0) {
                            message = "Checked in successfully!";
                            messageType = "success";
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            checkInTime = sdf.format(now);
                            currentCheckinStatus = "Checked In";
                            alreadyCheckedIn = true; // Update state after successful check-in
                        } else {
                            message = "Failed to record check-in.";
                            messageType = "error";
                        }
                    }
                } else {
                    message = "You are already checked in.";
                    messageType = "info";
                }
            } else if ("checkout".equals(action)) {
                if (alreadyCheckedIn && !alreadyCheckedOut) {
                    String updateSql = "UPDATE Checkin SET check_out_time = ? WHERE checkin_id = ?";
                    try (PreparedStatement updateStatement = connection.prepareStatement(updateSql)) {
                        updateStatement.setTimestamp(1, now);
                        updateStatement.setString(2, checkinId);
                        int updatedRows = updateStatement.executeUpdate();
                        if (updatedRows > 0) {
                            message = "Checked out successfully!";
                            messageType = "success";
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            checkOutTime = sdf.format(now);
                            currentCheckinStatus = "Checked Out";
                            alreadyCheckedOut = true; // Update state after successful check-out
                        } else {
                            message = "Failed to record check-out.";
                            messageType = "error";
                        }
                    }
                } else if (!alreadyCheckedIn) {
                    message = "You must check in first before checking out.";
                    messageType = "info";
                } else if (alreadyCheckedOut) {
                    message = "You have already checked out.";
                    messageType = "info";
                }
            }

        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            message = "JDBC Driver not found. Please ensure MySQL Connector/J is in your classpath.";
            messageType = "error";
            e.printStackTrace();
        } catch (NumberFormatException e) {
            message = "Invalid ID format in QR data: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        } catch (Exception e) {
            message = "An unexpected error occurred: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        } finally {
            // Close resources in finally block
            try {
                if (rs != null) rs.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 2. Set attributes in the request scope to pass data to the JSP
        request.setAttribute("checkinId", checkinId);
        request.setAttribute("detailId", detailId);
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.setAttribute("currentCheckinStatus", currentCheckinStatus);
        request.setAttribute("checkInTime", checkInTime);
        request.setAttribute("checkOutTime", checkOutTime);
        request.setAttribute("alreadyCheckedIn", alreadyCheckedIn);
        request.setAttribute("alreadyCheckedOut", alreadyCheckedOut);

        // 3. Forward the request to the JSP page
        request.getRequestDispatcher("/scan_qr.jsp").forward(request, response);
    }
}
