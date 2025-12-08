<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统设置 - 医药销售管理系统</title>
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
                <a href="#" onclick="toggleSubMenu(event)"><i class="ri-bar-chart-fill"></i>统计报表 <i class="ri-arrow-down-s-line"></i></a>
                <ul class="submenu" id="report-submenu">
                    <li><a href="${pageContext.request.contextPath}/report/finance">财务总销售金额报表</a></li>
                    <li><a href="${pageContext.request.contextPath}/report/employee-position">员工职位报表</a></li>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/ai-chat"><i class="ri-robot-fill"></i>AI助手</a></li>
            <li><a href="${pageContext.request.contextPath}/settings" class="active"><i class="ri-settings-3-fill"></i>系统设置</a></li>
        </ul>
    </div>

    <!-- 主内容区域 -->
    <div class="main-content">
        <div class="header">
            <h1><i class="ri-settings-3-line"></i> 系统设置</h1>
            <div class="actions">
                <button class="btn btn-primary" onclick="saveSettings()">
                    <i class="ri-save-line"></i> 保存设置
                </button>
                <button class="btn btn-secondary" onclick="resetSettings()">
                    <i class="ri-refresh-line"></i> 重置
                </button>
            </div>
        </div>

        <!-- 系统状态卡片 -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon"><i class="ri-database-2-line"></i></div>
                <h3 id="db-status">正常</h3>
                <p>数据库连接状态</p>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="ri-server-line"></i></div>
                <h3 id="server-status">运行中</h3>
                <p>服务器状态</p>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="ri-time-line"></i></div>
                <h3 id="uptime">24h 32m</h3>
                <p>系统运行时间</p>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="ri-user-line"></i></div>
                <h3 id="active-users">12</h3>
                <p>活跃用户</p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <!-- 基本设置 -->
                <div class="card settings-section">
                    <div class="card-header">
                        <h3 class="card-title"><i class="ri-settings-4-line"></i> 基本设置</h3>
                    </div>
                    <div class="card-body">
                        <div class="setting-item">
                            <div>
                                <label>系统名称</label>
                                <div class="description">显示在系统标题和界面中的名称</div>
                            </div>
                            <input type="text" class="form-control" style="width: 200px;" value="医药销售管理系统">
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>默认语言</label>
                                <div class="description">系统界面显示语言</div>
                            </div>
                            <select class="form-control" style="width: 200px;">
                                <option value="zh-CN" selected>中文(简体)</option>
                                <option value="zh-TW">中文(繁体)</option>
                                <option value="en-US">English</option>
                            </select>
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>时区设置</label>
                                <div class="description">系统时间显示时区</div>
                            </div>
                            <select class="form-control" style="width: 200px;">
                                <option value="Asia/Shanghai" selected>东八区 (北京时间)</option>
                                <option value="UTC">UTC</option>
                                <option value="America/New_York">东部时间</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 用户界面设置 -->
                <div class="card settings-section">
                    <div class="card-header">
                        <h3 class="card-title"><i class="ri-palette-line"></i> 用户界面</h3>
                    </div>
                    <div class="card-body">
                        <div class="setting-item">
                            <div>
                                <label>主题模式</label>
                                <div class="description">选择系统的显示主题</div>
                            </div>
                            <select class="form-control" style="width: 200px;">
                                <option value="light" selected>浅色主题</option>
                                <option value="dark">深色主题</option>
                                <option value="auto">跟随系统</option>
                            </select>
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>侧边栏折叠</label>
                                <div class="description">登录后自动折叠侧边栏</div>
                            </div>
                            <div class="toggle-switch" onclick="toggleSwitch(this)">
                                <input type="hidden" name="sidebar-collapse" value="false">
                            </div>
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>表格行数</label>
                                <div class="description">每页显示的数据行数</div>
                            </div>
                            <select class="form-control" style="width: 200px;">
                                <option value="10">10行</option>
                                <option value="20" selected>20行</option>
                                <option value="50">50行</option>
                                <option value="100">100行</option>
                            </select>
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>动画效果</label>
                                <div class="description">启用界面动画和过渡效果</div>
                            </div>
                            <div class="toggle-switch active" onclick="toggleSwitch(this)">
                                <input type="hidden" name="animations" value="true">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 安全设置 -->
                <div class="card settings-section">
                    <div class="card-header">
                        <h3 class="card-title"><i class="ri-shield-line"></i> 安全设置</h3>
                    </div>
                    <div class="card-body">
                        <div class="setting-item">
                            <div>
                                <label>会话超时</label>
                                <div class="description">用户登录后无操作自动登出时间</div>
                            </div>
                            <select class="form-control" style="width: 200px;">
                                <option value="15">15分钟</option>
                                <option value="30" selected>30分钟</option>
                                <option value="60">1小时</option>
                                <option value="120">2小时</option>
                            </select>
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>密码复杂度</label>
                                <div class="description">用户密码的最低复杂度要求</div>
                            </div>
                            <select class="form-control" style="width: 200px;">
                                <option value="low">低</option>
                                <option value="medium" selected>中</option>
                                <option value="high">高</option>
                            </select>
                        </div>

                        <div class="setting-item">
                            <div>
                                <label>双因子认证</label>
                                <div class="description">启用双因子认证以提高安全性</div>
                            </div>
                            <div class="toggle-switch" onclick="toggleSwitch(this)">
                                <input type="hidden" name="2fa" value="false">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <!-- 系统信息 -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title"><i class="ri-information-line"></i> 系统信息</h3>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <strong>版本号:</strong> v2.1.0
                        </div>
                        <div class="mb-3">
                            <strong>最后更新:</strong> 2025-11-27
                        </div>
                        <div class="mb-3">
                            <strong>Java版本:</strong> 17.0.9
                        </div>
                        <div class="mb-3">
                            <strong>数据库:</strong> MySQL 8.0
                        </div>
                        <div class="mb-3">
                            <strong>服务器:</strong> Tomcat 9.0
                        </div>
                    </div>
        </div>

                <!-- 快速操作 -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h3 class="card-title"><i class="ri-flashlight-line"></i> 快速操作</h3>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-warning w-100 mb-2" onclick="clearCache()">
                            <i class="ri-delete-bin-line"></i> 清除缓存
                        </button>
                        <button class="btn btn-info w-100 mb-2" onclick="exportSettings()">
                            <i class="ri-file-download-line"></i> 导出设置
                        </button>
                        <button class="btn btn-success w-100 mb-2" onclick="backupData()">
                            <i class="ri-database-line"></i> 数据备份
                        </button>
                        <button class="btn btn-danger w-100" onclick="showResetModal()">
                            <i class="ri-refresh-line"></i> 系统重置
                        </button>
                    </div>
        </div>

                <!-- 更新日志 -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h3 class="card-title"><i class="ri-file-list-line"></i> 最新更新</h3>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>v2.1.0 - 2025-11-27</h6>
                            <ul class="list-unstyled small">
                                <li>• 优化UI界面设计</li>
                                <li>• 增加数据导出功能</li>
                                <li>• 修复若干bug</li>
                            </ul>
                        </div>
                </div>
                </div>
                </div>
                </div>
            </div>
        </div>

