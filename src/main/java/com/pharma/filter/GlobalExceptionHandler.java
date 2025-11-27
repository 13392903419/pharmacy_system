package com.pharma.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebFilter("/*")
public class GlobalExceptionHandler implements Filter {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } catch (Exception e) {
            handleException(e, (HttpServletResponse) response);
        }
    }

    private void handleException(Exception e, HttpServletResponse response) throws IOException {
        // 打印详细的异常信息到控制台
        e.printStackTrace();

        Map<String, String> error = new HashMap<>();
        int status;

        if (e instanceof SQLException) {
            status = 500;
            error.put("message", "数据库操作失败");
            error.put("details", e.getMessage() + " - " + e.getCause());
        } else if (e instanceof IllegalArgumentException) {
            status = 400;
            error.put("message", "请求参数错误");
            error.put("details", e.getMessage());
        } else {
            status = 500;
            error.put("message", "系统内部错误");
            error.put("details", e.getMessage() + " - " + e.getCause());
        }

        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        objectMapper.writeValue(response.getWriter(), error);
    }

    @Override
    public void destroy() {}
} 