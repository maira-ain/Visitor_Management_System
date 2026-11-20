<%-- 
    Document   : update_location
    Created on : 29 Jun 2025, 1:32:55 am
    Author     : Comp
--%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Timestamp"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
    // Ensure this JSP is accessed via POST for security and proper data handling
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        out.print("{\"status\": \"error\", \"message\": \"Method Not Allowed\"}");
        return;
    }

    String checkinId = request.getParameter("checkin_id");
    String latitudeStr = request.getParameter("latitude");
    String longitudeStr = request.getParameter("longitude");

    String jsonResponse = "";
    Connection connection = null;
    PreparedStatement statement = null;

    if (checkinId == null || checkinId.isEmpty() || latitudeStr == null || latitudeStr.isEmpty() || longitudeStr == null || longitudeStr.isEmpty()) {
        jsonResponse = "{\"status\": \"error\", \"message\": \"Missing required parameters.\"}";
    } else {
        try {
            double latitude = Double.parseDouble(latitudeStr);
            double longitude = Double.parseDouble(longitudeStr);

            // Database Connection Details (same as other JSPs)
            String jdbcURL = "jdbc:mysql://localhost:3306/my_database2?useSSL=false&serverTimezone=UTC";
            String jdbcUsername = "root";
            String jdbcPassword = "";

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            // Check if an entry for this checkin_id already exists in Live_location_qr
            // If it exists, update; otherwise, insert.
            String selectSql = "SELECT COUNT(*) FROM Live_location_qr WHERE checkin_id = ?";
            statement = connection.prepareStatement(selectSql);
            statement.setString(1, checkinId);
            ResultSet rs = statement.executeQuery();
            rs.next();
            int count = rs.getInt(1);
            rs.close();
            statement.close();

            if (count > 0) {
                // Update existing record
                String updateSql = "UPDATE Live_location_qr SET latitude = ?, longitude = ?, updated_at = CURRENT_TIMESTAMP WHERE checkin_id = ?";
                statement = connection.prepareStatement(updateSql);
                statement.setDouble(1, latitude);
                statement.setDouble(2, longitude);
                statement.setString(3, checkinId);
            } else {
                // Insert new record (assuming location_id is auto-increment or not needed for update)
                // If location_id is PK and not auto-increment, you'll need to generate a UUID here.
                // For simplicity, let's assume it's auto-increment or handled by DB.
                // If not, replace "NULL" with a generated UUID or similar.
                String insertSql = "INSERT INTO Live_location_qr (checkin_id, latitude, longitude, updated_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
                statement = connection.prepareStatement(insertSql);
                statement.setString(1, checkinId);
                statement.setDouble(2, latitude);
                statement.setDouble(3, longitude);
            }

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                jsonResponse = "{\"status\": \"success\", \"message\": \"Location updated.\"}";
            } else {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Failed to update/insert location.\"}";
            }

        } catch (NumberFormatException e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Invalid latitude or longitude format.\"}";
            e.printStackTrace();
        } catch (SQLException e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Database error: " + e.getMessage() + "\"}";
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"JDBC Driver not found.\"}";
            e.printStackTrace();
        } catch (Exception e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"An unexpected error occurred: " + e.getMessage() + "\"}";
            e.printStackTrace();
        } finally {
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    out.print(jsonResponse);
%>