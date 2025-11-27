<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${order.salesId == null ? '新增销售单' : '编辑销售单'}</title>
    <meta charset="UTF-8">
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .container {
            max-width: 1200px;
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
            grid-template-columns: repeat(3, 1fr);
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
        select:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        .button-group {
            margin-top: 30px;
            display: flex;
            gap: 10px;
            justify-content: flex-start;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
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
        .btn-danger {
            background-color: #ef4444;
            color: white;
        }
        .details-section {
            margin-top: 40px;
        }
        .details-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .details-title {
            font-size: 18px;
            color: #1a1a1a;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background-color: #f8fafc;
            font-weight: 500;
            color: #64748b;
        }
        .detail-form {
            background-color: #f8fafc;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .detail-form .form-row {
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
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
    <h1 class="title">${order.salesId == null ? '新增销售单' : '编辑销售单'}</h1>

    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>

    <form id="salesForm" action="${pageContext.request.contextPath}/sales/save" method="post">
        <c:if test="${not empty order.salesId}">
            <input type="hidden" name="salesId" value="${order.salesId}">
        </c:if>

        <div class="form-row">
            <div class="form-group">
                <label>销售单号</label>
                <input type="text" name="salesCode" value="${order.salesCode != null ? order.salesCode : 'SO'}" required>
            </div>

            <div class="form-group">
                <label>客户</label>
                <select name="customerId" required>
                    <option value="">请选择客户</option>
                    <c:forEach items="${customerList}" var="customer">
                        <option value="${customer.customerId}" ${customer.customerId == order.customerId ? 'selected' : ''}>
                                ${customer.name} (${customer.customerCode})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>销售员</label>
                <select name="employeeId" required>
                    <option value="">请选择销售员</option>
                    <c:forEach items="${employeeList}" var="employee">
                        <option value="${employee.employeeId}" ${employee.employeeId == order.employeeId ? 'selected' : ''}>
                                ${employee.name} (${employee.employeeCode})
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>总金额</label>
                <input type="number" step="0.01" name="totalAmount" value="${order.totalAmount}" required readonly>
            </div>

            <div class="form-group">
                <div class="form-group">
                    <label>状态</label>
                    <select name="status" required>
                        <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>待处理</option>
                        <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>已完成</option>
                        <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>已取消</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="details-section">
            <div class="details-header">
                <h2 class="details-title">销售明细</h2>
            </div>

            <div class="detail-form">
                <div class="form-row">
                    <div class="form-group">
                        <label>选择药品</label>
                        <select id="medicineSelect">
                            <option value="">请选择药品</option>
                            <c:forEach items="${medicineList}" var="medicine">
                                <option value="${medicine.medicineId}"
                                        data-code="${medicine.medicineCode}"
                                        data-name="${medicine.medicineName}"
                                        data-price="${medicine.price}">
                                        ${medicine.medicineName} (${medicine.medicineCode})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>数量</label>
                        <input type="number" id="detailQuantity" min="1">
                    </div>
                    <div class="form-group">
                        <label>单价</label>
                        <input type="number" step="0.01" id="detailUnitPrice">
                    </div>
                    <div class="form-group">
                        <label>总价</label>
                        <input type="number" step="0.01" id="detailTotalPrice" readonly>
                    </div>
                    <div class="form-group" style="display: flex; align-items: flex-end;">
                        <button type="button" class="btn btn-primary" onclick="addDetail()">
                            <i class="ri-add-line"></i>添加
                        </button>
                    </div>
                </div>
            </div>

            <table id="detailsTable">
                <thead>
                <tr>
                    <th>药品编码</th>
                    <th>药品名称</th>
                    <th>数量</th>
                    <th>单价</th>
                    <th>总价</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${order.details}" var="detail">
                    <tr>
                        <td>${detail.medicineCode}
                            <!-- 🔥 关键：编辑时必须包含这些hidden字段 -->
                            <input type="hidden" name="detailMedicineIds[]" value="${detail.medicineId}">
                            <input type="hidden" name="detailMedicineCodes[]" value="${detail.medicineCode}">
                            <input type="hidden" name="detailMedicineNames[]" value="${detail.medicineName}">
                        </td>
                        <td>${detail.medicineName}</td>
                        <td>${detail.quantity}
                            <input type="hidden" name="detailQuantities[]" value="${detail.quantity}">
                        </td>
                        <td>${detail.unitPrice}
                            <input type="hidden" name="detailUnitPrices[]" value="${detail.unitPrice}">
                        </td>
                        <td>${detail.totalPrice}
                            <input type="hidden" name="detailTotalPrices[]" value="${detail.totalPrice}">
                        </td>
                        <td>
                            <button type="button" class="btn btn-danger" onclick="removeDetail(this)">
                                <i class="ri-delete-bin-line"></i>删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="button-group">
            <button type="submit" class="btn btn-primary">
                <i class="ri-save-line"></i>保存
            </button>
            <a href="${pageContext.request.contextPath}/sales" class="btn btn-secondary">
                <i class="ri-arrow-left-line"></i>返回
            </a>
        </div>
    </form>
</div>

<script>
    // 自动生成销售单号
    function generateSalesCode() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');
        const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        return `SO${year}${month}${day}${hours}${minutes}${seconds}${random}`;
    }

    // 页面加载时，如果是新增页面则自动生成销售单号并设置初始总金额
    window.addEventListener('load', function() {
        const salesCodeInput = document.querySelector('input[name="salesCode"]');
        if (salesCodeInput && !salesCodeInput.value) {
            salesCodeInput.value = generateSalesCode();
        }

        // 设置初始总金额
        updateOrderTotal();
    });

    // 计算明细总价
    document.getElementById('detailQuantity').addEventListener('input', calculateDetailTotal);
    document.getElementById('detailUnitPrice').addEventListener('input', calculateDetailTotal);

    function calculateDetailTotal() {
        const quantity = parseFloat(document.getElementById('detailQuantity').value) || 0;
        const unitPrice = parseFloat(document.getElementById('detailUnitPrice').value) || 0;
        document.getElementById('detailTotalPrice').value = (quantity * unitPrice).toFixed(2);
    }

    // 选择药品时自动填充单价
    document.getElementById('medicineSelect').addEventListener('change', function() {
        const selected = this.options[this.selectedIndex];
        if (selected.value) {
            document.getElementById('detailUnitPrice').value = selected.dataset.price;
            calculateDetailTotal();
        }
    });

    // 添加明细
    function addDetail() {
        const medicineSelect = document.getElementById('medicineSelect');
        const selected = medicineSelect.options[medicineSelect.selectedIndex];
        const quantity = document.getElementById('detailQuantity').value;
        const unitPrice = document.getElementById('detailUnitPrice').value;
        const totalPrice = document.getElementById('detailTotalPrice').value;

        if (!selected.value || !quantity || !unitPrice) {
            alert('请填写完整的明细信息');
            return;
        }

        const tbody = document.querySelector('#detailsTable tbody');
        if (!tbody) {
            alert('未找到明细表格的tbody，请检查表格结构！');
            return;
        }
        const tr = document.createElement('tr');
        tr.innerHTML =
            '<td>' + selected.dataset.code +
            '<input type="hidden" name="detailMedicineIds[]" value="' + selected.value + '">' +
            '<input type="hidden" name="detailMedicineCodes[]" value="' + selected.dataset.code + '">' +
            '<input type="hidden" name="detailMedicineNames[]" value="' + selected.dataset.name + '">' +
            '</td>' +
            '<td>' + selected.dataset.name + '</td>' +
            '<td>' + quantity +
            '<input type="hidden" name="detailQuantities[]" value="' + quantity + '">' +
            '</td>' +
            '<td>' + unitPrice +
            '<input type="hidden" name="detailUnitPrices[]" value="' + unitPrice + '">' +
            '</td>' +
            '<td>' + totalPrice +
            '<input type="hidden" name="detailTotalPrices[]" value="' + totalPrice + '">' +
            '</td>' +
            '<td>' +
            '<button type="button" class="btn btn-danger" onclick="removeDetail(this)">' +
            '<i class="ri-delete-bin-line"></i>删除' +
            '</button>' +
            '</td>';
        tbody.appendChild(tr);

        // 清空输入
        medicineSelect.value = '';
        document.getElementById('detailQuantity').value = '';
        document.getElementById('detailUnitPrice').value = '';
        document.getElementById('detailTotalPrice').value = '';

        updateOrderTotal();
    }

    // 删除明细
    function removeDetail(btn) {
        if (confirm('确定要删除这条明细吗？')) {
            btn.closest('tr').remove();
            updateOrderTotal();
        }
    }

    // 更新订单总金额
    function updateOrderTotal() {
        const totalPrices = Array.from(document.getElementsByName('detailTotalPrices[]'))
            .map(input => parseFloat(input.value) || 0);
        const orderTotal = totalPrices.reduce((sum, price) => sum + price, 0);
        document.querySelector('input[name="totalAmount"]').value = orderTotal.toFixed(2);
    }

    // 表单提交前验证
    document.getElementById('salesForm').addEventListener('submit', function(e) {
        const details = document.getElementsByName('detailMedicineIds[]');
        if (details.length === 0) {
            e.preventDefault();
            alert('请至少添加一条明细记录');
        }
    });
</script>
</body>
</html>