<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存预警</title>
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
        .btn-secondary {
            background-color: #64748b;
            color: white;
        }
        .warning-section {
            margin-bottom: 40px;
        }
        .warning-title {
            font-size: 18px;
            color: #1a1a1a;
            margin-bottom: 20px;
            padding-left: 10px;
            border-left: 4px solid #f59e0b;
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
        .status-low {
            background-color: #f59e0b;
            color: white;
        }
        .status-expired {
            background-color: #ef4444;
            color: white;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #64748b;
            font-size: 16px;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 class="title">库存预警</h1>
            <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">
                <i class="ri-arrow-left-line"></i>返回
            </a>
        </div>

        <div class="warning-section">
            <h2 class="warning-title">库存预警列表</h2>
            <c:choose>
                <c:when test="${not empty warningList}">
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
                            <c:forEach items="${warningList}" var="inventory">
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
                                            ${inventory.status == 'low' ? '库存不足' : '即将过期'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/inventory/edit/${inventory.inventoryId}" class="btn btn-secondary">
                                            <i class="ri-edit-line"></i>处理
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-message">
                        <i class="ri-emotion-happy-line" style="font-size: 24px; margin-right: 8px;"></i>
                        暂无库存预警信息
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html> 