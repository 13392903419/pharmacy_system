package com.pharma.servlet;

import com.pharma.mapper.InventoryMapper;
import com.pharma.mapper.MedicineMapper;
import com.pharma.model.Inventory;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/inventory/*")
public class InventoryServlet extends HttpServlet {
    private SqlSessionFactory sqlSessionFactory;
    private static final int PAGE_SIZE = 10;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

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
                InventoryMapper mapper = session.getMapper(InventoryMapper.class);
                List<Inventory> inventoryList = mapper.selectByPageAndKeyword(offset, PAGE_SIZE, keyword);
                int total = mapper.countByKeyword(keyword);
                int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);
                
                request.setAttribute("inventoryList", inventoryList);
                request.setAttribute("page", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/WEB-INF/views/inventory/list.jsp").forward(request, response);
            }
        } else if ("/add".equals(pathInfo)) {
            // 新增页面
            try (SqlSession session = sqlSessionFactory.openSession()) {
                MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);
                List<Medicine> medicineList = medicineMapper.selectAll();
                request.setAttribute("medicineList", medicineList);
                request.getRequestDispatcher("/WEB-INF/views/inventory/form.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/edit/")) {
            // 编辑页面
            String idStr = pathInfo.substring(6);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                InventoryMapper mapper = session.getMapper(InventoryMapper.class);
                MedicineMapper medicineMapper = session.getMapper(MedicineMapper.class);
                
                Inventory inventory = mapper.selectById(id);
                List<Medicine> medicineList = medicineMapper.selectAll();
                
                if (inventory != null) {
                    request.setAttribute("inventory", inventory);
                    request.setAttribute("medicineList", medicineList);
                    request.getRequestDispatcher("/WEB-INF/views/inventory/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if ("/check".equals(pathInfo)) {
            // 库存查询页面
            try (SqlSession session = sqlSessionFactory.openSession()) {
                InventoryMapper mapper = session.getMapper(InventoryMapper.class);
                List<Inventory> expiringList = mapper.selectExpiringList();
                List<Inventory> lowQuantityList = mapper.selectLowQuantityList();
                List<Inventory> expiredList = mapper.selectExpiredList();
                
                request.setAttribute("expiringList", expiringList);
                request.setAttribute("lowQuantityList", lowQuantityList);
                request.setAttribute("expiredList", expiredList);
                request.getRequestDispatcher("/WEB-INF/views/inventory/check.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // 删除操作
            String idStr = pathInfo.substring(8);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                InventoryMapper mapper = session.getMapper(InventoryMapper.class);
                mapper.deleteById(id);
                session.commit();
                response.sendRedirect(request.getContextPath() + "/inventory");
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
            String idStr = request.getParameter("inventoryId");
            String medicineIdStr = request.getParameter("medicineId");
            String quantityStr = request.getParameter("quantity");
            String minStockStr = request.getParameter("minStock");
            String maxStockStr = request.getParameter("maxStock");
            String location = request.getParameter("location");
            String status = request.getParameter("status");
            String batchNumber = request.getParameter("batchNumber");
            String productionDateStr = request.getParameter("productionDate");
            String expiryDateStr = request.getParameter("expiryDate");
            
            Inventory inventory = new Inventory();
            try (SqlSession session = sqlSessionFactory.openSession()) {
                if (idStr != null && !idStr.isEmpty()) {
                    inventory.setInventoryId(Integer.parseInt(idStr));
                }
                inventory.setMedicineId(Integer.parseInt(medicineIdStr));
                inventory.setQuantity(Integer.parseInt(quantityStr));
                inventory.setMinStock(Integer.parseInt(minStockStr));
                inventory.setMaxStock(Integer.parseInt(maxStockStr));
                inventory.setLocation(location);
                inventory.setStatus(status);
                inventory.setBatchNumber(batchNumber);
                inventory.setProductionDate(dateFormat.parse(productionDateStr));
                inventory.setExpiryDate(dateFormat.parse(expiryDateStr));
                inventory.setLastCheckTime(new Date());
                inventory.setCreatedAt(new Date());
                inventory.setUpdatedAt(new Date());
                
                InventoryMapper mapper = session.getMapper(InventoryMapper.class);
                if (inventory.getInventoryId() == null) {
                    mapper.insert(inventory);
                } else {
                    mapper.update(inventory);
                }
                session.commit();
                response.sendRedirect(request.getContextPath() + "/inventory");
            } catch (ParseException e) {
                request.setAttribute("error", "日期格式错误");
                request.setAttribute("inventory", inventory);
                request.getRequestDispatcher("/WEB-INF/views/inventory/form.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "保存失败: " + e.getMessage());
                request.setAttribute("inventory", inventory);
                request.getRequestDispatcher("/WEB-INF/views/inventory/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 