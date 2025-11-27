-- Create database
CREATE DATABASE IF NOT EXISTS pharma_db;
USE pharma_db;

-- Medicine table
CREATE TABLE IF NOT EXISTS medicine (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_code VARCHAR(50) UNIQUE NOT NULL,
    medicine_name VARCHAR(100) NOT NULL,
    specification VARCHAR(100),
    manufacturer VARCHAR(100),
    unit VARCHAR(20),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Employee table
CREATE TABLE IF NOT EXISTS employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    gender ENUM('M', 'F'),
    phone VARCHAR(20),
    email VARCHAR(100),
    position VARCHAR(50),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Customer table
CREATE TABLE IF NOT EXISTS customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    type ENUM('retail', 'wholesale') DEFAULT 'retail',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Supplier table
CREATE TABLE IF NOT EXISTS supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Purchase Order table
CREATE TABLE IF NOT EXISTS purchase_order (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_code VARCHAR(50) NOT NULL UNIQUE,
    supplier_id INT NOT NULL,
    employee_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Purchase Order Detail table
CREATE TABLE IF NOT EXISTS purchase_order_detail (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_id INT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (purchase_id) REFERENCES purchase_order(purchase_id),
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sales Order table
CREATE TABLE IF NOT EXISTS sales_order (
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

-- Sales Order Detail table
CREATE TABLE IF NOT EXISTS sales_order_detail (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    sales_id INT,
    medicine_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (sales_id) REFERENCES sales_order(sales_id),
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
);

-- Inventory Transaction table
CREATE TABLE IF NOT EXISTS inventory_transaction (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_id INT,
    transaction_type ENUM('purchase', 'sale', 'return', 'adjustment'),
    quantity INT NOT NULL,
    reference_id INT,
    reference_type ENUM('purchase_order', 'sales_order'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
);

-- User table
CREATE TABLE IF NOT EXISTS user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory table
CREATE TABLE IF NOT EXISTS inventory (
inventory_id INT PRIMARY KEY AUTO_INCREMENT,
medicine_id INT NOT NULL,
quantity INT NOT NULL DEFAULT 0,
min_stock INT DEFAULT 0,
max_stock INT DEFAULT 0,
location VARCHAR(100),
status VARCHAR(20) NOT NULL DEFAULT 'normal',
last_check_time DATETIME,
batch_number VARCHAR(50) NOT NULL,
production_date DATE NOT NULL,
expiry_date DATE NOT NULL,
created_at DATETIME NOT NULL,
updated_at DATETIME NOT NULL,
FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create indexes
DROP INDEX idx_medicine_code ON medicine;
CREATE INDEX idx_medicine_code ON medicine(medicine_code);
DROP INDEX idx_employee_code ON employee;
CREATE INDEX idx_employee_code ON employee(employee_code);
DROP INDEX idx_customer_code ON customer;
CREATE INDEX idx_customer_code ON customer(customer_code);
DROP INDEX idx_supplier_code ON supplier;
CREATE INDEX idx_supplier_code ON supplier(supplier_code);
DROP INDEX idx_purchase_code ON purchase_order;
CREATE INDEX idx_purchase_code ON purchase_order(purchase_code);
DROP INDEX idx_sales_code ON sales_order;
CREATE INDEX idx_sales_code ON sales_order(sales_code);


-- 插入药品数据
INSERT
INTO medicine (medicine_code, medicine_name, specification, manufacturer, unit, price, stock_quantity)
VALUES
    ('M001', '阿莫西林胶囊', '0.25g*24粒/盒', '哈药集团制药总厂', '盒', 15.80, 100),
    ('M002', '布洛芬片', '0.2g*24片/盒', '上海信谊药厂', '盒', 12.50, 150),
    ('M003', '感冒灵颗粒', '10g*10袋/盒', '白云山制药', '盒', 25.00, 80),
    ('M004', '维生素C片', '0.1g*100片/瓶', '北京同仁堂', '瓶', 18.50, 200),
    ('M005', '板蓝根颗粒', '10g*20袋/盒', '广州白云山', '盒', 22.00, 120),
    ('M006', '复方丹参片', '0.32g*36片/盒', '天津天士力', '盒', 28.50, 90),
    ('M007', '藿香正气水', '10ml*10支/盒', '云南白药', '盒', 16.80, 150),
    ('M008', '金银花露', '10ml*10支/盒', '广州白云山', '盒', 14.50, 180),
    ('M009', '六味地黄丸', '200丸/瓶', '北京同仁堂', '瓶', 35.00, 100),
    ('M010', '牛黄解毒片', '0.3g*24片/盒', '天津天士力', '盒', 12.80, 200);

-- 插入库存数据
INSERT
INTO inventory (medicine_id, quantity, batch_number, production_date, inventory.expiry_date, location, status, created_at, updated_at)
VALUES
     (1, 100, 'BN20240601', '2024-06-01', '2026-06-01', 'A区-01-01', 'normal', NOW(), NOW()),
     (2, 150, 'BN20240602', '2024-06-02', '2026-06-02', 'A区-01-02', 'normal', NOW(), NOW()),
     (3, 5, 'BN20240611', '2024-06-11', '2026-06-11', 'A区-01-11', 'low', NOW(), NOW()),
     (4, 200, 'BN20240604', '2024-06-04', '2026-06-04', 'A区-01-04', 'normal', NOW(), NOW()),
     (5, 120, 'BN20240605', '2024-06-05', '2026-06-05', 'A区-01-05', 'normal', NOW(), NOW()),
     (6, 2, 'BN20240612', '2024-06-12', '2026-06-12', 'A区-01-12', 'low', NOW(), NOW()),
     (7, 150, 'BN20240607', '2024-06-07', '2026-06-07', 'A区-01-07', 'normal', NOW(), NOW()),
     (8, 180, 'BN20240608', '2024-06-08', '2026-06-08', 'A区-01-08', 'normal', NOW(), NOW()),
     (9, 100, 'BN20240609', '2024-06-09', '2026-06-09', 'A区-01-09', 'normal', NOW(), NOW()),
     (10, 200, 'BN20240610', '2024-06-10', '2026-06-10', 'A区-01-10', 'normal', NOW(), NOW());

-- 插入客户信息
INSERT INTO customer (customer_code, name, contact_person, phone, email, address, type)
VALUES
('C001', '北京康复药房', '张三', '13800000001', 'zhangsan@pharmacy.com', '北京市朝阳区幸福路88号', 'retail'),
('C002', '上海健康大药房', '李四', '13900000002', 'lisi@pharmacy.com', '上海市浦东新区健康路66号', 'retail'),
('C003', '广州医药批发公司', '王五', '13700000003', 'wangwu@pharmacy.com', '广州市天河区医药路99号', 'wholesale');

-- 插入供应商信息
INSERT INTO supplier (supplier_code, name, contact_person, phone, email, address)
VALUES
('S001', '哈药集团', '赵六', '13600000004', 'zhaoliu@hayao.com', '黑龙江省哈尔滨市南岗区哈药路1号'),
('S002', '白云山制药', '钱七', '13500000005', 'qianqi@baiyunshan.com', '广东省广州市白云区制药路2号');

-- 插入员工信息
INSERT INTO employee (employee_code, name, gender, phone, email, position, status)
VALUES
('E001', '刘强', 'M', '13400000006', 'liuqiang@pharma.com', '销售经理', 'active'),
('E002', '孙丽', 'F', '13300000007', 'sunli@pharma.com', '采购专员', 'active'),
('E003', '周杰', 'M', '13200000008', 'zhoujie@pharma.com', '仓库管理员', 'active');


