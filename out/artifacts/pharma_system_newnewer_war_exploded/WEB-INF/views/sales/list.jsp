<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>销售管理</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .pagination .page-link { color: #0d6efd; }
        .pagination .active .page-link { background-color: #0d6efd; border-color: #0d6efd; color: #fff; }
    </style>
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">销售管理</h2>
    <div class="row mb-3">
        <div class="col">
            <a href="${pageContext.request.contextPath}/sales/add" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> 新增销售单
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary ms-2">
                <i class="bi bi-arrow-left"></i> 返回主页
            </a>
        </div>
        <div class="col-md-4">
            <form action="${pageContext.request.contextPath}/sales" method="get" class="d-flex">
                <input type="text" name="keyword" class="form-control me-2" placeholder="搜索销售单号..." value="${keyword}">
                <button type="submit" class="btn btn-outline-primary">搜索</button>
            </form>
        </div>
    </div>
    <table class="table table-striped table-hover align-middle">
        <thead>
        <tr>
            <th>销售单号</th>
            <th>客户ID</th>
            <th>员工ID</th>
            <th>总金额</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${salesList}" var="order">
            <tr>
                <td>${order.salesCode}</td>
                <td>${order.customerId}</td>
                <td>${order.employeeId}</td>
                <td>${order.totalAmount}</td>
                <td>${order.status}</td>
                <td>${order.createdAt}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/sales/edit/${order.salesId}" class="btn btn-sm btn-warning">
                        <i class="bi bi-pencil"></i> 编辑
                    </a>
                    <a href="${pageContext.request.contextPath}/sales/delete/${order.salesId}" class="btn btn-sm btn-danger" onclick="return confirm('确定要删除这个销售单吗？')">
                        <i class="bi bi-trash"></i> 删除
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <!-- 分页条 -->
    <nav>
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == page ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/sales?page=${i}&keyword=${keyword}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 