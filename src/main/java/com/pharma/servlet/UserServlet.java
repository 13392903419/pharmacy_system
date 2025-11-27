package com.pharma.servlet;

import com.pharma.mapper.UserMapper;
import com.pharma.model.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
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
        String path = request.getPathInfo();
        if (path == null || "/login".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
        } else if ("/logout".equals(path)) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/user/login");
        }
        else if ("/index".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/user/index.jsp").forward(request, response);
        } 
        else if ("/index".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/user/index.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if ("/login".equals(path)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            try (SqlSession session = sqlSessionFactory.openSession()) {
                UserMapper mapper = session.getMapper(UserMapper.class);
                User user = mapper.selectByUsername(username);
                if (user != null && user.getPassword().equals(password)) {
                    request.getSession().setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    request.setAttribute("error", "用户名或密码错误");
                    request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
                }
            }
        } else if ("/register".equals(path)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            try (SqlSession session = sqlSessionFactory.openSession()) {
                UserMapper mapper = session.getMapper(UserMapper.class);
                if (mapper.selectByUsername(username) != null) {
                    request.setAttribute("error", "用户名已存在");
                    request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
                    return;
                }
                User user = new User();
                user.setUsername(username);
                user.setPassword(password);
                user.setEmail(email);
                mapper.insert(user);
                session.commit();
                response.sendRedirect(request.getContextPath() + "/user/login");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 