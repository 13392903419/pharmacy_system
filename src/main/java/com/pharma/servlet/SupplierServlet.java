package com.pharma.servlet;

import com.pharma.mapper.SupplierMapper;
import com.pharma.model.Supplier;
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
import java.util.List;

@WebServlet("/supplier/*")
public class SupplierServlet extends HttpServlet {
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
            String pageStr = request.getParameter("page");
            String keyword = request.getParameter("keyword");
            if (keyword == null) keyword = "";
            int page = 1;
            if (pageStr != null) {
                try { page = Integer.parseInt(pageStr); } catch (Exception ignored) {}
            }
            int offset = (page - 1) * PAGE_SIZE;
            try (SqlSession session = sqlSessionFactory.openSession()) {
                SupplierMapper mapper = session.getMapper(SupplierMapper.class);
                List<Supplier> supplierList = mapper.selectByPageAndKeyword(offset, PAGE_SIZE, keyword);
                int total = mapper.countByKeyword(keyword);
                int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);
                request.setAttribute("supplierList", supplierList);
                request.setAttribute("page", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/WEB-INF/views/supplier/list.jsp").forward(request, response);
            }
        } else if (pathInfo.equals("/add")) {
            request.getRequestDispatcher("/WEB-INF/views/supplier/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                SupplierMapper mapper = session.getMapper(SupplierMapper.class);
                Supplier supplier = mapper.selectById(id);
                if (supplier != null) {
                    request.setAttribute("supplier", supplier);
                    request.getRequestDispatcher("/WEB-INF/views/supplier/form.jsp").forward(request, response);
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
                SupplierMapper mapper = session.getMapper(SupplierMapper.class);
                mapper.deleteById(id);
                session.commit();
                response.sendRedirect(request.getContextPath() + "/supplier");
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
            String idStr = request.getParameter("supplierId");
            String supplierCode = request.getParameter("supplierCode");
            String name = request.getParameter("name");
            String contactPerson = request.getParameter("contactPerson");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            Supplier supplier = new Supplier();
            try (SqlSession session = sqlSessionFactory.openSession()) {
                if (idStr != null && !idStr.isEmpty()) {
                    supplier.setSupplierId(Integer.parseInt(idStr));
                }
                supplier.setSupplierCode(supplierCode);
                supplier.setName(name);
                supplier.setContactPerson(contactPerson);
                supplier.setPhone(phone);
                supplier.setEmail(email);
                supplier.setAddress(address);
                SupplierMapper mapper = session.getMapper(SupplierMapper.class);
                if (supplier.getSupplierId() == null) {
                    mapper.insert(supplier);
                } else {
                    mapper.update(supplier);
                }
                session.commit();
                response.sendRedirect(request.getContextPath() + "/supplier");
            } catch (Exception e) {
                request.setAttribute("error", "保存失败: " + e.getMessage());
                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("/WEB-INF/views/supplier/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 