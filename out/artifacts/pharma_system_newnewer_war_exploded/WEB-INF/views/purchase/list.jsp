<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>进货管理</title>
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
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .title {
            font-size: 24px;
            color: #1a1a1a;
        }
        .search-box {
            display: flex;
            gap: 10px;
        }
        .search-input {
            width: 200px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn i {
            font-size: 16px;
        }
        .btn-primary {
            background-color: #6366f1;
            color: white;
        }
        .btn-secondary {
            background-color: #64748b;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background-color: #f8fafc;
            font-weight: 500;
            color: #64748b;
        }
        tr:hover {
            background-color: #f8fafc;
        }
        .action-btn {
            padding: 4px 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            margin-right: 4px;
        }
        .edit-btn {
            background-color: #eab308;
            color: white;
        }
        .delete-btn {
            background-color: #ef4444;
            color: white;
        }
        .pagination {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 5px;
        }
        .page-number {
            padding: 8px 12px;
            border: none;
            background-color: #6366f1;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .page-number.active {
            background-color: #4f46e5;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fef3c7;
            color: #d97706;
        }
        .status-completed {
            background-color: #dcfce7;
            color: #15803d;
        }
        .status-cancelled {
            background-color: #fee2e2;
            color: #b91c1c;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 class="title">进货管理</h1>
            <div class="search-box">
                <input type="text" class="search-input" placeholder="搜索进货单号..." value="${keyword}">
                <a href="${pageContext.request.contextPath}/purchase/add" class="btn btn-primary">
                    <i class="ri-add-line"></i>新增进货单
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="ri-arrow-left-line"></i>返回主页
                </a>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>进货单号</th>
                    <th>供应商</th>
                    <th>采购员</th>
                    <th>总金额</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${purchaseOrderList}" var="order">
                    <tr>
                        <td>${order.purchaseCode}</td>
                        <td>
                            <c:forEach items="${supplierList}" var="supplier">
                                <c:if test="${supplier.supplierId == order.supplierId}">
                                    ${supplier.name}
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>${order.employeeId}</td>
                        <td>￥${order.totalAmount}</td>
                        <td>
                            <span class="status-badge ${order.status == 'pending' ? 'status-pending' : order.status == 'completed' ? 'status-completed' : 'status-cancelled'}">
                                ${order.status == 'pending' ? '待处理' : order.status == 'completed' ? '已完成' : '已取消'}
                            </span>
                        </td>
                        <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/purchase/edit/${order.purchaseId}" class="action-btn edit-btn">
                                <i class="ri-edit-line"></i>编辑
                            </a>
                            <a href="${pageContext.request.contextPath}/purchase/delete/${order.purchaseId}" 
                               class="action-btn delete-btn" 
                               onclick="return confirm('确定要删除这个进货单吗？')">
                                <i class="ri-delete-bin-line"></i>删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="pagination">
            <c:if test="${page > 1}">
                <a href="${pageContext.request.contextPath}/purchase?page=${page-1}&keyword=${keyword}" class="page-number">上一页</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/purchase?page=${i}&keyword=${keyword}" 
                   class="page-number ${page == i ? 'active' : ''}">${i}</a>
            </c:forEach>
            <c:if test="${page < totalPages}">
                <a href="${pageContext.request.contextPath}/purchase?page=${page+1}&keyword=${keyword}" class="page-number">下一页</a>
            </c:if>
        </div>
    </div>
</body>
</html> 