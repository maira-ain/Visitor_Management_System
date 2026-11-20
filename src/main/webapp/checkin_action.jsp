<%-- 
    Document   : checkin_action
    Created on : 29 Jun 2025, 12:15:01 pm
    Author     : Comp
--%>
    <%@page import="java.sql.DriverManager"%>
    <%@page import="java.sql.PreparedStatement"%>
    <%@page import="java.sql.Connection"%>
    <%@page import="java.sql.SQLException"%>
    <%@page import="java.sql.Timestamp"%>
    <%@page import="java.sql.ResultSet"%>
    <%@page contentType="application/json" pageEncoding="UTF-8"%>
    <%
        // Ensure this JSP is accessed via POST for security and proper data handling
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            out.print("{\"status\": \"error\", \"message\": \"Method Not Allowed\"}");
            return;
        }

        String checkinId = request.getParameter("checkin_id");
        String action = request.getParameter("action");

        String jsonResponse = "";
        Connection connection = null;
        PreparedStatement statement = null;

        if (checkinId == null || checkinId.isEmpty() || action == null || action.isEmpty()) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Missing required parameters for check-in/out action.\"}";
        } else {
            try {
                // Database Connection Details (same as other JSPs)
                String jdbcURL = "jdbc:mysql://localhost:3306/my_database2?useSSL=false&serverTimezone=UTC";
                String jdbcUsername = "root";
                String jdbcPassword = "";

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

                String sql = "";
                String updatedTimestamp = ""; // To store the timestamp from DB

                if ("checkin".equals(action)) {
                    // Only update if check_in_time is currently NULL (prevent double check-in)
                    sql = "UPDATE Checkin SET check_in_time = CURRENT_TIMESTAMP WHERE checkin_id = ? AND check_in_time IS NULL";
                } else if ("checkout".equals(action)) {
                    // Only update if check_out_time is currently NULL (prevent double check-out)
                    sql = "UPDATE Checkin SET check_out_time = CURRENT_TIMESTAMP WHERE checkin_id = ? AND check_out_time IS NULL";
                } else {
                    jsonResponse = "{\"status\": \"error\", \"message\": \"Invalid action specified.\"}";
                }

                if (!sql.isEmpty()) {
                    statement = connection.prepareStatement(sql);
                    statement.setString(1, checkinId);
                    int rowsAffected = statement.executeUpdate();
                    statement.close();

                    if (rowsAffected > 0) {
                        // Fetch the updated timestamp from the database to ensure consistency
                        String fetchTimestampSql;
                        if ("checkin".equals(action)) {
                            fetchTimestampSql = "SELECT check_in_time FROM Checkin WHERE checkin_id = ?";
                        } else { // checkout
                            fetchTimestampSql = "SELECT check_out_time FROM Checkin WHERE checkin_id = ?";
                        }
                        statement = connection.prepareStatement(fetchTimestampSql);
                        statement.setString(1, checkinId);
                        ResultSet rs = statement.executeQuery();
                        if (rs.next()) {
                            Timestamp ts = rs.getTimestamp(1);
                            if (ts != null) {
                                // Format the timestamp for display if needed, or send as is
                                updatedTimestamp = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(ts);
                            }
                        }
                        rs.close();
                        statement.close();

                        jsonResponse = "{\"status\": \"success\", \"message\": \"" + action + " recorded!\", \"timestamp\": \"" + updatedTimestamp + "\"}";
                    } else {
                        // This means the update didn't happen (e.g., already checked in/out)
                        jsonResponse = "{\"status\": \"error\", \"message\": \"" + action + " failed. Perhaps already recorded or invalid ID.\"}";
                    }
                }

            } catch (SQLException e) {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Database error: " + e.getMessage().replace("\"", "\\\"") + "\"}";
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                jsonResponse = "{\"status\": \"error\", \"message\": \"JDBC Driver not found.\"}";
                e.printStackTrace();
            } catch (Exception e) {
                jsonResponse = "{\"status\": \"error\", \"message\": \"An unexpected error occurred: " + e.getMessage().replace("\"", "\\\"") + "\"}";
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