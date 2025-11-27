<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>客户管理</title>
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
    <h2 class="mb-4">客户管理</h2>
    <div class="row mb-3">
        <div class="col">
            <a href="${pageContext.request.contextPath}/customer/add" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> 新增客户
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary ms-2">
                <i class="bi bi-arrow-left"></i> 返回主页
            </a>
        </div>
        <div class="col-md-4">
            <form action="${pageContext.request.contextPath}/customer" method="get" class="d-flex">
                <input type="text" name="keyword" class="form-control me-2" placeholder="搜索客户名称或编码..." value="${keyword}">
                <button type="submit" class="btn btn-outline-primary">搜索</button>
            </form>
        </div>
    </div>
    <table class="table table-striped table-hover align-middle">
        <thead>
        <tr>
            <th>客户编码</th>
            <th>客户名称</th>
            <th>联系人</th>
            <th>电话</th>
            <th>邮箱</th>
            <th>地址</th>
            <th>类型</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty customerList}">
            <tr><td colspan="8" class="text-center text-muted">暂无客户信息</td></tr>
        </c:if>
        <c:forEach items="${customerList}" var="customer">
            <tr>
                <td>${customer.customerCode}</td>
                <td>${customer.name}</td>
                <td>${customer.contactPerson}</td>
                <td>${customer.phone}</td>
                <td>${customer.email}</td>
                <td>${customer.address}</td>
                <td>${customer.type}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/customer/edit/${customer.customerId}" class="btn btn-sm btn-warning">
                        <i class="bi bi-pencil"></i> 编辑
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/delete/${customer.customerId}" class="btn btn-sm btn-danger" onclick="return confirm('确定要删除这个客户吗？')">
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
                    <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${i}&keyword=${keyword}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 