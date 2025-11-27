<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存管理</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .title {
            font-size: 24px;
            color: #1a1a1a;
            margin: 0;
        }
        .search-box {
            display: flex;
            gap: 10px;
        }
        input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }
        .btn i {
            font-size: 16px;
        }
        .btn-primary {
            background-color: #6366f1;
            color: white;
        }
        .btn-warning {
            background-color: #f59e0b;
            color: white;
        }
        .btn-danger {
            background-color: #ef4444;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        th {
            background-color: #f8fafc;
            font-weight: 500;
            color: #64748b;
        }
        tr:hover {
            background-color: #f8fafc;
        }
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-normal {
            background-color: #22c55e;
            color: white;
        }
        .status-low {
            background-color: #f59e0b;
            color: white;
        }
        .status-expired {
            background-color: #ef4444;
            color: white;
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 20px;
        }
        .page-link {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            color: #6366f1;
            text-decoration: none;
        }
        .page-link.active {
            background-color: #6366f1;
            color: white;
            border-color: #6366f1;
        }
        .page-link:hover {
            background-color: #f8fafc;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary" style="margin-right:10px;">
                <i class="ri-arrow-left-line"></i> 返回主页
            </a>
            <div class="search-box">
                <form action="${pageContext.request.contextPath}/inventory" method="get" style="display: flex; gap: 10px;">
                    <input type="text" name="keyword" value="${keyword}" placeholder="搜索药品名称/编码/批次号">
                    <button type="submit" class="btn btn-primary">
                        <i class="ri-search-line"></i>搜索
                    </button>
                </form>
                <a href="${pageContext.request.contextPath}/inventory/check" class="btn btn-warning">
                    <i class="ri-alert-line"></i>库存预警
                </a>
                <a href="${pageContext.request.contextPath}/inventory/add" class="btn btn-primary">
                    <i class="ri-add-line"></i>新增
                </a>
            </div>
        </div>

        <table>
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
                        <td>${inventory.medicineCode}</td>
                        <td>${inventory.medicineName}</td>
                        <td>${inventory.batchNumber}</td>
                        <td>${inventory.quantity}</td>
                        <td><fmt:formatDate value="${inventory.productionDate}" pattern="yyyy-MM-dd"/></td>
                        <td><fmt:formatDate value="${inventory.expiryDate}" pattern="yyyy-MM-dd"/></td>
                        <td>${inventory.location}</td>
                        <td>
                            <span class="status status-${inventory.status}">
                                ${inventory.status == 'normal' ? '正常' : inventory.status == 'low' ? '库存不足' : '已过期'}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/inventory/edit/${inventory.inventoryId}" class="btn btn-primary">
                                <i class="ri-edit-line"></i>编辑
                            </a>
                            <a href="javascript:void(0)" onclick="deleteInventory(${inventory.inventoryId})" class="btn btn-danger">
                                <i class="ri-delete-bin-line"></i>删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

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
    </div>

    <script>
    function deleteInventory(id) {
        if (confirm('确定要删除这条库存记录吗？')) {
            window.location.href = '${pageContext.request.contextPath}/inventory/delete/' + id;
        }
    }
    </script>
</body>
</html> 