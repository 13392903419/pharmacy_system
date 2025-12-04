<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>灵药AI - 智能医药助手</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .layout {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background: #2563eb;
            color: white;
            padding: 20px;
        }
        .logo {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .menu li {
            margin-bottom: 10px;
        }
        .menu a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 5px;
            transition: background-color 0.3s;
            gap: 10px;
        }
        .menu a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        .chat-container {
            flex: 1;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        .chat-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f6f8fa;
            border-radius: 10px 10px 0 0;
        }
        .chat-header i {
            color: #2563eb;
            font-size: 24px;
        }
        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
            background: #f6f8fa;
        }
        .message {
            max-width: 70%;
            padding: 14px 18px;
            border-radius: 18px;
            position: relative;
            font-size: 15px;
            line-height: 1.7;
            word-break: break-word;
            box-shadow: 0 2px 8px #e0e7ef;
        }
        .message.user {
            align-self: flex-end;
            background: #7c3aed;
            color: #fff;
            border-bottom-right-radius: 4px;
            text-align: right;
        }
        .message.ai {
            align-self: flex-start;
            background: #fff;
            color: #222;
            border-bottom-left-radius: 4px;
            border: 1px solid #e5e7eb;
            text-align: left;
            white-space: pre-line;
        }
        .chat-input {
            padding: 20px;
            border-top: 1px solid #eee;
            display: flex;
            gap: 10px;
            background: #f6f8fa;
            border-radius: 0 0 10px 10px;
        }
        .chat-input input {
            flex: 1;
            padding: 14px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 15px;
            background: #fff;
        }
        .chat-input button {
            padding: 14px 28px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            transition: background 0.3s;
        }
        .chat-input button:hover {
            background: #4f46e5;
        }
        .suggestions {
            display: flex;
            gap: 10px;
            padding: 0 20px 20px;
            flex-wrap: wrap;
        }
        .suggestion-chip {
            padding: 8px 16px;
            background: #f3f4f6;
            border-radius: 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .suggestion-chip:hover {
            background: #e5e7eb;
        }
        .typing-indicator {
            display: none;
            align-self: flex-start;
            padding: 12px 16px;
            background: #f3f4f6;
            border-radius: 10px;
            color: #666;
        }
        .typing-indicator.active {
            display: block;
        }
        .submenu {
            list-style: none;
            padding-left: 30px;
            margin-top: 5px;
        }
        .submenu li {
            margin-bottom: 5px;
        }
        .submenu a {
            font-size: 14px;
            padding: 8px;
        }
    </style>
</head>
<body>
<div class="layout">
    <div class="sidebar">
        <div class="logo">
            <i class="ri-capsule-fill"></i>
            医药销售管理系统
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
                <ul class="submenu" style="display:none;">
                    <li><a href="${pageContext.request.contextPath}/report/finance">财务总销售金额报表</a></li>
                    <li><a href="${pageContext.request.contextPath}/report/employee-position">员工职位报表</a></li>
                </ul>
            </li>
            <li><a href="${pageContext.request.contextPath}/ai-chat"><i class="ri-robot-fill"></i>灵药AI</a></li>
            <li><a href="${pageContext.request.contextPath}/settings"><i class="ri-settings-3-fill"></i>系统设置</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="chat-container">
            <div class="chat-header">
                <i class="ri-robot-fill"></i>
                <h2>灵药AI - 智能医药助手</h2>
            </div>
            <div class="chat-messages" id="chatMessages">
                <div class="message ai">
                    您好！我是灵药AI助手，我可以帮您解答药品相关的问题，提供用药建议，分析处方等。请问有什么可以帮您？
                </div>
            </div>
            <div class="typing-indicator" id="typingIndicator">
                正在思考...
            </div>
            <div class="suggestions">
                <div class="suggestion-chip">推荐常用药品</div>
                <div class="suggestion-chip">用药注意事项</div>
                <div class="suggestion-chip">处方分析</div>
                <div class="suggestion-chip">药品相互作用</div>
            </div>
            <div class="chat-input">
                <input type="text" id="userInput" placeholder="请输入您的问题..." />
                <button onclick="sendMessage()">发送</button>
            </div>
        </div>
    </div>
</div>

<script>
function toggleSubMenu(e) {
    e.preventDefault();
    const submenu = e.target.closest('li').querySelector('.submenu');
    if (submenu) {
        submenu.style.display = submenu.style.display === 'none' ? 'block' : 'none';
    }
}

function sendMessage() {
    const input = document.getElementById('userInput');
    const message = input.value.trim();
    if (!message) return;

    // 添加用户消息
    addMessage(message, 'user');
    input.value = '';

    // 显示正在输入指示器
    const typingIndicator = document.getElementById('typingIndicator');
    typingIndicator.classList.add('active');

    // 发送请求到后端
    fetch('${pageContext.request.contextPath}/api/ai-chat', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ message: message })
    })
    .then(response => response.json())
    .then(data => {
        // 隐藏正在输入指示器
        typingIndicator.classList.remove('active');
        // 添加AI响应
        addMessage(data.response, 'ai');
    })
    .catch(error => {
        typingIndicator.classList.remove('active');
        addMessage('抱歉，发生了错误，请稍后重试。', 'ai');
        console.error('Error:', error);
    });
}

function addMessage(text, type) {
    const messagesContainer = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${type}`;
    if(type === 'ai') {
        // 支持换行、分段、序号等格式
        messageDiv.innerHTML = text
            .replace(/\n/g, '<br>')
            .replace(/(\d+\.) /g, '<b>$1</b> ');
    } else {
        messageDiv.textContent = text;
    }
    messagesContainer.appendChild(messageDiv);
    // 自动滚动到底部
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

// 添加回车键发送功能
document.getElementById('userInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        sendMessage();
    }
});

// 添加建议点击功能
document.querySelectorAll('.suggestion-chip').forEach(chip => {
    chip.addEventListener('click', function() {
        document.getElementById('userInput').value = this.textContent;
        sendMessage();
    });
});
</script>
</body>
</html> 