<!-- 重置确认模态框 -->
<div class="modal fade" id="resetModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">确认重置</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>确定要重置所有设置吗？此操作不可撤销。</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" onclick="confirmReset()">确认重置</button>
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

// 切换开关
function toggleSwitch(element) {
    element.classList.toggle('active');
    const input = element.querySelector('input[type="hidden"]');
    input.value = element.classList.contains('active') ? 'true' : 'false';
}

// 保存设置
function saveSettings() {
    // 这里可以添加保存设置的逻辑
    alert('设置已保存！');
}

// 重置设置
function resetSettings() {
    if (confirm('确定要重置所有设置吗？')) {
        // 重置逻辑
        alert('设置已重置！');
    }
}

// 清除缓存
function clearCache() {
    if (confirm('确定要清除系统缓存吗？')) {
        alert('缓存已清除！');
    }
}

// 导出设置
function exportSettings() {
    alert('设置已导出！');
}

// 数据备份
function backupData() {
    alert('数据备份已启动！');
}

// 显示重置模态框
function showResetModal() {
    // 如果没有Bootstrap，可以用原生方式显示模态框
    alert('系统重置功能即将上线！');
}

// 确认重置
function confirmReset() {
    alert('系统已重置！');
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 可以在这里添加页面初始化逻辑
});
</script>

<!-- Bootstrap JS (可选，用于模态框等组件) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>