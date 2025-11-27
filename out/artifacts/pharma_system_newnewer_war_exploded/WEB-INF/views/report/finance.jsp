<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>财务总销售金额报表</title>
    <meta charset="UTF-8">
    <style>
        body { background: #f0f2f5; font-family: Arial, sans-serif; }
        .summary-card { background: #4f46e5; color: #fff; border-radius: 12px; padding: 30px 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
        .summary-card .item { font-size: 22px; }
        .summary-card .item span { font-size: 32px; font-weight: bold; margin-left: 10px; }
        .bill-list { background: #fff; border-radius: 10px; box-shadow: 0 2px 8px #eee; padding: 20px; }
        .bill-item { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f0f0f0; padding: 18px 0; }
        .bill-item:last-child { border-bottom: none; }
        .bill-info { display: flex; flex-direction: column; }
        .bill-title { font-size: 18px; color: #222; }
        .bill-desc { color: #888; font-size: 14px; margin-top: 4px; }
        .bill-amount { font-size: 20px; font-weight: bold; color: #ef4444; }
        .bill-amount.income { color: #22c55e; }
    </style>
</head>
<body>
<div class="summary-card">
    <div class="item">收入 <span>￥${totalIncome}</span></div>
    <div class="item">支出 <span>￥${totalExpense}</span></div>
</div>
<div class="bill-list">
    <c:forEach var="item" items="${financeList}">
        <div class="bill-item">
            <div class="bill-info">
                <div class="bill-title">
                    <span style="font-size:14px;color:#888;">${item.type}</span>
                    ${item.customerName}（${item.salesCode}）
                </div>
                <div class="bill-desc">${item.createdAt} | 备注：${item.remark}</div>
            </div>
            <div class="bill-amount ${item.amount > 0 ? 'income' : ''}" style="color:${item.amount < 0 ? '#ef4444' : '#22c55e'}">
                ￥${item.amount}
            </div>
        </div>
    </c:forEach>
</div>
</body>
</html> 