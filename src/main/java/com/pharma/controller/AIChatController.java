package com.pharma.controller;

import com.pharma.service.AIChatService;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.stream.Collectors;

@WebServlet("/api/ai-chat")
public class AIChatController extends HttpServlet {
    private AIChatService aiChatService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        aiChatService = new AIChatService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 设置响应类型
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 读取请求体
        BufferedReader reader = request.getReader();
        String requestBody = reader.lines().collect(Collectors.joining());

        // 解析请求体
        ChatRequest chatRequest = gson.fromJson(requestBody, ChatRequest.class);

        try {
            // 调用AI服务
            String aiResponse = aiChatService.getAIResponse(chatRequest.getMessage());

            // 创建响应对象
            ChatResponse chatResponse = new ChatResponse(aiResponse);

            // 发送响应
            response.getWriter().write(gson.toJson(chatResponse));
        } catch (Exception e) {
            // 处理错误
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ChatResponse errorResponse = new ChatResponse("抱歉，发生了错误，请稍后重试。");
            response.getWriter().write(gson.toJson(errorResponse));
        }
    }

    // 请求和响应的内部类
    private static class ChatRequest {
        private String message;

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }

    private static class ChatResponse {
        private String response;

        public ChatResponse(String response) {
            this.response = response;
        }

        public String getResponse() {
            return response;
        }

        public void setResponse(String response) {
            this.response = response;
        }
    }
} 