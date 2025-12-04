<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>员工职位报表 - 医药销售管理系统</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/global.css" rel="stylesheet">
</head>
<body>
<div class="layout">
    <!-- 侧边栏 -->
    <div class="sidebar">
        <div class="logo">
            <i class="ri-capsule-fill"></i>
            医药管理系统
        </div>
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="ri-dashboard-fill"></i>控制面板</a></li>
            <li><a href="${pageContext.request.contextPath}/medicine"><i class="ri-medicine-bottle-fill"></i>药品管理</a></li>
            <li><a href="${pageContext.request.contextPath}/inventory"><i class="ri-store-2-fill"></i>库存管理</a></li>
            <li><a href="${pageContext.request.contextPath}/sales"><i class="ri-shopping-cart-fill"></i>销售管理</a></li>
            <li><a href="${pageContext.request.contextPath}/purchase"><i class="ri-truck-fill"></i>进货管理</a></li>
            <li><a href="${pageContext.request.contextPath}/customer"><i class="ri-user-3-fill"></i>客户管理</a></li>
            <li><a href="${pageContext.request.contextPath}/supplier"><i class="ri-user-2-fill"></i>供应商管理</a></li>
            <li><a href="${pageContext.request.contextPath}/employee"><i class="ri-team-fill"></i>员工管理</a></li>
            <li>
                <a href="#" onclick="toggleSubMenu(event)" class="active"><i class="ri-bar-chart-fill"></i>统计报表 <i class="ri-arrow-down-s-line"></i></a>
                <ul class="submenu show" id="report-submenu">
                    <li><a href="${pageContext.request.contextPath}/report/finance">财务总销售金额报表</a></li>
                    <li><a href="${pageContext.request.contextPath}/report/employee-position" class="active">员工职位报表</a></li>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/ai-chat"><i class="ri-robot-fill"></i>AI助手</a></li>
            <li><a href="${pageContext.request.contextPath}/settings"><i class="ri-settings-3-fill"></i>系统设置</a></li>
        </ul>
    </div>

    <!-- 主内容区域 -->
    <div class="main-content">
        <div class="header">
            <h1><i class="ri-pie-chart-line"></i> 员工职位分布报表</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="ri-arrow-left-line"></i> 返回主页
                </a>
            </div>
        </div>

        <!-- 职位统计卡片 -->
        <div class="stats-grid" style="margin-bottom: 24px;">
            <c:forEach items="${positionList}" var="item" varStatus="status">
                <c:if test="${status.index < 6}"> <!-- 只显示前6个职位 -->
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="ri-user-fill"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">${item.count}</div>
                            <div class="stat-label">${item.position}</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <!-- 隐藏数据存储 -->
        <div id="chartData" style="display: none;">
            <c:forEach var="item" items="${positionList}">
                <c:set var="safeCount" value="${item.count != null ? item.count : 0}"/>
                <c:set var="safePosition" value="${item.position != null ? item.position : '未知'}"/>
                <div class="data-item" data-count="${safeCount}" data-position="${safePosition}"></div>
            </c:forEach>
        </div>

        <!-- 图表区域 -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title"><i class="ri-pie-chart-fill"></i> 职位分布图表</h3>
            </div>
            <div class="card-body">
                <div id="pieChart" style="width: 100%; height: 500px;"></div>
            </div>
        </div>

        <!-- 详细数据表格 -->
        <div class="card" style="margin-top: 24px;">
            <div class="card-header">
                <h3 class="card-title"><i class="ri-file-list-line"></i> 职位详细数据</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>职位名称</th>
                                <th>员工数量</th>
                                <th>占比</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="totalEmployees" value="0"/>
                            <c:forEach items="${positionList}" var="item">
                                <c:set var="totalEmployees" value="${totalEmployees + item.count}"/>
                            </c:forEach>

                            <c:forEach items="${positionList}" var="item">
                                <tr>
                                    <td style="font-weight: 500;">
                                        <i class="ri-user-line" style="margin-right: 8px;"></i>
                                        ${item.position}
                                    </td>
                                    <td style="font-weight: 600; color: var(--primary-color);">${item.count}</td>
                                    <td>
                                        <c:set var="percentage" value="${totalEmployees > 0 ? (item.count * 100.0 / totalEmployees) : 0}"/>
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <div style="flex: 1; height: 8px; background: #e5e7eb; border-radius: 4px;">
                                                <div class="progress-bar" data-percentage="${String.format("%.1f", percentage)}" style="height: 100%; background: var(--primary-color); border-radius: 4px; width: 0%;" title="${String.format("%.1f", percentage)}%"></div>
                                            </div>
                                            <span style="font-weight: 500; color: var(--text-primary); min-width: 50px;">
                                                ${String.format("%.1f", percentage)}%
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty positionList}">
                                <tr>
                                    <td colspan="3" style="text-align: center; padding: 60px; color: var(--text-secondary);">
                                        <i class="ri-user-line" style="font-size: 48px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                                        <br>暂无职位数据
                                        <br><small>请先添加员工信息</small>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 切换子菜单显示
