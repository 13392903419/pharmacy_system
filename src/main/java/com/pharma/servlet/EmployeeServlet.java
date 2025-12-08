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
        } else if (pathInfo.equals("/check-code")) {
            // AJAX请求：检查员工编码是否重复
            String employeeCode = request.getParameter("employeeCode");
            String employeeIdStr = request.getParameter("employeeId");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (SqlSession session = sqlSessionFactory.openSession()) {
                EmployeeMapper mapper = session.getMapper(EmployeeMapper.class);
                Integer excludeId = (employeeIdStr != null && !employeeIdStr.isEmpty()) 
                    ? Integer.parseInt(employeeIdStr) : null;
                int count = mapper.countByEmployeeCode(employeeCode, excludeId);
                
                response.getWriter().write("{\"exists\":" + (count > 0) + "}");
            } catch (Exception e) {
                response.getWriter().write("{\"exists\":false,\"error\":\"" + e.getMessage() + "\"}");
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

                // 检查员工编号是否重复
                Integer excludeId = employee.getEmployeeId(); // 编辑时排除当前ID，新增时为null
                System.out.println("检查员工编码重复: 编码=" + employee.getEmployeeCode() + ", 排除ID=" + excludeId);
                int count = mapper.countByEmployeeCode(employee.getEmployeeCode(), excludeId);
                System.out.println("找到重复编码数量: " + count);
                if (count > 0) {
                    System.out.println("发现重复编码，显示错误信息");
                    request.setAttribute("error", "员工编码【" + employee.getEmployeeCode() + "】已存在,请使用其他编码!");
                    request.setAttribute("employee", employee);
                    request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
                    return;
                }

                if (employee.getEmployeeId() == null) {
                    mapper.insert(employee);
                } else {
                    mapper.update(employee);
                }
                session.commit();
                System.out.println("员工保存成功: " + employee.getEmployeeCode());
                response.sendRedirect(request.getContextPath() + "/employee");
            } catch (Exception e) {
                System.err.println("员工保存失败: " + e.getMessage());
                e.printStackTrace();

                // 检查是否是数据库约束违反（重复编码）
                String errorMessage = "保存失败: " + e.getMessage();
                if (e.getMessage() != null && e.getMessage().toLowerCase().contains("duplicate")) {
                    errorMessage = "员工编码【" + employee.getEmployeeCode() + "】已存在,请使用其他编码!";
                }

                request.setAttribute("error", errorMessage);
                request.setAttribute("employee", employee);
                request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 