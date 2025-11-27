<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>库存预警</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: Arial, sans-serif; }
        .container { max-width: 1000px; margin: 40px auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px #eee; padding: 30px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .title { font-size: 24px; color: #1a1a1a; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; }
        .btn-secondary { background-color: #64748b; color: white; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f8fafc; color: #64748b; }
        .status-low { color: #fff; background: #f59e0b; border-radius: 4px; padding: 2px 8px; }
        .status-expired { color: #fff; background: #ef4444; border-radius: 4px; padding: 2px 8px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <span class="title"><i class="ri-alert-line"></i> 库存预警</span>
        <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">
            <i class="ri-arrow-left-line"></i> 返回库存管理
        </a>
    </div>
    <c:choose>
        <c:when test="${not empty warningList || not empty expiringList}">
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
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${warningList}" var="inv">
                        <tr>
                            <td>${inv.medicineCode}</td>
                            <td>${inv.medicineName}</td>
                            <td>${inv.batchNumber}</td>
                            <td>${inv.quantity}</td>
                            <td><fmt:formatDate value="${inv.productionDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${inv.expiryDate}" pattern="yyyy-MM-dd"/></td>
                            <td>${inv.location}</td>
                            <td><span class="status-low">库存不足</span></td>
                        </tr>
                    </c:forEach>
                    <c:forEach items="${expiringList}" var="inv">
                        <tr>
                            <td>${inv.medicineCode}</td>
                            <td>${inv.medicineName}</td>
                            <td>${inv.batchNumber}</td>
                            <td>${inv.quantity}</td>
                            <td><fmt:formatDate value="${inv.productionDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${inv.expiryDate}" pattern="yyyy-MM-dd"/></td>
                            <td>${inv.location}</td>
                            <td><span class="status-expired">即将过期</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div style="text-align:center; color:#888; margin:40px 0; font-size:18px;">
                <i class="ri-emotion-happy-line" style="font-size:32px;"></i> 暂无库存预警信息
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html> 