function toggleSubMenu(event) {
    event.preventDefault();
    const submenu = document.getElementById('report-submenu');
    const arrow = event.currentTarget.querySelector('.ri-arrow-down-s-line, .ri-arrow-up-s-line');

    if (submenu.classList.contains('show')) {
        submenu.classList.remove('show');
        arrow.className = 'ri-arrow-down-s-line';
    } else {
        submenu.classList.add('show');
        arrow.className = 'ri-arrow-up-s-line';
    }
}

// 初始化ECharts图表
function initChart() {
    // 从隐藏元素获取数据
    var dataItems = document.querySelectorAll('#chartData .data-item');
    var data = [];

    dataItems.forEach(function(item) {
        var count = parseInt(item.getAttribute('data-count')) || 0;
        var position = item.getAttribute('data-position') || '未知';

        data.push({
            value: count,
            name: position,
            itemStyle: {
                color: getColor(position)
            }
        });
    });

    var chart = echarts.init(document.getElementById('pieChart'));
    chart.setOption({
        title: {
            text: '员工职位分布',
            left: 'center',
            textStyle: {
                fontSize: 18,
                fontWeight: '500',
                color: '#1a1a1a'
            }
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} 人 ({d}%)'
        },
        legend: {
            orient: 'vertical',
            left: 'right',
            top: 'center',
            textStyle: {
                fontSize: 12
            }
        },
        series: [{
            name: '职位分布',
            type: 'pie',
            radius: ['40%', '70%'],
            center: ['35%', '50%'],
            avoidLabelOverlap: false,
            emphasis: {
                label: {
                    show: true,
                    fontSize: '16',
                    fontWeight: 'bold'
                },
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            },
            label: {
                show: false
            },
            labelLine: {
                show: false
            },
            data: data
        }]
    });

    // 响应式调整
    window.addEventListener('resize', function() {
        chart.resize();
    });
}

// 获取职位对应的颜色 - 医药系统专用配色
function getColor(position) {
    var colors = {
        '经理': '#2563eb',      // 专业蓝色
        '主管': '#059669',      // 健康绿色
        '销售员': '#0891b2',    // 医疗青色
        '采购员': '#10b981',    // 薄荷绿
        '仓库管理员': '#0ea5e9', // 天蓝色
        '财务': '#3b82f6',      // 亮蓝色
        '医生': '#059669',      // 深绿色
        '护士': '#10b981',      // 翠绿色
        '药师': '#0891b2',      // 青色
        '其他': '#64748b'       // 中性灰色
    };
    return colors[position] || '#64748b';
}

// 设置进度条宽度
function setProgressBarWidths() {
    const progressBars = document.querySelectorAll('.progress-bar');
    progressBars.forEach(bar => {
        const percentage = bar.getAttribute('data-percentage');
        if (percentage && !isNaN(percentage)) {
            bar.style.width = percentage + '%';
        }
    });
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    initChart();
    setProgressBarWidths();
});
</script>
</body>
</html>
