<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>登录 - 灵药苍穹</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/static/pharmacy-bg.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 48px 40px 40px 40px;
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            z-index: 2;
            border: 3px solid;
            border-image: linear-gradient(135deg, #6366f1 0%, #8b5cf6 60%, #a78bfa 100%) 1;
            backdrop-filter: blur(10px);
        }
        .system-name {
            text-align: center;
            margin-bottom: 24px;
            background: linear-gradient(90deg, #6366f1, #8b5cf6, #a78bfa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 30px;
            font-weight: bold;
            letter-spacing: 2px;
        }
        .system-description {
            text-align: center;
            color: #7c3aed;
            margin-bottom: 30px;
            font-size: 15px;
        }
        .btn-primary {
            background: linear-gradient(90deg, #6366f1, #8b5cf6, #a78bfa);
            border: none;
            font-weight: bold;
            letter-spacing: 1px;
            box-shadow: 0 2px 8px rgba(99,102,241,0.13);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #7c3aed, #6366f1);
            transform: scale(1.04);
            box-shadow: 0 4px 16px rgba(99,102,241,0.18);
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="system-name">
        <i class="ri-capsule-fill"></i> 灵药苍穹
    </div>
    <div class="system-description">如掌药于云端，数据化运营，销售如神助。</div>
    <h3 class="mb-4">用户登录</h3>
    <form action="${pageContext.request.contextPath}/user/login" method="post">
        <div class="mb-3">
            <label class="form-label">用户名</label>
            <input type="text" name="username" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">密码</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <button type="submit" class="btn btn-primary w-100">登录</button>
        <div class="mt-3 text-center">
            <a href="${pageContext.request.contextPath}/user/register">没有账号？注册</a>
        </div>
    </form>
</div>
</body>
</html> 