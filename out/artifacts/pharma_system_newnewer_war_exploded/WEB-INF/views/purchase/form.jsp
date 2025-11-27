<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>进货单</title>
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
    <h1 class="title">${purchaseOrder.purchaseId == null ? '新增进货单' : '编辑进货单'}</h1>

    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>

    <form id="purchaseForm" action="${pageContext.request.contextPath}/purchase/save" method="post">
        <c:if test="${not empty purchaseOrder.purchaseId}">
            <input type="hidden" name="purchaseId" value="${purchaseOrder.purchaseId}">
        </c:if>

        <div class="form-row">
            <div class="form-group">
                <label>进货单号</label>
                <input type="text" name="purchaseCode" value="${purchaseOrder.purchaseCode != null ? purchaseOrder.purchaseCode : 'PO'}" required>
            </div>

            <div class="form-group">
                <label>供应商</label>
                <select name="supplierId" required>
                    <option value="">请选择供应商</option>
                    <c:forEach items="${supplierList}" var="supplier">
                        <option value="${supplier.supplierId}" ${supplier.supplierId == purchaseOrder.supplierId ? 'selected' : ''}>
                                ${supplier.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>采购员</label>
                <select name="employeeId" required>
                    <option value="">请选择采购员</option>
                    <c:forEach items="${employeeList}" var="employee">
                        <option value="${employee.employeeId}" ${employee.employeeId == purchaseOrder.employeeId ? 'selected' : ''}>
                                ${employee.name}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>总金额</label>
                <input type="number" step="0.01" name="totalAmount" value="${purchaseOrder.totalAmount}" required readonly>
            </div>

            <div class="form-group">
                <label>状态</label>
                <select name="status" required>
                    <option value="pending" ${purchaseOrder.status == 'pending' ? 'selected' : ''}>待处理</option>
                    <option value="completed" ${purchaseOrder.status == 'completed' ? 'selected' : ''}>已完成</option>
                    <option value="cancelled" ${purchaseOrder.status == 'cancelled' ? 'selected' : ''}>已取消</option>
                </select>
            </div>
        </div>

        <div class="details-section">
            <div class="details-header">
                <h2 class="details-title">进货明细</h2>
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
                <c:forEach items="${purchaseOrder.details}" var="detail">
                    <tr>
                        <td>${detail.medicineCode}</td>
                        <td>${detail.medicineName}</td>
                        <td>${detail.quantity}</td>
                        <td>${detail.unitPrice}</td>
                        <td>${detail.totalPrice}</td>
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
            <a href="${pageContext.request.contextPath}/purchase" class="btn btn-secondary">
                <i class="ri-arrow-left-line"></i>返回
            </a>
        </div>
    </form>
</div>

<script>
    // 自动生成进货单号
    function generatePurchaseCode() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');
        const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        return `PO${year}${month}${day}${hours}${minutes}${seconds}${random}`;
    }

    // 页面加载时，如果是新增页面则自动生成进货单号
    window.addEventListener('load', function() {
        const purchaseCodeInput = document.querySelector('input[name="purchaseCode"]');
        if (purchaseCodeInput && !purchaseCodeInput.value) {
            purchaseCodeInput.value = generatePurchaseCode();
        }
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
        console.log('addDetail被调用');
        const medicineSelect = document.getElementById('medicineSelect');
        const selected = medicineSelect.options[medicineSelect.selectedIndex];
        const quantity = document.getElementById('detailQuantity').value;
        const unitPrice = document.getElementById('detailUnitPrice').value;
        const totalPrice = document.getElementById('detailTotalPrice').value;

        console.log('selected.value:', selected.value);
        console.log('selected.dataset.code:', selected.dataset.code);
        console.log('selected.dataset.name:', selected.dataset.name);
        console.log('quantity:', quantity);
        console.log('unitPrice:', unitPrice);
        console.log('totalPrice:', totalPrice);

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
        console.log('tr已添加', tbody.children.length);

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
    document.getElementById('purchaseForm').addEventListener('submit', function(e) {
        const details = document.getElementsByName('detailMedicineIds[]');
        const purchaseId = document.querySelector('input[name="purchaseId"]');
        // 只在新增进货单时要求添加明细
        if (!purchaseId && details.length === 0) {
            e.preventDefault();
            alert('请至少添加一条明细记录');
        }
    });
</script>
</body>
</html> 