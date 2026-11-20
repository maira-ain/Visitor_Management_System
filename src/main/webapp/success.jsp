<%-- 
    Document   : success
    Created on : 28 Jun 2025, 10:50:22 pm
    Author     : Comp
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Success</title>
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background: url(usim.jpg) no-repeat center center fixed;
            background-size: cover;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            flex-direction: column;
        }
        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            color: #333;
            max-width: 500px;
            width: 90%;
        }
        h1 {
            color: #28a745; /* Green color for success */
            margin-bottom: 20px;
            font-size: 2em;
        }
        p {
            font-size: 1.1em;
            margin-bottom: 30px;
        }
        .btn {
            background-color: #007bff; /* Blue button */
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 1em;
            transition: background-color 0.3s ease;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Success!</h1>
        <%
            String successMessage = request.getParameter("message");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
            <p><%= successMessage %></p>
        <%
            } else {
        %>
            <p>Your action was successful.</p>
        <%
            }
        %>
        <a href="register.jsp" class="btn">Proceed to Sign-in</a>
    </div>
</body>
</html>