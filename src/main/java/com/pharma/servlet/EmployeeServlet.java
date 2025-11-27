package com.pharma.servlet;

import com.pharma.mapper.EmployeeMapper;
import com.pharma.model.Employee;
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

@WebServlet("/employee/*")
public class EmployeeServlet extends HttpServlet {
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
                EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
                List<Employee> employeeList = mapper.selectByPageAndKeyword(offset, PAGE_SIZE, keyword);
                int total = mapper.countByKeyword(keyword);
                int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("page", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/WEB-INF/views/employee/list.jsp").forward(request, response);
            }
        } else if (pathInfo.equals("/add")) {
            request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring(6);
            try (SqlSession session = sqlSessionFactory.openSession()) {
                int id = Integer.parseInt(idStr);
                EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
                Employee employee = mapper.selectById(id);
                if (employee != null) {
                    request.setAttribute("employee", employee);
                    request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
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
                EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
                mapper.deleteById(id);
                session.commit();
                response.sendRedirect(request.getContextPath() + "/employee");
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
            String idStr = request.getParameter("employeeId");
            String employeeCode = request.getParameter("employeeCode");
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String position = request.getParameter("position");
            String status = request.getParameter("status");
            Employee employee = new Employee();
            try (SqlSession session = sqlSessionFactory.openSession()) {
                if (idStr != null && !idStr.isEmpty()) {
                    employee.setEmployeeId(Integer.parseInt(idStr));
                }
                employee.setEmployeeCode(employeeCode);
                employee.setName(name);
                employee.setGender(gender);
                employee.setPhone(phone);
                employee.setEmail(email);
                employee.setPosition(position);
                employee.setStatus(status);
                EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
                if (employee.getEmployeeId() == null) {
                    mapper.insert(employee);
                } else {
                    mapper.update(employee);
                }
                session.commit();
                response.sendRedirect(request.getContextPath() + "/employee");
            } catch (Exception e) {
                request.setAttribute("error", "保存失败: " + e.getMessage());
                request.setAttribute("employee", employee);
                request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 