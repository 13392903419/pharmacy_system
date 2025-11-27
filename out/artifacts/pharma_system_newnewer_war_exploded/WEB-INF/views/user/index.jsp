<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.pharma.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>用户主页</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h3>欢迎，<%= user.getUsername() %>！</h3>
    <a href="<%= request.getContextPath() %>/user/logout" class="btn btn-danger mt-3">退出登录</a>
</div>
</body>
</html> 