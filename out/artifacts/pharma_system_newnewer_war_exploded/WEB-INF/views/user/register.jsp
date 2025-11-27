<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>注册 - 灵药苍穹</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f0f2f5 0%, #e6e9f0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }
        .system-name {
            text-align: center;
            margin-bottom: 30px;
            color: #6366f1;
            font-size: 24px;
            font-weight: bold;
        }
        .system-description {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .btn-success {
            background: linear-gradient(45deg, #10b981, #059669);
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(45deg, #059669, #047857);
        }
    </style>
</head>
<body>
<div class="register-container">
    <div class="system-name">
        <i class="ri-capsule-fill"></i> 灵药苍穹
    </div>
    <div class="system-description">如掌药于云端，数据化运营，销售如神助。</div>
    <h3 class="mb-4">用户注册</h3>
    <form action="${pageContext.request.contextPath}/user/register" method="post">
        <div class="mb-3">
            <label class="form-label">用户名</label>
            <input type="text" name="username" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">密码</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-control">
        </div>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <button type="submit" class="btn btn-success w-100">注册</button>
        <div class="mt-3 text-center">
            <a href="${pageContext.request.contextPath}/user/login">已有账号？登录</a>
        </div>
    </form>
</div>
</body>
</html> 