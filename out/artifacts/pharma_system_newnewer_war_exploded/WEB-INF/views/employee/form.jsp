<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${employee.employeeId == null ? '新增员工' : '编辑员工'}</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4" style="max-width:600px;">
    <h3 class="mb-4">${employee.employeeId == null ? '新增员工' : '编辑员工'}</h3>
    <form action="${pageContext.request.contextPath}/employee/save" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="employeeId" value="${employee.employeeId}">
        <div class="mb-3">
            <label class="form-label">员工编码</label>
            <input type="text" name="employeeCode" class="form-control" value="${employee.employeeCode}" required>
            <div class="invalid-feedback">请输入员工编码</div>
        </div>
        <div class="mb-3">
            <label class="form-label">姓名</label>
            <input type="text" name="name" class="form-control" value="${employee.name}" required>
            <div class="invalid-feedback">请输入姓名</div>
        </div>
        <div class="mb-3">
            <label class="form-label">性别</label>
            <select name="gender" class="form-select" required>
                <option value="M" ${employee.gender == 'M' ? 'selected' : ''}>男</option>
                <option value="F" ${employee.gender == 'F' ? 'selected' : ''}>女</option>
            </select>
            <div class="invalid-feedback">请选择性别</div>
        </div>
        <div class="mb-3">
            <label class="form-label">电话</label>
            <input type="text" name="phone" class="form-control" value="${employee.phone}">
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-control" value="${employee.email}">
        </div>
        <div class="mb-3">
            <label class="form-label">职位</label>
            <input type="text" name="position" class="form-control" value="${employee.position}">
        </div>
        <div class="mb-3">
            <label class="form-label">状态</label>
            <select name="status" class="form-select" required>
                <option value="active" ${employee.status == 'active' ? 'selected' : ''}>在职</option>
                <option value="inactive" ${employee.status == 'inactive' ? 'selected' : ''}>离职</option>
            </select>
            <div class="invalid-feedback">请选择状态</div>
        </div>
        <div class="mb-3">
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-save"></i> 保存
            </button>
            <a href="${pageContext.request.contextPath}/employee" class="btn btn-secondary">
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