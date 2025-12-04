<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>财务报表 - 医药销售管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/global.css" rel="stylesheet">
</head>
<body>
<div class="layout">
    <!-- 侧边栏 -->
    <div class="sidebar">
        <div class="logo">
            <i class="ri-capsule-fill"></i>
            医药管理系统
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
                <a href="#" onclick="toggleSubMenu(event)" class="active"><i class="ri-bar-chart-fill"></i>统计报表 <i class="ri-arrow-down-s-line"></i></a>
                <ul class="submenu show" id="report-submenu">
                    <li><a href="${pageContext.request.contextPath}/report/finance" class="active">财务总销售金额报表</a></li>
                    <li><a href="${pageContext.request.contextPath}/report/employee-position">员工职位报表</a></li>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/ai-chat"><i class="ri-robot-fill"></i>AI助手</a></li>
            <li><a href="${pageContext.request.contextPath}/settings"><i class="ri-settings-3-fill"></i>系统设置</a></li>
        </ul>
    </div>

    <!-- 主内容区域 -->
    <div class="main-content">
        <div class="header">
            <h1><i class="ri-money-dollar-circle-line"></i> 财务总销售金额报表</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="ri-arrow-left-line"></i> 返回主页
                </a>
            </div>
        </div>

        <!-- 财务概览 -->
        <div class="stats-grid" style="margin-bottom: 24px;">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="ri-money-dollar-circle-fill"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-value">￥${totalIncome}</div>
                    <div class="stat-label">总收入</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="ri-shopping-bag-fill"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-value">￥${totalExpense}</div>
                    <div class="stat-label">总支出</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="ri-calculator-fill"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-value">￥${totalIncome - totalExpense}</div>
                    <div class="stat-label">净利润</div>
                </div>
            </div>
        </div>

        <!-- 财务明细列表 -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><i class="ri-file-list-line"></i> 财务明细</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>类型</th>
                                <th>客户/供应商</th>
                                <th>单号</th>
                                <th>金额</th>
                                <th>时间</th>
                                <th>备注</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${financeList}" var="item">
                                <tr>
                                    <td>
                                        <span class="status-badge ${item.type == '销售收入' ? 'status-completed' : 'status-pending'}">
                                            ${item.type}
                                        </span>
                                    </td>
                                    <td style="font-weight: 500;">${item.customerName}</td>
                                    <td style="font-family: monospace; color: var(--primary-color);">${item.salesCode}</td>
                                    <td style="font-weight: 600; color: ${item.amountColor}; font-size: 16px;">
                                        ￥${item.amountDisplay}
                                    </td>
                                    <td>${item.createdAt}</td>
                                    <td style="color: var(--text-secondary);">${item.remark}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty financeList}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 60px; color: var(--text-secondary);">
                                        <i class="ri-file-list-line" style="font-size: 48px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                                        <br>暂无财务数据
                                        <br><small>系统将显示销售和采购的财务记录</small>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 切换子菜单显示
function toggleSubMenu(event) {
    event.preventDefault();
    const submenu = document.getElementById('report-submenu');
    const arrow = event.currentTarget.querySelector('.ri-arrow-down-s-line, .ri-arrow-up-s-line');

    if (submenu.classList.contains('show')) {
        submenu.classList.remove('show');
        arrow.className = 'ri-arrow-down-s-line';
    } else {
        submenu.classList.add('show');
        arrow.className = 'ri-arrow-up-s-line';
    }
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 可以在这里添加页面初始化逻辑
});
</script>
</body>
</html>
