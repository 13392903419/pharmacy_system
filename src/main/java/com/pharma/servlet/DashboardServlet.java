package com.pharma.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.pharma.mapper.*;
import com.pharma.model.*;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Locale;
import java.time.format.TextStyle;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
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
        try (SqlSession session = sqlSessionFactory.openSession()) {
            // 获取药品总数
            MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);
            int medicineCount = medicineMapper.selectAll().size();
            request.setAttribute("medicineCount", medicineCount);

            // 获取今日销售数量
            SalesMapper salesMapper = session.getMapper(SalesMapper.class);
            LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
            LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
            int todaySalesCount = salesMapper.countTodaySales(todayStart, todayEnd);
            request.setAttribute("todaySalesCount", todaySalesCount);

            // 获取库存预警数量
            InventoryMapper inventoryMapper = session.getMapper(InventoryMapper.class);
            int warningCount = inventoryMapper.countWarningAll();
            request.setAttribute("warningCount", warningCount);

            // 获取待处理订单数量
            PurchaseOrderMapper purchaseOrderMapper = session.getMapper(PurchaseOrderMapper.class);
            int pendingOrderCount = purchaseOrderMapper.countPendingOrders();
            request.setAttribute("pendingOrderCount", pendingOrderCount);

            // 获取最近三条销售记录
            List<SalesOrder> recentSales = salesMapper.selectRecentSales(3);
            request.setAttribute("recentSales", recentSales);

            // 获取最近三条库存预警记录
            List<Inventory> recentWarnings = inventoryMapper.selectRecentWarnings(3);
            request.setAttribute("recentWarnings", recentWarnings);

            // 获取当前日期字符串
            LocalDate today = LocalDate.now();
            String[] weekDays = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
            int weekIndex = today.getDayOfWeek().getValue() % 7;
            String dateStr = String.format("%d年%d月%d日%s", today.getYear(), today.getMonthValue(), today.getDayOfMonth(), weekDays[weekIndex]);
            request.setAttribute("todayStr", dateStr);
        }
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
} 