<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>库存管理 - 医药销售管理系统</title>
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
            <li><a href="${pageContext.request.contextPath}/inventory" class="active"><i class="ri-store-2-fill"></i>库存管理</a></li>
            <li><a href="${pageContext.request.contextPath}/sales"><i class="ri-shopping-cart-fill"></i>销售管理</a></li>
            <li><a href="${pageContext.request.contextPath}/purchase"><i class="ri-truck-fill"></i>进货管理</a></li>
            <li><a href="${pageContext.request.contextPath}/customer"><i class="ri-user-3-fill"></i>客户管理</a></li>
            <li><a href="${pageContext.request.contextPath}/supplier"><i class="ri-user-2-fill"></i>供应商管理</a></li>
            <li><a href="${pageContext.request.contextPath}/employee"><i class="ri-team-fill"></i>员工管理</a></li>
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
            <h1><i class="ri-store-2-line"></i> 库存管理</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/inventory/check" class="btn btn-warning">
                    <i class="ri-alert-line"></i> 库存预警
                </a>
                <a href="${pageContext.request.contextPath}/inventory/add" class="btn btn-primary">
                    <i class="ri-add-line"></i> 新增库存
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="ri-arrow-left-line"></i> 返回主页
                </a>
            </div>
        </div>

        <!-- 搜索区域 -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/inventory" method="get" style="display: flex; gap: 12px; max-width: 400px;">
                    <input type="text" name="keyword" class="form-control" placeholder="搜索药品名称、编码或批次号..." value="${keyword}" style="flex: 1;">
                    <button type="submit" class="btn btn-primary">
                        <i class="ri-search-line"></i> 搜索
                    </button>
                </form>
            </div>
        </div>

        <!-- 库存列表 -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">库存列表</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>药品编码</th>
                                <th>药品名称</th>
                                <th>批次号</th>
                                <th>数量</th>
                                <th>生产日期</th>
                                <th>有效期至</th>
                                <th>库位</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${inventoryList}" var="inventory">
                                <tr>
                                    <td style="font-weight: 500; color: var(--primary-color);">${inventory.medicineCode}</td>
                                    <td style="font-weight: 500;">${inventory.medicineName}</td>
                                    <td>${inventory.batchNumber}</td>
                                    <td style="font-weight: 600; color: var(--text-primary);">${inventory.quantity}</td>
                                    <td><fmt:formatDate value="${inventory.productionDate}" pattern="yyyy-MM-dd"/></td>
                                    <td><fmt:formatDate value="${inventory.expiryDate}" pattern="yyyy-MM-dd"/></td>
                                    <td>${inventory.location}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inventory.quantity > 50}">
                                                <span class="status active">正常</span>
                                            </c:when>
                                            <c:when test="${inventory.quantity > 10}">
                                                <span class="status pending">偏低</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status inactive">严重不足</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <a href="${pageContext.request.contextPath}/inventory/edit/${inventory.inventoryId}"
                                               class="btn btn-sm btn-warning"
                                               title="编辑库存">
                                                <i class="ri-edit-line"></i> 编辑
                                            </a>
                                            <a href="javascript:void(0)"
                                               onclick="deleteInventory('${inventory.inventoryId}', this.dataset.name)"
                                               data-name="${inventory.medicineName}"
                                               class="btn btn-sm btn-danger"
                                               title="删除库存">
                                                <i class="ri-delete-bin-line"></i> 删除
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty inventoryList}">
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 60px; color: var(--text-secondary);">
                                        <i class="ri-store-2-line" style="font-size: 48px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                                        <br>暂无库存数据
                                        <br><small>点击"新增库存"开始管理您的库存</small>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- 分页 -->
                <c:if test="${not empty inventoryList && totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${page > 1}">
                            <a href="${pageContext.request.contextPath}/inventory?page=${page-1}&keyword=${keyword}" class="page-link">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/inventory?page=${i}&keyword=${keyword}"
                               class="page-link ${i == page ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <c:if test="${page < totalPages}">
                            <a href="${pageContext.request.contextPath}/inventory?page=${page+1}&keyword=${keyword}" class="page-link">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
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

// 删除库存
function deleteInventory(id, medicineName) {
    // 转义单引号以防止JavaScript错误
    var escapedName = medicineName.replace(/'/g, "\\'");
    if (confirm('确定要删除药品【' + escapedName + '】的库存记录吗？此操作不可恢复！')) {
        window.location.href = '${pageContext.request.contextPath}/inventory/delete/' + parseInt(id);
    }
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 可以在这里添加页面初始化逻辑
});
</script>
</body>
</html> 