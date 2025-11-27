package com.pharma.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@WebFilter("/*")
public class RateLimitFilter implements Filter {
    private static final int MAX_REQUESTS_PER_MINUTE = 60;
    private static final Map<String, RequestCount> requestCounts = new ConcurrentHashMap<>();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private static class RequestCount {
        AtomicInteger count = new AtomicInteger(0);
        long resetTime = System.currentTimeMillis() + 60000; // 1分钟后重置
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String clientIp = getClientIp(httpRequest);
        
        if (isRateLimited(clientIp)) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setStatus(429); // Too Many Requests
            httpResponse.setContentType("application/json;charset=UTF-8");
            
            Map<String, String> error = Map.of(
                "message", "请求过于频繁，请稍后再试",
                "details", "每分钟最多允许" + MAX_REQUESTS_PER_MINUTE + "次请求"
            );
            
            objectMapper.writeValue(response.getWriter(), error);
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isRateLimited(String clientIp) {
        RequestCount count = requestCounts.computeIfAbsent(clientIp, k -> new RequestCount());
        
        long currentTime = System.currentTimeMillis();
        if (currentTime > count.resetTime) {
            count.count.set(0);
            count.resetTime = currentTime + 60000;
        }

        return count.count.incrementAndGet() > MAX_REQUESTS_PER_MINUTE;
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    @Override
    public void destroy() {}
} 