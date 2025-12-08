package com.pharma.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class AIChatService {
    private static final String API_KEY = "sk-e35c0b6306cf4a01b5502a73d093e5c2";
    private static final String API_ENDPOINT = "https://api.deepseek.com/chat/completions";
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AIChatService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public String getAIResponse(String userMessage) throws IOException, InterruptedException {
        System.out.println("收到用户消息: " + userMessage);

        String requestBody = String.format("""
            {
                "model": "deepseek-chat",
                "messages": [
                    {
                        "role": "system",
                        "content": "你是一个专业的医药助手，可以回答药品相关的问题，提供用药建议，分析处方等。请用专业但易懂的语言回答。"
                    },
                    {
                        "role": "user",
                        "content": "%s"
                    }
                ],
                "temperature": 0.7,
                "max_tokens": 1000
            }
            """, userMessage.replace("\"", "\\\"").replace("\n", "\\n"));

        System.out.println("发送请求体: " + requestBody);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_ENDPOINT))
                .timeout(Duration.ofSeconds(20))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        try {
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            System.out.println("API响应状态码: " + response.statusCode());

        if (response.statusCode() == 200) {
                String responseBody = response.body();
                System.out.println("DeepSeek API响应: " + responseBody);

                try {
                    JsonNode root = objectMapper.readTree(responseBody);
            JsonNode choices = root.path("choices");

                    if (choices.isArray() && choices.size() > 0) {
                        JsonNode firstChoice = choices.get(0);
                        JsonNode messageNode = firstChoice.path("message");
                        String content = messageNode.path("content").asText();

                        if (content != null && !content.trim().isEmpty()) {
                            System.out.println("成功解析DeepSeek API响应");
                            return content;
                        }
                    }

                    System.err.println("DeepSeek API响应格式异常");
                    return "抱歉，我收到了您的消息但无法正确解析AI的回复。";

                } catch (Exception e) {
                    System.err.println("解析DeepSeek API响应失败: " + e.getMessage());
                    return "抱歉，AI服务响应格式异常，请稍后重试。";
                }

            } else {
                System.err.println("DeepSeek API请求失败: " + response.statusCode() + ", 响应: " + response.body());
                return "API调用失败，状态码: " + response.statusCode() + "。请检查控制台日志获取详细信息。";
            }

        } catch (java.net.http.HttpTimeoutException e) {
            System.err.println("DeepSeek API请求超时: " + e.getMessage());
            return "抱歉，AI服务响应超时，请稍后重试或检查网络连接。";

        } catch (java.io.IOException e) {
            System.err.println("DeepSeek API网络错误: " + e.getMessage());
            return "抱歉，网络连接出现问题，请检查网络后重试。";

        } catch (Exception e) {
            System.err.println("DeepSeek API调用异常: " + e.getMessage());
            return "抱歉，AI服务暂时出现技术问题，请稍后重试。如问题持续，请联系技术支持。";
        }
    }
}
