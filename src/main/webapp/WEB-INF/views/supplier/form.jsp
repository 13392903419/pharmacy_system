<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>供应商信息</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4" style="max-width: 600px;">
    <h3 class="mb-4">${supplier.supplierId == null ? '新增供应商' : '编辑供应商'}</h3>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/supplier/save" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="supplierId" value="${supplier.supplierId}"/>
        <div class="mb-3">
            <label class="form-label">供应商编码</label>
            <input type="text" name="supplierCode" class="form-control" value="${supplier.supplierCode}" required maxlength="32">
            <div class="invalid-feedback">请输入供应商编码</div>
        </div>
        <div class="mb-3">
            <label class="form-label">供应商名称</label>
            <input type="text" name="name" class="form-control" value="${supplier.name}" required maxlength="64">
            <div class="invalid-feedback">请输入供应商名称</div>
        </div>
        <div class="mb-3">
            <label class="form-label">联系人</label>
            <input type="text" name="contactPerson" class="form-control" value="${supplier.contactPerson}" maxlength="32">
        </div>
        <div class="mb-3">
            <label class="form-label">电话</label>
            <input type="text" name="phone" class="form-control" value="${supplier.phone}" maxlength="32">
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-control" value="${supplier.email}" maxlength="64">
        </div>
        <div class="mb-3">
            <label class="form-label">地址</label>
            <input type="text" name="address" class="form-control" value="${supplier.address}" maxlength="128">
        </div>
        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-success">
                <i class="bi bi-save"></i> 保存
            </button>
            <div>
                <a href="${pageContext.request.contextPath}/supplier" class="btn btn-secondary me-2">
                    <i class="bi bi-arrow-left"></i> 返回列表
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
                    <i class="bi bi-house"></i> 返回主页
                </a>
            </div>
        </div>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict';
        var forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html> 