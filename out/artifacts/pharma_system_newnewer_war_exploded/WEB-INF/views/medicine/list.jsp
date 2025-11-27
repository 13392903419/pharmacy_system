<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>药品管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>药品管理</h2>
        
        <div class="row mb-3">
            <div class="col">
                <a href="${pageContext.request.contextPath}/medicine/add" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> 添加药品
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary ms-2">
                    <i class="bi bi-arrow-left"></i> 返回主页
                </a>
            </div>
            <div class="col-md-4">
                <form action="${pageContext.request.contextPath}/medicine/search" method="get" class="d-flex">
                    <input type="text" name="keyword" class="form-control me-2" placeholder="搜索药品...">
                    <button type="submit" class="btn btn-outline-primary">搜索</button>
                </form>
            </div>
        </div>

        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>药品编码</th>
                    <th>药品名称</th>
                    <th>规格</th>
                    <th>生产厂家</th>
                    <th>单位</th>
                    <th>价格</th>
                    <th>库存数量</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${medicines}" var="medicine">
                    <tr>
                        <td>${medicine.medicineCode}</td>
                        <td>${medicine.medicineName}</td>
                        <td>${medicine.specification}</td>
                        <td>${medicine.manufacturer}</td>
                        <td>${medicine.unit}</td>
                        <td>${medicine.price}</td>
                        <td>${medicine.stockQuantity}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/medicine/edit/${medicine.medicineId}" 
                               class="btn btn-sm btn-warning">
                                <i class="bi bi-pencil"></i> 编辑
                            </a>
                            <a href="${pageContext.request.contextPath}/medicine/delete/${medicine.medicineId}" 
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('确定要删除这个药品吗？')">
                                <i class="bi bi-trash"></i> 删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 