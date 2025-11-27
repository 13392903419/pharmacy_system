<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${customer.customerId == null ? '新增客户' : '编辑客户'}</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4" style="max-width:600px;">
    <h3 class="mb-4">${customer.customerId == null ? '新增客户' : '编辑客户'}</h3>
    <form action="${pageContext.request.contextPath}/customer/save" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="customerId" value="${customer.customerId}">
        <div class="mb-3">
            <label class="form-label">客户编码</label>
            <input type="text" name="customerCode" class="form-control" value="${customer.customerCode}" required>
            <div class="invalid-feedback">请输入客户编码</div>
        </div>
        <div class="mb-3">
            <label class="form-label">客户名称</label>
            <input type="text" name="name" class="form-control" value="${customer.name}" required>
            <div class="invalid-feedback">请输入客户名称</div>
        </div>
        <div class="mb-3">
            <label class="form-label">联系人</label>
            <input type="text" name="contactPerson" class="form-control" value="${customer.contactPerson}">
        </div>
        <div class="mb-3">
            <label class="form-label">电话</label>
            <input type="text" name="phone" class="form-control" value="${customer.phone}">
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-control" value="${customer.email}">
        </div>
        <div class="mb-3">
            <label class="form-label">地址</label>
            <input type="text" name="address" class="form-control" value="${customer.address}">
        </div>
        <div class="mb-3">
            <label class="form-label">类型</label>
            <select name="type" class="form-select" required>
                <option value="retail" ${customer.type == 'retail' ? 'selected' : ''}>零售</option>
                <option value="wholesale" ${customer.type == 'wholesale' ? 'selected' : ''}>批发</option>
            </select>
            <div class="invalid-feedback">请选择类型</div>
        </div>
        <div class="mb-3">
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-save"></i> 保存
            </button>
            <a href="${pageContext.request.contextPath}/customer" class="btn btn-secondary">
                <i class="bi bi-x-circle"></i> 取消
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary ms-2">
                <i class="bi bi-arrow-left"></i> 返回主页
            </a>
        </div>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>
</body>
</html> 