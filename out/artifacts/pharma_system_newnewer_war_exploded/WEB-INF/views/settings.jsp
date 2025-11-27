<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统设置 - 灵药苍穹</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #ff6b6b 0%, #ffd93d 100%);
            min-height: 100vh;
        }
        .layout {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #ff6b6b 0%, #ffd93d 100%);
            color: white;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }
        .logo {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .menu li {
            margin-bottom: 10px;
        }
        .menu a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.3s;
            gap: 10px;
        }
        .menu a:hover {
            background-color: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
        }
        .menu i {
            width: 20px;
        }
        .main-content {
            flex: 1;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .system-info {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .system-info:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .system-name {
            font-size: 36px;
            font-weight: bold;
            color: #ff6b6b;
            margin-bottom: 10px;
            text-align: center;
        }
        .system-description {
            font-size: 18px;
            color: #666;
            text-align: center;
            margin-bottom: 30px;
        }
        .designers {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .designers:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .designers h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .designer-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .designer-list li {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            color: #666;
            transition: color 0.3s;
        }
        .designer-list li:hover {
            color: #ff6b6b;
        }
        .slogan {
            background: linear-gradient(45deg, #ff6b6b, #ffd93d);
            padding: 40px;
            border-radius: 10px;
            text-align: center;
            color: white;
            margin-top: 30px;
            position: relative;
            transition: transform 0.3s, box-shadow 0.3s;
            overflow: hidden;
        }
        .slogan::before {
            content: '';
            position: absolute;
            left: 0; top: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.25);
            z-index: 1;
        }
        .slogan:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .slogan-text {
            font-size: 32px;
            font-weight: bold;
            margin: 0;
            background: linear-gradient(45deg, #ff6b6b, #ffd93d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.45), 0 0 2px #fff;
            position: relative;
            z-index: 2;
        }
        .tm-symbol {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 14px;
            font-weight: bold;
            color: rgba(255,255,255,0.8);
            z-index: 2;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
<div class="layout">
    <div class="sidebar">
        <div class="logo">
            <i class="ri-capsule-fill"></i>
            灵药苍穹
        </div>
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="ri-dashboard-fill"></i>控制面板</a></li>
            <li><a href="${pageContext.request.contextPath}/medicine"><i class="ri-medicine-bottle-fill"></i>药品管理</a></li>
            <li><a href="${pageContext.request.contextPath}/inventory"><i class="ri-store-2-fill"></i>库存管理</a></li>
            <li><a href="${pageContext.request.contextPath}/sales"><i class="ri-shopping-cart-fill"></i>销售管理</a></li>
            <li><a href="${pageContext.request.contextPath}/purchase"><i class="ri-truck-fill"></i>进货管理</a></li>
            <li><a href="${pageContext.request.contextPath}/customer"><i class="ri-user-3-fill"></i>客户管理</a></li>
            <li><a href="${pageContext.request.contextPath}/supplier"><i class="ri-user-2-fill"></i>供应商管理</a></li>
            <li><a href="${pageContext.request.contextPath}/employee"><i class="ri-team-fill"></i>员工管理</a></li>
            <li><a href="${pageContext.request.contextPath}/report"><i class="ri-bar-chart-fill"></i>统计报表</a></li>
            <li><a href="${pageContext.request.contextPath}/settings"><i class="ri-settings-3-fill"></i>系统设置</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>系统设置</h1>
        </div>

        <div class="system-info">
            <div class="system-name">灵药苍穹 (ElixirSky)</div>
            <div class="system-description">如掌药于云端，数据化运营，销售如神助。</div>
        </div>

        <div class="designers">
            <h2>设计团队</h2>
            <div style="display: flex; gap: 40px; justify-content: center; align-items: flex-start;">
                <div style="text-align:center;">
                    <img src="${pageContext.request.contextPath}/static/partners/photo1.jpg" alt="合伙人1" style="width:120px;height:120px;object-fit:cover;border-radius:16px;border:2px solid #eee;box-shadow:0 2px 8px #eee;">
                    <div style="margin-top:8px;font-weight:bold;font-size:16px;">张耀元</div>
                </div>
                <div style="text-align:center;">
                    <img src="${pageContext.request.contextPath}/static/partners/photo2.jpg" alt="合伙人2" style="width:120px;height:120px;object-fit:cover;border-radius:16px;border:2px solid #eee;box-shadow:0 2px 8px #eee;">
                    <div style="margin-top:8px;font-weight:bold;font-size:16px;">刘宇菲</div>
                </div>
                <div style="text-align:center;">
                    <img src="${pageContext.request.contextPath}/static/partners/photo3.jpg" alt="合伙人3" style="width:120px;height:120px;object-fit:cover;border-radius:16px;border:2px solid #eee;box-shadow:0 2px 8px #eee;">
                    <div style="margin-top:8px;font-weight:bold;font-size:16px;">林思淇</div>
                </div>
                <div style="text-align:center;">
                    <img src="${pageContext.request.contextPath}/static/partners/photo4.jpg" alt="合伙人4" style="width:120px;height:120px;object-fit:cover;border-radius:16px;border:2px solid #eee;box-shadow:0 2px 8px #eee;">
                    <div style="margin-top:8px;font-weight:bold;font-size:16px;">李林慧</div>
                </div>
            </div>
        </div>

        <div class="slogan">
            <span class="tm-symbol">™</span>
            <p class="slogan-text">耀破苍穹，淇动九霄，慧眼千里，菲凡制胜——药霸天，来了！？</p>
        </div>
    </div>
</div>
</body>
</html>