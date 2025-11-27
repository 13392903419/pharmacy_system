package com.pharma.servlet;

import com.pharma.mapper.EmployeeMapper;
import com.pharma.mapper.SalesMapper;
import com.pharma.mapper.CustomerMapper;
import com.pharma.mapper.PurchaseOrderMapper;
import com.pharma.model.Employee;
import com.pharma.model.SalesOrder;
import com.pharma.model.PurchaseOrder;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;

@WebServlet("/report/*")
public class ReportServlet extends HttpServlet {
    private SqlSessionFactory sqlSessionFactory;

    @Override
    public void init() throws ServletException {
        try {
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            // 默认跳转到报表菜单页
            request.getRequestDispatcher("/WEB-INF/views/report/finance.jsp").forward(request, response);
            return;
        }
        if (pathInfo.startsWith("/finance")) {
            showFinanceReport(request, response);
        } else if (pathInfo.startsWith("/employee-position")) {
            showEmployeePositionReport(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showFinanceReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            SalesMapper salesMapper = session.getMapper(SalesMapper.class);
            CustomerMapper customerMapper = session.getMapper(CustomerMapper.class);
            PurchaseOrderMapper purchaseOrderMapper = session.getMapper(PurchaseOrderMapper.class);
            List<SalesOrder> salesList = salesMapper.selectAll();
            List<PurchaseOrder> purchaseList = purchaseOrderMapper.selectAll();
            List<Map<String, Object>> financeList = new ArrayList<>();
            double totalIncome = 0;
            double totalExpense = 0;
            // 销售流水
            for (SalesOrder order : salesList) {
                Map<String, Object> item = new HashMap<>();
                item.put("type", "销售");
                item.put("salesCode", order.getSalesCode());
                item.put("createdAt", order.getCreatedAt());

                String status = order.getStatus();
                double amount = order.getTotalAmount() != null ? order.getTotalAmount().doubleValue() : 0;

                if ("pending".equals(status)) {
                    // 待处理，灰色，不计入总收入/支出
                    item.put("amount", amount);
                    item.put("amountDisplay", amount);
                    item.put("amountColor", "#888888");
                    item.put("remark", "待处理");
                } else if ("completed".equals(status)) {
                    // 已完成，正数，计入总收入
                    item.put("amount", amount);
                    item.put("amountDisplay", amount);
                    item.put("amountColor", "#22c55e");
                    item.put("remark", "已完成");
                    totalIncome += amount;
                } else if ("cancelled".equals(status)) {
                    // 已取消，负数，计入总支出
                    item.put("amount", -amount);
                    item.put("amountDisplay", -amount);
                    item.put("amountColor", "#ef4444");
                    item.put("remark", "已取消");
                    totalExpense += amount;
                } else {
                    // 其他状态，默认灰色
                    item.put("amount", amount);
                    item.put("amountDisplay", amount);
                    item.put("amountColor", "#888888");
                    item.put("remark", status);
                }

                String customerName = "";
                if (order.getCustomerId() != null) {
                    try {
                        customerName = customerMapper.selectById(order.getCustomerId()).getName();
                    } catch (Exception e) {
                        customerName = "";
                    }
                }
                item.put("customerName", customerName);
                financeList.add(item);
            }
            // 进货流水
            for (PurchaseOrder po : purchaseList) {
                Map<String, Object> item = new HashMap<>();
                item.put("type", "进货");
                item.put("salesCode", po.getPurchaseCode());
                item.put("createdAt", po.getCreatedAt());

                String status = po.getStatus();
                double amount = po.getTotalAmount() != null ? po.getTotalAmount().doubleValue() : 0;

                if ("pending".equals(status)) {
                    // 待处理时，显示金额颜色为灰色，不计入总收入/支出
                    item.put("amount", amount); // 依然为数字，便于排序
                    item.put("amountDisplay", amount);
                    item.put("amountColor", "#888888");
                    item.put("remark", "待处理");
                } else if ("cancelled".equals(status)) {
                    // 已取消的订单显示为正数（表示退款），计入总收入
                    item.put("amount", amount);
                    item.put("amountDisplay", String.valueOf(amount));
                    item.put("amountColor", "#22c55e");
                    item.put("remark", status);
                    totalIncome += amount;
                } else {
                    // 其他状态显示为负数（表示支出），计入总支出
                    item.put("amount", -amount);
                    item.put("amountDisplay", String.valueOf(-amount));
                    item.put("amountColor", "#ef4444");
                    item.put("remark", status);
                    totalExpense += amount;
                }

                item.put("customerName", po.getSupplierName());
                financeList.add(item);
            }
            // 按时间倒序排列
            financeList.sort((a, b) -> {
                LocalDateTime d1 = toLocalDateTime(a.get("createdAt"));
                LocalDateTime d2 = toLocalDateTime(b.get("createdAt"));
                return d2.compareTo(d1);
            });
            request.setAttribute("financeList", financeList);
            request.setAttribute("totalIncome", totalIncome);
            request.setAttribute("totalExpense", totalExpense);
            request.getRequestDispatcher("/WEB-INF/views/report/finance.jsp").forward(request, response);
        }
    }

    private void showEmployeePositionReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
            List<Employee> employeeList = employeeMapper.selectAll();
            Map<String, Integer> positionMap = new LinkedHashMap<>();
            for (Employee emp : employeeList) {
                String pos = emp.getPosition();
                if (pos == null) pos = "未设置";
                positionMap.put(pos, positionMap.getOrDefault(pos, 0) + 1);
            }
            List<Map<String, Object>> positionList = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : positionMap.entrySet()) {
                Map<String, Object> item = new HashMap<>();
                item.put("position", entry.getKey());
                item.put("count", entry.getValue());
                positionList.add(item);
            }
            request.setAttribute("positionList", positionList);
            request.getRequestDispatcher("/WEB-INF/views/report/employee_position.jsp").forward(request, response);
        }
    }

    private static LocalDateTime toLocalDateTime(Object obj) {
        if (obj instanceof LocalDateTime) {
            return (LocalDateTime) obj;
        } else if (obj instanceof Date) {
            return ((Date) obj).toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        } else if (obj instanceof String) {
            try {
                return LocalDateTime.parse((String) obj);
            } catch (Exception e) {
                return LocalDateTime.MIN;
            }
        }
        return LocalDateTime.MIN;
    }
}
