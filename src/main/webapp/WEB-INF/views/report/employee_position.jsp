<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>员工职位分布报表</title>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
    <style>
        body { background: #f0f2f5; font-family: Arial, sans-serif; }
        .container { max-width: 600px; margin: 40px auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px #eee; padding: 30px; }
        .title { font-size: 24px; color: #1a1a1a; margin-bottom: 30px; text-align: center; }
        #pieChart { width: 100%; height: 400px; }
        .back-button {
            display: inline-block;
            background: #4f46e5;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            margin: 30px auto;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            width: fit-content;
        }
        .back-button:hover {
            background: #4338ca;
            transform: translateY(-2px);
        }
        .button-container {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="title">员工职位分布</div>
    <div id="pieChart"></div>
</div>
<div class="button-container">
    <a href="${pageContext.request.contextPath}/dashboard" class="back-button">
        <i class="ri-arrow-left-line"></i>返回主页
    </a>
</div>
<script>
    var data = [];
    <c:forEach var="item" items="${positionList}">
    data.push({ value: ${item.count}, name: '${item.position}' });
    </c:forEach>
    var chart = echarts.init(document.getElementById('pieChart'));
    chart.setOption({
        title: { text: '员工职位分布', left: 'center' },
        tooltip: { trigger: 'item' },
        legend: { orient: 'vertical', left: 'left' },
        series: [{
            name: '职位',
            type: 'pie',
            radius: '60%',
            data: data,
            emphasis: {
                itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' }
            }
        }]
    });
</script>
</body>
</html>
