<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${medicine.medicineId == null ? '添加药品' : '编辑药品'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>${medicine.medicineId == null ? '添加药品' : '编辑药品'}</h2>
        
        <form action="${pageContext.request.contextPath}/medicine/save" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="medicineId" value="${medicine.medicineId}">
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="medicineCode" class="form-label">药品编码</label>
                    <input type="text" class="form-control" id="medicineCode" name="medicineCode" 
                           value="${medicine.medicineCode}" required>
                    <div class="invalid-feedback">请输入药品编码</div>
                </div>
                
                <div class="col-md-6">
                    <label for="medicineName" class="form-label">药品名称</label>
                    <input type="text" class="form-control" id="medicineName" name="medicineName" 
                           value="${medicine.medicineName}" required>
                    <div class="invalid-feedback">请输入药品名称</div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="specification" class="form-label">规格</label>
                    <input type="text" class="form-control" id="specification" name="specification" 
                           value="${medicine.specification}">
                </div>
                
                <div class="col-md-6">
                    <label for="manufacturer" class="form-label">生产厂家</label>
                    <input type="text" class="form-control" id="manufacturer" name="manufacturer" 
                           value="${medicine.manufacturer}" required>
                    <div class="invalid-feedback">请输入生产厂家</div>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="unit" class="form-label">单位</label>
                    <input type="text" class="form-control" id="unit" name="unit" 
                           value="${medicine.unit}" required>
                    <div class="invalid-feedback">请输入单位</div>
                </div>
                
                <div class="col-md-4">
                    <label for="price" class="form-label">价格</label>
                    <input type="number" step="0.01" class="form-control" id="price" name="price" 
                           value="${medicine.price}" required>
                    <div class="invalid-feedback">请输入价格</div>
                </div>
                
                <div class="col-md-4">
                    <label for="stockQuantity" class="form-label">库存数量</label>
                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" 
                           value="${medicine.stockQuantity}" required>
                    <div class="invalid-feedback">请输入库存数量</div>
                </div>
            </div>

            <div class="mb-3">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-save"></i> 保存
                </button>
                <a href="${pageContext.request.contextPath}/medicine" class="btn btn-secondary">
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
        // Form validation
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