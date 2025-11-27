<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>员工管理 - 医药销售管理系统</title>
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
            <li><a href="${pageContext.request.contextPath}/employee" class="active"><i class="ri-team-fill"></i>员工管理</a></li>
            <li>
                <a href="#" onclick="toggleSubMenu(event)"><i class="ri-bar-chart-fill"></i>统计报表 <i class="ri-arrow-down-s-line"></i></a>
                <ul class="submenu" id="report-submenu">
                    <li><a href="${pageContext.request.contextPath}/report/finance">财务总销售金额报表</a></li>
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
            <h1><i class="ri-team-line"></i> 员工管理</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/employee/add" class="btn btn-primary">
                    <i class="ri-add-line"></i> 新增员工
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="ri-arrow-left-line"></i> 返回主页
                </a>
            </div>
        </div>

        <!-- 搜索区域 -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/employee" method="get" style="display: flex; gap: 12px; max-width: 400px;">
                    <input type="text" name="keyword" class="form-control" placeholder="搜索员工姓名、编码或职位..." value="${keyword}" style="flex: 1;">
                    <button type="submit" class="btn btn-primary">
                        <i class="ri-search-line"></i> 搜索
                    </button>
                </form>
            </div>
        </div>

        <!-- 员工列表 -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">员工列表</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>员工编码</th>
                                <th>姓名</th>
                                <th>性别</th>
                                <th>电话</th>
                                <th>邮箱</th>
                                <th>职位</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${employeeList}" var="employee">
                                <tr>
                                    <td style="font-weight: 500; color: var(--primary-color);">${employee.employeeCode}</td>
                                    <td style="font-weight: 500;">${employee.name}</td>
                                    <td>${employee.gender}</td>
                                    <td>${employee.phone}</td>
                                    <td>${employee.email}</td>
                                    <td>${employee.position}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${employee.status == '在职'}">
                                                <span class="status active">在职</span>
                                            </c:when>
                                            <c:when test="${employee.status == '离职'}">
                                                <span class="status inactive">离职</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status pending">${employee.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <a href="${pageContext.request.contextPath}/employee/edit/${employee.employeeId}"
                                               class="btn btn-sm btn-warning"
                                               title="编辑员工">
                                                <i class="ri-edit-line"></i> 编辑
                                            </a>
                                            <a href="${pageContext.request.contextPath}/employee/delete/${employee.employeeId}"
                                               class="btn btn-sm btn-danger"
                                               onclick="return confirm('确定要删除员工【${employee.name}】吗？此操作不可恢复！')"
                                               title="删除员工">
                                                <i class="ri-delete-bin-line"></i> 删除
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty employeeList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 60px; color: var(--text-secondary);">
                                        <i class="ri-team-line" style="font-size: 48px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                                        <br>暂无员工信息
                                        <br><small>点击"新增员工"开始管理您的员工</small>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- 分页 -->
                <c:if test="${not empty employeeList && totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a class="page-link ${i == page ? 'active' : ''}" href="${pageContext.request.contextPath}/employee?page=${i}&keyword=${keyword}">${i}</a>
                        </c:forEach>
                    </div>
                </c:if>
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