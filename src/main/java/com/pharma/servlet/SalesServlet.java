package com.pharma.servlet;

import com.pharma.mapper.SalesMapper;
import com.pharma.mapper.CustomerMapper;
import com.pharma.mapper.EmployeeMapper;
import com.pharma.mapper.MedicineMapper;
import com.pharma.mapper.InventoryMapper;
import com.pharma.model.SalesOrder;
import com.pharma.model.SalesOrderDetail;
import com.pharma.model.Customer;
import com.pharma.model.Employee;
import com.pharma.model.Medicine;
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
import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/sales/*")
public class SalesServlet extends HttpServlet {
    private SqlSessionFactory sqlSessionFactory;
    private static final int PAGE_SIZE = 8;

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
            // 列表+分页+搜索
            String pageStr = request.getParameter("page");
            String keyword = request.getParameter("keyword");
            if (keyword == null) keyword = "";
            int page = 1;
            if (pageStr != null) {
                try { page = Integer.parseInt(pageStr); } catch (Exception ignored) {}
            }
            int offset = (page - 1) * PAGE_SIZE;
            try (SqlSession session = sqlSessionFactory.openSession()) {
                SalesMapper mapper = session.getMapper(SalesMapper.class);

                List<SalesOrder> salesList = mapper.selectByPageAndKeyword(offset, PAGE_SIZE, keyword);
                int total = mapper.countByKeyword(keyword);
                int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);

                request.setAttribute("salesList", salesList);
                request.setAttribute("page", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/WEB-INF/views/sales/list.jsp").forward(request, response);
            }
        } else if (pathInfo.equals("/add")) {
            try (SqlSession session = sqlSessionFactory.openSession()) {
                CustomerMapper customerMapper = session.getMapper(CustomerMapper.class);
                EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
                MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);

                List<Customer> customerList = customerMapper.selectByPageAndKeyword(0, 1000, "");
                List<Employee> employeeList = employeeMapper.selectByPosition("销售员");
                List<Medicine> medicineList = medicineMapper.selectAll();

                request.setAttribute("customerList", customerList);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("medicineList", medicineList);
                request.getRequestDispatcher("/WEB-INF/views/sales/form.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                SalesMapper salesMapper = session.getMapper(SalesMapper.class);
                CustomerMapper customerMapper = session.getMapper(CustomerMapper.class);
                EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
                MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);

                SalesOrder order = salesMapper.selectById(id);
                if (order != null) {
                    List<Customer> customerList = customerMapper.selectByPageAndKeyword(0, 1000, "");
                    List<Employee> employeeList = employeeMapper.selectByPosition("销售经理");
                    List<Medicine> medicineList = medicineMapper.selectAll();

                    request.setAttribute("order", order);
                    request.setAttribute("customerList", customerList);
                    request.setAttribute("employeeList", employeeList);
                    request.setAttribute("medicineList", medicineList);
                    request.getRequestDispatcher("/WEB-INF/views/sales/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            String idStr = pathInfo.substring(8);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                SalesMapper salesMapper = session.getMapper(SalesMapper.class);
                InventoryMapper inventoryMapper = session.getMapper(InventoryMapper.class);

                // 🔥 1. 先查询要删除的销售订单信息（检查状态）
                SalesOrder orderToDelete = salesMapper.selectById(id);
                if (orderToDelete == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                // 🔥 2. 查询销售订单明细
                List<SalesOrderDetail> details = salesMapper.selectDetailsBySalesId(id);

                // 🔥 3. 只有状态为"completed"的订单被删除时才恢复库存
                if ("completed".equals(orderToDelete.getStatus())) {
                    for (SalesOrderDetail detail : details) {
                        int addResult = inventoryMapper.addStock(detail.getMedicineId(), detail.getQuantity());
                        if (addResult > 0) {
                            System.out.println("恢复库存成功：药品ID=" + detail.getMedicineId() +
                                    ", 药品名称=" + detail.getMedicineName() +
                                    ", 恢复数量=" + detail.getQuantity());
                        }
                    }
                    System.out.println("✅ 删除已完成订单，已恢复库存");
                } else {
                    System.out.println("ℹ️ 删除" + orderToDelete.getStatus() + "状态订单，不恢复库存");
                }

                // 🔥 4. 删除明细记录
                salesMapper.deleteDetailsBySalesId(id);

                // 🔥 5. 删除主订单
                salesMapper.deleteById(id);

                session.commit();
                response.sendRedirect(request.getContextPath() + "/sales");

            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("删除失败，ID: " + idStr + ", 错误: " + e.getMessage());
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/save".equals(pathInfo)) {
            String idStr = request.getParameter("salesId");
            String salesCode = request.getParameter("salesCode");
            String customerIdStr = request.getParameter("customerId");
            String employeeIdStr = request.getParameter("employeeId");
            String totalAmountStr = request.getParameter("totalAmount");
            String status = request.getParameter("status");

            // 获取明细数据
            String[] medicineIds = request.getParameterValues("detailMedicineIds[]");
            String[] quantities = request.getParameterValues("detailQuantities[]");
            String[] unitPrices = request.getParameterValues("detailUnitPrices[]");
            String[] totalPrices = request.getParameterValues("detailTotalPrices[]");
            String[] medicineCodes = request.getParameterValues("detailMedicineCodes[]");
            String[] medicineNames = request.getParameterValues("detailMedicineNames[]");

            SalesOrder order = new SalesOrder();
            List<SalesOrderDetail> details = new ArrayList<>();

            try (SqlSession session = sqlSessionFactory.openSession()) {
                if (idStr != null && !idStr.isEmpty()) {
                    order.setSalesId(Integer.parseInt(idStr));
                }
                order.setSalesCode(salesCode);
                order.setCustomerId(customerIdStr != null && !customerIdStr.isEmpty() ? Integer.parseInt(customerIdStr) : null);
                order.setEmployeeId(employeeIdStr != null && !employeeIdStr.isEmpty() ? Integer.parseInt(employeeIdStr) : null);
                order.setTotalAmount(totalAmountStr != null && !totalAmountStr.isEmpty() ? new BigDecimal(totalAmountStr) : BigDecimal.ZERO);
                order.setStatus(status);

                // 处理明细数据
                if (medicineIds != null) {
                    for (int i = 0; i < medicineIds.length; i++) {
                        SalesOrderDetail detail = new SalesOrderDetail();
                        detail.setMedicineId(Integer.parseInt(medicineIds[i]));
                        detail.setMedicineCode(medicineCodes[i]);
                        detail.setMedicineName(medicineNames[i]);
                        detail.setQuantity(Integer.parseInt(quantities[i]));
                        detail.setUnitPrice(new BigDecimal(unitPrices[i]));
                        detail.setTotalPrice(new BigDecimal(totalPrices[i]));
                        details.add(detail);
                    }
                }
                order.setDetails(details);

                SalesMapper mapper = session.getMapper(SalesMapper.class);

                if (order.getSalesId() == null) {
                    // ========== 新增销售订单 ==========

                    // 1. 获取库存Mapper
                    InventoryMapper inventoryMapper = session.getMapper(InventoryMapper.class);

                    // 🔥 2. 只有状态为"completed"时才检查和减少库存
                    if ("completed".equals(status)) {
                        // 2.1 检查所有药品库存是否足够
                        for (SalesOrderDetail detail : details) {
                            Integer currentStock = inventoryMapper.getStockByMedicineId(detail.getMedicineId());
                            if (currentStock == null || currentStock < detail.getQuantity()) {
                                throw new RuntimeException("药品 " + detail.getMedicineName() + " 库存不足！当前库存：" +
                                        (currentStock == null ? 0 : currentStock) + "，需要：" + detail.getQuantity());
                            }
                        }
                    }

                    // 3. 保存销售订单
                    mapper.insert(order);

                    // 4. 保存明细数据到数据库
                    for (SalesOrderDetail detail : details) {
                        detail.setSalesId(order.getSalesId());
                        mapper.insertDetail(detail);
                    }

                    // 🔥 5. 只有状态为"completed"时才减少库存
                    if ("completed".equals(status)) {
                        for (SalesOrderDetail detail : details) {
                            int updateResult = inventoryMapper.reduceStock(detail.getMedicineId(), detail.getQuantity());
                            if (updateResult == 0) {
                                throw new RuntimeException("库存更新失败，可能是并发问题，请重试");
                            }
                        }
                        System.out.println("✅ 订单状态为已完成，已减少库存");
                    } else {
                        System.out.println("ℹ️ 订单状态为" + status + "，不减少库存");
                    }

                } else {
                    // ========== 编辑订单时处理状态变更的库存逻辑 ==========

                    // 1. 获取原订单信息
                    SalesOrder originalOrder = mapper.selectById(order.getSalesId());
                    String originalStatus = originalOrder.getStatus();
                    String newStatus = status;

                    System.out.println("📝 编辑订单：原状态=" + originalStatus + " → 新状态=" + newStatus);

                    // 2. 获取原订单明细
                    List<SalesOrderDetail> originalDetails = mapper.selectDetailsBySalesId(order.getSalesId());

                    // 3. 根据状态变更处理库存
                    InventoryMapper inventoryMapper = session.getMapper(InventoryMapper.class);

                    if (!originalStatus.equals(newStatus)) {
                        // 状态发生了变更，需要处理库存

                        if ("pending".equals(originalStatus) && "completed".equals(newStatus)) {
                            // 🔥 待处理 → 已完成：减库存（发货）
                            System.out.println("🚚 订单发货：待处理 → 已完成，开始减库存");

                            // 检查库存是否足够（使用新的明细数据）
                            for (SalesOrderDetail detail : details) {
                                Integer currentStock = inventoryMapper.getStockByMedicineId(detail.getMedicineId());
                                if (currentStock == null || currentStock < detail.getQuantity()) {
                                    throw new RuntimeException("药品 " + detail.getMedicineName() + " 库存不足！当前库存：" +
                                            (currentStock == null ? 0 : currentStock) + "，需要：" + detail.getQuantity());
                                }
                            }

                            // 减库存（使用新的明细数据）
                            for (SalesOrderDetail detail : details) {
                                int updateResult = inventoryMapper.reduceStock(detail.getMedicineId(), detail.getQuantity());
                                if (updateResult == 0) {
                                    throw new RuntimeException("库存更新失败，可能是并发问题，请重试");
                                }
                                System.out.println("✅ 减库存：" + detail.getMedicineName() + " 减少 " + detail.getQuantity());
                            }

                        } else if ("completed".equals(originalStatus) && "pending".equals(newStatus)) {
                            // 🔥 已完成 → 待处理：加库存（撤销发货）
                            System.out.println("↩️ 撤销发货：已完成 → 待处理，开始恢复库存");

                            // 使用原订单明细恢复库存
                            for (SalesOrderDetail detail : originalDetails) {
                                int addResult = inventoryMapper.addStock(detail.getMedicineId(), detail.getQuantity());
                                if (addResult > 0) {
                                    System.out.println("✅ 恢复库存：" + detail.getMedicineName() + " 增加 " + detail.getQuantity());
                                }
                            }

                        } else if ("completed".equals(originalStatus) && "cancelled".equals(newStatus)) {
                            // 🔥 已完成 → 已取消：加库存（退货）
                            System.out.println("🔄 订单取消：已完成 → 已取消，开始恢复库存");

                            // 使用原订单明细恢复库存
                            for (SalesOrderDetail detail : originalDetails) {
                                int addResult = inventoryMapper.addStock(detail.getMedicineId(), detail.getQuantity());
                                if (addResult > 0) {
                                    System.out.println("✅ 恢复库存：" + detail.getMedicineName() + " 增加 " + detail.getQuantity());
                                }
                            }

                        } else if ("cancelled".equals(originalStatus) && "completed".equals(newStatus)) {
                            // 🔥 已取消 → 已完成：减库存（重新发货）
                            System.out.println("🔄 重新发货：已取消 → 已完成，开始减库存");

                            // 检查库存是否足够（使用新的明细数据）
                            for (SalesOrderDetail detail : details) {
                                Integer currentStock = inventoryMapper.getStockByMedicineId(detail.getMedicineId());
                                if (currentStock == null || currentStock < detail.getQuantity()) {
                                    throw new RuntimeException("药品 " + detail.getMedicineName() + " 库存不足！当前库存：" +
                                            (currentStock == null ? 0 : currentStock) + "，需要：" + detail.getQuantity());
                                }
                            }

                            // 减库存（使用新的明细数据）
                            for (SalesOrderDetail detail : details) {
                                int updateResult = inventoryMapper.reduceStock(detail.getMedicineId(), detail.getQuantity());
                                if (updateResult == 0) {
                                    throw new RuntimeException("库存更新失败，可能是并发问题，请重试");
                                }
                                System.out.println("✅ 减库存：" + detail.getMedicineName() + " 减少 " + detail.getQuantity());
                            }

                        } else {
                            // 其他状态变更不影响库存
                            System.out.println("ℹ️ 状态变更不影响库存：" + originalStatus + " → " + newStatus);
                        }
                    } else {
                        System.out.println("ℹ️ 状态未变更，不处理库存");
                    }

                    // 🔥 4. 更新订单主信息
                    mapper.update(order);

                    // 🔥 5. 更新明细信息：先删除再新增
                    System.out.println("🔄 开始更新订单明细...");

                    // 5.1 删除原有明细
                    mapper.deleteDetailsBySalesId(order.getSalesId());
                    System.out.println("✅ 已删除原有明细");

                    // 5.2 插入新明细
                    for (SalesOrderDetail detail : details) {
                        detail.setSalesId(order.getSalesId());
                        mapper.insertDetail(detail);
                        System.out.println("✅ 插入明细：" + detail.getMedicineName() +
                                " 数量:" + detail.getQuantity() + " 单价:" + detail.getUnitPrice());
                    }
                    System.out.println("✅ 明细更新完成");
                }

                session.commit();
                response.sendRedirect(request.getContextPath() + "/sales");

            } catch (Exception e) {
                request.setAttribute("error", "保存失败: " + e.getMessage());
                request.setAttribute("order", order);

                // 重新加载页面需要的数据
                try (SqlSession session = sqlSessionFactory.openSession()) {
                    CustomerMapper customerMapper = session.getMapper(CustomerMapper.class);
                    EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
                    MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);

                    List<Customer> customerList = customerMapper.selectByPageAndKeyword(0, 1000, "");
                    List<Employee> employeeList = employeeMapper.selectByPosition("销售经理");
                    List<Medicine> medicineList = medicineMapper.selectAll();

                    request.setAttribute("customerList", customerList);
                    request.setAttribute("employeeList", employeeList);
                    request.setAttribute("medicineList", medicineList);
                }

                request.getRequestDispatcher("/WEB-INF/views/sales/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
