<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${inventory.inventoryId == null ? '新增库存' : '编辑库存'}</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .title {
            font-size: 24px;
            color: #1a1a1a;
            margin-bottom: 30px;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-size: 14px;
        }
        input[type="text"],
        input[type="number"],
        input[type="date"],
        select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            font-size: 14px;
            color: #1a1a1a;
            background-color: #fff;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="date"]:focus,
        select:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        .button-group {
            margin-top: 30px;
            display: flex;
            gap: 10px;
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
        .btn-primary {
            background-color: #6366f1;
            color: white;
        }
        .btn-secondary {
            background-color: #64748b;
            color: white;
        }
        .error-message {
            color: #ef4444;
            font-size: 14px;
            margin-top: 20px;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="title">${inventory.inventoryId == null ? '新增库存' : '编辑库存'}</h1>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/inventory/save" method="post">
            <c:if test="${not empty inventory.inventoryId}">
                <input type="hidden" name="inventoryId" value="${inventory.inventoryId}">
            </c:if>
            
            <div class="form-row">
                <div class="form-group">
                    <label>选择药品</label>
                    <select name="medicineId" required>
                        <option value="">请选择药品</option>
                        <c:forEach items="${medicineList}" var="medicine">
                            <option value="${medicine.medicineId}" ${medicine.medicineId == inventory.medicineId ? 'selected' : ''}>
                                ${medicine.medicineName} (${medicine.medicineCode})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>数量</label>
                    <input type="number" name="quantity" id="quantity" value="${inventory.quantity}" required min="0" oninput="validateQuantity(this)">
                    <div id="quantityWarning" style="color: #ef4444; font-size: 14px; margin-top: 5px; display: none;">
                        <i class="ri-error-warning-line"></i> 输入数量超过最大库存限制！
                    </div>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>批次号</label>
                    <input type="text" name="batchNumber" value="${inventory.batchNumber}" required>
                </div>
                
                <div class="form-group">
                    <label>库位</label>
                    <input type="text" name="location" value="${inventory.location}" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>生产日期</label>
                    <input type="date" name="productionDate" 
                           value="<fmt:formatDate value="${inventory.productionDate}" pattern="yyyy-MM-dd"/>" 
                           required>
                </div>
                
                <div class="form-group">
                    <label>有效期至</label>
                    <input type="date" name="expiryDate" 
                           value="<fmt:formatDate value="${inventory.expiryDate}" pattern="yyyy-MM-dd"/>" 
                           required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>最小库存</label>
                    <input type="number" name="minStock" value="${inventory.minStock}" required min="0">
                </div>
                <div class="form-group">
                    <label>最大库存</label>
                    <input type="number" name="maxStock" value="${inventory.maxStock}" required min="0">
                </div>
            </div>


            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <i class="ri-save-line"></i>保存
                </button>
                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">
                    <i class="ri-arrow-left-line"></i>返回
                </a>
            </div>
        </form>
    </div>
    <script>
    window.onload = function() {
        // 设置生产日期最大为今天
        var today = new Date().toISOString().split('T')[0];
        document.querySelector('input[name="productionDate"]').setAttribute('max', today);
        // 设置有效期至最小为生产日期
        var prodInput = document.querySelector('input[name="productionDate"]');
        var expInput = document.querySelector('input[name="expiryDate"]');
        function updateExpiryMin() {
            expInput.setAttribute('min', prodInput.value);
        }
        prodInput.addEventListener('change', updateExpiryMin);
        updateExpiryMin();
        // 表单提交校验
        document.querySelector('form').addEventListener('submit', function(e) {
            var prod = prodInput.value;
            var exp = expInput.value;
            if (prod && exp && exp < prod) {
                alert('有效期至不能小于生产日期！');
                e.preventDefault();
            }
            
            // 检查数量是否超过最大库存
            var quantity = document.getElementById('quantity').value;
            var maxStock = document.querySelector('input[name="maxStock"]').value;
            if (parseInt(quantity) > parseInt(maxStock)) {
                alert('输入数量超过最大库存限制！');
                e.preventDefault();
            }
        });
    }

    // 验证数量输入
    function validateQuantity(input) {
        var quantity = parseInt(input.value);
        var maxStock = parseInt(document.querySelector('input[name="maxStock"]').value);
        var warning = document.getElementById('quantityWarning');
        
        if (quantity > maxStock) {
            warning.style.display = 'block';
            input.style.borderColor = '#ef4444';
        } else {
            warning.style.display = 'none';
            input.style.borderColor = '#d1d5db';
        }
    }
    </script>
</body>
</html> 