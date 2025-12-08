<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${employee.employeeId == null ? '新增员工' : '编辑员工'}</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c2c7;
            color: #842029;
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .alert-danger .bi-exclamation-triangle-fill {
            color: #dc3545;
        }
        .alert-danger .btn-close {
            opacity: 0.6;
        }
        .alert-danger .btn-close:hover {
            opacity: 1;
        }
    </style>
</head>
<body>
<div class="container mt-4" style="max-width:600px;">
    <h3 class="mb-4">${employee.employeeId == null ? '新增员工' : '编辑员工'}</h3>
    
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert" style="display: flex; align-items: center; border-left: 4px solid #dc3545;">
            <i class="bi bi-exclamation-triangle-fill me-2" style="font-size: 1.2rem;"></i>
            <span style="flex: 1;">${error}</span>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/employee/save" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="employeeId" value="${employee.employeeId}">
        <div class="mb-3">
            <label class="form-label">员工编码</label>
            <input type="text" name="employeeCode" id="employeeCode" class="form-control" value="${employee.employeeCode}" required>
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
                // 检查编码是否重复
                if (window.codeExists) {
                    event.preventDefault()
                    event.stopPropagation()
                    showCodeError('员工编码【' + document.getElementById('employeeCode').value + '】已存在,请使用其他编码!')
                    return false
                }
                
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()

    // 全局变量：标记编码是否已存在
    window.codeExists = false;
    const originalEmployeeCode = '${employee.employeeCode != null ? employee.employeeCode : ""}';
    const employeeId = document.querySelector('input[name="employeeId"]')?.value || '';
    const employeeCodeInput = document.getElementById('employeeCode');

    // 显示编码错误
    function showCodeError(message) {
        employeeCodeInput.classList.add('is-invalid');
        employeeCodeInput.classList.remove('is-valid');
        
        // 显示顶部错误提示框
        showTopError(message);
    }

    // 隐藏编码错误
    function hideCodeError() {
        employeeCodeInput.classList.remove('is-invalid');
        window.codeExists = false;
        
        // 移除顶部错误提示框
        const existingAlert = document.querySelector('.alert-danger');
        if (existingAlert) {
            existingAlert.remove();
        }
    }

    // 显示顶部错误提示框
    function showTopError(message) {
        // 移除已存在的错误提示（包括服务器端渲染的和动态创建的）
        const existingAlerts = document.querySelectorAll('.alert-danger');
        existingAlerts.forEach(function(alert) {
            alert.remove();
        });

        // 创建新的错误提示框
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-danger alert-dismissible fade show';
        alertDiv.setAttribute('role', 'alert');
        alertDiv.style.cssText = 'display: flex; align-items: center; border-left: 4px solid #dc3545;';
        
        // 创建图标
        const icon = document.createElement('i');
        icon.className = 'bi bi-exclamation-triangle-fill me-2';
        icon.style.fontSize = '1.2rem';
        
        // 创建文本
        const textSpan = document.createElement('span');
        textSpan.style.flex = '1';
        textSpan.textContent = message;
        
        // 创建关闭按钮
        const closeBtn = document.createElement('button');
        closeBtn.type = 'button';
        closeBtn.className = 'btn-close';
        closeBtn.setAttribute('data-bs-dismiss', 'alert');
        closeBtn.setAttribute('aria-label', 'Close');
        
        // 组装元素
        alertDiv.appendChild(icon);
        alertDiv.appendChild(textSpan);
        alertDiv.appendChild(closeBtn);

        // 插入到标题下方
        const title = document.querySelector('h3.mb-4');
        if (title && title.nextSibling) {
            title.parentNode.insertBefore(alertDiv, title.nextSibling);
        } else {
            title.parentNode.appendChild(alertDiv);
        }
    }

    // 检查编码是否重复
    function checkEmployeeCode() {
        const code = employeeCodeInput.value.trim();
        
        if (!code) {
            hideCodeError();
            return;
        }

        // 如果编码没有变化，不检查
        if (code === originalEmployeeCode) {
            hideCodeError();
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/employee/check-code?employeeCode=' + encodeURIComponent(code) + '&employeeId=' + employeeId, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.exists) {
                            window.codeExists = true;
                            showCodeError('员工编码【' + code + '】已存在,请使用其他编码!');
                        } else {
                            hideCodeError();
                            employeeCodeInput.classList.add('is-valid');
                        }
                    } catch (e) {
                        console.error('解析响应失败:', e);
                    }
                }
            }
        };
        xhr.send();
    }

    // 输入框失去焦点时检查
    employeeCodeInput.addEventListener('blur', checkEmployeeCode);

    // 输入时清除之前的错误状态（延迟检查）
    let checkTimeout;
    employeeCodeInput.addEventListener('input', function() {
        hideCodeError();
        clearTimeout(checkTimeout);
        checkTimeout = setTimeout(checkEmployeeCode, 500); // 延迟500ms检查，避免频繁请求
    });
</script>
</body>
</html> 