package com.pharma.servlet;

import com.pharma.mapper.PurchaseOrderMapper;
import com.pharma.mapper.PurchaseOrderDetailMapper;
import com.pharma.mapper.SupplierMapper;
import com.pharma.mapper.EmployeeMapper;
import com.pharma.mapper.MedicineMapper;
import com.pharma.model.PurchaseOrder;
import com.pharma.model.PurchaseOrderDetail;
import com.pharma.model.Supplier;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/purchase/*")
public class PurchaseOrderServlet extends HttpServlet {
    private SqlSessionFactory sqlSessionFactory;
    private static final int PAGE_SIZE = 10;

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
            // 列表页面
            String pageStr = request.getParameter("page");
            String keyword = request.getParameter("keyword");
            if (keyword == null) keyword = "";
            int page = 1;
            if (pageStr != null) {
                try { page = Integer.parseInt(pageStr); } catch (Exception ignored) {}
            }
            int offset = (page - 1) * PAGE_SIZE;
            
            try (SqlSession session = sqlSessionFactory.openSession()) {
                PurchaseOrderMapper mapper = session.getMapper(PurchaseOrderMapper.class);
                List<PurchaseOrder> purchaseOrderList = mapper.selectByPageAndKeyword(offset, PAGE_SIZE, keyword);
                int total = mapper.countByKeyword(keyword);
                int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);
                
                request.setAttribute("purchaseOrderList", purchaseOrderList);
                request.setAttribute("page", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/WEB-INF/views/purchase/list.jsp").forward(request, response);
            }
        } else if ("/add".equals(pathInfo)) {
            // 新增页面
            try (SqlSession session = sqlSessionFactory.openSession()) {
                SupplierMapper supplierMapper = session.getMapper(SupplierMapper.class);
                EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
                MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);
                
                List<Supplier> supplierList = supplierMapper.selectByPageAndKeyword(0, 1000, "");
                List<Employee> employeeList = employeeMapper.selectByPosition("采购员");
                List<Medicine> medicineList = medicineMapper.selectAll();
                
                request.setAttribute("supplierList", supplierList);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("medicineList", medicineList);
                request.getRequestDispatcher("/WEB-INF/views/purchase/form.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/edit/")) {
            // 编辑页面
            String idStr = pathInfo.substring(6);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                PurchaseOrderMapper mapper = session.getMapper(PurchaseOrderMapper.class);
                PurchaseOrderDetailMapper detailMapper = session.getMapper(PurchaseOrderDetailMapper.class);
                SupplierMapper supplierMapper = session.getMapper(SupplierMapper.class);
                EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
                MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);
                
                PurchaseOrder purchaseOrder = mapper.selectById(id);
                List<PurchaseOrderDetail> details = detailMapper.selectByPurchaseId(id);
                purchaseOrder.setDetails(details);
                
                List<Supplier> supplierList = supplierMapper.selectByPageAndKeyword(0, 1000, "");
                List<Employee> employeeList = employeeMapper.selectByPosition("采购专员");
                List<Medicine> medicineList = medicineMapper.selectAll();
                
                request.setAttribute("purchaseOrder", purchaseOrder);
                request.setAttribute("supplierList", supplierList);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("medicineList", medicineList);
                request.getRequestDispatcher("/WEB-INF/views/purchase/form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // 删除操作
            String idStr = pathInfo.substring(8);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                PurchaseOrderDetailMapper detailMapper = session.getMapper(PurchaseOrderDetailMapper.class);
                PurchaseOrderMapper mapper = session.getMapper(PurchaseOrderMapper.class);
                
                // 先删除明细
                detailMapper.deleteByPurchaseId(id);
                // 再删除主表
                mapper.deleteById(id);
                
                session.commit();
                response.sendRedirect(request.getContextPath() + "/purchase");
            } catch (Exception e) {
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
            // 保存操作
            String idStr = request.getParameter("purchaseId");
            String purchaseCode = request.getParameter("purchaseCode");
            String supplierIdStr = request.getParameter("supplierId");
            String employeeIdStr = request.getParameter("employeeId");
            String totalAmountStr = request.getParameter("totalAmount");
            String status = request.getParameter("status");
            
            // 获取明细数据
            String[] medicineIds = request.getParameterValues("detailMedicineIds[]");
            String[] quantities = request.getParameterValues("detailQuantities[]");
            String[] unitPrices = request.getParameterValues("detailUnitPrices[]");
            String[] totalPrices = request.getParameterValues("detailTotalPrices[]");
            
            PurchaseOrder purchaseOrder = new PurchaseOrder();
            List<PurchaseOrderDetail> details = new ArrayList<>();
            
            try (SqlSession session = sqlSessionFactory.openSession()) {
                if (idStr != null && !idStr.isEmpty()) {
                    purchaseOrder.setPurchaseId(Integer.parseInt(idStr));
                }
                purchaseOrder.setPurchaseCode(purchaseCode);
                purchaseOrder.setSupplierId(Integer.parseInt(supplierIdStr));
                purchaseOrder.setEmployeeId(Integer.parseInt(employeeIdStr));
                purchaseOrder.setTotalAmount(Double.parseDouble(totalAmountStr));
                purchaseOrder.setStatus(status);
                purchaseOrder.setCreatedAt(new Date());
                purchaseOrder.setUpdatedAt(new Date());
                
                PurchaseOrderMapper mapper = session.getMapper(PurchaseOrderMapper.class);
                PurchaseOrderDetailMapper detailMapper = session.getMapper(PurchaseOrderDetailMapper.class);
                
                if (purchaseOrder.getPurchaseId() == null) {
                    // 新增
                    mapper.insert(purchaseOrder);
                } else {
                    // 修改
                    mapper.update(purchaseOrder);
                }
                
                // 保存新的明细（如果有）
                if (medicineIds != null && medicineIds.length > 0) {
                    for (int i = 0; i < medicineIds.length; i++) {
                        PurchaseOrderDetail detail = new PurchaseOrderDetail();
                        detail.setPurchaseId(purchaseOrder.getPurchaseId());
                        detail.setMedicineId(Integer.parseInt(medicineIds[i]));
                        detail.setQuantity(Integer.parseInt(quantities[i]));
                        detail.setUnitPrice(Double.parseDouble(unitPrices[i]));
                        detail.setTotalPrice(Double.parseDouble(totalPrices[i]));
                        detailMapper.insert(detail);
                    }
                }
                
                session.commit();
                response.sendRedirect(request.getContextPath() + "/purchase");
            } catch (Exception e) {
                request.setAttribute("error", "保存失败: " + e.getMessage());
                request.setAttribute("purchaseOrder", purchaseOrder);
                try (SqlSession session = sqlSessionFactory.openSession()) {
                    SupplierMapper supplierMapper = session.getMapper(SupplierMapper.class);
                    EmployeeMapper employeeMapper = session.getMapper(EmployeeMapper.class);
                    MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);
                    
                    List<Supplier> supplierList = supplierMapper.selectByPageAndKeyword(0, 1000, "");
                    List<Employee> employeeList = employeeMapper.selectByPosition("采购专员");
                    List<Medicine> medicineList = medicineMapper.selectAll();
                    
                    request.setAttribute("supplierList", supplierList);
                    request.setAttribute("employeeList", employeeList);
                    request.setAttribute("medicineList", medicineList);
                }
                request.getRequestDispatcher("/WEB-INF/views/purchase/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}