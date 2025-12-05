# 医药销售管理系统 (Pharma System)

[![Java](https://img.shields.io/badge/Java-17-orange)](https://openjdk.java.net/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)](https://www.mysql.com/)
[![Maven](https://img.shields.io/badge/Maven-3.9-red)](https://maven.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

一款专为医药行业设计的现代化企业级管理系统，提供完整的医药供应链管理解决方案。

## 📋 目录

- [项目简介](#项目简介)
- [核心功能](#核心功能)
- [技术架构](#技术架构)
- [快速开始](#快速开始)
- [部署指南](#部署指南)
- [系统配置](#系统配置)
- [API文档](#api文档)
- [开发指南](#开发指南)
- [数据库设计](#数据库设计)
- [常见问题](#常见问题)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

## 🎯 项目简介

医药销售管理系统是一款专为医药企业打造的全面数字化管理平台，集成了药品管理、库存控制、销售管理、采购管理、客户关系、员工管理、财务分析和AI智能助手等核心功能模块。

### ✨ 系统特色

- **🏥 医药行业专用**: 深度契合医药行业业务流程和管理需求
- **🎨 现代化UI**: 采用专业医药配色方案，界面简洁优雅
- **🤖 AI智能助手**: 集成智能医药助手，提供专业咨询服务
- **📊 智能报表**: 提供多维度数据分析和可视化报表
- **🔒 安全可靠**: 采用企业级安全架构，数据安全有保障
- **📱 响应式设计**: 支持多终端访问，适配各种设备

## 🚀 核心功能

### 📦 药品管理
- 药品信息录入和管理
- 药品分类和标签管理
- 药品规格和厂家信息维护
- 药品价格和库存预警设置

### 📊 库存管理
- 实时库存监控
- 库存预警和自动补货提醒
- 批次管理和过期提醒
- 库存盘点和调整功能

### 💰 销售管理
- 销售订单创建和管理
- 客户信息关联
- 销售数据统计和分析
- 销售业绩追踪

### 🛒 采购管理
- 采购订单管理
- 供应商管理
- 采购成本分析
- 采购历史查询

### 👥 客户管理
- 客户信息维护
- 客户分类和等级管理
- 客户交易历史
- 客户服务记录

### 🏢 供应商管理
- 供应商信息管理
- 供应商评估和分级
- 供应商合作历史
- 供应商合同管理

### 👨‍💼 员工管理
- 员工信息管理
- 职位和权限管理
- 员工绩效评估
- 员工培训记录

### 📈 统计报表
- 财务销售金额报表
- 员工职位分布报表
- 销售趋势分析
- 库存分析报告

### 🤖 AI智能助手
- 智能医药咨询
- 药品信息查询
- 用药建议和指导
- 处方审核辅助

## 🏗️ 技术架构

### 后端技术栈
- **框架**: Java Servlet + JSP
- **ORM**: MyBatis 3.5.9
- **数据库**: MySQL 8.0
- **构建工具**: Maven 3.9
- **Java版本**: JDK 17

### 前端技术栈
- **UI框架**: 原生HTML5 + CSS3
- **图标库**: RemixIcon
- **图表库**: ECharts
- **样式预处理**: CSS Variables

### 系统架构图
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │    │   Tomcat Server │    │   MySQL Database│
│                 │    │                 │    │                 │
│  ┌────────────┐ │    │  ┌────────────┐ │    │  ┌────────────┐ │
│  │   HTML/CSS │◄┼────┼─►│   Servlets │◄┼────┼─►│    Tables   │ │
│  │     JS     │ │    │  │     JSP    │ │    │  │  Relations  │ │
│  └────────────┘ │    │  └────────────┘ │    │  └────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
    用户界面              业务逻辑层              数据持久层
```

## 🏃‍♂️ 快速开始

### 环境要求
- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 9.0+

### 快速启动

1. **克隆项目**
```bash
git clone https://github.com/your-repo/pharma-system.git
cd pharma-system
```

2. **数据库初始化**
```sql
# 创建数据库
CREATE DATABASE pharma_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入表结构
mysql -u root -p pharma_db < src/main/resources/schema.sql
```

3. **编译部署**
```bash
# 编译项目
mvn clean compile

# 打包WAR文件
mvn clean package

# 部署到Tomcat
cp target/pharma_system.war /path/to/tomcat/webapps/
```

4. **启动服务**
```bash
# 启动Tomcat
/path/to/tomcat/bin/startup.sh

# 访问系统
http://localhost:8080/pharma_system/
```

## 📋 部署指南

### 开发环境部署

#### 1. IDE配置 (推荐使用IntelliJ IDEA)
- 导入Maven项目
- 配置Tomcat运行环境
- 设置数据库连接

#### 2. 数据库配置
```properties
# src/main/resources/mybatis-config.xml
<property name="url" value="jdbc:mysql://localhost:3306/pharma_db?useSSL=false&amp;serverTimezone=UTC"/>
<property name="username" value="root"/>
<property name="password" value="your_password"/>
```

#### 3. 运行项目
```bash
# 使用IDEA运行
Run → Run 'Tomcat'

# 或使用Maven
mvn tomcat7:run
```

### 生产环境部署

#### 1. 服务器准备
```bash
# 更新系统
sudo apt update && sudo apt upgrade

# 安装Java
sudo apt install openjdk-17-jdk

# 安装Tomcat
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.x/bin/apache-tomcat-9.0.x.tar.gz
tar -xzf apache-tomcat-9.0.x.tar.gz
sudo mv apache-tomcat-9.0.x /opt/tomcat
```

#### 2. 部署应用
```bash
# 复制WAR文件
sudo cp pharma_system.war /opt/tomcat/webapps/

# 启动Tomcat
sudo /opt/tomcat/bin/startup.sh
```

#### 3. Nginx反向代理 (可选)
```nginx
server {
    listen 80;
    server_name pharma.yourdomain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## ⚙️ 系统配置

### 数据库配置
```xml
<!-- src/main/resources/mybatis-config.xml -->
<dataSource type="POOLED">
    <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
    <property name="url" value="jdbc:mysql://localhost:3306/pharma_db?useSSL=false&amp;serverTimezone=UTC"/>
    <property name="username" value="root"/>
    <property name="password" value="your_password"/>
</dataSource>
```

### 应用配置
```xml
<!-- src/main/webapp/WEB-INF/web.xml -->
<context-param>
    <param-name>db.driver</param-name>
    <param-value>com.mysql.cj.jdbc.Driver</param-value>
</context-param>
```

### 日志配置
```xml
<!-- src/main/resources/logback.xml -->
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    <root level="info">
        <appender-ref ref="STDOUT"/>
    </root>
</configuration>
```

## 📚 API文档

### REST API端点

#### 用户认证
```
POST /api/auth/login          # 用户登录
POST /api/auth/logout         # 用户登出
GET  /api/auth/info           # 获取用户信息
```

#### 药品管理
```
GET    /api/medicines         # 获取药品列表
POST   /api/medicines         # 创建药品
GET    /api/medicines/{id}    # 获取药品详情
PUT    /api/medicines/{id}    # 更新药品
DELETE /api/medicines/{id}    # 删除药品
```

#### 库存管理
```
GET    /api/inventory         # 获取库存列表
POST   /api/inventory/adjust  # 库存调整
GET    /api/inventory/alerts  # 库存预警
```

#### AI助手
```
POST   /api/ai-chat           # AI对话
GET    /api/ai/history        # 对话历史
POST   /api/ai/analyze        # 数据分析
```

### 数据格式

#### 请求示例
```json
{
  "action": "query_medicine",
  "data": {
    "medicine_code": "MED001",
    "medicine_name": "阿莫西林"
  }
}
```

#### 响应示例
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "medicine_id": 1,
    "medicine_code": "MED001",
    "medicine_name": "阿莫西林",
    "stock": 150,
    "price": 25.50
  }
}
```

## 🛠️ 开发指南

### 项目结构
```
pharma-system/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/pharma/
│   │   │       ├── controller/     # 控制器层
│   │   │       ├── service/        # 业务逻辑层
│   │   │       ├── mapper/         # 数据访问层
│   │   │       ├── model/          # 数据模型
│   │   │       ├── util/           # 工具类
│   │   │       └── filter/         # 过滤器
│   │   ├── resources/
│   │   │   ├── mybatis-config.xml  # MyBatis配置
│   │   │   ├── logback.xml         # 日志配置
│   │   │   └── schema.sql          # 数据库脚本
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml         # Web配置
│   │       │   └── views/          # JSP视图
│   │       └── static/             # 静态资源
│   └── test/                       # 测试代码
├── pom.xml                         # Maven配置
└── README.md                       # 项目文档
```

### 开发环境设置

#### 1. 安装依赖
```bash
# 克隆项目
git clone <repository-url>
cd pharma-system

# 安装依赖
mvn clean install
```

#### 2. 数据库设置
```sql
-- 创建数据库
CREATE DATABASE pharma_db CHARACTER SET utf8mb4;

-- 导入初始数据
mysql -u root -p pharma_db < src/main/resources/schema.sql
```

#### 3. IDE配置
- 导入项目到IntelliJ IDEA或Eclipse
- 配置Tomcat服务器
- 设置JDK 17
- 配置数据库连接

### 代码规范

#### Java代码规范
```java
// 使用Lombok简化代码
@Data
public class Medicine {
    private Integer medicineId;
    private String medicineCode;
    private String medicineName;
    // getters and setters自动生成
}
```

#### 命名规范
- 类名：`PascalCase` (如：`MedicineService`)
- 方法名：`camelCase` (如：`getMedicineById`)
- 变量名：`camelCase` (如：`medicineList`)
- 常量：`UPPER_SNAKE_CASE` (如：`PAGE_SIZE`)

#### 数据库规范
- 表名：`snake_case` (如：`sales_order`)
- 字段名：`snake_case` (如：`medicine_id`)
- 主键：`{table_name}_id`

## 🗄️ 数据库设计

### 核心数据表

#### 药品表 (medicine)
```sql
CREATE TABLE medicine (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_code VARCHAR(50) UNIQUE NOT NULL,
    medicine_name VARCHAR(100) NOT NULL,
    specification VARCHAR(100),
    manufacturer VARCHAR(100),
    unit VARCHAR(20),
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 销售订单表 (sales_order)
```sql
CREATE TABLE sales_order (
    sales_id INT PRIMARY KEY AUTO_INCREMENT,
    sales_code VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT,
    employee_id INT,
    total_amount DECIMAL(12,2) NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);
```

#### 库存表 (inventory)
```sql
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_id INT NOT NULL,
    batch_number VARCHAR(50),
    quantity INT NOT NULL,
    location VARCHAR(100),
    production_date DATE,
    expiry_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
);
```

### 数据库关系图
```
medicine (1) ──── (n) inventory
    │                    │
    │                    │
    └─── (n) sales_order_detail
                │
                │
          sales_order (n) ──── (1) customer
                │
                │
                └─── (1) employee
```

## ❓ 常见问题

### Q: 如何修改数据库连接配置？
A: 编辑 `src/main/resources/mybatis-config.xml` 文件中的数据源配置。

### Q: 系统启动失败怎么办？
A: 检查以下几点：
1. JDK版本是否为17+
2. Tomcat版本是否兼容
3. 数据库连接是否正常
4. 端口8080是否被占用

### Q: 如何添加新的功能模块？
A: 按照以下步骤：
1. 在数据库中添加相关表
2. 创建对应的Model类
3. 创建Mapper接口和XML映射
4. 实现Service层逻辑
5. 创建Controller处理请求
6. 添加对应的JSP视图

### Q: 如何自定义主题颜色？
A: 修改 `src/main/webapp/static/css/global.css` 中的CSS变量：
```css
:root {
    --primary-color: #your-color;
    --secondary-color: #your-color;
}
```

## 🤝 贡献指南

### 开发流程

1. **Fork项目**
2. **创建特性分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **提交更改**
   ```bash
   git commit -m "Add: your feature description"
   ```
4. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```
5. **创建Pull Request**

### 提交规范

#### 提交类型
- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或工具配置

#### 示例
```bash
git commit -m "feat: 添加药品库存预警功能"

git commit -m "fix: 修复销售统计图表显示错误"

git commit -m "docs: 更新API文档"
```

### 代码审查

- 确保代码符合项目规范
- 添加必要的测试用例
- 更新相关文档
- 通过所有自动化测试

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系我们

- **项目主页**: [GitHub Repository]
- **问题反馈**: [Issues]
- **邮箱**: your-email@example.com
- **微信**: pharma-system

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者！

特别感谢：
- OpenJDK团队提供优秀的Java运行环境
- MyBatis团队提供的ORM框架
- Apache Tomcat团队提供的Web服务器
- MySQL团队提供的数据库系统

---

**医药销售管理系统** - 让医药管理更简单、更智能！💊🏥✨
