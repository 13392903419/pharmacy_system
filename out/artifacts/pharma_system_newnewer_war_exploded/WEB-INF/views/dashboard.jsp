<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>医药销售管理系统</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .layout {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background: #6366f1;
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
            transition: background-color 0.3s;
            gap: 10px;
        }
        .menu a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        .menu i {
            width: 20px;
        }
        .main-content {
            flex: 1;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.95);
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
        .welcome {
            font-size: 24px;
            color: #1a1a1a;
        }
        .date {
            color: #666;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            margin: 0;
            font-size: 32px;
            color: #6366f1;
        }
        .stat-card p {
            margin: 5px 0 0;
            color: #666;
        }
        .quick-actions {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .quick-actions h2 {
            margin: 0 0 20px;
            color: #1a1a1a;
        }
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .action-button {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
            border-radius: 10px;
            background: #f8fafc;
            text-decoration: none;
            color: #1a1a1a;
            transition: transform 0.2s;
        }
        .action-button:hover {
            transform: translateY(-2px);
        }
        .action-button i {
            font-size: 24px;
            margin-bottom: 10px;
            color: #6366f1;
        }
        .recent-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .recent-section h2 {
            margin: 0 0 20px;
            color: #1a1a1a;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .notification-count {
            background: #ef4444;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 12px;
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
                <div>
                    <h1 class="welcome">欢迎回来，系统管理员！</h1>
                    <p class="date">今天是 2025年6月13日星期五，祝您工作愉快！</p>
                </div>
                <div class="user-info">
                    <span class="notification-count">3</span>
                    <i class="ri-notification-3-fill"></i>
                    <span>系统管理员</span>
                    <i class="ri-arrow-down-s-line"></i>
                </div>
            </div>

            <div class="stats">
                <div class="stat-card">
                    <h3>156</h3>
                    <p>药品总数</p>
                </div>
                <div class="stat-card">
                    <h3>89</h3>
                    <p>今日销售</p>
                </div>
                <div class="stat-card">
                    <h3 style="color: #6366f1; font-size: 32px; margin: 0; text-align: center;">${warningCount}</h3>
                    <p style="margin: 5px 0 0; color: #666; text-align: center;">库存预警</p>
                    <p style="text-align: center; margin: 8px 0 0;"><a href="${pageContext.request.contextPath}/inventory/check" style="color: #6366f1; text-decoration: underline; font-size: 14px;">查看详情</a></p>
                </div>
                <div class="stat-card">
                    <h3>45</h3>
                    <p>待处理订单</p>
                </div>
            </div>

            <div class="quick-actions">
                <h2><i class="ri-flashlight-fill"></i> 快速操作</h2>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/medicine/add" class="action-button">
                        <i class="ri-add-circle-fill"></i>
                        添加药品
                    </a>
                    <a href="${pageContext.request.contextPath}/sales/add" class="action-button">
                        <i class="ri-shopping-cart-2-fill"></i>
                        销售开单
                    </a>
                    <a href="${pageContext.request.contextPath}/purchase/add" class="action-button">
                        <i class="ri-truck-fill"></i>
                        进货入库
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory/check" class="action-button">
                        <i class="ri-search-2-line"></i>
                        库存查询
                    </a>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px;">
                <div class="recent-section">
                    <h2><i class="ri-time-fill"></i> 最近销售</h2>
                    <!-- 这里添加最近销售的列表 -->
                </div>
                <div class="recent-section">
                    <h2><i class="ri-alert-fill"></i> 库存预警</h2>
                    <!-- 这里添加库存预警的列表 -->
                </div>
            </div>
        </div>
    </div>
</body>
</html> 