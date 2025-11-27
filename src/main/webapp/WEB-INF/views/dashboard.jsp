<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>医药销售管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/global.css" rel="stylesheet">
</head>
<body>
<div class="layout">
    <div class="sidebar">
        <div class="logo">
            <i class="ri-capsule-fill"></i>
            医药销售管理系统
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
            <li>
                <a href="#" onclick="toggleSubMenu(event)"><i class="ri-bar-chart-fill"></i>统计报表 <i class="ri-arrow-down-s-line"></i></a>
                <ul class="submenu" style="display:none;">
                    <li><a href="${pageContext.request.contextPath}/report/finance">财务总销售金额报表</a></li>
                    <li><a href="${pageContext.request.contextPath}/report/employee-position">员工职位报表</a></li>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/ai-chat"><i class="ri-robot-fill"></i>灵药AI</a></li>
            <li><a href="${pageContext.request.contextPath}/settings"><i class="ri-settings-3-fill"></i>系统设置</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <div>
                <h1 style="margin: 0; color: var(--text-primary);">欢迎回来，系统管理员！</h1>
                <p style="margin: 8px 0 0 0; color: var(--text-secondary);">今天是 ${todayStr}，祝您工作愉快！</p>
            </div>
            <div style="display: flex; align-items: center; gap: 16px;">
                <div style="position: relative;">
                    <i class="ri-notification-3-fill" style="font-size: 24px; color: var(--text-secondary); cursor: pointer;"></i>
                    <span style="position: absolute; top: -8px; right: -8px; background: var(--danger-color); color: white; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 500;">3</span>
                </div>
                <span style="font-weight: 500; color: var(--text-primary);">系统管理员</span>
                <i class="ri-arrow-down-s-line" style="color: var(--text-secondary);"></i>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon"><i class="ri-medicine-bottle-line"></i></div>
                <h3>${medicineCount}</h3>
                <p>药品总数</p>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="ri-shopping-cart-line"></i></div>
                <h3>${todaySalesCount}</h3>
                <p>今日销售</p>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="ri-alert-line"></i></div>
                <h3>${warningCount}</h3>
                <p>库存预警</p>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="ri-file-list-line"></i></div>
                <h3>${pendingOrderCount}</h3>
                <p>待处理订单</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><i class="ri-flashlight-fill"></i> 快速操作</h3>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                    <a href="${pageContext.request.contextPath}/medicine/add" style="display: flex; flex-direction: column; align-items: center; padding: 20px; border-radius: var(--border-radius); background: var(--light-bg); text-decoration: none; color: var(--text-primary); transition: all 0.3s ease;">
                        <i class="ri-add-circle-fill" style="font-size: 32px; color: var(--primary-color); margin-bottom: 12px;"></i>
                        <span style="font-weight: 500;">添加药品</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/sales/add" style="display: flex; flex-direction: column; align-items: center; padding: 20px; border-radius: var(--border-radius); background: var(--light-bg); text-decoration: none; color: var(--text-primary); transition: all 0.3s ease;">
                        <i class="ri-shopping-cart-2-fill" style="font-size: 32px; color: var(--primary-color); margin-bottom: 12px;"></i>
                        <span style="font-weight: 500;">销售开单</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/purchase/add" style="display: flex; flex-direction: column; align-items: center; padding: 20px; border-radius: var(--border-radius); background: var(--light-bg); text-decoration: none; color: var(--text-primary); transition: all 0.3s ease;">
                        <i class="ri-truck-fill" style="font-size: 32px; color: var(--primary-color); margin-bottom: 12px;"></i>
                        <span style="font-weight: 500;">进货入库</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory/check" style="display: flex; flex-direction: column; align-items: center; padding: 20px; border-radius: var(--border-radius); background: var(--light-bg); text-decoration: none; color: var(--text-primary); transition: all 0.3s ease;">
                        <i class="ri-search-2-line" style="font-size: 32px; color: var(--primary-color); margin-bottom: 12px;"></i>
                        <span style="font-weight: 500;">库存查询</span>
                    </a>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="ri-time-fill"></i> 最近销售</h3>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty recentSales}">
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <c:forEach var="sale" items="${recentSales}">
                                    <div style="padding: 16px; background: var(--light-bg); border-radius: var(--border-radius); border: 1px solid var(--border-color);">
                                        <div style="display: flex; flex-direction: column; gap: 8px;">
                                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                                <span style="font-weight: 500; color: var(--text-primary);">${sale.salesCode}</span>
                                                <span style="font-weight: 600; color: var(--success-color);">￥${sale.totalAmount}</span>
                                            </div>
                                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                                <span class="status ${sale.status == 'completed' ? 'active' : sale.status == 'pending' ? 'pending' : 'inactive'}">
                                                    ${sale.status == 'completed' ? '已完成' : sale.status == 'pending' ? '待处理' : '已取消'}
                                                </span>
                                                <span style="font-size: 12px; color: var(--text-secondary);">${sale.createdAt}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; color: var(--text-secondary); padding: 40px; font-size: 14px;">
                                <i class="ri-shopping-bag-line" style="font-size: 48px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                                <br>最近未销售商品
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="ri-alert-fill"></i> 库存预警</h3>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty recentWarnings}">
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <c:forEach var="warning" items="${recentWarnings}">
                                    <div style="padding: 16px; background: var(--light-bg); border-radius: var(--border-radius); border: 1px solid var(--border-color);">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <i class="ri-alert-line" style="color: var(--warning-color);"></i>
                                            <span style="font-weight: 500; color: var(--text-primary);">${warning.medicineName}</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; color: var(--text-secondary); padding: 40px; font-size: 14px;">
                                <i class="ri-check-circle-line" style="font-size: 48px; color: var(--success-color); margin-bottom: 16px;"></i>
                                <br>没有库存预警
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function toggleSubMenu(e) {
        e.preventDefault();
        var submenu = e.target.closest('li').querySelector('.submenu');
        if (submenu) {
            submenu.style.display = submenu.style.display === 'none' ? 'block' : 'none';
        }
    }
</script>
</body>
</html>
